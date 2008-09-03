Return-Path: <linux-kernel-owner+w=401wt.eu-S1754093AbYICKsb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbYICKsb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 06:48:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751489AbYICKsW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 06:48:22 -0400
Received: from casper.infradead.org ([85.118.1.10]:43732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997AbYICKsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 06:48:21 -0400
Subject: [PATCH 1/3] Use PCI_DEVICE_ID_88ALP01 for =?ISO-8859-1?Q?CAF=C9?=
	chip, rather than PCI_DEVICE_ID_CAFE.
From: David Woodhouse <dwmw2@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: Pierre Ossman <drzeus@drzeus.cx>, devel@laptop.org
In-Reply-To: <1220438625.patch@pmac.infradead.org>
References: <1220438625.patch@pmac.infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 11:48:17 +0100
Message-Id: <1220438897.2985.99.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-Bad-Reply: References and In-Reply-To but no 'Re:' in Subject.
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Probably better to use the official designation.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
---
(Carried in git://git.infradead.org/~dwmw2/random-2.6.git)

 drivers/mmc/host/sdhci-pci.c |    2 +-
 include/linux/pci_ids.h      |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index fcb14c2..0341cfb 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -326,7 +326,7 @@ static const struct pci_device_id pci_ids[] __devinitdata = {
 
 	{
 		.vendor         = PCI_VENDOR_ID_MARVELL,
-		.device         = PCI_DEVICE_ID_MARVELL_CAFE_SD,
+		.device         = PCI_DEVICE_ID_MARVELL_88ALP01_SD,
 		.subvendor      = PCI_ANY_ID,
 		.subdevice      = PCI_ANY_ID,
 		.driver_data    = (kernel_ulong_t)&sdhci_cafe,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..ef6ef64 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1521,7 +1521,7 @@
 #define PCI_DEVICE_ID_MARVELL_GT64260	0x6430
 #define PCI_DEVICE_ID_MARVELL_MV64360	0x6460
 #define PCI_DEVICE_ID_MARVELL_MV64460	0x6480
-#define PCI_DEVICE_ID_MARVELL_CAFE_SD	0x4101
+#define PCI_DEVICE_ID_MARVELL_88ALP01_SD	0x4101
 
 #define PCI_VENDOR_ID_V3		0x11b0
 #define PCI_DEVICE_ID_V3_V960		0x0001
-- 
1.5.5.1
-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation



