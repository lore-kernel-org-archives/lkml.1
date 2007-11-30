Return-Path: <linux-kernel-owner+w=401wt.eu-S1762982AbXK3J3x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762982AbXK3J3x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 04:29:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756896AbXK3J3j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 04:29:39 -0500
Received: from [60.23.248.87] ([60.23.248.87]:44931 "EHLO virgo.fc-cn.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756349AbXK3J3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 04:29:36 -0500
X-Greylist: delayed 1270 seconds by postgrey-1.27 at vger.kernel.org; Fri, 30 Nov 2007 04:29:36 EST
From: Qi Yong <qiyong@fc-cn.com>
Organization: FCD
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [patch] kill an unused PTR_ERR in bdev_cache_init
Date: Fri, 30 Nov 2007 17:08:23 +0800
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_HM9THTRUT4twnio"
Message-Id: <200711301708.23649.qiyong@fc-cn.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_HM9THTRUT4twnio
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Kill an old unused PTR_ERR in bdev_cache_init().


Signed-off-by: Qi Yong <qiyong@fc-cn.com>

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 993f78c..b5fa625 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -534,7 +534,6 @@ void __init bdev_cache_init(void)
 	if (err)
 		panic("Cannot register bdev pseudo-fs");
 	bd_mnt = kern_mount(&bd_type);
-	err = PTR_ERR(bd_mnt);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */
-- 
Qi Yong

--Boundary-00=_HM9THTRUT4twnio
Content-Type: text/x-diff;
  charset="us-ascii";
  name="bdev_cache_init-kill-unused.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="bdev_cache_init-kill-unused.diff"

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 993f78c..b5fa625 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -534,7 +534,6 @@ void __init bdev_cache_init(void)
 	if (err)
 		panic("Cannot register bdev pseudo-fs");
 	bd_mnt = kern_mount(&bd_type);
-	err = PTR_ERR(bd_mnt);
 	if (IS_ERR(bd_mnt))
 		panic("Cannot create bdev pseudo-fs");
 	blockdev_superblock = bd_mnt->mnt_sb;	/* For writeback */

--Boundary-00=_HM9THTRUT4twnio--
