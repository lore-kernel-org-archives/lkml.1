Return-Path: <linux-kernel-owner+w=401wt.eu-S1758658AbXEaVYT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658AbXEaVYT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 17:24:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbXEaVYK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 17:24:10 -0400
Received: from THUNK.ORG ([69.25.196.29]:56066 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752580AbXEaVYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 17:24:09 -0400
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT] Please pull ext4 bug fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1Hts7q-0001zK-Ce@candygram.thunk.org>
Date: Thu, 31 May 2007 17:24:06 -0400
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Linus,

Please pull from the "for_linus" branch at:

	git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

It contains the following fixes, which (except for the superblock field
reservations) have all been in the -mm tree for quite a while.

Thanks, regards,

						- Ted


 fs/ext4/balloc.c                |    6 -
 fs/ext4/extents.c               |  148 +++++++++++++++++++++++++++-------------
 fs/ext4/inode.c                 |    4 -
 fs/ext4/namei.c                 |    4 -
 fs/ext4/super.c                 |    2 
 include/linux/ext4_fs.h         |   33 +++++---
 include/linux/ext4_fs_extents.h |    5 -
 include/linux/ext4_fs_i.h       |    6 -
 8 files changed, 134 insertions(+), 74 deletions(-)

Alex Tomas (1):
      When ext4_ext_insert_extent() fails to insert new blocks

Amit Arora (1):
      ext4: Extent overlap bugfix

Dave Kleikamp (1):
      EXT4: Fix whitespace

Mingming Cao (1):
      Remove unnecessary exported symbols.

Theodore Ts'o (1):
      Define/reserve new ext4 superblock fields

