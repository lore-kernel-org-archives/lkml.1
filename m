Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZFYFP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZFYFP6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jun 2009 01:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbZFYFNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Jun 2009 01:13:49 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1440 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012AbZFYFNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jun 2009 01:13:41 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Karsten Keil <isdn@linux-pingi.de>, Armin Schindler <mac@melware.de>
Subject: [PATCH 05/19] drivers/isdn: Use PCI_VDEVICE
Date: Wed, 24 Jun 2009 22:13:21 -0700
Message-Id: <07280e5d5d745a42a24ce42d17f917683941044e.1245906152.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1245906151.git.joe@perches.com>
References: <cover.1245906151.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/isdn/hardware/eicon/divasmain.c |   34 +++++----------
 drivers/isdn/hardware/mISDN/hfcmulti.c  |    9 +---
 drivers/isdn/hardware/mISDN/hfcpci.c    |   69 ++++++++++--------------------
 3 files changed, 37 insertions(+), 75 deletions(-)

diff --git a/drivers/isdn/hardware/eicon/divasmain.c b/drivers/isdn/hardware/eicon/divasmain.c
index fbbcb27..44804be 100644
--- a/drivers/isdn/hardware/eicon/divasmain.c
+++ b/drivers/isdn/hardware/eicon/divasmain.c
@@ -114,39 +114,27 @@ typedef struct _diva_os_thread_dpc {
   */
 static struct pci_device_id divas_pci_tbl[] = {
 /* Diva Server BRI-2M PCI 0xE010 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRA,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_MAESTRA_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRA), CARDTYPE_MAESTRA_PCI},
 /* Diva Server 4BRI-8M PCI 0xE012 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRAQ,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_Q_8M_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRAQ), CARDTYPE_DIVASRV_Q_8M_PCI},
 /* Diva Server 4BRI-8M 2.0 PCI 0xE013 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRAQ_U,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_Q_8M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRAQ_U), CARDTYPE_DIVASRV_Q_8M_V2_PCI},
 /* Diva Server PRI-30M PCI 0xE014 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRAP,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_P_30M_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRAP), CARDTYPE_DIVASRV_P_30M_PCI},
 /* Diva Server PRI 2.0 adapter 0xE015 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRAP_2,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_P_30M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRAP_2), CARDTYPE_DIVASRV_P_30M_V2_PCI},
 /* Diva Server Voice 4BRI-8M PCI 0xE016 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_4BRI_VOIP,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_VOICE_Q_8M_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_4BRI_VOIP), CARDTYPE_DIVASRV_VOICE_Q_8M_PCI},
 /* Diva Server Voice 4BRI-8M 2.0 PCI 0xE017 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_4BRI_2_VOIP,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_VOICE_Q_8M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_4BRI_2_VOIP), CARDTYPE_DIVASRV_VOICE_Q_8M_V2_PCI},
 /* Diva Server BRI-2M 2.0 PCI 0xE018 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_BRI2M_2,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_B_2M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_BRI2M_2), CARDTYPE_DIVASRV_B_2M_V2_PCI},
 /* Diva Server Voice PRI 2.0 PCI 0xE019 */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_MAESTRAP_2_VOIP,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0,
-	 CARDTYPE_DIVASRV_VOICE_P_30M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_MAESTRAP_2_VOIP), CARDTYPE_DIVASRV_VOICE_P_30M_V2_PCI},
 /* Diva Server 2FX 0xE01A */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_2F,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_B_2F_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_2F), CARDTYPE_DIVASRV_B_2F_PCI},
 /* Diva Server Voice BRI-2M 2.0 PCI 0xE01B */
-	{PCI_VENDOR_ID_EICON, PCI_DEVICE_ID_EICON_BRI2M_2_VOIP,
-	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, CARDTYPE_DIVASRV_VOICE_B_2M_V2_PCI},
+	{PCI_VDEVICE(EICON, PCI_DEVICE_ID_EICON_BRI2M_2_VOIP), CARDTYPE_DIVASRV_VOICE_B_2M_V2_PCI},
 	{0,}			/* 0 terminated list. */
 };
 MODULE_DEVICE_TABLE(pci, divas_pci_tbl);
diff --git a/drivers/isdn/hardware/mISDN/hfcmulti.c b/drivers/isdn/hardware/mISDN/hfcmulti.c
index e1dab30..dcfab65 100644
--- a/drivers/isdn/hardware/mISDN/hfcmulti.c
+++ b/drivers/isdn/hardware/mISDN/hfcmulti.c
@@ -5361,12 +5361,9 @@ static struct pci_device_id hfmultipci_ids[] __devinitdata = {
 	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFCE1, PCI_VENDOR_ID_CCD,
 		PCI_SUBDEVICE_ID_CCD_JHSE1, 0, 0, H(25)}, /* Junghanns E1 */
 
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC4S, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFC8S, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
-	{ PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_HFCE1, PCI_ANY_ID, PCI_ANY_ID,
-		0, 0, 0},
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFC4S), 0},
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFC8S), 0},
+	{ PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_HFCE1), 0},
 	{0, }
 };
 #undef H
diff --git a/drivers/isdn/hardware/mISDN/hfcpci.c b/drivers/isdn/hardware/mISDN/hfcpci.c
index 228ffbe..63e685c 100644
--- a/drivers/isdn/hardware/mISDN/hfcpci.c
+++ b/drivers/isdn/hardware/mISDN/hfcpci.c
@@ -2201,52 +2201,29 @@ static const struct _hfc_map hfc_map[] =
 
 static struct pci_device_id hfc_ids[] =
 {
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_2BD0,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[0]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B000,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[1]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B006,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[2]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B007,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[3]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B008,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[4]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B009,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[5]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B00A,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[6]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B00B,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[7]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B00C,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[8]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B100,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[9]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B700,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[10]},
-	{PCI_VENDOR_ID_CCD, PCI_DEVICE_ID_CCD_B701,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[11]},
-	{PCI_VENDOR_ID_ABOCOM, PCI_DEVICE_ID_ABOCOM_2BD1,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[12]},
-	{PCI_VENDOR_ID_ASUSTEK, PCI_DEVICE_ID_ASUSTEK_0675,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[13]},
-	{PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_T_CONCEPT,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[14]},
-	{PCI_VENDOR_ID_BERKOM, PCI_DEVICE_ID_BERKOM_A1T,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[15]},
-	{PCI_VENDOR_ID_ANIGMA, PCI_DEVICE_ID_ANIGMA_MC145575,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[16]},
-	{PCI_VENDOR_ID_ZOLTRIX, PCI_DEVICE_ID_ZOLTRIX_2BD0,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[17]},
-	{PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_DF_M_IOM2_E,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[18]},
-	{PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_DF_M_E,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[19]},
-	{PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_DF_M_IOM2_A,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[20]},
-	{PCI_VENDOR_ID_DIGI, PCI_DEVICE_ID_DIGI_DF_M_A,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[21]},
-	{PCI_VENDOR_ID_SITECOM, PCI_DEVICE_ID_SITECOM_DC105V2,
-		PCI_ANY_ID, PCI_ANY_ID, 0, 0, (unsigned long) &hfc_map[22]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_2BD0), (unsigned long) &hfc_map[0]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B000), (unsigned long) &hfc_map[1]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B006), (unsigned long) &hfc_map[2]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B007), (unsigned long) &hfc_map[3]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B008), (unsigned long) &hfc_map[4]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B009), (unsigned long) &hfc_map[5]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B00A), (unsigned long) &hfc_map[6]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B00B), (unsigned long) &hfc_map[7]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B00C), (unsigned long) &hfc_map[8]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B100), (unsigned long) &hfc_map[9]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B700), (unsigned long) &hfc_map[10]},
+	{PCI_VDEVICE(CCD, PCI_DEVICE_ID_CCD_B701), (unsigned long) &hfc_map[11]},
+	{PCI_VDEVICE(ABOCOM, PCI_DEVICE_ID_ABOCOM_2BD1), (unsigned long) &hfc_map[12]},
+	{PCI_VDEVICE(ASUSTEK, PCI_DEVICE_ID_ASUSTEK_0675), (unsigned long) &hfc_map[13]},
+	{PCI_VDEVICE(BERKOM, PCI_DEVICE_ID_BERKOM_T_CONCEPT), (unsigned long) &hfc_map[14]},
+	{PCI_VDEVICE(BERKOM, PCI_DEVICE_ID_BERKOM_A1T), (unsigned long) &hfc_map[15]},
+	{PCI_VDEVICE(ANIGMA, PCI_DEVICE_ID_ANIGMA_MC145575), (unsigned long) &hfc_map[16]},
+	{PCI_VDEVICE(ZOLTRIX, PCI_DEVICE_ID_ZOLTRIX_2BD0), (unsigned long) &hfc_map[17]},
+	{PCI_VDEVICE(DIGI, PCI_DEVICE_ID_DIGI_DF_M_IOM2_E), (unsigned long) &hfc_map[18]},
+	{PCI_VDEVICE(DIGI, PCI_DEVICE_ID_DIGI_DF_M_E), (unsigned long) &hfc_map[19]},
+	{PCI_VDEVICE(DIGI, PCI_DEVICE_ID_DIGI_DF_M_IOM2_A), (unsigned long) &hfc_map[20]},
+	{PCI_VDEVICE(DIGI, PCI_DEVICE_ID_DIGI_DF_M_A), (unsigned long) &hfc_map[21]},
+	{PCI_VDEVICE(SITECOM, PCI_DEVICE_ID_SITECOM_DC105V2), (unsigned long) &hfc_map[22]},
 	{},
 };
 
-- 
1.6.3.1.10.g659a0.dirty

