Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933988Ab0BQNly (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:41:54 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:38185 "EHLO
	bob.linux.org.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933844Ab0BQNlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:41:50 -0500
From: Alan Cox <alan@linux.intel.com>
Subject: [PATCH 5/5] pata_efar: Enable PARALLEL_SCAN
To: jeff@garzik.org.com, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Date: Wed, 17 Feb 2010 13:17:52 +0000
Message-ID: <20100217131749.16884.3192.stgit@localhost.localdomain>
In-Reply-To: <20100217131532.16884.21696.stgit@localhost.localdomain>
References: <20100217131532.16884.21696.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again originally proposed by Bartlomiej but this does it by using the
generic helper logic instead.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/ata/pata_efar.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)


diff --git a/drivers/ata/pata_efar.c b/drivers/ata/pata_efar.c
index 2a9014c..4289db0 100644
--- a/drivers/ata/pata_efar.c
+++ b/drivers/ata/pata_efar.c
@@ -278,7 +278,8 @@ static int efar_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL, 0);
+	return ata_pci_sff_init_one(pdev, ppi, &efar_sht, NULL,
+					ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id efar_pci_tbl[] = {

