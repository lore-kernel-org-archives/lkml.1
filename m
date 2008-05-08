Return-Path: <linux-kernel-owner+w=401wt.eu-S1764252AbYEHUvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764252AbYEHUvS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 16:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760454AbYEHUuY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 16:50:24 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:52764 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759504AbYEHUuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 16:50:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=cZuR4zwfuZI2sfCQxyleQdbZl3kMC5fX6YL2zVO/EuFswVCpVQqi9Lccv8pex3cMKdEA2bdO37auzBH6cC9Vse6fJa7tqrkeZ4HPg+6pBOtgYECV4UY7mwYlntzNkF01xbsiagVvtMCCkkEzW9hgGqv5K6iJI/E3PoKeMDUbTgU=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [PATCH 2/5] alim15x3: remove stale warning about ATI RS100 northbridge
Date: Thu, 8 May 2008 23:04:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200805082304.12386.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ide/pci/alim15x3.c |    8 --------
 1 file changed, 8 deletions(-)

Index: b/drivers/ide/pci/alim15x3.c
===================================================================
--- a/drivers/ide/pci/alim15x3.c
+++ b/drivers/ide/pci/alim15x3.c
@@ -522,17 +522,9 @@ static const struct ide_port_info ali15x
  
 static int __devinit alim15x3_init_one(struct pci_dev *dev, const struct pci_device_id *id)
 {
-	static struct pci_device_id ati_rs100[] = {
-		{ PCI_DEVICE(PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_RS100) },
-		{ },
-	};
-
 	struct ide_port_info d = ali15x3_chipset;
 	u8 rev = dev->revision, idx = id->driver_data;
 
-	if (pci_dev_present(ati_rs100))
-		printk(KERN_WARNING "alim15x3: ATI Radeon IGP Northbridge is not yet fully tested.\n");
-
 	/* don't use LBA48 DMA on ALi devices before rev 0xC5 */
 	if (rev <= 0xC4)
 		d.host_flags |= IDE_HFLAG_NO_LBA48_DMA;
