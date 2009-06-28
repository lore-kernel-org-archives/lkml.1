Return-Path: <linux-kernel-owner+w=401wt.eu-S1759569AbZF1Qi2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569AbZF1Qi2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 12:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757313AbZF1Q2R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 12:28:17 -0400
Received: from 136-022.dsl.LABridge.com ([206.117.136.22]:1163 "EHLO
	mail.perches.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257AbZF1Q2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 12:28:07 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org
Subject: [PATCH 46/62] drivers/staging: Remove unnecessary semicolons
Date: Sun, 28 Jun 2009 09:26:51 -0700
Message-Id: <9a32739d4385555d40f40f7ca88429c04587db00.1246173682.git.joe@perches.com>
X-Mailer: git-send-email 1.6.3.1.10.g659a0.dirty
In-Reply-To: <cover.1246173664.git.joe@perches.com>
References: <cover.1246173664.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 .../comedi/drivers/addi-data/APCI1710_Tor.c        |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1500.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci1516.c      |    2 +-
 .../comedi/drivers/addi-data/hwdrv_apci3501.c      |    2 +-
 drivers/staging/comedi/drivers/amplc_pci230.c      |    2 +-
 drivers/staging/comedi/drivers/comedi_bond.c       |    2 +-
 drivers/staging/go7007/go7007-driver.c             |    2 +-
 drivers/staging/otus/80211core/cmmsta.c            |    2 +-
 drivers/staging/otus/hal/hpmain.c                  |    2 +-
 drivers/staging/rt2860/common/cmm_data_2860.c      |    8 ++++----
 drivers/staging/rt2860/rt_linux.c                  |    2 +-
 drivers/staging/rt2860/rtmp.h                      |    3 +--
 drivers/staging/rt2860/sta/aironet.c               |    2 +-
 drivers/staging/rtl8187se/r8185b_init.c            |    2 +-
 drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c |    2 +-
 drivers/staging/rtl8192su/r8192U_core.c            |    6 +++---
 drivers/staging/rtl8192su/r819xU_phy.c             |    2 +-
 drivers/staging/vt6655/card.c                      |    2 +-
 drivers/staging/vt6655/iwctl.c                     |    2 +-
 drivers/staging/vt6655/wpa2.c                      |    4 ++--
 20 files changed, 26 insertions(+), 27 deletions(-)

diff --git a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
index 43198aa..7f28fe2 100644
--- a/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
+++ b/drivers/staging/comedi/drivers/addi-data/APCI1710_Tor.c
@@ -1008,7 +1008,7 @@ int i_APCI1710_InsnWriteEnableDisableTorCounter(struct comedi_device *dev,
 	b_ExternGate = (unsigned char) data[3];
 	b_CycleMode = (unsigned char) data[4];
 	b_InterruptEnable = (unsigned char) data[5];
-	i_ReturnValue = insn->n;;
+	i_ReturnValue = insn->n;
 	devpriv->tsk_Current = current;	/*  Save the current process task structure */
 	/**************************/
 	/* Test the module number */
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
index 236b8a3..fb4db93 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1500.c
@@ -2834,7 +2834,7 @@ int i_APCI1500_Reset(struct comedi_device *dev)
 	i_Logic = 0;
 	i_CounterLogic = 0;
 	i_InterruptMask = 0;
-	i_InputChannel = 0;;
+	i_InputChannel = 0;
 	i_TimerCounter1Enabled = 0;
 	i_TimerCounter2Enabled = 0;
 	i_WatchdogCounter3Enabled = 0;
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
index 3841635..fcd71ae 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci1516.c
@@ -335,7 +335,7 @@ int i_APCI1516_WriteDigitalOutput(struct comedi_device *dev, struct comedi_subde
 			return -EINVAL;
 		}		/* if else data[3]==1) */
 	}			/* if else data[3]==0) */
-	return (insn->n);;
+	return (insn->n);
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
index ef21f03..edd1fff 100644
--- a/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
+++ b/drivers/staging/comedi/drivers/addi-data/hwdrv_apci3501.c
@@ -339,7 +339,7 @@ int i_APCI3501_ConfigAnalogOutput(struct comedi_device *dev, struct comedi_subde
 int i_APCI3501_WriteAnalogOutput(struct comedi_device *dev, struct comedi_subdevice *s,
 	struct comedi_insn *insn, unsigned int *data)
 {
-	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;;
+	unsigned int ul_Command1 = 0, ul_Channel_no, ul_Polarity, ul_DAC_Ready = 0;
 
 	ul_Channel_no = CR_CHAN(insn->chanspec);
 
diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 21133f0..48e0765 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -918,7 +918,7 @@ static int pci230_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	if (thisboard->ao_chans > 0) {
 		s->type = COMEDI_SUBD_AO;
 		s->subdev_flags = SDF_WRITABLE | SDF_GROUND;
-		s->n_chan = thisboard->ao_chans;;
+		s->n_chan = thisboard->ao_chans;
 		s->maxdata = (1 << thisboard->ao_bits) - 1;
 		s->range_table = &pci230_ao_range;
 		s->insn_write = &pci230_ao_winsn;
diff --git a/drivers/staging/comedi/drivers/comedi_bond.c b/drivers/staging/comedi/drivers/comedi_bond.c
index 45cd41f..8bd50d7 100644
--- a/drivers/staging/comedi/drivers/comedi_bond.c
+++ b/drivers/staging/comedi/drivers/comedi_bond.c
@@ -400,7 +400,7 @@ static int doDevConfig(struct comedi_device *dev, struct comedi_devconfig *it)
 	void *devs_opened[COMEDI_NUM_BOARD_MINORS];
 
 	memset(devs_opened, 0, sizeof(devs_opened));
-	devpriv->name[0] = 0;;
+	devpriv->name[0] = 0;
 	/* Loop through all comedi devices specified on the command-line,
 	   building our device list */
 	for (i = 0; i < COMEDI_NDEVCONFOPTS && (!i || it->options[i]); ++i) {
diff --git a/drivers/staging/go7007/go7007-driver.c b/drivers/staging/go7007/go7007-driver.c
index 77b1e76..98a4a00 100644
--- a/drivers/staging/go7007/go7007-driver.c
+++ b/drivers/staging/go7007/go7007-driver.c
@@ -647,7 +647,7 @@ struct go7007 *go7007_alloc(struct go7007_board_info *board, struct device *dev)
 	go->dvd_mode = 0;
 	go->interlace_coding = 0;
 	for (i = 0; i < 4; ++i)
-		go->modet[i].enable = 0;;
+		go->modet[i].enable = 0;
 	for (i = 0; i < 1624; ++i)
 		go->modet_map[i] = 0;
 	go->audio_deliver = NULL;
diff --git a/drivers/staging/otus/80211core/cmmsta.c b/drivers/staging/otus/80211core/cmmsta.c
index b28a4e2..d6aa0a4 100644
--- a/drivers/staging/otus/80211core/cmmsta.c
+++ b/drivers/staging/otus/80211core/cmmsta.c
@@ -1426,7 +1426,7 @@ struct zsBssInfo* zfStaFindBssInfo(zdev_t* dev, zbuf_t* buf, struct zsWlanProbeR
                     if (zfHpIsAllowedChannel(dev, zfChNumToFreq(dev, channel, 0)) == 0) {
                         frequency = 0;
                     } else {
-                        frequency = zfChNumToFreq(dev, channel, 0);;
+                        frequency = zfChNumToFreq(dev, channel, 0);
                     }
                 } else {
                     frequency = 0;
diff --git a/drivers/staging/otus/hal/hpmain.c b/drivers/staging/otus/hal/hpmain.c
index 322585b..32f0b49 100644
--- a/drivers/staging/otus/hal/hpmain.c
+++ b/drivers/staging/otus/hal/hpmain.c
@@ -1455,7 +1455,7 @@ void zfHpSetFrequencyEx(zdev_t* dev, u32_t frequency, u8_t bw40,
        /* calibration that updates the pddac with the wrong polarity.  Fortunately    */
        /* the second loop can be disabled with a bit called en_pd_dc_offset_thr.      */
 #if 0
-        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);;
+        cmdB[0] = 8 | (ZM_CMD_BITAND << 8);
         cmdB[1] = (0xa27c + 0x1bc000);
         cmdB[2] = 0xffefffff;
         ret = zfIssueCmd(dev, cmdB, 12, ZM_OID_INTERNAL_WRITE, 0);
diff --git a/drivers/staging/rt2860/common/cmm_data_2860.c b/drivers/staging/rt2860/common/cmm_data_2860.c
index fb17355..5a6349a 100644
--- a/drivers/staging/rt2860/common/cmm_data_2860.c
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c
@@ -80,7 +80,7 @@ USHORT RtmpPCI_WriteTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -139,7 +139,7 @@ USHORT RtmpPCI_WriteSingleTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = TXINFO_SIZE + TXWI_SIZE + hwHeaderLen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -218,7 +218,7 @@ USHORT RtmpPCI_WriteMultiTxResource(
 
 	pTxD->SDPtr0 = BufBasePaLow;
 	pTxD->SDLen0 = firstDMALen; // include padding
-	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr1 = PCI_MAP_SINGLE(pAd, pTxBlk, 0, 1, PCI_DMA_TODEVICE);
 	pTxD->SDLen1 = pTxBlk->SrcBufLen;
 	pTxD->LastSec0 = 0;
 	pTxD->LastSec1 = (bIsLast) ? 1 : 0;
@@ -372,7 +372,7 @@ int RtmpPCIMgmtKickOut(
 	pTxD->LastSec1 = 1;
 	pTxD->DMADONE = 0;
 	pTxD->SDLen1 = 0;
-	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);;
+	pTxD->SDPtr0 = PCI_MAP_SINGLE(pAd, pSrcBufVA, SrcBufLen, 0, PCI_DMA_TODEVICE);
 	pTxD->SDLen0 = SrcBufLen;
 
 	pAd->RalinkCounters.KickTxCount++;
diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
index 80176b2..b5a2050 100644
--- a/drivers/staging/rt2860/rt_linux.c
+++ b/drivers/staging/rt2860/rt_linux.c
@@ -934,7 +934,7 @@ void send_monitor_packets(
     ph->rssi.did = DIDmsg_lnxind_wlansniffrm_rssi;
 	ph->rssi.status = 0;
 	ph->rssi.len = 4;
-    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));;
+    ph->rssi.data = (u_int32_t)RTMPMaxRssi(pAd, ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI0, RSSI_0), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI1, RSSI_1), ConvertToRssi(pAd, pRxBlk->pRxWI->RSSI2, RSSI_2));
 
 	ph->signal.did = DIDmsg_lnxind_wlansniffrm_signal;
 	ph->signal.status = 0;
diff --git a/drivers/staging/rt2860/rtmp.h b/drivers/staging/rt2860/rtmp.h
index 25c3199..c8138d0 100644
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -4507,8 +4507,7 @@ VOID IterateOnBssTab(
 	IN  PRTMP_ADAPTER   pAd);
 
 VOID IterateOnBssTab2(
-	IN  PRTMP_ADAPTER   pAd);;
-
+	IN  PRTMP_ADAPTER   pAd);
 VOID JoinParmFill(
 	IN  PRTMP_ADAPTER   pAd,
 	IN  OUT MLME_JOIN_REQ_STRUCT *JoinReq,
diff --git a/drivers/staging/rt2860/sta/aironet.c b/drivers/staging/rt2860/sta/aironet.c
index 4af4a19..07b0d51 100644
--- a/drivers/staging/rt2860/sta/aironet.c
+++ b/drivers/staging/rt2860/sta/aironet.c
@@ -367,7 +367,7 @@ VOID	ChannelLoadRequestAction(
 		if (NStatus	!= NDIS_STATUS_SUCCESS)
 			return;
 
-		pNullFrame = (PHEADER_802_11) pOutBuffer;;
+		pNullFrame = (PHEADER_802_11) pOutBuffer;
 		// Make the power save Null frame with PSM bit on
 		MgtMacHeaderInit(pAd, pNullFrame, SUBTYPE_NULL_FUNC, 1, pAd->CommonCfg.Bssid, pAd->CommonCfg.Bssid);
 		pNullFrame->Duration 	= 0;
diff --git a/drivers/staging/rtl8187se/r8185b_init.c b/drivers/staging/rtl8187se/r8185b_init.c
index 4b885a2..0add9f5 100644
--- a/drivers/staging/rtl8187se/r8185b_init.c
+++ b/drivers/staging/rtl8187se/r8185b_init.c
@@ -2642,7 +2642,7 @@ SetRFPowerState(
 
 		default:
 			printk("SetRFPowerState8185(): unknown RFChipID: 0x%X!!!\n", priv->rf_chip);
-			break;;
+			break;
 }
 //	printk("<--------- SetRFPowerState(): bResult(%d)\n", bResult);
 
diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
index 7294572..46b4bad 100644
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_tx.c
@@ -788,7 +788,7 @@ int ieee80211_xmit(struct sk_buff *skb, struct net_device *dev)
 		{
 			txb->queue_index = UP2AC(skb->priority);
 		} else {
-			txb->queue_index = WME_AC_BK;;
+			txb->queue_index = WME_AC_BK;
 		}
 
 
diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
index f1423d7..0f4d82d 100644
--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -7454,7 +7454,7 @@ static void rtl8192SU_MacConfigBeforeFwDownloadASIC(struct net_device *dev)
 void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
-	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;;
+	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
 
 
 	//
@@ -7527,7 +7527,7 @@ void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 void rtl8192SU_HalUsbRxAggr8192SUsb(struct net_device *dev, bool Value)
 {
 	struct r8192_priv *priv = ieee80211_priv((struct net_device *)dev);
-	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;;
+	PRT_HIGH_THROUGHPUT	pHTInfo = priv->ieee80211->pHTInfo;
 
 
 	//
@@ -10688,7 +10688,7 @@ static void rtl8192_query_rxphystatus(
 			//Get Rx snr value in DB
 			tmp_rxsnr =	pofdm_buf->rxsnr_X[i];
 			rx_snrX = (char)(tmp_rxsnr);
-			//rx_snrX >>= 1;;
+			//rx_snrX >>= 1;
 			rx_snrX /= 2;
 			priv->stats.rxSNRdB[i] = (long)rx_snrX;
 
diff --git a/drivers/staging/rtl8192su/r819xU_phy.c b/drivers/staging/rtl8192su/r819xU_phy.c
index 00497d3..0b0eeb0 100644
--- a/drivers/staging/rtl8192su/r819xU_phy.c
+++ b/drivers/staging/rtl8192su/r819xU_phy.c
@@ -1011,7 +1011,7 @@ u8 rtl8192_phy_ConfigRFWithHeaderFile(struct net_device* dev, RF90_RADIO_PATH_E
 			break;
 	}
 
-	return ret;;
+	return ret;
 
 }
 /******************************************************************************
diff --git a/drivers/staging/vt6655/card.c b/drivers/staging/vt6655/card.c
index 723f44e..8076cb9 100644
--- a/drivers/staging/vt6655/card.c
+++ b/drivers/staging/vt6655/card.c
@@ -2960,7 +2960,7 @@ BOOL CARDbSoftwareReset (PVOID pDeviceHandler)
 QWORD CARDqGetTSFOffset (BYTE byRxRate, QWORD qwTSF1, QWORD qwTSF2)
 {
     QWORD   qwTSFOffset;
-    WORD    wRxBcnTSFOffst= 0;;
+    WORD    wRxBcnTSFOffst= 0;
 
     HIDWORD(qwTSFOffset) = 0;
     LODWORD(qwTSFOffset) = 0;
diff --git a/drivers/staging/vt6655/iwctl.c b/drivers/staging/vt6655/iwctl.c
index 4d5a1da..fff6265 100644
--- a/drivers/staging/vt6655/iwctl.c
+++ b/drivers/staging/vt6655/iwctl.c
@@ -2168,7 +2168,7 @@ int iwctl_giwencodeext(struct net_device *dev,
              struct iw_point *wrq,
              char *extra)
 {
-		return -EOPNOTSUPP;;
+		return -EOPNOTSUPP;
 }
 
 int iwctl_siwmlme(struct net_device *dev,
diff --git a/drivers/staging/vt6655/wpa2.c b/drivers/staging/vt6655/wpa2.c
index e2fdb33..8828873 100644
--- a/drivers/staging/vt6655/wpa2.c
+++ b/drivers/staging/vt6655/wpa2.c
@@ -225,7 +225,7 @@ WPA2vParseRSN (
         m = *((PWORD) &(pRSN->abyRSN[4]));
 
         if (pRSN->len >= 10+m*4) { // ver(2) + GK(4) + PK count(2) + PKS(4*m) + AKMSS count(2)
-            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            pBSSNode->wAKMSSAuthCount = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             j = 0;
             pbyOUI = &(pRSN->abyRSN[8+4*m]);
             for (i = 0; (i < pBSSNode->wAKMSSAuthCount) && (j < sizeof(pBSSNode->abyAKMSSAuthType)/sizeof(BYTE)); i++) {
@@ -244,7 +244,7 @@ WPA2vParseRSN (
             pBSSNode->wAKMSSAuthCount = (WORD)j;
             DEVICE_PRT(MSG_LEVEL_DEBUG, KERN_INFO"wAKMSSAuthCount: %d\n", pBSSNode->wAKMSSAuthCount);
 
-            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));;
+            n = *((PWORD) &(pRSN->abyRSN[6+4*m]));
             if (pRSN->len >= 12+4*m+4*n) { // ver(2)+GK(4)+PKCnt(2)+PKS(4*m)+AKMSSCnt(2)+AKMSS(4*n)+Cap(2)
                 pBSSNode->sRSNCapObj.bRSNCapExist = TRUE;
                 pBSSNode->sRSNCapObj.wRSNCap = *((PWORD) &(pRSN->abyRSN[8+4*m+4*n]));
-- 
1.6.3.1.10.g659a0.dirty

