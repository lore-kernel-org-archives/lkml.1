Return-Path: <linux-kernel-owner+w=401wt.eu-S1751616AbZL2MXb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616AbZL2MXb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 07:23:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbZL2MXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 07:23:31 -0500
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:57662 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbZL2MXa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 07:23:30 -0500
Date: Tue, 29 Dec 2009 13:23:28 +0100
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] block bits for 2.6.33-rc3
Message-ID: <20091229122328.GR4489@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A round of collected fixes for the current 2.6.33-rc2 kernel. The
shortlog lists a duplicated entry, the reason being that I integrated a
fix that was also added in the drbd branch I later pulled in.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Andrew Morton (1):
      aoe: switch to the new bio_flush_dcache_pages() interface

Emese Revfy (1):
      drbd: Constify struct file_operations

FUJITA Tomonori (1):
      block: remove Documentation/block/as-iosched.txt

H Hartley Sweeten (1):
      drivers/block/mg_disk.c: use resource_size()

Huang Weiyi (2):
      drbd: remove duplicated #include
      drbd: remove unused #include <linux/version.h>

Jens Axboe (1):
      Merge branch 'for-jens' of git://git.drbd.org/linux-2.6-drbd into for-linus

Julia Lawall (1):
      drivers/block/DAC960.c: use DAC960_V2_Controller

Martin K. Petersen (2):
      block: Fix topology stacking for data and discard alignment
      block: Fix incorrect alignment offset reporting and update documentation

OGAWA Hirofumi (1):
      block: Honor the gfp_mask for alloc_page() in blkdev_issue_discard()

Roel Kluin (2):
      drbd: fix test of unsigned in _drbd_fault_random()
      drbd: Fix test of unsigned in _drbd_fault_random()

Shaohua Li (1):
      cfq-iosched: don't regard requests with long distance as close

Vivek Goyal (3):
      cfq-iosched: Remove the check for same cfq group from allow_merge
      cfq-iosched: Get rid of nr_groups
      cfq-iosched: Remove prio_change logic for workload selection

 Documentation/block/00-INDEX       |    2 -
 Documentation/block/as-iosched.txt |  172 ------------------------------------
 block/blk-barrier.c                |    2 +-
 block/blk-settings.c               |  121 ++++++++++++++++---------
 block/cfq-iosched.c                |   67 ++++----------
 drivers/block/DAC960.c             |    2 +-
 drivers/block/aoe/aoecmd.c         |   17 +----
 drivers/block/drbd/drbd_int.h      |    2 +-
 drivers/block/drbd/drbd_main.c     |    5 +-
 drivers/block/drbd/drbd_proc.c     |    2 +-
 drivers/block/drbd/drbd_receiver.c |    1 -
 drivers/block/drbd/drbd_worker.c   |    2 -
 drivers/block/mg_disk.c            |    2 +-
 include/linux/blkdev.h             |   11 ++-
 14 files changed, 115 insertions(+), 293 deletions(-)
 delete mode 100644 Documentation/block/as-iosched.txt

-- 
Jens Axboe

