Return-Path: <linux-kernel-owner+w=401wt.eu-S1760653AbZFYFSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760653AbZFYFSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758155AbZFYFOV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:14:21 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1473 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbZFYFOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:14:12 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 16/19] drivers/staging: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:32 -0700
Message-Id: <127986351d52895b618ad6bc31a704bc34ef2d97.1245906153.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../staging/comedi/drivers/addi-data/addi_common.c |   54 ++++++++++----------
 drivers/staging/epl/Edrv8139.c                     |    2 +-
 drivers/staging/vt6655/device_main.c               |    2 +-
 3 files changed, 29 insertions(+), 29 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.c b/drivers/staging/comedi/drivers/addi-data/addi_common.c
index a56535f..87b11ca 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.c
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.c
@@ -184,35 +184,35 @@ static DEFINE_PCI_DEVICE_TABLE(addi_apci_tbl) = {
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 #endif
 #ifdef CONFIG_APCI_16XX
-	{0x15B8, 0x1009, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x100A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(ADDIDATA, 0x1009), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x100A), 0},
 #endif
 #ifdef CONFIG_APCI_3XXX
-	{0x15B8, 0x3010, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3013, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3014, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3015, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3016, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3017, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3018, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3019, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301A, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301D, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301E, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x301F, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3020, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3021, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3022, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3023, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x300B, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3002, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3003, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3004, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
-	{0x15B8, 0x3024, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3010), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x300F), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x300E), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3013), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3014), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3015), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3016), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3017), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3018), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3019), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301A), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301B), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301C), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301D), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301E), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x301F), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3020), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3021), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3022), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3023), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x300B), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3002), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3003), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3004), 0},
+	{PCI_VDEVICE(ADDIDATA, 0x3024), 0},
 #endif
 	{0}
 };
diff --git a/drivers/staging/epl/Edrv8139.c b/drivers/staging/epl/Edrv8139.c
index 44e3f7b..3013480 100644
--- a/drivers/staging/epl/Edrv8139.c
+++ b/drivers/staging/epl/Edrv8139.c
@@ -308,7 +308,7 @@ static void EdrvRemoveOne(struct pci_dev *pPciDev);
 // buffers and buffer descriptors and pointers
 
 static struct pci_device_id aEdrvPciTbl[] = {
-	{0x10ec, 0x8139, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
+	{PCI_VDEVICE(REALTEK, 0x8139), 0},
 	{0,}
 };
 
diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
index a10ed27..7a2377c 100644
--- a/drivers/staging/vt6655/device_main.c
+++ b/drivers/staging/vt6655/device_main.c
@@ -344,7 +344,7 @@ static CHIP_INFO chip_info_table[]= {
 };
 
 static struct pci_device_id device_id_table[] __devinitdata = {
-{ 0x1106, 0x3253, PCI_ANY_ID, PCI_ANY_ID, 0, 0, (int)&chip_info_table[0]},
+{ PCI_VDEVICE(VIA, 0x3253), (int)&chip_info_table[0]},
 { 0, }
 };
 #endif
-- 
1.6.3.1.10.g659a0.dirty

