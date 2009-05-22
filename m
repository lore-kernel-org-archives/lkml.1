Return-Path: <linux-kernel-owner+w=401wt.eu-S1758633AbZEVVIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758633AbZEVVIb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758128AbZEVVEz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:55 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:51562 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757388AbZEVVEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:54 -0400
Message-Id: <e27193109e9bb5f33e0a408b5b9674375d073bda.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 15/19] Add PCI ID for Junghanns 8S card
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Fri, 22 May 2009 23:04:55 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

new id for HFC-8S

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    3 +++
 include/linux/pci_ids.h                |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 5be4edf..50e9f4d 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5275,6 +5275,7 @@ static const struct hm_map hfcm_map[] = {
 /*30*/	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0, 0},
 /*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
 		HFC_IO_MODE_EMBSD, XHFC_IRQ},
+/*32*/	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
 };
 
 #undef H
@@ -5328,6 +5329,8 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 		PCI_SUBDEVICE_ID_CCD_HFC8S, 0, 0, H(18)}, /* 8S */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_OV8S, 0, 0, H(30)}, /* OpenVox 8 */
+	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
+		PCI_SUBDEVICE_ID_CCD_JH8S, 0, 0, H(32)}, /* Junganns 8S  */
 
 
 	/* Cards with HFC-E1 Chip */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 3038ac2..4bdff98 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1914,6 +1914,7 @@
 #define PCI_SUBDEVICE_ID_CCD_SWYX4S	0xB540
 #define PCI_SUBDEVICE_ID_CCD_JH4S20	0xB550
 #define PCI_SUBDEVICE_ID_CCD_IOB8ST_1	0xB552
+#define PCI_SUBDEVICE_ID_CCD_JH8S	0xB55B
 #define PCI_SUBDEVICE_ID_CCD_BN4S	0xB560
 #define PCI_SUBDEVICE_ID_CCD_BN8S	0xB562
 #define PCI_SUBDEVICE_ID_CCD_BNE1	0xB563
-- 
1.6.0.2

