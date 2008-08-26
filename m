Return-Path: <linux-kernel-owner+w=401wt.eu-S1752886AbYHZHGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886AbYHZHGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 03:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752144AbYHZHGn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 03:06:43 -0400
Received: from [93.163.65.50] ([93.163.65.50]:26471 "EHLO kernel.dk"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752002AbYHZHGm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 03:06:42 -0400
Date: Tue, 26 Aug 2008 09:06:41 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] block bits
Message-ID: <20080826070640.GR20055@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A small collection of fixes for 2.6.27, please apply.

  git://git.kernel.dk/linux-2.6-block.git for-linus

Adel Gadllah (1):
      block: clean up cmdfilter sysfs interface

FUJITA Tomonori (5):
      block: move cmdfilter from gendisk to request_queue
      sg: restore command permission for TYPE_SCANNER
      block: rename blk_scsi_cmd_filter to blk_cmd_filter
      bio: fix bio_copy_kern() handling of bio->bv_len
      bio: fix __bio_copy_iov() handling of bio->bv_len

Jens Axboe (2):
      block: submit_bh() inadvertently discards barrier flag on a sync write
      block: remove blk_queue_tag_depth() and blk_queue_tag_queue()

Matthew Wilcox (1):
      block: remove unused ->busy part of the block queue tag map

xiphmont@xiph.org (1):
      SG_IO block filter whitelist missing MMC SET READ AHEAD command

 block/blk-core.c       |    2 +
 block/blk-tag.c        |    6 +-
 block/bsg.c            |   44 +++--------
 block/cmd-filter.c     |  196 ++++++++++++------------------------------------
 block/scsi_ioctl.c     |   95 ++++++++++++++++++++++-
 drivers/scsi/sg.c      |   17 ++++-
 fs/bio.c               |   48 ++++++++----
 fs/buffer.c            |   13 ++-
 include/linux/blkdev.h |   18 +++-
 include/linux/genhd.h  |   10 ---
 10 files changed, 224 insertions(+), 225 deletions(-)

-- 
Jens Axboe

