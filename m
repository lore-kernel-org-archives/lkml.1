Return-Path: <linux-kernel-owner+w=401wt.eu-S1753474AbYIJIiq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474AbYIJIiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 04:38:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751586AbYIJIif
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 04:38:35 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:11499 "EHLO
	WA4EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751676AbYIJIie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 04:38:34 -0400
X-BigFish: VPS4(zzzz10d3izzz32i43j62h)
X-Spam-TCS-SCL: 1:0
X-FB-SS: 5,
X-WSS-ID: 0K6Z1C0-02-ISY-01
From: Robert Richter <robert.richter@amd.com>
To: linux-serial@vger.kernel.org
CC: LKML <linux-kernel@vger.kernel.org>,
       Andre Przywara <andre.przywara@amd.com>,
       Robert Richter <robert.richter@amd.com>
Subject: [PATCH] 8250 serial: add OXCB950 chip
Date: Wed, 10 Sep 2008 10:37:11 +0200
Message-ID: <1221035831-12660-1-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.6.0.1
X-OriginalArrivalTime: 10 Sep 2008 08:38:23.0875 (UTC) FILETIME=[96542D30:01C91320]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andre Przywara <andre.przywara@amd.com>

This patch adds the OXCB950 chip to the 8250 PCI driver.

----------
Chip: Oxford Semiconductor OXCB950 for PCI Cardbus interface
http://www.transdimension.com/products/serial/OXCB950.html

on this card:
ExSys EX-1370 1 port high-speed serial card for ExpressCard/34 slot
----------

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 drivers/serial/8250_pci.c |    3 +++
 include/linux/pci_ids.h   |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/serial/8250_pci.c b/drivers/serial/8250_pci.c
index c2f2393..eec0620 100644
--- a/drivers/serial/8250_pci.c
+++ b/drivers/serial/8250_pci.c
@@ -2293,6 +2293,9 @@ static struct pci_device_id serial_pci_tbl[] = {
 	{	PCI_VENDOR_ID_OXSEMI, 0x950a,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_2_1130000 },
+	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_C950,
+		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
+		pbn_b0_1_921600 },
 	{	PCI_VENDOR_ID_OXSEMI, PCI_DEVICE_ID_OXSEMI_16PCI954,
 		PCI_ANY_ID, PCI_ANY_ID, 0, 0,
 		pbn_b0_4_115200 },
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index f1624b3..1d08fbe 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1930,6 +1930,7 @@
 #define PCI_VENDOR_ID_OXSEMI		0x1415
 #define PCI_DEVICE_ID_OXSEMI_12PCI840	0x8403
 #define PCI_DEVICE_ID_OXSEMI_16PCI954	0x9501
+#define PCI_DEVICE_ID_OXSEMI_C950	0x950B
 #define PCI_DEVICE_ID_OXSEMI_16PCI95N	0x9511
 #define PCI_DEVICE_ID_OXSEMI_16PCI954PP	0x9513
 #define PCI_DEVICE_ID_OXSEMI_16PCI952	0x9521
-- 
1.6.0.1


