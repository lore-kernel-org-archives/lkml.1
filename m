Return-Path: <linux-kernel-owner+w=401wt.eu-S935827AbXLQTwi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935827AbXLQTwi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2007 14:52:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933635AbXLQTko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Dec 2007 14:40:44 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:3170 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763929AbXLQTkl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2007 14:40:41 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Vincent Sanders <support@simtec.co.uk>, linux-mtd@lists.infradead.org
Subject: [PATCH] drivers/mtd/: Spelling fixes
Date: Mon, 17 Dec 2007 11:40:07 -0800
Message-Id: <1197920439-5455-1-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.7.949.g2221a6
Message-Id: <5703e57f925f31fc0eb38873bd7f10fc44f99cb4.1197918891.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/mtd/nand/autcpu12.c    |    6 +++---
 drivers/mtd/nand/bf5xx_nand.c  |    2 +-
 drivers/mtd/nand/cs553x_nand.c |    2 +-
 drivers/mtd/nand/edb7312.c     |    2 +-
 drivers/mtd/nand/nand_base.c   |    2 +-
 drivers/mtd/nand/nandsim.c     |    2 +-
 drivers/mtd/nand/s3c2410.c     |    2 +-
 drivers/mtd/nand/sharpsl.c     |    2 +-
 8 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/mtd/nand/autcpu12.c b/drivers/mtd/nand/autcpu12.c
index e3744eb..dd38011 100644
--- a/drivers/mtd/nand/autcpu12.c
+++ b/drivers/mtd/nand/autcpu12.c
@@ -20,7 +20,7 @@
  *
  *	02-12-2002 TG	Cleanup of module params
  *
- *	02-20-2002 TG	adjusted for different rd/wr adress support
+ *	02-20-2002 TG	adjusted for different rd/wr address support
  *			added support for read device ready/busy line
  *			added page_cache
  *
@@ -144,7 +144,7 @@ static int __init autcpu12_init(void)
 		goto out;
 	}
 
-	/* map physical adress */
+	/* map physical address */
 	autcpu12_fio_base = ioremap(AUTCPU12_PHYS_SMC, SZ_1K);
 	if (!autcpu12_fio_base) {
 		printk("Ioremap autcpu12 SmartMedia Card failed\n");
@@ -227,7 +227,7 @@ static void __exit autcpu12_cleanup(void)
 	/* Release resources, unregister device */
 	nand_release(autcpu12_mtd);
 
-	/* unmap physical adress */
+	/* unmap physical address */
 	iounmap(autcpu12_fio_base);
 
 	/* Free the MTD device structure */
diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
index 1657ecd..a52f3a7 100644
--- a/drivers/mtd/nand/bf5xx_nand.c
+++ b/drivers/mtd/nand/bf5xx_nand.c
@@ -4,7 +4,7 @@
  *	http://blackfin.uclinux.org/
  *	Bryan Wu <bryan.wu@analog.com>
  *
- * Blackfin BF5xx on-chip NAND flash controler driver
+ * Blackfin BF5xx on-chip NAND flash controller driver
  *
  * Derived from drivers/mtd/nand/s3c2410.c
  * Copyright (c) 2007 Ben Dooks <ben@simtec.co.uk>
diff --git a/drivers/mtd/nand/cs553x_nand.c b/drivers/mtd/nand/cs553x_nand.c
index 89deff0..19e1594 100644
--- a/drivers/mtd/nand/cs553x_nand.c
+++ b/drivers/mtd/nand/cs553x_nand.c
@@ -337,7 +337,7 @@ static void __exit cs553x_cleanup(void)
 		nand_release(cs553x_mtd[i]);
 		cs553x_mtd[i] = NULL;
 
-		/* unmap physical adress */
+		/* unmap physical address */
 		iounmap(mmio_base);
 
 		/* Free the MTD device structure */
diff --git a/drivers/mtd/nand/edb7312.c b/drivers/mtd/nand/edb7312.c
index 0146cdc..ba67bbe 100644
--- a/drivers/mtd/nand/edb7312.c
+++ b/drivers/mtd/nand/edb7312.c
@@ -125,7 +125,7 @@ static int __init ep7312_init(void)
 		return -ENOMEM;
 	}
 
-	/* map physical adress */
+	/* map physical address */
 	ep7312_fio_base = ioremap(ep7312_fio_pbase, SZ_1K);
 	if (!ep7312_fio_base) {
 		printk("ioremap EDB7312 NAND flash failed\n");
diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
index e29c1da..ddd4fc0 100644
--- a/drivers/mtd/nand/nand_base.c
+++ b/drivers/mtd/nand/nand_base.c
@@ -89,7 +89,7 @@ static int nand_do_write_oob(struct mtd_info *mtd, loff_t to,
 			     struct mtd_oob_ops *ops);
 
 /*
- * For devices which display every fart in the system on a seperate LED. Is
+ * For devices which display every fart in the system on a separate LED. Is
  * compiled away when LED support is disabled.
  */
 DEFINE_LED_TRIGGER(nand_led_trigger);
diff --git a/drivers/mtd/nand/nandsim.c b/drivers/mtd/nand/nandsim.c
index 10490b4..bb885d1 100644
--- a/drivers/mtd/nand/nandsim.c
+++ b/drivers/mtd/nand/nandsim.c
@@ -210,7 +210,7 @@ MODULE_PARM_DESC(overridesize,   "Specifies the NAND Flash size overriding the I
 #define STATE_CMD_RESET        0x0000000C /* reset */
 #define STATE_CMD_MASK         0x0000000F /* command states mask */
 
-/* After an addres is input, the simulator goes to one of these states */
+/* After an address is input, the simulator goes to one of these states */
 #define STATE_ADDR_PAGE        0x00000010 /* full (row, column) address is accepted */
 #define STATE_ADDR_SEC         0x00000020 /* sector address was accepted */
 #define STATE_ADDR_ZERO        0x00000030 /* one byte zero address was accepted */
diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
index 66f76e9..2bd0737 100644
--- a/drivers/mtd/nand/s3c2410.c
+++ b/drivers/mtd/nand/s3c2410.c
@@ -8,7 +8,7 @@
  *
  * Changelog:
  *	21-Sep-2004  BJD  Initial version
- *	23-Sep-2004  BJD  Mulitple device support
+ *	23-Sep-2004  BJD  Multiple device support
  *	28-Sep-2004  BJD  Fixed ECC placement for Hardware mode
  *	12-Oct-2004  BJD  Fixed errors in use of platform data
  *	18-Feb-2005  BJD  Fix sparse errors
diff --git a/drivers/mtd/nand/sharpsl.c b/drivers/mtd/nand/sharpsl.c
index 51c7288..033f880 100644
--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -165,7 +165,7 @@ static int __init sharpsl_nand_init(void)
 		return -ENOMEM;
 	}
 
-	/* map physical adress */
+	/* map physical address */
 	sharpsl_io_base = ioremap(sharpsl_phys_base, 0x1000);
 	if (!sharpsl_io_base) {
 		printk("ioremap to access Sharp SL NAND chip failed\n");
-- 
1.5.3.7.949.g2221a6

