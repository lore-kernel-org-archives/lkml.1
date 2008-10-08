Return-Path: <linux-kernel-owner+w=401wt.eu-S1755673AbYJHS4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673AbYJHS4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2008 14:56:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752974AbYJHS4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Oct 2008 14:56:06 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:11045 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbYJHS4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2008 14:56:05 -0400
Message-ID: <48ED0233.3040603@oracle.com>
Date: Wed, 08 Oct 2008 11:55:47 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@osdl.org>
CC: jens.axboe@oracle.com, andrew.patterson@hp.com
Subject: [PATCH -mm/git] block_dev: fix kernel-doc in new functions
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

Fix kernel-doc in new functions:

Error(mmotm-2008-1002-1617//fs/block_dev.c:895): duplicate section name 'Description'
Error(mmotm-2008-1002-1617//fs/block_dev.c:924): duplicate section name 'Description'
Warning(mmotm-2008-1002-1617//fs/block_dev.c:1282): No description found for parameter 'pathname'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Andrew Patterson <andrew.patterson@hp.com>

---
 fs/block_dev.c |   13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

--- mmotm-2008-1002-1617.orig/fs/block_dev.c
+++ mmotm-2008-1002-1617/fs/block_dev.c
@@ -884,9 +884,7 @@ static void flush_disk(struct block_devi
 }
 
 /**
- * check_disk_size_change - checks for disk size change and adjusts
- *                          bdev size.
- *
+ * check_disk_size_change - checks for disk size change and adjusts bdev size.
  * @disk: struct gendisk to check
  * @bdev: struct bdev to adjust.
  *
@@ -913,9 +911,7 @@ void check_disk_size_change(struct gendi
 EXPORT_SYMBOL(check_disk_size_change);
 
 /**
- * revalidate_disk - wrapper for lower-level driver's revalidate_disk
- *                   call-back
- *
+ * revalidate_disk - wrapper for lower-level driver's revalidate_disk call-back
  * @disk: struct gendisk to be revalidated
  *
  * This routine is a wrapper for lower-level driver's revalidate_disk
@@ -1271,10 +1267,9 @@ EXPORT_SYMBOL(ioctl_by_bdev);
 
 /**
  * lookup_bdev  - lookup a struct block_device by name
+ * @pathname:	special file representing the block device
  *
- * @path:	special file representing the block device
- *
- * Get a reference to the blockdevice at @path in the current
+ * Get a reference to the blockdevice at @pathname in the current
  * namespace if possible and return it.  Return ERR_PTR(error)
  * otherwise.
  */
