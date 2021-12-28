#!/usr/bin/env bash

# TODO: Work out if user has uninstalled an app manually
function install_app() {
    NAME=$1
    BRANCH="stable"
    REPO="appcenter"

    if [ "$2" != "" ]; then
        BRANCH=$2
    fi

    if [ "$3" != "" ]; then
        REPO=$3
    fi

    flatpak info $NAME $BRANCH || flatpak install --system $REPO $NAME $BRANCH -y
}

echo "Installing AppCenter Flatpak repository..."

# TODO:
# - Get GPG key from remote location?
# - Check if GPG key actually exists on system
# - Check if repository is already enabled
# - Check we can reach the remote, otherwise abandon this attempt after a while
#   until the next boot

flatpak remote-add \
    --comment="The open source, pay-what-you-want app store from elementary" \
    --description="Reviewed and curated by elementary to ensure a native, privacy-respecting, and secure experience" \
    --gpg-import=/usr/share/gnupg/appcenter.gpg \
    --homepage="https://appcenter.elementary.io/" \
    --icon="https://flatpak.elementary.io/icon.svg" \
    --if-not-exists \
    --title="AppCenter" \
    appcenter https://flatpak.elementary.io/repo/ 

install_app org.gnome.Evince
install_app org.gnome.FileRoller

# Web will not be installed automatically due to the following reasons:
# - Firefox is Fedora's default browser: we should respect that decision
# - It's a large package the user possibly doesn't want
# - With Firefox being the default, it would be odd for many users for
#   it to disappear
#
# Instead, the user can run 'sodalite-install-epiphany'
