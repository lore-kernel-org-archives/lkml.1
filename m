Return-Path: <linux-kernel-owner+w=401wt.eu-S1755917AbZKIQce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917AbZKIQce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 11:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755758AbZKIQcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 11:32:32 -0500
Received: from mail-ew0-f207.google.com ([209.85.219.207]:46243 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732AbZKIQca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 11:32:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:content-type
         :content-transfer-encoding:message-id;
        b=Z5QdtHEXYP51S6nixPgsTX/EqCRvpXacgfszwaTwO8S6a8BBX36hioXebpMl9422uy
         GTvGjkdh1BDidEobOidONr4C+FDkCXqLb5T44gyBVzUHSaX5JsRUnnrEwtcCpaIzN6Af
         WdgK0issp1hxU89GSHJ8gfBGNBW2lEiqlhrm0=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Greg KH <gregkh@suse.de>
Subject: [PATCH] Staging: rt28x0: fix comments in chip/mac_pci.h
Date: Mon, 9 Nov 2009 17:19:45 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-96.fc12.x86_64; KDE/4.3.2; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091719.45191.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: fix comments in chip/mac_pci.h

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/chip/mac_pci.h |   72 +++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 36 deletions(-)

Index: b/drivers/staging/rt2860/chip/mac_pci.h
===================================================================
--- a/drivers/staging/rt2860/chip/mac_pci.h
+++ b/drivers/staging/rt2860/chip/mac_pci.h
@@ -43,10 +43,10 @@
 #include "../rtmp_iface.h"
 #include "../rtmp_dot11.h"
 
-//
-// Device ID & Vendor ID related definitions,
-// NOTE: you should not add the new VendorID/DeviceID here unless you not sure it belongs to what chip.
-//
+/* */
+/* Device ID & Vendor ID related definitions, */
+/* NOTE: you should not add the new VendorID/DeviceID here unless you not sure it belongs to what chip. */
+/* */
 #define NIC_PCI_VENDOR_ID		0x1814
 #define PCIBUS_INTEL_VENDOR	0x8086
 
@@ -66,22 +66,22 @@
 
 #define AUX_CTRL           0x10c
 
-//
-// TX descriptor format, Tx     ring, Mgmt Ring
-//
+/* */
+/* TX descriptor format, Tx     ring, Mgmt Ring */
+/* */
 struct PACKED rt_txd {
-	// Word 0
+	/* Word 0 */
 	u32 SDPtr0;
-	// Word 1
+	/* Word 1 */
 	u32 SDLen1:14;
 	u32 LastSec1:1;
 	u32 Burst:1;
 	u32 SDLen0:14;
 	u32 LastSec0:1;
 	u32 DMADONE:1;
-	//Word2
+	/*Word2 */
 	u32 SDPtr1;
-	//Word3
+	/*Word3 */
 	u32 rsv2:24;
 	u32 WIV:1;		/* Wireless Info Valid. 1 if Driver already fill WI,  o if DMA needs to copy WI to correctposition */
 	u32 QSEL:2;		/* select on-chip FIFO ID for 2nd-stage output scheduler.0:MGMT, 1:HCCA 2:EDCA */
@@ -91,21 +91,21 @@ struct PACKED rt_txd {
 	u32 ICO:1;		/* */
 };
 
-//
-// Rx descriptor format, Rx Ring
-//
+/* */
+/* Rx descriptor format, Rx Ring */
+/* */
 typedef struct PACKED rt_rxd {
-	// Word 0
+	/* Word 0 */
 	u32 SDP0;
-	// Word 1
+	/* Word 1 */
 	u32 SDL1:14;
 	u32 Rsv:2;
 	u32 SDL0:14;
 	u32 LS0:1;
 	u32 DDONE:1;
-	// Word 2
+	/* Word 2 */
 	u32 SDP1;
-	// Word 3
+	/* Word 3 */
 	u32 BA:1;
 	u32 DATA:1;
 	u32 NULLDATA:1;
@@ -141,9 +141,9 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 
 /* ----------------- EEPROM Related MACRO ----------------- */
 
-// 8051 firmware image for RT2860 - base address = 0x4000
+/* 8051 firmware image for RT2860 - base address = 0x4000 */
 #define FIRMWARE_IMAGE_BASE     0x2000
-#define MAX_FIRMWARE_IMAGE_SIZE 0x2000	// 8kbyte
+#define MAX_FIRMWARE_IMAGE_SIZE 0x2000	/* 8kbyte */
 
 /* ----------------- Frimware Related MACRO ----------------- */
 #define RTMP_WRITE_FIRMWARE(_pAd, _pFwImage, _FwLen)			\
@@ -222,25 +222,25 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 /* ----------------- RX Related MACRO ----------------- */
 
 /* ----------------- ASIC Related MACRO ----------------- */
-// reset MAC of a station entry to 0x000000000000
+/* reset MAC of a station entry to 0x000000000000 */
 #define RTMP_STA_ENTRY_MAC_RESET(pAd, Wcid)	\
 	AsicDelWcidTab(pAd, Wcid);
 
-// add this entry into ASIC RX WCID search table
+/* add this entry into ASIC RX WCID search table */
 #define RTMP_STA_ENTRY_ADD(pAd, pEntry)		\
 	AsicUpdateRxWCIDTable(pAd, pEntry->Aid, pEntry->Addr);
 
-// add by johnli, fix "in_interrupt" error when call "MacTableDeleteEntry" in Rx tasklet
-// Set MAC register value according operation mode
+/* add by johnli, fix "in_interrupt" error when call "MacTableDeleteEntry" in Rx tasklet */
+/* Set MAC register value according operation mode */
 #define RTMP_UPDATE_PROTECT(pAd)	\
 	AsicUpdateProtect(pAd, 0, (ALLN_SETPROTECT), TRUE, 0);
-// end johnli
+/* end johnli */
 
-// remove Pair-wise key material from ASIC
+/* remove Pair-wise key material from ASIC */
 #define RTMP_STA_ENTRY_KEY_DEL(pAd, BssIdx, Wcid)	\
 	AsicRemovePairwiseKeyEntry(pAd, BssIdx, (u8)Wcid);
 
-// add Client security information into ASIC WCID table and IVEIV table
+/* add Client security information into ASIC WCID table and IVEIV table */
 #define RTMP_STA_SECURITY_INFO_ADD(pAd, apidx, KeyID, pEntry)		\
 	RTMPAddWcidAttributeEntry(pAd, apidx, KeyID,			\
 							pAd->SharedKey[apidx][KeyID].CipherAlg, pEntry);
@@ -257,7 +257,7 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 						  pAd->SharedKey[apidx][KeyID].CipherAlg,		\
 						  pEntry); }
 
-// Insert the BA bitmap to ASIC for the Wcid entry
+/* Insert the BA bitmap to ASIC for the Wcid entry */
 #define RTMP_ADD_BA_SESSION_TO_ASIC(_pAd, _Aid, _TID)	\
 		do{					\
 			u32 _Value = 0, _Offset;					\
@@ -267,8 +267,8 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 			RTMP_IO_WRITE32((_pAd), _Offset, _Value);\
 		}while(0)
 
-// Remove the BA bitmap from ASIC for the Wcid entry
-//              bitmap field starts at 0x10000 in ASIC WCID table
+/* Remove the BA bitmap from ASIC for the Wcid entry */
+/*              bitmap field starts at 0x10000 in ASIC WCID table */
 #define RTMP_DEL_BA_SESSION_FROM_ASIC(_pAd, _Wcid, _TID)				\
 		do{								\
 			u32 _Value = 0, _Offset;				\
@@ -280,10 +280,10 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 
 /* ----------------- Interface Related MACRO ----------------- */
 
-//
-// Enable & Disable NIC interrupt via writing interrupt mask register
-// Since it use ADAPTER structure, it have to be put after structure definition.
-//
+/* */
+/* Enable & Disable NIC interrupt via writing interrupt mask register */
+/* Since it use ADAPTER structure, it have to be put after structure definition. */
+/* */
 #define RTMP_ASIC_INTERRUPT_DISABLE(_pAd)		\
 	do{			\
 		RTMP_IO_WRITE32((_pAd), INT_MASK_CSR, 0x0);     /* 0: disable */	\
@@ -324,7 +324,7 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 /* ----------------- Power Save Related MACRO ----------------- */
 #define RTMP_PS_POLL_ENQUEUE(pAd)				EnqueuePsPoll(pAd)
 
-// For RTMPPCIePowerLinkCtrlRestore () function
+/* For RTMPPCIePowerLinkCtrlRestore () function */
 #define RESTORE_HALT		1
 #define RESTORE_WAKEUP		2
 #define RESTORE_CLOSE           3
@@ -352,4 +352,4 @@ typedef union _TX_ATTENUATION_CTRL_STRUC
 #define RTMP_MLME_RADIO_OFF(pAd) \
     RT28xxPciMlmeRadioOFF(pAd);
 
-#endif //__MAC_PCI_H__ //
+#endif /*__MAC_PCI_H__ // */
