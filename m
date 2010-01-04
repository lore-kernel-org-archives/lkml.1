Return-Path: <linux-kernel-owner+w=401wt.eu-S1753303Ab0ADDKj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab0ADDKj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jan 2010 22:10:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752944Ab0ADDKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Jan 2010 22:10:35 -0500
Received: from THUNK.ORG ([69.25.196.29]:57900 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753172Ab0ADDKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jan 2010 22:10:24 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes for v2.6.33
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1NRbdv-0006oG-Hg@closure.thunk.org>
Date: Sun, 03 Jan 2010 20:21:59 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab a bug fix for v2.6.33.  This fixes a stupid typo and some
undesirable side effects of commit 0637c6f (which at least prevented
people from BUG'ing, but it would be great to get these fixes in before
-rc3).

Thanks!!

                                                        - Ted

Theodore Ts'o (2):
      ext4: Fix accounting of reserved metadata blocks
      ext4: Calculate metadata requirements more accurately

 fs/ext4/ext4.h         |    2 +
 fs/ext4/ext4_extents.h |    3 +-
 fs/ext4/extents.c      |   49 ++++++++++++++++++++++-----------
 fs/ext4/inode.c        |   70 +++++++++++++++++++++++++++--------------------
 fs/ext4/super.c        |    1 +
 5 files changed, 77 insertions(+), 48 deletions(-)
