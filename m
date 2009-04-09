Return-Path: <linux-kernel-owner+w=401wt.eu-S936692AbZDIUsZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936692AbZDIUsZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 16:48:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760962AbZDIUsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 16:48:16 -0400
Received: from thunk.org ([69.25.196.29]:56105 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760807AbZDIUsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 16:48:15 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Ls1AM-0005OR-NI@closure.thunk.org>
Date: Thu, 09 Apr 2009 16:48:06 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please grab the latest ext4 fixes from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

Thanks!!

						- Ted

From: Thiemo Nagel (1):
      ext4: check block device size on mount

Thiemo Nagel (2):
      ext4: Fix big-endian problem in __ext4_check_blockref()
      ext4: Fix off-by-one-error in ext4_valid_extent_idx()

 fs/ext4/extents.c |    2 +-
 fs/ext4/inode.c   |    8 ++++----
 fs/ext4/super.c   |    9 +++++++++
 3 files changed, 14 insertions(+), 5 deletions(-)


