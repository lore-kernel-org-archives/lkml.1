Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYJNRES@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYJNRES (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 13:04:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751924AbYJNREJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 13:04:09 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:28930 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909AbYJNREI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 13:04:08 -0400
Message-ID: <48F4D100.5080400@oracle.com>
Date: Tue, 14 Oct 2008 10:04:00 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, jens.axboe@oracle.com
Subject: [PATCH] block: fix current kernel-doc warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix block kernel-doc warnings:

Warning(linux-2.6.27-git4//fs/block_dev.c:1272): No description found for parameter 'path'
Warning(linux-2.6.27-git4//block/blk-core.c:1021): No description found for parameter 'cpu'
Warning(linux-2.6.27-git4//block/blk-core.c:1021): No description found for parameter 'part'
Warning(/var/linsrc/linux-2.6.27-git4//block/genhd.c:544): No description found for parameter 'partno'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 block/blk-core.c |    5 +++--
 block/genhd.c    |    2 +-
 fs/block_dev.c   |    2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

--- linux-2.6.27-git4.orig/block/blk-core.c
+++ linux-2.6.27-git4/block/blk-core.c
@@ -1003,8 +1003,9 @@ static void part_round_stats_single(int 
 }
 
 /**
- * part_round_stats()	- Round off the performance stats on a struct
- * disk_stats.
+ * part_round_stats() - Round off the performance stats on a struct disk_stats.
+ * @cpu: cpu number for stats access
+ * @part: target partition
  *
  * The average IO queue length and utilisation statistics are maintained
  * by observing the current state of the queue length and the amount of
--- linux-2.6.27-git4.orig/block/genhd.c
+++ linux-2.6.27-git4/block/genhd.c
@@ -535,7 +535,7 @@ void unlink_gendisk(struct gendisk *disk
 /**
  * get_gendisk - get partitioning information for a given device
  * @devt: device to get partitioning information for
- * @part: returned partition index
+ * @partno: returned partition index
  *
  * This function gets the structure containing partitioning
  * information for the given device @devt.
--- linux-2.6.27-git4.orig/fs/block_dev.c
+++ linux-2.6.27-git4/fs/block_dev.c
@@ -1262,7 +1262,7 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 
 /**
  * lookup_bdev  - lookup a struct block_device by name
- * @pathname:	special file representing the block device
+ * @path:	special file representing the block device
  *
  * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
