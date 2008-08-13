Return-Path: <linux-kernel-owner+w=401wt.eu-S1757244AbYHMIsj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbYHMIsj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 04:48:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbYHMIkO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 04:40:14 -0400
Received: from a-sasl-quonix.sasl.smtp.pobox.com ([208.72.237.25]:50455 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755513AbYHMIkE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 04:40:04 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.6.0-rc3
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
cc: linux-kernel@vger.kernel.org
Date: Wed, 13 Aug 2008 01:39:54 -0700
Message-ID: <7viqu5nw9x.fsf@gitster.siamese.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Pobox-Relay-ID: 6B73D5D6-6913-11DD-B98C-3113EBD4C077-77302942!a-sasl-quonix.pobox.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The last rc before the final, 1.6.0-rc3, can be found at the usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.6.0.rc3.tar.{gz,bz2}			(source tarball)
  git-htmldocs-1.6.0.rc3.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.6.0.rc3.tar.{gz,bz2}		(preformatted docs)

The RPM binary packages for a few architectures are also provided
as courtesy.

  testing/git-*-1.6.0.rc3-1.fc9.$arch.rpm	(RPM)

Hopefully the real 1.6.0 will appear over the weekend.

----------------------------------------------------------------

Changes since v1.6.0-rc2 are as follows:

Brandon Casey (2):
      Makefile: set SHELL to value of SHELL_PATH
      Makefile: add a target which will abort compilation with ancient shells

Eric Wong (2):
      git-svn: add ability to specify --commit-url for dcommit
      git-svn: wrap long lines in a few places

Francis Moreau (1):
      git-bisect: fix wrong usage of read(1)

Gustaf Hendeby (2):
      gitattributes: Document built in hunk header patterns
      Teach git diff about BibTeX head hunk patterns

Ivan Stankovic (1):
      Documentation: fix invalid reference to 'mybranch' in user manual

Johannes Schindelin (1):
      clone --mirror: avoid storing repeated tags

Jonathan Nieder (1):
      Documentation: user-manual: "git commit -a" doesn't motivate .gitignore

Junio C Hamano (9):
      asciidoc markup fixes
      GIT-VERSION-GEN: mark the version 'dirty' only if there are modified files
      mailinfo: fix MIME multi-part message boundary handling
      Update draft RelNotes for 1.6.0
      Fix deleting reflog entries from HEAD reflog
      Re-fix rev-list-options documentation
      diff --check: do not unconditionally complain about trailing empty lines
      Do not talk about "diff" in rev-list documentation.
      GIT 1.6.0-rc3

Marcus Griep (5):
      Fix multi-glob assertion in git-svn
      git-svn: Allow deep branch names by supporting multi-globs
      Git.pm: Add faculties to allow temp files to be cached
      git-svn: Make it incrementally faster by minimizing temp files
      git-svn: Reduce temp file usage when dealing with non-links

Nguyễn Thái Ngọc Duy (1):
      Fix typo in comments of longest_ancestor_length()

Petr Baudis (2):
      Fail properly when cloning from invalid HTTP URL
      Adjust for the new way of enabling the default post-update hook

Pieter de Bie (2):
      builtin-rm: Add a --force flag
      reflog test: add more tests for 'reflog delete'

SZEDER Gábor (1):
      bash: remove redundant check for 'git stash apply' options

Stephen R. van den Berg (1):
      git-daemon: SysV needs the signal handler reinstated.

Thomas Rast (6):
      Documentation: commit-tree: remove 16 parents restriction
      Documentation: filter-branch: document how to filter all refs
      filter-branch: be more helpful when an annotated tag changes
      Documentation: rev-list-options: Fix -g paragraph formatting
      Documentation: rev-list-options: Fix a typo
      Documentation: rev-list-options: Rewrite simplification descriptions for clarity

