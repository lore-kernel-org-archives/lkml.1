Return-Path: <linux-kernel-owner+w=401wt.eu-S1030787AbXCNJTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787AbXCNJTh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 05:19:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030764AbXCNJTI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 05:19:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:60489 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030787AbXCNJTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 05:19:00 -0400
To: torvalds@linux-foundation.org
Subject: [PATCH 7/17] trivial ATA iomem annotations
Cc: jgarzik@pobox.com, linux-kernel@vger.kernel.org
Message-Id: <E1HRPdM-0003Sq-0w@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Wed, 14 Mar 2007 09:19:00 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 drivers/ata/pata_cs5520.c |    2 +-
 drivers/ata/sata_sis.c    |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_cs5520.c b/drivers/ata/pata_cs5520.c
index 7ef8342..55cc293 100644
--- a/drivers/ata/pata_cs5520.c
+++ b/drivers/ata/pata_cs5520.c
@@ -208,7 +208,7 @@ static struct ata_port_operations cs5520_port_ops = {
 static int __devinit cs5520_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
 	u8 pcicfg;
-	void *iomap[5];
+	void __iomem *iomap[5];
 	static struct ata_probe_ent probe[2];
 	int ports = 0;
 
diff --git a/drivers/ata/sata_sis.c b/drivers/ata/sata_sis.c
index 1879e0c..a787f0d 100644
--- a/drivers/ata/sata_sis.c
+++ b/drivers/ata/sata_sis.c
@@ -354,7 +354,7 @@ static int sis_init_one (struct pci_dev *pdev, const struct pci_device_id *ent)
 		return -ENOMEM;
 
 	if (!(probe_ent->port_flags & SIS_FLAG_CFGSCR)) {
-		void *mmio;
+		void __iomem *mmio;
 
 		mmio = pcim_iomap(pdev, SIS_SCR_PCI_BAR, 0);
 		if (!mmio)
-- 
1.5.0-rc2.GIT


