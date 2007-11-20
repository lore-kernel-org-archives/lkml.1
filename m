Return-Path: <linux-kernel-owner+w=401wt.eu-S1760660AbXKTB7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760660AbXKTB7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbXKTBuB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:50:01 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2109 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755598AbXKTBtR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:49:17 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Woodhouse <dwmw2@infradead.org>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       linux-mtd@lists.infradead.org
Subject: [PATCH 28/59] drivers/mtd: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:20 -0800
Message-Id: <1195523331-15303-29-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-28-git-send-email-joe@perches.com>
References: 1234567
 <1195523331-15303-1-git-send-email-joe@perches.com>
 <1195523331-15303-2-git-send-email-joe@perches.com>
 <1195523331-15303-3-git-send-email-joe@perches.com>
 <1195523331-15303-4-git-send-email-joe@perches.com>
 <1195523331-15303-5-git-send-email-joe@perches.com>
 <1195523331-15303-6-git-send-email-joe@perches.com>
 <1195523331-15303-7-git-send-email-joe@perches.com>
 <1195523331-15303-8-git-send-email-joe@perches.com>
 <1195523331-15303-9-git-send-email-joe@perches.com>
 <1195523331-15303-10-git-send-email-joe@perches.com>
 <1195523331-15303-11-git-send-email-joe@perches.com>
 <1195523331-15303-12-git-send-email-joe@perches.com>
 <1195523331-15303-13-git-send-email-joe@perches.com>
 <1195523331-15303-14-git-send-email-joe@perches.com>
 <1195523331-15303-15-git-send-email-joe@perches.com>
 <1195523331-15303-16-git-send-email-joe@perches.com>
 <1195523331-15303-17-git-send-email-joe@perches.com>
 <1195523331-15303-18-git-send-email-joe@perches.com>
 <1195523331-15303-19-git-send-email-joe@perches.com>
 <1195523331-15303-20-git-send-email-joe@perches.com>
 <1195523331-15303-21-git-send-email-joe@perches.com>
 <1195523331-15303-22-git-send-email-joe@perches.com>
 <1195523331-15303-23-git-send-email-joe@perches.com>
 <1195523331-15303-24-git-send-email-joe@perches.com>
 <1195523331-15303-25-git-send-email-joe@perches.com>
 <1195523331-15303-26-git-send-email-joe@perches.com>
 <1195523331-15303-27-git-send-email-joe@perches.com>
 <1195523331-15303-28-git-send-email-joe@perches.com>
Message-Id: <3ad6205457781910c10dd7261e606de0bf7bafac.1195454435.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/nand/nandsim.c         |    2 +-
 drivers/mtd/onenand/onenand_base.c |    4 ++--
 drivers/mtd/ssfdc.c                |    4 ++--
 drivers/mtd/ubi/build.c            |    8 ++++----
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 10490b4..54be667 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -1425,7 +1425,7 @@ static int do_state_action(struct nandsim *ns, uint32_t action)
 
 	case ACTION_HALFOFF:
 		if (!(ns->options & OPT_PAGE512_8BIT)) {
-			NS_ERR("do_state_action: BUG! can't skip half of page for non-512"
+			NS_ERR("do_state_action: BUG! can't skip half of page for non-512 "
 				"byte page size 8x chips\n");
 			return -1;
 		}
diff --git a/drivers/mtd/onenand/onenand_base.c b/drivers/mtd/onenand/onenand_base.c
index 1b0b320..89ddbaf 100644
--- a/drivers/mtd/onenand/onenand_base.c
+++ b/drivers/mtd/onenand/onenand_base.c
@@ -1119,7 +1119,7 @@ static int onenand_bbt_wait(struct mtd_info *mtd, int state)
 		if (ecc & ONENAND_ECC_2BIT_ALL)
 			return ONENAND_BBT_READ_ERROR;
 	} else {
-		printk(KERN_ERR "onenand_bbt_wait: read timeout!"
+		printk(KERN_ERR "onenand_bbt_wait: read timeout! "
 			"ctrl=0x%04x intr=0x%04x\n", ctrl, interrupt);
 		return ONENAND_BBT_READ_FATAL_ERROR;
 	}
@@ -2542,7 +2542,7 @@ static void onenand_resume(struct mtd_info *mtd)
 	if (this->state == FL_PM_SUSPENDED)
 		onenand_release_device(mtd);
 	else
-		printk(KERN_ERR "resume() called for the chip which is not"
+		printk(KERN_ERR "resume() called for the chip which is not "
 				"in suspended state\n");
 }
 
diff --git a/drivers/mtd/ssfdc.c b/drivers/mtd/ssfdc.c
index a5f3d60..9a38328 100644
--- a/drivers/mtd/ssfdc.c
+++ b/drivers/mtd/ssfdc.c
@@ -222,7 +222,7 @@ static int get_logical_address(uint8_t *oob_buf)
 
 			if (get_parity(block_address, 10) != parity) {
 				DEBUG(MTD_DEBUG_LEVEL0,
-					"SSFDC_RO: logical address field%d"
+					"SSFDC_RO: logical address field%d "
 					"parity error(0x%04X)\n", j+1,
 					block_address);
 			} else {
@@ -280,7 +280,7 @@ static int build_logical_block_map(struct ssfdcr_record *ssfdc)
 				(unsigned short)phys_block;
 
 			DEBUG(MTD_DEBUG_LEVEL2,
-				"SSFDC_RO: build_block_map() phys_block=%d,"
+				"SSFDC_RO: build_block_map() phys_block=%d, "
 				"logic_block_addr=%d, zone=%d\n",
 				phys_block, block_address, zone_index);
 		}
diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 0236539..c3b37e7 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -852,10 +852,10 @@ MODULE_PARM_DESC(mtd, "MTD devices to attach. Parameter format: "
 		      "Optional \"vid_hdr_offs\" and \"data_offs\" parameters "
 		      "specify UBI VID header position and data starting "
 		      "position to be used by UBI.\n"
-		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD device"
-		      "with name content using VID header offset 1984 and data "
-		      "start 2048, and MTD device number 4 using default "
-		      "offsets");
+		      "Example: mtd=content,1984,2048 mtd=4 - attach MTD "
+		      "device with name content using VID header offset 1984 "
+		      "and data start 2048, and MTD device number 4 using "
+		      "default offsets");
 
 MODULE_VERSION(__stringify(UBI_VERSION));
 MODULE_DESCRIPTION("UBI - Unsorted Block Images");
-- 
1.5.3.5.652.gf192c

