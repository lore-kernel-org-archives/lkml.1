Return-Path: <linux-kernel-owner+w=401wt.eu-S1758925AbZEGPMe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758925AbZEGPMe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 11:12:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754920AbZEGPMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 11:12:24 -0400
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:22785 "EHLO
	IE1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754299AbZEGPMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 11:12:23 -0400
X-BigFish: VPS-1(zz4015Lzz1202hzzz32i43j65h)
X-Spam-TCS-SCL: 4:0
X-WSS-ID: 0KJA4W3-02-GS7-01
From: Andre Przywara <andre.przywara@amd.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
       Andre Przywara <andre.przywara@amd.com>
Subject: [PATCH] This patch adds the OXCB950 chip to the 8250 PCI driver.
Date: Thu, 7 May 2009 17:13:40 +0200
Message-ID: <1241709220-13247-1-git-send-email-andre.przywara@amd.com>
X-Mailer: git-send-email 1.6.1.3
X-OriginalArrivalTime: 07 May 2009 15:12:09.0483 (UTC) FILETIME=[31041DB0:01C9CF26]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for the following serial controller chip:
Oxford Semiconductor OXCB950 for PCI Cardbus interface
http://www.transdimension.com/products/serial/OXCB950.html

on this card:
ExSys EX-1370 1 port high-speed serial card for ExpressCard/34 slot

Signed-off-by: Andre Przywara <andre.przywara@amd.com>
---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

Please apply!

Thanks,
Andre.

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index 938bc1b..e371a9c 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2776,6 +2776,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_C950,
+		PCI_VENDOR_ID_OXSEMI, PCI_SUBDEVICE_ID_OXSEMI_C950, 0, 0,
+		pbn_b0_1_921600 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_115200 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 06ba90c..e8a6a95 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1996,10 +1996,12 @@
 #define PCI_DEVICE_ID_OXSEMI_PCIe952_1_U	0xC118
 #define PCI_DEVICE_ID_OXSEMI_PCIe952_1_GU	0xC11C
 #define PCI_DEVICE_ID_OXSEMI_16PCI954	0x9501
+#define PCI_DEVICE_ID_OXSEMI_C950	0x950B
 #define PCI_DEVICE_ID_OXSEMI_16PCI95N	0x9511
 #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
 #define PCI_DEVICE_ID_OXSEMI_16PCI952PP	0x9523
+#define PCI_SUBDEVICE_ID_OXSEMI_C950	0x0001
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
-- 
1.6.1.3


