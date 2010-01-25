Return-Path: <linux-kernel-owner+w=401wt.eu-S1752791Ab0AYVbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab0AYVbb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 16:31:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751876Ab0AYVb2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 16:31:28 -0500
Received: from thunk.org ([69.25.196.29]:59567 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab0AYVb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 16:31:26 -0500
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] ext4 fixes
From: "Theodore Ts'o" <tytso@mit.edu>
Phone: (781) 391-3464
Message-Id: <E1NZWWf-00047q-QF@closure.thunk.org>
Date: Mon, 25 Jan 2010 16:31:13 -0500
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull from:

        git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git for_linus

to grab the following regression fixes for ext4 and jbd2.

Thanks,

                                                - Ted

Aneesh Kumar K.V (3):
      ext4: Handle -EDQUOT error on write
      ext4: Fix quota accounting error with fallocate
      ext4: Drop EXT4_GET_BLOCKS_UPDATE_RESERVE_SPACE flag

 fs/ext4/ext4.h    |    9 ++---
 fs/ext4/extents.c |   21 +++++++++++++
 fs/ext4/inode.c   |   82 +++++++++++++++++++++++++++++++++-------------------
 3 files changed, 77 insertions(+), 35 deletions(-)
