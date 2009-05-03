Return-Path: <linux-kernel-owner+w=401wt.eu-S1756691AbZECWAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756691AbZECWAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 18:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbZECV7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 17:59:48 -0400
Received: from fed1rmmtao104.cox.net ([68.230.241.42]:47676 "EHLO
	fed1rmmtao104.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbZECV7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 17:59:46 -0400
X-Authority-Analysis: v=1.0 c=1 a=VwQbUJbxAAAA:8 a=61BYfe8WDedVoHIt8lEA:9
 a=VS4gyZqJFirYrQ9iTIMA:7 a=3mmyFEIdo_7EOmxncbbssRHcgmwA:4
X-CM-Score: 0.00
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.3.rc4
References: <7vhc0acxes.fsf@gitster.siamese.dyndns.org>
From: Junio C Hamano <gitster@pobox.com>
Date: Sun, 03 May 2009 14:59:45 -0700
In-Reply-To: <7vhc0acxes.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's message of "Mon\, 27 Apr 2009 01\:29\:15 -0700")
Message-ID: <7vbpq9luem.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate GIT 1.6.3.rc4 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.3.rc4.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.3.rc4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.3.rc4.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.6.3.rc4-1.fc9.$arch.rpm	(RPM)

This is hopefully the final rc before the real thing; it includes the
updates to git-gui and gitk.

----------------------------------------------------------------

Changes since v1.6.3-rc3 are as follows:

Alex Riesen (3):
      git-gui: Update Russian translation
      improve error message in config.c
      gitk: Add Russian translation

Alexander Gavrilov (3):
      git-gui: Fix post-commit status with subject in non-locale encoding
      git-gui: Avoid an infinite rescan loop in handle_empty_diff.
      git-gui: Support more git version notations.

Allan Caffee (2):
      builtin-merge: fix a typo in an error message
      Documentation: fix a grammatical error in api-builtin.txt

Benjamin Kramer (1):
      daemon.c: fix segfault on OS X

Christian Stimming (1):
      gitk: Mark forgotten string for translation

Daniel A. Steffen (2):
      gitk: Fixes for Mac OS X TkAqua
      git-gui: Fixes for Mac OS X TkAqua

Eric Blake (2):
      Makefile: installing git in cygwin 1.7.0
      doc: consistently use ASCIIDOC_EXTRA

Felipe Contreras (2):
      git config: error when editing a repo config and not being in one
      Fix a bunch of pointer declarations (codestyle)

Ferry Huberts (1):
      git-gui: Ensure consistent usage of mergetool.keepBackup

Giuseppe Bilotta (1):
      gitk: Provide a window icon if possible

Jeff King (1):
      Makefile: fix NO_PERL bug with gitweb

Jens Lehmann (4):
      git-gui: Fix merge conflict display error when filename contains spaces
      git-gui: When calling post-commit hook wrong variable was cleared.
      git-gui: run post-checkout hook on checkout
      git-gui: run post-checkout hook after clone

Joerg Bornemann (1):
      git-gui: fix use of undeclared variable diff_empty_count

Johannes Schindelin (2):
      t5701: do not get stuck in empty-push/
      Rename core.unreliableHardlinks to core.createObject

Johannes Sixt (1):
      prune-packed: advanced progress even for non-existing fan-out directories

Junio C Hamano (3):
      diff -c -p: do not die on submodules
      merge-recursive: do not die on a conflicting submodule
      GIT 1.6.3-rc4

Linus Torvalds (1):
      grep: fix segfault when "git grep '('" is given

Mark Drago (1):
      Add semicolon to curly brace group in main Makefile

Markus Heidelberg (5):
      git-gui: don't hide the Browse button when resizing the repo chooser
      git-gui: fix deleting from the context menu with empty selection
      git-gui: use `git --html-path` to get the location of installed HTML docs
      git-gui (Win): make "Explore Working Copy" more robust
      git-gui (Win): make starting via "Git GUI Here" on .git/ possible

Michele Ballabio (2):
      gitk: Mark some more strings for translation
      gitk: Map KP_Divide to focus the search box

Pat Thoyts (4):
      gitk: Handle blobs containing a DOS end-of-file marker
      gitk: Remember and restore the window state with the geometry
      gitk: Handle external diff tool with spaces in the path
      gitk: Avoid crash if closed while reading references

Patrick Welche (1):
      NetBSD compilation fix

Paul Mackerras (4):
      gitk: Add a way to mark a commit, plus a "find descendant" command
      gitk: Add a command to compare two strings of commits
      gitk: Make .gitk a hidden file under windows
      gitk: Fix compare-commits function when we have local changes

Phil Lawrence (1):
      Append ampersand to "Target" of lnk files created by do_cygwin_shortcut

René Scharfe (1):
      ctype.c: fix typo in comment

Sam Hocevar (2):
      git-gui: various French translation fixes
      git-gui: minor spelling fix and string factorisation.

Sam Vilain (1):
      SubmittingPatches: itemize and reflect upon well written changes

Stephen Boyd (1):
      gitk: Provide a 32x32 window icon based on the git logo

Uwe Kleine-König (1):
      parseopt: fix documentation for --keep-dashdash

