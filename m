Return-Path: <linux-kernel-owner+w=401wt.eu-S932716AbZJaJl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932716AbZJaJl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Oct 2009 05:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932162AbZJaJlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Oct 2009 05:41:55 -0400
Received: from mail-vw0-f192.google.com ([209.85.212.192]:33643 "EHLO
	mail-vw0-f192.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932371AbZJaJlx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Oct 2009 05:41:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=JB8GovN/aE9IGp7DSge+qY8Q4leD/FlmL2DG5e0nA+6A/rxcjEL/O5gLfdD7M5mi86
         XFxgNeVuMce9gsZGt92YMpr5gisTekydJC8NmjsL0BQZVx1Gaz79xNvesE8IYaCp8tlI
         Jr3wxzCW90U8zX5vduoLqY4i52LHvQFU/T1Js=
MIME-Version: 1.0
From: =?ISO-8859-1?Q?Andr=E9_Goddard_Rosa?= <andre.goddard@gmail.com>
Date: Sat, 31 Oct 2009 07:41:38 -0200
Message-ID: <b8bf37780910310241v6a6acd9bo9d1f63e04d7b91a0@mail.gmail.com>
Subject: [PATCH 11/16] trivial: fix assorted "channel" typos
To: trivial@kernel.org, linux list <linux-kernel@vger.kernel.org>
Cc: me <andre.goddard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 6b663c88691e4d53859d8eb68a508ab31639a005 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Andr=C3=A9=20Goddard=20Rosa?= <andre.goddard@gmail.com>
Date: Fri, 30 Oct 2009 07:03:37 -0200
Subject: [PATCH 11/16] trivial: fix assorted "channel" typos
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Signed-off-by: André Goddard Rosa <andre.goddard@gmail.com>

diff --git a/arch/arm/mach-sa1100/dma.c b/arch/arm/mach-sa1100/dma.c
index cb4521a..ad66035 100644
--- a/arch/arm/mach-sa1100/dma.c
+++ b/arch/arm/mach-sa1100/dma.c
@@ -65,7 +65,7 @@ static irqreturn_t dma_irq_handler(int irq, void *dev_id)


 /**
- *	sa1100_request_dma - allocate one of the SA11x0's DMA chanels
+ *	sa1100_request_dma - allocate one of the SA11x0's DMA channels
  *	@device: The SA11x0 peripheral targeted by this request
  *	@device_id: An ascii name for the claiming device
  *	@callback: Function to be called when the DMA completes
diff --git a/drivers/staging/comedi/drivers/addi-data/addi_common.h
b/drivers/staging/comedi/drivers/addi-data/addi_common.h
index edd657b..3ab27cf 100644
--- a/drivers/staging/comedi/drivers/addi-data/addi_common.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_common.h
@@ -82,7 +82,7 @@ struct addi_board {

 	int i_NbrDiChannel;	/*  Number of DI channels */
 	int i_NbrDoChannel;	/*  Number of DO channels */
-	int i_DoMaxdata;	/*  data to set all chanels high */
+	int i_DoMaxdata;	/*  data to set all channels high */

 	int i_NbrTTLChannel;	/*  Number of TTL channels */
 	const struct comedi_lrange *pr_TTLRangelist;	/* rangelist for TTL */
diff --git a/drivers/staging/otus/80211core/cmm.c
b/drivers/staging/otus/80211core/cmm.c
index bed16b5..a6c1b41 100644
--- a/drivers/staging/otus/80211core/cmm.c
+++ b/drivers/staging/otus/80211core/cmm.c
@@ -1428,7 +1428,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t*
buf, struct zsAdditionInfo* AddInf
         {
                 /* Beacon */
             case ZM_WLAN_FRAME_TYPE_BEACON :
-                /* if enable 802.11h and current chanel is silent but
receive beacon from other AP */
+                /* if enable 802.11h and current channel is silent
but receive beacon from other AP */
                 if
(((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
@@ -1469,7 +1469,7 @@ void zfProcessManagement(zdev_t* dev, zbuf_t*
buf, struct zsAdditionInfo* AddInf
                 break;
                 /* Probe response */
             case ZM_WLAN_FRAME_TYPE_PROBERSP :
-                /* if enable 802.11h and current chanel is silent but
receive probe response from other AP */
+                /* if enable 802.11h and current channel is silent
but receive probe response from other AP */
                 if
(((wd->regulationTable.allowChannel[wd->regulationTable.CurChIndex].channelFlags
                         & ZM_REG_FLAG_CHANNEL_CSA) != 0) && wd->sta.DFSEnable)
                 {
diff --git a/drivers/staging/rtl8187se/r8180_dm.c
b/drivers/staging/rtl8187se/r8180_dm.c
index 4c9d46f..9acfbcd 100644
--- a/drivers/staging/rtl8187se/r8180_dm.c
+++ b/drivers/staging/rtl8187se/r8180_dm.c
@@ -36,7 +36,7 @@ bool CheckHighPower(struct net_device *dev)
 //
 //	Note:
 //		The reason why we udpate Tx power level here instead of DoRxHighPower()
-//		is the number of IO to change Tx power is much more than chane TR switch
+//		is the number of IO to change Tx power is much more than channel TR switch
 //		and they are related to OFDM and MAC registers.
 //		So, we don't want to update it so frequently in per-Rx packet base.
 //
diff --git a/drivers/staging/rtl8192e/r819xE_phyreg.h
b/drivers/staging/rtl8192e/r819xE_phyreg.h
index d4a4392..37f0fee 100644
--- a/drivers/staging/rtl8192e/r819xE_phyreg.h
+++ b/drivers/staging/rtl8192e/r819xE_phyreg.h
@@ -294,7 +294,7 @@
 #define bR2RCCAMask               		0x00000f00
 #define bHSSI_R2TDelay            		0xf8000000
 #define bHSSI_T2RDelay            		0xf80000
-#define bContTxHSSI               		0x400     //chane gain at continue Tx
+#define bContTxHSSI               		0x400     //channel gain at continue Tx
 #define bIGFromCCK                		0x200
 #define bAGCAddress               		0x3f
 #define bRxHPTx                   			0x7000
diff --git a/drivers/staging/rtl8192su/r8192S_phyreg.h
b/drivers/staging/rtl8192su/r8192S_phyreg.h
index 96c7cfa..1584378 100644
--- a/drivers/staging/rtl8192su/r8192S_phyreg.h
+++ b/drivers/staging/rtl8192su/r8192S_phyreg.h
@@ -453,7 +453,7 @@
 #define		bR2RCCAMask               			0x00000f00
 #define		bHSSI_R2TDelay            		0xf8000000
 #define		bHSSI_T2RDelay            		0xf80000
-#define		bContTxHSSI               			0x400     //chane gain at continue Tx
+#define		bContTxHSSI               			0x400     //channel gain at continue Tx
 #define		bIGFromCCK                			0x200
 #define		bAGCAddress               			0x3f
 #define		bRxHPTx                   			0x7000
diff --git a/sound/pci/emu10k1/emu10k1x.c b/sound/pci/emu10k1/emu10k1x.c
index 36e08bd..360e380 100644
--- a/sound/pci/emu10k1/emu10k1x.c
+++ b/sound/pci/emu10k1/emu10k1x.c
@@ -184,7 +184,7 @@ MODULE_PARM_DESC(enable, "Enable the EMU10K1X soundcard.");
  * The hardware has 3 channels for playback and 1 for capture.
  *  - channel 0 is the front channel
  *  - channel 1 is the rear channel
- *  - channel 2 is the center/lfe chanel
+ *  - channel 2 is the center/lfe channel
  * Volume is controlled by the AC97 for the front and rear channels by
  * the PCM Playback Volume, Sigmatel Surround Playback Volume and
  * Surround Playback Volume. The Sigmatel 4-Speaker Stereo switch affects
-- 
1.6.5.2.101.gcd0f8
