Return-Path: <linux-kernel-owner+w=401wt.eu-S1759408AbZLJBoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408AbZLJBoR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 20:44:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759397AbZLJBoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 20:44:13 -0500
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:45346 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759396AbZLJBoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 20:44:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws; d=pobox.com; h=to:subject:from
	:date:message-id:mime-version:content-type
	:content-transfer-encoding; q=dns; s=sasl; b=TAGVY2r9VGXbzYhIVeq
	Niusbd07qR73x2kUrVpwTNyYaKzLHWB0MU6klRYQNWNiVCABR8I4cORP2s+kuoqh
	tKDEFAdSY/lcAbxtdJ29wh9/5a5bfXKP4vGH5TtXJjYC2nwv+UPMTm/khIX0Bd9K
	b4na7s3dWkNXFhS2eocDsC9U=
To: git@vger.kernel.org
Subject: [ANNOUNCE] Git 1.6.6.rc2
From: Junio C Hamano <gitster@pobox.com>
Date: Wed, 09 Dec 2009 17:44:02 -0800
Message-ID: <7vocm7li1p.fsf@alter.siamese.dyndns.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Pobox-Relay-ID: 83145E30-E52D-11DE-A5E1-DC0DEE7EF46B-77302942!a-pb-sasl-quonix.pobox.com
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A release candidate Git 1.6.6.rc2 is available at the usual places
for testing:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.6.rc2.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.6.rc2.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.6.rc2.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are found in:

  testing/git-*-1.6.6.rc2-1.fc11.$arch.rpm	(RPM)

The changes since rc1 are mostly updates to the subsystems.

The regression to "git pull" that made the command give annoying warning
message when there is no local commit has been fixed; it appeared in rc1.

----------------------------------------------------------------

Changes since v1.6.6-rc1 are as follows:

Alex Vandiver (3):
      git-svn: sort svk merge tickets to account for minimal parents
      git-svn: Set svn.authorsfile to an absolute path when cloning
      git-svn: set svn.authorsfile earlier when cloning

Alexander Gavrilov (1):
      git-gui: Increase blame viewer usability on MacOS.

Bernt Hansen (1):
      gitk: Skip translation of "wrong Tcl version" message

Brandon Casey (2):
      t4201: use ISO8859-1 rather than ISO-8859-1
      t9001: use older Getopt::Long boolean prefix '--no' rather than '--no-'

Clemens Buchacher (1):
      git-gui: search 4 directories to improve statistic of gc hint

Eric Wong (1):
      git svn: log removals of empty directories

Greg Price (1):
      git svn: Don't create empty directories whose parents were deleted

Guillermo S. Romero (1):
      gitk: Add configuration for UI colour scheme

Heiko Voigt (1):
      git gui: make current branch default in "remote delete branch" merge check

Jakub Narebski (1):
      gitweb: Describe (possible) gitweb.js minification in gitweb/README

Jan Krüger (1):
      pull: clarify advice for the unconfigured error case

Jeff King (3):
      rerere: don't segfault on failure to open rr-cache
      reset: improve worktree safety valves
      add-interactive: fix deletion of non-empty files

Jens Lehmann (2):
      gitk: Fix diffing committed -> staged (typo in diffcmd)
      gitk: Use the --submodule option for displaying diffs when available

Jindrich Makovicka (1):
      git-gui: suppress RenderBadPicture X error caused by Tk bug

Johan Herland (1):
      Fix crasher on encountering SHA1-like non-note in notes tree

Junio C Hamano (9):
      Documentation/Makefile: allow man.base.url.for.relative.link to be set from Make
      Unconditionally set man.base.url.for.relative.links
      Git 1.6.5.4
      Documentation: xmlto 0.0.18 does not know --stringparam
      Prepare for 1.6.5.5
      Git 1.6.5.5
      Revert recent "git merge <msg> HEAD <commit>..." deprecation
      Update draft release notes to 1.6.6 before -rc2
      Git 1.6.6-rc2

Linus Torvalds (1):
      Fix diff -B/--dirstat miscounting of newly added contents

Markus Heidelberg (1):
      gitk: Fix "git gui blame" invocation when called from top-level directory

Mizar (2):
      gitk: Add Japanese translation
      gitk: Update Japanese translation

Pat Thoyts (4):
      gitk: Use themed tk widgets
      gitk: Fix errors in the theme patch
      gitk: Default to the system colours on Windows
      gitk: Fix selection of tags

Paul Mackerras (5):
      gitk: Restore scrolling position of diff pane on back/forward in history
      gitk: Add a user preference to enable/disable use of themed widgets
      gitk: Show diff of commits at end of compare-commits output
      gitk: Don't compare fake children when comparing commits
      gitk: Improve appearance of radiobuttons and checkbuttons

René Scharfe (1):
      archive: clarify description of path parameter

SZEDER Gábor (1):
      bash: update 'git commit' completion

Sitaram Chamarty (1):
      gitk: Disable checkout of remote branches

Todd Zullinger (1):
      Documentation: Avoid use of xmlto --stringparam

