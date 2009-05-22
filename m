Return-Path: <linux-kernel-owner+w=401wt.eu-S1758968AbZEVVI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758968AbZEVVI4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 17:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757924AbZEVVE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 17:04:58 -0400
Received: from d112a2.x-mailer.de ([212.162.53.4]:47192 "EHLO
	d112a2.x-mailer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758011AbZEVVEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 17:04:55 -0400
Message-Id: <439e83d3a432e8896ec699bc28b3ef4f72fdc730.1243024967.git.kkeil@pingi.linux-pingi.de>
In-Reply-To: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
References: <cover.1243024967.git.kkeil@pingi.linux-pingi.de>
Subject: [mISDN PATCH v2 16/19] Added PCI ID for new Junghanns.net Single E1 cards.
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

The new ID is validated by Cologne Chip.
LEDs control is also supported.

Signed-off-by: Andreas Eversberg <andreas@eversberg.eu>
Signed-off-by: Karsten Keil <keil@b1-systems.de>
---
 drivers/isdn/hardware/mISDN/hfcmulti.c |    4 ++++
 include/linux/pci_ids.h                |    1 +
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index 50e9f4d..a4d790b 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5354,6 +5354,10 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
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
index 4bdff98..12db06c 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -1914,6 +1914,7 @@
 #define PCI_SUBDEVICE_ID_CCD_SWYX4S	0xB540
 #define PCI_SUBDEVICE_ID_CCD_JH4S20	0xB550
 #define PCI_SUBDEVICE_ID_CCD_IOB8ST_1	0xB552
+#define PCI_SUBDEVICE_ID_CCD_JHSE1	0xB553
 #define PCI_SUBDEVICE_ID_CCD_JH8S	0xB55B
 #define PCI_SUBDEVICE_ID_CCD_BN4S	0xB560
 #define PCI_SUBDEVICE_ID_CCD_BN8S	0xB562
-- 
1.6.0.2

