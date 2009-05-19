Return-Path: <linux-kernel-owner+w=401wt.eu-S1753670AbZESRIP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753670AbZESRIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:08:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752270AbZESRIJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:08:09 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:40861 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbZESRII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:08:08 -0400
Message-Id: <2992ff6583a9605618da1243cb2ae0700a83eddd.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 03/19] Add PCI ID for Junghanns 8S card
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:24 +0200
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
index 71b0de5..30831d7 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5410,6 +5410,7 @@ static const struct hm_map hfcm_map[] = {
 /*30*/	{VENDOR_CCD, "HFC-8S OpenVox", 8, 8, 1, 0, 0, 0, 0, 0},
 /*31*/	{VENDOR_CCD, "XHFC-4S Speech Design", 5, 4, 0, 0, 0, 0,
 		HFC_IO_MODE_EMBSD, XHFC_IRQ},
+/*32*/	{VENDOR_JH, "HFC-8S (junghanns)", 8, 8, 1, 0, 0, 0, 0, 0},
 };
 
 #undef H
@@ -5463,6 +5464,8 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 		PCI_SUBDEVICE_ID_CCD_HFC8S, 0, 0, H(18)}, /* 8S */
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_OV8S, 0, 0, H(30)}, /* OpenVox 8 */
+	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_VENDOR_ID_CCD,
+		PCI_SUBDEVICE_ID_CCD_JH8S, 0, 0, H(32)}, /* Junganns 8S  */
 
 
 	/* Cards with HFC-E1 Chip */
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 8771e2f..1247568 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1927,6 +1927,7 @@
 #define PCI_SUBDEVICE_ID_CCD_SWYX4S	0xB540
 #define PCI_SUBDEVICE_ID_CCD_JH4S20	0xB550
 #define PCI_SUBDEVICE_ID_CCD_IOB8ST_1	0xB552
+#define PCI_SUBDEVICE_ID_CCD_JH8S	0xB55B
 #define PCI_SUBDEVICE_ID_CCD_BN4S	0xB560
 #define PCI_SUBDEVICE_ID_CCD_BN8S	0xB562
 #define PCI_SUBDEVICE_ID_CCD_BNE1	0xB563
-- 
1.6.0.2

