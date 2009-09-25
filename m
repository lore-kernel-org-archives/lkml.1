Return-Path: <linux-kernel-owner+w=401wt.eu-S1753175AbZIYQMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175AbZIYQMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Sep 2009 12:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753100AbZIYQL7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Sep 2009 12:11:59 -0400
Received: from brick.kernel.dk ([93.163.65.50]:39662 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072AbZIYQL6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Sep 2009 12:11:58 -0400
Date: Fri, 25 Sep 2009 18:12:01 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, fengguang.wu@intel.com,
       jack@suse.cz
Subject: [GIT PULL] writeback updates for -rc1
Message-ID: <20090925161201.GS23126@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Last round of tweaks/cleanups to the writeback code for -rc1. Please
pull.

  git://git.kernel.dk/linux-2.6-block.git writeback

Jan Kara (1):
      fs: Fix busyloop in wb_writeback()

Jens Axboe (5):
      writeback: improve readability of the wb_writeback() continue/break logic
      writeback: get rid to incorrect references to pdflush in comments
      writeback: don't resort for a single super_block in move_expired_inodes()
      writeback: make the super_block pinning more efficient
      writeback: writeback_inodes_sb() should use bdi_start_writeback()

Shaohua Li (1):
      writeback: move inodes from one super_block together

Wu Fengguang (5):
      writeback: balance_dirty_pages() shall write more than dirtied pages
      writeback: stop background writeback when below background threshold
      writeback: kupdate writeback shall not stop when more io is possible
      writeback: cleanup writeback_single_inode()
      writeback: don't delay inodes redirtied by a fast dirtier

 fs/buffer.c         |   10 ++--
 fs/fs-writeback.c   |  161 ++++++++++++++++++++++++++++++++++++---------------
 mm/page-writeback.c |   30 ++++++----
 mm/shmem.c          |    5 +-
 mm/vmscan.c         |    8 +-
 5 files changed, 142 insertions(+), 72 deletions(-)

-- 
Jens Axboe

