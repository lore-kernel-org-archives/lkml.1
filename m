Return-Path: <linux-kernel-owner+w=401wt.eu-S1757284AbXJCVRo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284AbXJCVRo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2007 17:17:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbXJCVRe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Oct 2007 17:17:34 -0400
Received: from rune.pobox.com ([208.210.124.79]:54338 "EHLO rune.pobox.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbXJCVRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2007 17:17:32 -0400
From: Junio C Hamano <gitster@pobox.com>
To: git@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] GIT 1.5.3.4
References: <7vir66pjhs.fsf@gitster.siamese.dyndns.org>
	<7vve9thrhx.fsf@gitster.siamese.dyndns.org>
Date: Wed, 03 Oct 2007 14:17:22 -0700
In-Reply-To: <7vve9thrhx.fsf@gitster.siamese.dyndns.org> (Junio C. Hamano's
	message of "Sat, 29 Sep 2007 18:27:38 -0700")
Message-ID: <7v1wcbew4d.fsf_-_@gitster.siamese.dyndns.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

The latest maintenance release GIT 1.5.3.4 is available at the
usual places:

  http://www.kernel.org/pub/software/scm/git/

  git-1.5.3.4.tar.{gz,bz2}			(tarball)
  git-htmldocs-1.5.3.4.tar.{gz,bz2}		(preformatted docs)
  git-manpages-1.5.3.4.tar.{gz,bz2}		(preformatted docs)
  RPMS/$arch/git-*-1.5.3.4-1.$arch.rpm	(RPM)

GIT v1.5.3.4 Release Notes
==========================

Fixes since v1.5.3.3
--------------------

 * Change to "git-ls-files" in v1.5.3.3 that was introduced to support
   partial commit of removal better had a segfaulting bug, which was
   diagnosed and fixed by Keith and Carl.

 * Performance improvements for rename detection has been backported
   from the 'master' branch.

 * "git-for-each-ref --format='%(numparent)'" was not working
   correctly at all, and --format='%(parent)' was not working for
   merge commits.

 * Sample "post-receive-hook" incorrectly sent out push
   notification e-mails marked as "From: " the committer of the
   commit that happened to be at the tip of the branch that was
   pushed, not from the person who pushed.

 * "git-remote" did not exit non-zero status upon error.

 * "git-add -i" did not respond very well to EOF from tty nor
   bogus input.

 * "git-rebase -i" squash subcommand incorrectly made the
   author of later commit the author of resulting commit,
   instead of taking from the first one in the squashed series.

 * "git-stash apply --index" was not documented.

 * autoconfiguration learned that "ar" command is found as "gas" on
   some systems.

----------------------------------------------------------------

Changes since v1.5.3.3 are as follows:

Andy Parkins (1):
      post-receive-hook: Remove the From field from the generated email header so that the pusher's name is used

Carl Worth (1):
      Add test case for ls-files --with-tree

Federico Mena Quintero (4):
      Say when --track is useful in the git-checkout docs.
      Add documentation for --track and --no-track to the git-branch docs.
      Note that git-branch will not automatically checkout the new branch
      Make git-pull complain and give advice when there is nothing to merge with

Jari Aalto (1):
      git-remote: exit with non-zero status after detecting errors.

Jean-Luc Herren (2):
      git-add--interactive: Allow Ctrl-D to exit
      git-add--interactive: Improve behavior on bogus input

Jeff King (1):
      diffcore-rename: cache file deltas

Johan Herland (1):
      Mention 'cpio' dependency in INSTALL

Johannes Schindelin (2):
      rebase -i: squash should retain the authorship of the _first_ commit
      Fix typo in config.txt

Junio C Hamano (5):
      Whip post 1.5.3.3 maintenance series into shape.
      git-commit: initialize TMP_INDEX just to be sure.
      for-each-ref: fix %(numparent) and %(parent)
      rename diff_free_filespec_data_large() to diff_free_filespec_blob()
      GIT 1.5.3.4

Keith Packard (1):
      Must not modify the_index.cache as it may be passed to realloc at some point.

Miklos Vajna (1):
      git stash: document apply's --index switch

Robert Schiele (1):
      the ar tool is called gar on some systems

Steffen Prohaska (1):
      fixed link in documentation of diff-options

