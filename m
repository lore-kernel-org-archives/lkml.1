Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757578Ab0BRS76 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 13:59:58 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:16918 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758165Ab0BRS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 13:59:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=rKeIW3nJlv9ut8P/FFX0lw7z4KYn+Sc4+h3YAQlBWuwW/Zw9nJvQIp5/ZCPAV/yHRf
         hXrppPU9OHqmNW4C+h0m1MBcvAt7a746dB2Q9T0OFla8E77xB2UppfK72lPbzvmMpXMY
         v0pWd0wJDdp9gOGnPeW80MNAvZOre2Ja+jNeI=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Thu, 18 Feb 2010 19:59:36 +0100
Message-Id: <20100218185936.16594.94485.sendpatchset@localhost>
In-Reply-To: <20100218185914.16594.61415.sendpatchset@localhost>
References: <20100218185914.16594.61415.sendpatchset@localhost>
Subject: [PATCH 3/3] pata_oldpiix: enable parallel scan
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] pata_oldpiix: enable parallel scan

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/ata/pata_oldpiix.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: b/drivers/ata/pata_oldpiix.c
===================================================================
--- a/drivers/ata/pata_oldpiix.c
+++ b/drivers/ata/pata_oldpiix.c
@@ -215,7 +215,8 @@ static int oldpiix_init_one (struct pci_
 		dev_printk(KERN_DEBUG, &pdev->dev,
 			   "version " DRV_VERSION "\n");
 
-	return ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL);
+	return __ata_pci_sff_init_one(pdev, ppi, &oldpiix_sht, NULL, NULL,
+				      ATA_HOST_PARALLEL_SCAN);
 }
 
 static const struct pci_device_id oldpiix_pci_tbl[] = {
