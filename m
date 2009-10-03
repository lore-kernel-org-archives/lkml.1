Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZJCRqx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZJCRqx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Oct 2009 13:46:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753841AbZJCRqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Oct 2009 13:46:52 -0400
Received: from thunk.org ([69.25.196.29]:59175 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754730AbZJCRqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Oct 2009 13:46:52 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes for v2.6.32
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Mu8gO-0004H4-G9@closure.thunk.org>
Date: Sat, 03 Oct 2009 13:46:12 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, can you pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

This will pick up the fix to the problem Markus Trippelsdorf reported,
plus some other miscellaneous fixes.

                                               - Ted

Curt Wohlgemuth (1):
      ext4: Fix build warning in ext4_dirty_inode()

Eric Sandeen (2):
      ext4: drop ext4dev compat
      ext4: retry failed direct IO allocations

Theodore Ts'o (1):
      ext4: fix a BUG_ON crash by checking that page has buffers attached to it

 fs/ext4/Kconfig |   14 --------------
 fs/ext4/inode.c |   28 +++++++++++++++-------------
 fs/ext4/super.c |   31 -------------------------------
 3 files changed, 15 insertions(+), 58 deletions(-)
