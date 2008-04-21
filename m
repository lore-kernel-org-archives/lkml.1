Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbYDUWtZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbYDUWtZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 18:49:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753727AbYDUWtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 18:49:15 -0400
Received: from a-sasl-fastnet.sasl.smtp.pobox.com ([207.106.133.19]:57336 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753809AbYDUWtO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 18:49:14 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.5.1
cc: linux-kernel@vger.kernel.org
Date: Mon, 21 Apr 2008 15:48:59 -0700
Message-ID: <7vej8yako4.fsf@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.5.1 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.5.1.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.5.1.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.5.1.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.5.1-1.$arch.rpm	(RPM)

Fortunately there weren't many brown paper bag breakages we needed to fix
immediately after releasing 1.5.5, but there do exist some usability and
documentation fixes accumulated on the maintenance branch.  This release
delibers them.

----------------------------------------------------------------

Changes since v1.5.5 are as follows:

Alberto Bertogli (1):
      builtin-apply: Show a more descriptive error on failure when opening a patch

Björn Steinbrink (1):
      Fix section about backdating tags in the git-tag docs

Carlos Rica (2):
      Fix documentation syntax of optional arguments in short options.
      core-tutorial.txt: Fix showing the current behaviour.

Christian Couder (4):
      bisect: fix bad rev checking in "git bisect good"
      bisect: report bad rev better
      bisect: squelch "fatal: ref HEAD not a symref" misleading message
      git-bisect: make "start", "good" and "skip" succeed or fail atomically

Clifford Caoile (1):
      Docs gitk: Explicitly mention the files that gitk uses (~/.gitk)

Daniel Barkalow (1):
      Fix config key miscount in url.*.insteadOf

Dirk Suesserott (1):
      Documentation/git-request-pull: Fixed a typo ("send" -> "end")

Jakub Narebski (1):
      gitweb: Fix 'history' view for deleted files with history

Jeff King (1):
      git-fetch: fix status output when not storing tracking ref

Johannes Sixt (1):
      Document option --only of git commit

Jon Loeliger (1):
      Clarify and fix English in "git-rm" documentation

Jonas Fonseca (1):
      git-remote: reject adding remotes with invalid names

Junio C Hamano (7):
      Document -w option to shortlog
      Documentation/git-submodule: typofix
      t7401: squelch garbage output
      rebase: do not munge commit log message
      git-am: minor cleanup
      am: POSIX portability fix
      GIT 1.5.5.1

Linus Torvalds (2):
      Ignore leading empty lines while summarizing merges
      git-am: cope better with an empty Subject: line

Mark Levedahl (1):
      git-submodule - possibly use branch name to describe a module

Matthieu Moy (1):
      Document that WebDAV doesn't need git on the server, and works over SSL

Michele Ballabio (1):
      revision.c: make --date-order overriddable

Pedro Melo (1):
      Force the medium pretty format on calls to git log

Ping Yin (1):
      git-submodule: Avoid 'fatal: cannot describe' message

René Scharfe (1):
      git-archive: ignore prefix when checking file attribute

Scott Collins (1):
      Clarify documentation of git-cvsserver, particularly in relation to git-shell

Shawn Bohrer (2):
      git clean: Don't automatically remove directories when run within subdirectory
      git clean: Add test to verify directories aren't removed with a prefix

