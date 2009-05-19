Return-Path: <linux-kernel-owner+w=401wt.eu-S1755637AbZESOrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637AbZESOrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 10:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755192AbZESOrJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 10:47:09 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:35901 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394AbZESOrC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 10:47:02 -0400
Message-Id: <55ac00a442efe0ead8a7cb6e586da77d8a71efbb.1242739648.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
References: <cover.1242739648.git.kkeil@pingi.linux-pingi.de>
Subject: [PATCH 15/19] Added PCI ID for new Junghanns.net Single E1 cards.
From: Karsten Keil <keil@b1-systems.de>
To: linux-kernel@vger.kernel.org
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
       i4ldeveloper@listserv.isdn4linux.de
Date: Tue, 19 May 2009 15:58:33 +0200
X-Info: valid message
X-Info: original Date
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Eversberg <andreas@eversberg.eu>

The new ID is validated by Cologne Chip.
LEDs control is also supported.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    4 ++++
 include/linux/pci_ids.h                |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 77bba63..11f5679 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5523,6 +5523,10 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 		PCI_SUBDEVICE_ID_CCD_SPD4S, 0, 0, H(26)}, /* PLX PCI Bridge */
 	{ PCI_VENDOR_ID_PLX, PCI_DEVICE_ID_PLX_9030, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_SPDE1, 0, 0, H(27)}, /* PLX PCI Bridge */
+
+	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFCE1, PCI_VENDOR_ID_CCD,
+		PCI_SUBDEVICE_ID_CCD_JHSE1, 0, 0, H(25)}, /* Junghanns E1 */
+
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_ANY_ID, PCI_ANY_ID,
 		0, 0, 0},
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_ANY_ID, PCI_ANY_ID,
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 1247568..65894e1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1927,6 +1927,7 @@
 #define PCI_SUBDEVICE_ID_CCD_SWYX4S	0xB540
 #define PCI_SUBDEVICE_ID_CCD_JH4S20	0xB550
 #define PCI_SUBDEVICE_ID_CCD_IOB8ST_1	0xB552
+#define PCI_SUBDEVICE_ID_CCD_JHSE1	0xB553
 #define PCI_SUBDEVICE_ID_CCD_JH8S	0xB55B
 #define PCI_SUBDEVICE_ID_CCD_BN4S	0xB560
 #define PCI_SUBDEVICE_ID_CCD_BN8S	0xB562
-- 
1.6.0.2

