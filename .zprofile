## Profiling options
#PS4='+$(date "+%s:%N") %N:%i> '
#exec 3>&2 2>/tmp/zsh-startlog.$$
#setopt prompt_subst
#setopt xtrace

typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions
fpath=($fpath $HOME/.zsh/func)
#typeset -u fpath

# Options
setopt appendhistory hist_ignore_space hist_ignore_all_dups extendedglob nomatch notify dvorak # correct
unsetopt beep
bindkey -e

zstyle :compinstall filename '~/.zshrc'
autoload -Uz compinit colors zgitinit && colors && zgitinit
compinit -u
#bindkey '^L' push-line
bindkey "^I" expand-or-complete-prefix
umask 022

# Fix $TERM
if [ -f /etc/termcap ] ; then
    export TERMCAP=/etc/termcap
fi
case "$TERM" in
    rxvt-unicode) export TERM=rxvt;;
    rxvt-256color) export TERM=rxvt;;
esac

# Paths
#export LD_LIBRARY_PATH=/opt/csw/lib
#zsh's path
export PATH=/usr/sbin:/usr/bin:/sbin:/bin
export MANPATH=~/local/share/man:/usr/man:/usr/share/man
paths=(/usr/texbin /cat/bin /cat/games/bin /opt/csw/sbin /opt/csw/bin
/pkgs/ghc/current/bin /usr/X11/bin /pkgs/chromium/bin /usr/sfw/sbin
/usr/sfw/bin /opt/SUNWut/sbin /opt/SUNWut/bin /usr/ccs/bin /opt/local/sbin
/opt/local/bin /usr/local/share/bin /usr/openwin/bin /usr/bin/X11
~/Library/Haskell/bin /usr/local/bin/X11 /usr/openwin/bin/xview /opt/java/bin
/opt/java5/bin /opt/java/jre/bin /opt/openoffice/program)
prepaths=(/usr/local/bin /usr/local/sbin ~/.cabal/bin ~/local/bin ~/local/sbin
~/local/share/bin)
for dir in $paths ; do
    if [ -d $dir ] ; then
        export PATH=$PATH:$dir
    fi
    if [ -d `dirname $dir`/man ] ; then
        export MANPATH=$MANPATH:`dirname $dir`/man
    fi
done
for dir in $prepaths ; do
    if [ -d $dir ] ; then
        export PATH=$dir:$PATH
    fi
    if [ -d `dirname $dir`/man ] ; then
        export MANPATH=`dirname $dir`/man:$MANPATH
    fi
done
# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
    for profile in /etc/profile.d/*.sh; do
        test -x $profile && . $profile
    done
    unset profile
fi
#gem's path
if [ -d ~/.gems/bin ] ; then
    export PATH="$HOME/.gems/bin:$PATH"
fi
if [ -d ~/.gem/ruby/1.8/bin ] ; then
    export PATH="$PATH:$HOME/.gem/ruby/1.8/bin"
fi
#if [ -d ~/.rvm/bin ] ; then
#    export PATH="$HOME/.rvm/bin:$PATH"
#fi
#for dir in `find /opt/*/bin|grep /bin$` `find /opt/csw/*/bin|grep /bin$` ; do
#    export PATH=$PATH:$dir
#done

# Setting vars
#TERM=rxvt
#export GEM_HOME="$HOME/.gems"
#export GEM_HOME="/Library/Ruby/Gems/1.8"
#export GEM_PATH="$GEM_HOME:/usr/lib/ruby/gems/1.8"
#export GEM_PATH="/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/lib/ruby/gems/1.8"
zshhosts=(serenity.cat.pdx.edu hunner@mint.cic.pdx.edu drkatz.cat.pdx.edu walt.ece.pdx.edu bunny.cat.pdx.edu spof.cat.pdx.edu fops.cat.pdx.edu narsil.cat.pdx.edu hunner@odin.pdx.edu hunnur@alcmaeonllc.com mir.cat.pdx.edu geppetto.cat.pdx.edu)
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.history
export GPGKEY="48C7AF0C"
export NETHACKOPTIONS='autopickup,color,!cmdassist,!number_pad,hilite_pet,boulder:0,pickup_types:$"=/!?+,menustyle:partial,!legacy,suppress_alert:3.3.1'
export ENVPUPPET_BASEDIR="/Users/hunner/Documents/work/git"
export OVFTOOL='/Applications/VMware OVF Tool/ovftool'

# Prompt
#PS1="%m%# "
prompt_precmd() {
    gitcolor=""
    if zgit_isgit ; then
        if ! zgit_isindexclean ; then
            #PROMPT="[%F{$usercolor}%n%F{white}@%F{$hostcolor}%m%F{white}:%F{blue}%~%f](%F{cyan}$(zgit_branch)%f)>"
            gitcolor=$fg[blue]
        elif ! zgit_isworktreeclean ; then
            #PROMPT="[%F{$usercolor}%n%F{white}@%F{$hostcolor}%m%F{white}:%F{blue}%~%f]>"
            gitcolor=$fg[green]
        fi
    fi
    color="%(?.$gitcolor.$fg[red])"
    PROMPT="%m$color%#%{$reset_color%} "
}
#precmd_functions+=prompt_precmd
PROMPT="%m%# "

if [ `uname -s` = "SunOS" ] ; then
    export LANG="C"
else
    export LANG="en_US.UTF-8"
fi
#export LC_CTYPE="en_US.UTF-8"
export LC_COLLATE="C" #order files in ls
#export LC_TIME="en_US.UTF-8"
#export LC_NUMERIC="en_US.UTF-8"
#export LC_MONETARY="en_US.UTF-8"
#export LC_MESSAGES="en_US.UTF-8"
#export LC_ALL='en_US.utf8'
export DIALOGOPTS='--visit-items'
export MAIL=~/mail
export MAILCHECK=0
#export AWT_TOOLKIT=MToolkit
#export AWT_TOOLKIT=XToolkit
export _JAVA_AWT_WM_NONREPARENTING=1
if [ -x `whence less` ] ; then
    export PAGER==less
else
    export PAGER==more
fi
if [ -z "$PERL5LIB" ] ; then
        # If PERL5LIB wasn't previously defined, set it...
        export PERL5LIB=~/local/lib/perl5:~/local/lib/perl5/site_perl
else
        # ...otherwise, extend it.
        export PERL5LIB=$PERL5LIB:~/local/lib/perl5:~/local/lib/perl5/site_perl
fi

## Set up vim aliases
if whence vim > /dev/null ; then
    VIM=vim
    if whence mvim > /dev/null ; then
        #VIM=mvim
        VIM="mvim -c 'au VimLeave * maca hide:'"
    fi
else
    VIM=vi
fi
export VISUAL="$VIM -f"
export EDITOR="$VIM -f"
alias v=$VIM
alias vh="mvim -c 'au VimLeave * maca hide:'"
alias vi=$VIM
alias vr="$VIM --remote-tab"
alias vl="$VIM --serverlist"
vs() { $VIM --servername $1 --remote-tab $argv[2,$] }
alias vd=${VIM}diff
alias vir=vr
alias vis=vs
alias gvim="gvim -font 'APL385 Unicode 8' -c 'set keymap=uniapl385'"

## For forwarding ssh auth I think
if [ -n "$SSH_AUTH_SOCK" ] ; then
    ln -fs $SSH_AUTH_SOCK $HOME/.ssh-agent
fi

## Add extra fonts
#xset fp+ /usr/APL2/fonts/X11
#xset fp  rehash

## Set up ruby gems for $RUBYLIB
#if [ -d $HOME/.gems/gems ] ; then
#    for rlib in $HOME/.gems/gems/*/lib ; do
#        export RUBYLIB=$RUBYLIB:$rlib
#    done
#fi
#for rubylib in /usr/lib/ruby/gems/1.8/gems/*/lib ; do
#    export RUBYLIB=$RUBYLIB:$rubylib
#done

# Aliases
alias ls="ls -F"
alias l="ls -F"
alias ll="l -Fl"
alias la="l -Fa"
alias lla="ll -Fa"
alias c="cd"
cl() { cd $@ && ls }
alias e="TERM=rxvt-256color; emacs -nw"
alias et="TERM=rxvt-256color; emacsclient -t"
alias ec="emacsclient -c --eval '(set-background-color \"black\")'"
alias ecx="emacsclient --eval '(make-frame-on-display \"$DISPLAY\")'"
#alias s="TERM=xterm;ssh serenity.cat.pdx.edu"
alias s="TERM=rxvt;ssh hunner@serenity.cat.pdx.edu"
alias f="TERM=rxvt;ssh hunner@firefly.cat.pdx.edu"
alias z="TERM=rxvt;ssh hunner@zabava.cat.pdx.edu"
alias o="TERM=rxvt;ssh hunner@osiris.cat.pdx.edu"
alias m="TERM=rxvt;ssh hunner@mint.cic.pdx.edu"
alias chandra="TERM=rxvt;ssh hunner@chandra.cs.pdx.edu"
export CS=cs.pdx.edu
alias odin="TERM=xterm;ssh hunner@odin.pdx.edu"
alias budda="ssh hunnur@budda.dreamhost.com"
alias kvar="ssh hunner@131.252.134.134"
alias kvin="ssh hunner@131.252.135.22"
alias mutt="TERM=xterm-256color mutt"
alias x="exit"
alias gpg-add="/usr/libexec/gpg-preset-passphrase"
alias rsync="rsync -azPHe ssh" #-a equals -rlptgoD
alias mang="cd ~/zips/mangband ; DISPLAY=\"\" ./mangclient"
alias nh="export HISTFILE=/dev/null"
#alias cl="co -l"
alias cu="ci -u"
alias sl="screen -ls"
alias sr="screen -r"
alias sx="screen -x"
alias srd="screen -rd"
alias t="TERM=xterm-256color tmux at"
alias tl="tmux ls"
alias bc="bc -q"
alias fm="fmstatus.sh&;shell-fm"
alias apl="gvim -font 'APL385 Unicode 14' -c 'set keymap=uniapl385'"
alias d="dtach -a ~/.dtach"
alias eo="xmodmap ~/keymaps/eo_dv_hunner.pke"
alias vt="export TERM=vt220"
alias rm=rm; unalias rm #hack
alias gs="git status"
alias gl="git lg"
alias gla="git lg --all"
alias go="git checkout"
alias gob="git checkout -b"
alias gb="git branch"
alias ga="git add"
alias gd="git diff"
alias gdc="git diff --cached"
alias gc="git commit"
alias gca="git commit --amend"
alias gfa="git fetch --all"
alias gr="git remote -v show"
alias gp="git push"
alias gu="git pull"
alias gdw="git diff --color-words"
alias gk="gitk --all&"
alias gx="gitx --all"
alias uzbl="uzbl-browser"
alias hide="SetFile -a V"
alias show="SetFile -a v"
#startup aliases
alias -s pdf="zathura"
alias -s txt="vi"
alias -s flv="mplayer"
alias -s avi="mplayer"
alias -s mkv="mplayer"
alias -s mpg="mplayer"

# Functions
args() { echo $#; }
title() { WINTITLE="$*"; print -Pn "\e]0;$WINTITLE\a" }
#if [ x$WINDOW != x ]; then
#    # Running under screen(1)
#    precmd()  { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [W$WINDOW] [%~]\a" || : }
#    preexec() { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [W$WINDOW] [$1]\a" || : }
#else
#    precmd()  { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [%~]\a" || : }
#    preexec() { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [$1]\a" || : }
#fi
if [ x$DISPLAY != x ] ; then
    precmd()  { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [%~]\a" || : }
    preexec() { [ -z "$WINTITLE" ] && print -Pn "\e]0;%m [$1]\a" || : }
fi
alias resize="printf '\33]50;%s%d\007' 'xft:Terminus:pixelsize=' $1" # ':antialias=true'"
alias asdf="xkbcomp -w0 ~/keymaps/xkb/hunner.xkb $DISPLAY"
alias auie="xkbcomp -w0 ~/keymaps/xkb/hunner.xkb $DISPLAY"
alias aoeu='setxkbmap us'
alias bepo='setxkbmap fr bepo "ctrl:swapcaps"'
alias notes='vi ~/Dropbox/Notes/vim*'
alias 256colors='(x=`tput op` y=`printf %80s`;for i in {0..256};do o=00$i;echo -e ${o:${#o}-3:3} `tput setaf $i;tput setab $i`${y// /=}$x;done)'
alias hibernateon='sudo pmset -a hibernatemode 25'
alias hibernateoff='sudo pmset -a hibernatemode 3'
alias hibernate='pmset -g|grep hibernatemode'

if [ -f $HOME/.termcap ] ; then
    TERMCAP=$(< $HOME/.termcap)
    export TERMCAP
fi
make_termcap() {
    cat > $HOME/.termcap << EOF
rxvt-256color|rxvt-256color terminal (X Window System):\
    :Co#256:\
    :tc=rxvt-unicode:\
    :tc=rxvt:
EOF
}
type7() {
    if [ `uname -s` = "SunOS" ] ; then
        xmodmap ~/keymaps/eo_dv_hunner_type7_sol.pke
    else
        xmodmap ~/keymaps/nu_type7.pke
    fi
}
zpush() {
    for host in $zshhosts ; do
        files=(.zshrc .vim .vimrc)
        if [ x$(hostname) = x$host ] ; then
            continue
        fi
        if [ $(uname) = "Linux" ] ; then
            ping -c1 -W1 ${host#*@} > /dev/null
        else
            ping -c1 -t1 ${host#*@} > /dev/null
        fi
        if [ $status -eq 0 ] ; then
            echo -n "$host: copying"
            for file in $files ; do
                echo -n .
                if ! rsync -azPH $file $host:~ > /dev/null ; then continue 2 ; fi
            done
            echo "done"
            #rsync .zshenv $host:~ > /dev/null
        else
            echo "$host: unpings"
        fi
    done;
}
function r() {
    if [[ -n $TMUX ]]; then
        NEW_SSH_AUTH_SOCK=`tmux showenv|grep ^SSH_AUTH_SOCK|cut -d = -f 2`
        if [[ -n $NEW_SSH_AUTH_SOCK ]] && [[ -S $NEW_SSH_AUTH_SOCK ]]; then
            SSH_AUTH_SOCK=$NEW_SSH_AUTH_SOCK
        fi
    fi
}
ex () {
    if whence gtar > /dev/null ; then
        TAR=gtar
    else
        TAR=tar
    fi
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   $TAR xvjf $1  ;;
            *.tar.gz)    $TAR xvzf $1  ;;
            *.tar.xz)    $TAR xvJf $1  ;;
            *.bz2)       bunzip2 $1    ;;
            *.rar)       unrar x $1    ;;
            *.gz)        gunzip $1     ;;
            *.xz)        unxz $1       ;;
            *.tar)       $TAR xvf $1   ;;
            *.tbz2)      $TAR xvjf $1  ;;
            *.tbz)       $TAR xvjf $1  ;;
            *.tgz)       $TAR xvzf $1  ;;
            *.txz)       $TAR xvJf $1  ;;
            *.zip)       unzip $1      ;;
            *.Z)         uncompress $1 ;;
            *.7z)        7z x $1       ;;
            *)           echo "don't know how to extract '$1'..." ;;
        esac
    else
        echo "'$1' is not a valid file!"
    fi
}


[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
## Profiling options
#unsetopt xtrace
#exec 2>&3 3>&-
