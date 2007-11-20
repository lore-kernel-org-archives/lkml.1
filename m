Return-Path: <linux-kernel-owner+w=401wt.eu-S1758485AbXKTBxU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758485AbXKTBxU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 20:53:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757362AbXKTBtM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 20:49:12 -0500
Received: from DSL022.labridge.com ([206.117.136.22]:2059 "EHLO perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756404AbXKTBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 20:48:59 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 11/59] drivers/block: Add missing "space"
Date: Mon, 19 Nov 2007 17:48:03 -0800
Message-Id: <1195523331-15303-12-git-send-email-joe@perches.com>
X-Mailer: git-send-email 1.5.3.6.728.gea559
In-Reply-To: <1195523331-15303-11-git-send-email-joe@perches.com>
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
Message-Id: <06ac5c8ff3114d38896fe59a453dd1b77b11cdec.1195454434.git.joe@perches.com>
In-Reply-To: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
References: <ee1678e1bc8b80b7ae420059fffc7241486ea91a.1195454434.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/block/DAC960.c   |    2 +-
 drivers/block/cpqarray.c |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index 9030c37..72c5e96 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -2999,7 +2999,7 @@ DAC960_DetectController(struct pci_dev *PCI_Device,
 	    }
 	  if (!DAC960_V1_EnableMemoryMailboxInterface(Controller))
 	    {
-	      DAC960_Error("Unable to allocate DMA mapped memory"
+	      DAC960_Error("Unable to allocate DMA mapped memory "
 			   "for Controller at\n", Controller);
 	      goto Failure;
 	    }
diff --git a/drivers/block/cpqarray.c b/drivers/block/cpqarray.c
index c8132d9..a8acd10 100644
--- a/drivers/block/cpqarray.c
+++ b/drivers/block/cpqarray.c
@@ -367,7 +367,7 @@ static void __devexit cpqarray_remove_one_pci (struct pci_dev *pdev)
 	tmp_ptr = pci_get_drvdata(pdev);
 	i = tmp_ptr->ctlr;
 	if (hba[i] == NULL) {
-		printk(KERN_ERR "cpqarray: controller %d appears to have"
+		printk(KERN_ERR "cpqarray: controller %d appears to have "
 			"already been removed \n", i);
 		return;
         }
@@ -382,7 +382,7 @@ static void __devexit cpqarray_remove_one_pci (struct pci_dev *pdev)
 static void __devexit cpqarray_remove_one_eisa (int i)
 {
 	if (hba[i] == NULL) {
-		printk(KERN_ERR "cpqarray: controller %d appears to have"
+		printk(KERN_ERR "cpqarray: controller %d appears to have "
 			"already been removed \n", i);
 		return;
         }
-- 
1.5.3.5.652.gf192c

