Return-Path: <linux-kernel-owner+w=401wt.eu-S934299AbXC2BM6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934299AbXC2BM6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 21:12:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934296AbXC2BM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 21:12:57 -0400
Received: from fed1rmmtao102.cox.net ([68.230.241.44]:53045 "EHLO
	fed1rmmtao102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965811AbXC2BM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 21:12:56 -0400
From: Junio C Hamano <junkio@cox.net>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.0.6
cc: linux-kernel@vger.kernel.org
Date: Wed, 28 Mar 2007 18:12:55 -0700
Message-ID: <7vlkhgc0o8.fsf@assigned-by-dhcp.cox.net>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.0.6 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.0.6.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.0.6.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.0.6.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.0.6-1.$arch.rpm	(RPM)

GIT v1.5.0.6 Release Notes
==========================

Fixes since v1.5.0.5
--------------------

* Bugfixes

  - a handful small fixes to gitweb.

  - build procedure for user-manual is fixed not to require locally
    installed stylesheets.

  - "git commit $paths" on paths whose earlier contents were
    already updated in the index were failing out.

* Documentation

  - user-manual has better cross references.

  - gitweb installation/deployment procedure is now documented.

----------------------------------------------------------------

Changes since v1.5.0.5 are as follows:

J. Bruce Fields (5):
      user-manual: run xsltproc without --nonet option
      user-manual: Use def_ instead of ref_ for glossary references.
      glossary: stop generating automatically
      glossary: clean up cross-references
      user-manual: introduce "branch" and "branch head" differently

Jakub Narebski (4):
      gitweb: Fix "next" link in commit view
      gitweb: Don't escape attributes in CGI.pm HTML methods
      gitweb: Fix not marking signoff lines in "log" view
      gitweb: Add some installation notes in gitweb/INSTALL

Jeff King (1):
      commit: fix pretty-printing of messages with "\nencoding "

Jim Meyering (1):
      user-manual.txt: fix a tiny typo.

Johannes Schindelin (1):
      t4118: be nice to non-GNU sed

Junio C Hamano (2):
      git-commit: "read-tree -m HEAD" is not the right way to read-tree quickly
      GIT 1.5.0.6

Li Yang (1):
      gitweb: Change to use explicitly function call cgi->escapHTML()

Michael S. Tsirkin (1):
      fix typo in git-am manpage

Peter Eriksen (1):
      Documentation/pack-format.txt: Clear up description of types.


