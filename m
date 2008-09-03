Return-Path: <linux-kernel-owner+w=401wt.eu-S1754837AbYICKsq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754837AbYICKsq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:48:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752169AbYICKsY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:48:24 -0400
Received: from casper.infradead.org ([85.118.1.10]:43734 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbYICKsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:48:22 -0400
Subject: [PATCH 2/3] [MTD] [NAND] Define and use
	PCI_DEVICE_ID_MARVELL_88ALP01_NAND for =?ISO-8859-1?Q?CAF=C9?=
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: devel@laptop.org
In-Reply-To: <1220438625.patch@pmac.infradead.org>
References: <1220438625.patch@pmac.infradead.org>
Content-Type: text/plain; charset=UTF-8
Date: Wed, 03 Sep 2008 11:48:20 +0100
Message-Id: <1220438900.2985.100.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 8bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
(Carried in git://git.infradead.org/~dwmw2/random-2.6.git)

 drivers/mtd/nand/cafe_nand.c |    6 +++++-
 include/linux/pci_ids.h      |    1 +
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/mtd/nand/cafe_nand.c b/drivers/mtd/nand/cafe_nand.c
index 95345d0..b8064bf 100644
--- a/drivers/mtd/nand/cafe_nand.c
+++ b/drivers/mtd/nand/cafe_nand.c
@@ -1,6 +1,9 @@
 /*
  * Driver for One Laptop Per Child ‘CAFÉ’ controller, aka Marvell 88ALP01
  *
+ * The data sheet for this device can be found at:
+ *    http://www.marvell.com/products/pcconn/88ALP01.jsp
+ *
  * Copyright © 2006 Red Hat, Inc.
  * Copyright © 2006 David Woodhouse <dwmw2@infradead.org>
  */
@@ -842,7 +845,8 @@ static void __devexit cafe_nand_remove(struct pci_dev *pdev)
 }
 
 static struct pci_device_id cafe_nand_tbl[] = {
-	{ 0x11ab, 0x4100, PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VENDOR_ID_MARVELL, PCI_DEVICE_ID_MARVELL_88ALP01_NAND,
+	  PCI_ANY_ID, PCI_ANY_ID },
 	{ }
 };
 
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ef6ef64..e6240b7 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1521,6 +1521,7 @@
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
+#define PCI_DEVICE_ID_MARVELL_88ALP01_NAND	0x4100
 #define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
 
 #define PCI_VENDOR_ID_V3		0x11b0
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



