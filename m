Return-Path: <linux-kernel-owner+w=401wt.eu-S1762176AbXGDMbB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762176AbXGDMbB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:31:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761074AbXGDMa2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:30:28 -0400
Received: from noname.neutralserver.com ([70.84.186.210]:59083 "EHLO
	noname.neutralserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761911AbXGDMa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:30:27 -0400
Date: Wed, 4 Jul 2007 15:30:22 +0300
From: Dan Aloni <da-x@monatomic.org>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: [PATCH 10/11] drivers/block/rd.c: lower printk severity
Message-ID: <93d7a361198aac1cdb9bbfe556ae60faa40ff36c.1183551645.git.da-x@monatomic.org>
References: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6789b0ff288d584d640ee65f8e1e5e27bf040862.1183551644.git.da-x@monatomic.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - noname.neutralserver.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - monatomic.org
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Dan Aloni <da-x@monatomic.org>
---
 drivers/block/rd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/rd.c b/drivers/block/rd.c
index a1512da..3b974f8 100644
--- a/drivers/block/rd.c
+++ b/drivers/block/rd.c
@@ -463,9 +463,9 @@ static int __init rd_init(void)
 	}
 
 	/* rd_size is given in kB */
-	printk("RAMDISK driver initialized: "
-		"%d RAM disks of %dK size %d blocksize\n",
-		CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
+	printk(KERN_INFO "RAMDISK driver initialized: "
+	       "%d RAM disks of %dK size %d blocksize\n",
+	       CONFIG_BLK_DEV_RAM_COUNT, rd_size, rd_blocksize);
 
 	return 0;
 out:
-- 
1.4.4.3


-- 
Dan Aloni
XIV LTD, http://www.xivstorage.com
da-x (at) monatomic.org, dan (at) xiv.co.il
