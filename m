Return-Path: <linux-kernel-owner+w=401wt.eu-S1752371AbZKGQbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371AbZKGQbU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Nov 2009 11:31:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752319AbZKGQbS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Nov 2009 11:31:18 -0500
Received: from sedf.de ([212.83.34.151]:50822 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259AbZKGQbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Nov 2009 11:31:16 -0500
Date: Sat, 7 Nov 2009 17:31:12 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Patch 3/3 v2] staging: rt2860: reduce superfluous exclamation
 marks
Message-ID: <20091107163112.GA25035@sedf.de>
References: <20091106134812.GA27210@sedf.de>
 <20091106225931.GD32205@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Dxnq1zWXvFF0Q93v"
Content-Disposition: inline
In-Reply-To: <20091106225931.GD32205@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Dxnq1zWXvFF0Q93v
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 06, 2009 at 02:59:31PM -0800, Greg KH wrote:
> Heh, this is funny.  How did you determine that 3 '!' is acceptable when
> 4 or 5 '!' are not?
>=20
> As this is a pretty pointless patch, I'm not going to apply it.

In retrospect, i am glad you didn't apply this. I personally do not=20
think that 3 '!' is acceptable, but i found 3 '!' at several different=20
places in the kernel, what led me to the assumption that others do.
In my humble opinion the whole kernel deserves a sed -i -e s/\!\!*/\!/g=20

Please apply the patch below, which cleans the strings more rigorous.
It is meant to be applied on top of [Patch 2/3 v2] of this series.

Thanks,
sedf

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>

This removes superfluous exclamation marks from strings and comments, and=
=20
also three spelling typos.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru a/drivers/staging/rt2860/common/ba_action.c b/drivers/staging/rt28=
60/common/ba_action.c
--- a/drivers/staging/rt2860/common/ba_action.c	2009-11-06 08:03:10.0000000=
00 +0100
+++ b/drivers/staging/rt2860/common/ba_action.c	2009-11-07 15:39:06.9158489=
57 +0100
@@ -1481,7 +1481,7 @@
 		NdisReleaseSpinLock(&pBAEntry->RxReRingLock);
 	} else {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("!!! (%d) Can't allocate reordering mpdu blk\n",
+			 (" (%d) Can't allocate reordering mpdu blk\n",
 			  pBAEntry->list.qlen));
=20
 		/*
@@ -1542,7 +1542,7 @@
 		}
 		pBAEntry =3D &pAd->BATable.BARecEntry[Idx];
 	} else {
-		/* impossible !!! */
+		/* impossible ! */
 		ASSERT(0);
 		/* release packet */
 		RELEASE_NDIS_PACKET(pAd, pRxBlk->pRxPacket,
diff -ru a/drivers/staging/rt2860/common/cmm_aes.c b/drivers/staging/rt2860=
/common/cmm_aes.c
--- a/drivers/staging/rt2860/common/cmm_aes.c	2009-11-06 08:03:10.000000000=
 +0100
+++ b/drivers/staging/rt2860/common/cmm_aes.c	2009-11-07 15:39:06.929184179=
 +0100
@@ -1279,7 +1279,7 @@
=20
 	if (R =3D=3D NULL) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("!!!AES_GTK_KEY_UNWRAP: no memory!!!\n"));
+			 ("AES_GTK_KEY_UNWRAP: no memory!\n"));
 		return;
 	}
 	/* End of if */
diff -ru a/drivers/staging/rt2860/common/cmm_asic.c b/drivers/staging/rt286=
0/common/cmm_asic.c
--- a/drivers/staging/rt2860/common/cmm_asic.c	2009-11-06 08:03:10.00000000=
0 +0100
+++ b/drivers/staging/rt2860/common/cmm_asic.c	2009-11-07 15:39:06.95584931=
4 +0100
@@ -1005,7 +1005,7 @@
 void AsicResetBBPAgent(struct rt_rtmp_adapter *pAd)
 {
 	BBP_CSR_CFG_STRUC BbpCsr;
-	DBGPRINT(RT_DEBUG_ERROR, ("Reset BBP Agent busy bit.!! \n"));
+	DBGPRINT(RT_DEBUG_ERROR, ("Reset BBP Agent busy bit!\n"));
 	/* Still need to find why BBP agent keeps busy, but in fact, hardware sti=
ll function ok. Now clear busy first. */
 	RTMP_IO_READ32(pAd, H2M_BBP_AGENT, &BbpCsr.word);
 	BbpCsr.field.Busy =3D 0;
diff -ru a/drivers/staging/rt2860/common/cmm_data_2860.c b/drivers/staging/=
rt2860/common/cmm_data_2860.c
--- a/drivers/staging/rt2860/common/cmm_data_2860.c	2009-11-06 08:03:10.000=
000000 +0100
+++ b/drivers/staging/rt2860/common/cmm_data_2860.c	2009-11-07 15:39:06.972=
516527 +0100
@@ -847,7 +847,7 @@
 		AutoWakeupCfg.word =3D 0;
 		RTMP_IO_WRITE32(pAd, AUTO_WAKEUP_CFG, AutoWakeupCfg.word);
=20
-		// If this is called from Halt. ALWAYS force wakeup!!!
+		// If this is called from Halt. ALWAYS force wakeup!
 		if (Level =3D=3D RTMP_HALT)
 		{
 			RT28xxPciAsicRadioOn(pAd, RTMP_HALT);
diff -ru a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt286=
0/common/cmm_data.c
--- a/drivers/staging/rt2860/common/cmm_data.c	2009-11-06 08:03:10.00000000=
0 +0100
+++ b/drivers/staging/rt2860/common/cmm_data.c	2009-11-07 15:39:06.99918250=
6 +0100
@@ -397,7 +397,7 @@
 	    && (pAd->CommonCfg.bIEEE80211H =3D=3D 1)
 	    && (pAd->CommonCfg.RadarDetect.RDMode !=3D RD_NORMAL_MODE)) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("MlmeHardTransmit --> radar detect not in normal mode !!!\n"));
+			 ("MlmeHardTransmit --> radar detect not in normal mode!\n"));
 /*              if (!IrqState) */
 		RTMP_SEM_UNLOCK(&pAd->MgmtRingLock);
 		return (NDIS_STATUS_FAILURE);
@@ -964,7 +964,7 @@
 	IRQL =3D PASSIVE_LEVEL
 	IRQL =3D DISPATCH_LEVEL
=20
-    See also : BASmartHardTransmit()    !!!
+    See also : BASmartHardTransmit()    !
=20
 	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
 */
@@ -1708,7 +1708,7 @@
 				pProbeEntry =3D pProbeEntry->pNext;
 			} while (pProbeEntry);
=20
-			/* not found !!! */
+			/* not found ! */
 			ASSERT(pProbeEntry !=3D NULL);
=20
 			RTMP_STA_ENTRY_KEY_DEL(pAd, BSS0, wcid);
@@ -1729,7 +1729,7 @@
 				  pAd->MacTab.Size));
 		} else {
 			DBGPRINT(RT_DEBUG_OFF,
-				 ("\n%s: Impossible Wcid =3D %d !!!!!\n",
+				 ("\n%s: Impossible Wcid =3D %d !\n",
 				  __func__, wcid));
 		}
 	}
diff -ru a/drivers/staging/rt2860/common/cmm_data_pci.c b/drivers/staging/r=
t2860/common/cmm_data_pci.c
--- a/drivers/staging/rt2860/common/cmm_data_pci.c	2009-11-06 08:03:10.0000=
00000 +0100
+++ b/drivers/staging/rt2860/common/cmm_data_pci.c	2009-11-07 15:39:07.0091=
82667 +0100
@@ -979,7 +979,7 @@
 	    && (pAd->CommonCfg.bIEEE80211H =3D=3D 1)
 	    && (pAd->CommonCfg.RadarDetect.RDMode !=3D RD_NORMAL_MODE)) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("MlmeHardTransmit --> radar detect not in normal mode !!!\n"));
+			 ("MlmeHardTransmit --> radar detect not in normal mode!\n"));
 		/*NdisReleaseSpinLock(&pAd->TxRingLock); */
 		return (NDIS_STATUS_FAILURE);
 	}
diff -ru a/drivers/staging/rt2860/common/cmm_mac_pci.c b/drivers/staging/rt=
2860/common/cmm_mac_pci.c
--- a/drivers/staging/rt2860/common/cmm_mac_pci.c	2009-11-06 08:03:10.00000=
0000 +0100
+++ b/drivers/staging/rt2860/common/cmm_mac_pci.c	2009-11-07 15:39:07.04918=
2473 +0100
@@ -1650,7 +1650,7 @@
=20
 		if (brc =3D=3D FALSE) {
 			DBGPRINT(RT_DEBUG_ERROR,
-				 ("%s call RT28xxPciAsicRadioOff fail !!\n",
+				 ("%s call RT28xxPciAsicRadioOff fail!\n",
 				  __func__));
 		}
 	}
diff -ru a/drivers/staging/rt2860/common/cmm_mac_usb.c b/drivers/staging/rt=
2860/common/cmm_mac_usb.c
--- a/drivers/staging/rt2860/common/cmm_mac_usb.c	2009-11-06 08:03:10.00000=
0000 +0100
+++ b/drivers/staging/rt2860/common/cmm_mac_usb.c	2009-11-07 15:39:07.06251=
6300 +0100
@@ -205,9 +205,9 @@
 			/*Allocate URB */
 			LM_USB_ALLOC(pObj, pHTTXContext, struct rt_httx_buffer *,
 				     sizeof(struct rt_httx_buffer), Status,
-				     ("<-- ERROR in Alloc TX TxContext[%d] urb!! \n",
+				     ("<-- ERROR in Alloc TX TxContext[%d] urb!\n",
 				      acidx), done,
-				     ("<-- ERROR in Alloc TX TxContext[%d] struct rt_httx_buffer !! \n=
",
+				     ("<-- ERROR in Alloc TX TxContext[%d] struct rt_httx_buffer!\n",
 				      acidx), out1);
=20
 			NdisZeroMemory(pHTTXContext->TransferBuffer->
@@ -259,7 +259,7 @@
 			pMLMEContext->pUrb =3D RTUSB_ALLOC_URB(0);
 			if (pMLMEContext->pUrb =3D=3D NULL) {
 				DBGPRINT(RT_DEBUG_ERROR,
-					 ("<-- ERROR in Alloc TX MLMEContext[%d] urb!! \n",
+					 ("<-- ERROR in Alloc TX MLMEContext[%d] urb!\n",
 					  i));
 				Status =3D NDIS_STATUS_RESOURCES;
 				goto out2;
@@ -296,9 +296,9 @@
 			/*Allocate URB */
 			LM_USB_ALLOC(pObj, pBeaconContext, struct rt_tx_buffer *,
 				     sizeof(struct rt_tx_buffer), Status,
-				     ("<-- ERROR in Alloc TX BeaconContext[%d] urb!! \n",
+				     ("<-- ERROR in Alloc TX BeaconContext[%d] urb!\n",
 				      i), out2,
-				     ("<-- ERROR in Alloc TX BeaconContext[%d] struct rt_tx_buffer !! =
\n",
+				     ("<-- ERROR in Alloc TX BeaconContext[%d] struct rt_tx_buffer!\n",
 				      i), out3);
=20
 			pBeaconContext->pAd =3D pAd;
@@ -315,9 +315,9 @@
 		/*Allocate URB */
 		LM_USB_ALLOC(pObj, pNullContext, struct rt_tx_buffer *, sizeof(struct rt=
_tx_buffer),
 			     Status,
-			     ("<-- ERROR in Alloc TX NullContext urb!! \n"),
+			     ("<-- ERROR in Alloc TX NullContext urb!\n"),
 			     out3,
-			     ("<-- ERROR in Alloc TX NullContext struct rt_tx_buffer !! \n"),
+			     ("<-- ERROR in Alloc TX NullContext struct rt_tx_buffer!\n"),
 			     out4);
=20
 		pNullContext->pAd =3D pAd;
@@ -333,9 +333,9 @@
 		/*Allocate URB */
 		LM_USB_ALLOC(pObj, pRTSContext, struct rt_tx_buffer *, sizeof(struct rt_=
tx_buffer),
 			     Status,
-			     ("<-- ERROR in Alloc TX RTSContext urb!! \n"),
+			     ("<-- ERROR in Alloc TX RTSContext urb!\n"),
 			     out4,
-			     ("<-- ERROR in Alloc TX RTSContext struct rt_tx_buffer !! \n"),
+			     ("<-- ERROR in Alloc TX RTSContext struct rt_tx_buffer!\n"),
 			     out5);
=20
 		pRTSContext->pAd =3D pAd;
@@ -350,9 +350,9 @@
 		/*Allocate URB */
 		LM_USB_ALLOC(pObj, pPsPollContext, struct rt_tx_buffer *,
 			     sizeof(struct rt_tx_buffer), Status,
-			     ("<-- ERROR in Alloc TX PsPollContext urb!! \n"),
+			     ("<-- ERROR in Alloc TX PsPollContext urb!\n"),
 			     out5,
-			     ("<-- ERROR in Alloc TX PsPollContext struct rt_tx_buffer !! \n"),
+			     ("<-- ERROR in Alloc TX PsPollContext struct rt_tx_buffer!\n"),
 			     out6);
=20
 		pPsPollContext->pAd =3D pAd;
diff -ru a/drivers/staging/rt2860/common/cmm_sanity.c b/drivers/staging/rt2=
860/common/cmm_sanity.c
--- a/drivers/staging/rt2860/common/cmm_sanity.c	2009-11-06 08:03:10.000000=
000 +0100
+++ b/drivers/staging/rt2860/common/cmm_sanity.c	2009-11-07 15:39:07.075849=
289 +0100
@@ -256,7 +256,7 @@
=20
 	/* For some 11a AP which didn't have DS_IE, we use two conditions to deci=
de the channel */
 	/*      1. If the AP is 11n enabled, then check the control channel. */
-	/*      2. If the AP didn't have any info about channel, use the channel =
we received this frame as the channel. (May inaccuracy!!) */
+	/*      2. If the AP didn't have any info about channel, use the channel =
we received this frame as the channel. (May inaccuracy!) */
 	u8 CtrlChannel =3D 0;
=20
 	/* Add for 3 necessary EID field check */
@@ -371,7 +371,7 @@
 			break;
=20
 		case IE_HT_CAP:
-			if (pEid->Len >=3D SIZE_HT_CAP_IE)	/*Note: allow extension.!! */
+			if (pEid->Len >=3D SIZE_HT_CAP_IE)	/*Note: allow extension! */
 			{
 				NdisMoveMemory(pHtCapability, pEid->Octet,
 					       sizeof(struct rt_ht_capability_ie));
diff -ru a/drivers/staging/rt2860/common/cmm_tkip.c b/drivers/staging/rt286=
0/common/cmm_tkip.c
--- a/drivers/staging/rt2860/common/cmm_tkip.c	2009-11-06 08:03:10.00000000=
0 +0100
+++ b/drivers/staging/rt2860/common/cmm_tkip.c	2009-11-07 15:39:07.09251678=
2 +0100
@@ -828,6 +828,6 @@
 		/*RTMPReportMicError(pAd, &pWpaKey[KeyID]);     // marked by AlbertY @ 2=
0060630 */
 		return (FALSE);
 	}
-	/*DBGPRINT(RT_DEBUG_TRACE, "RTMPSoftDecryptTKIP Decript done!!\n"); */
+	/*DBGPRINT(RT_DEBUG_TRACE, "RTMPSoftDecryptTKIP Decript done!\n"); */
 	return TRUE;
 }
diff -ru a/drivers/staging/rt2860/common/cmm_wep.c b/drivers/staging/rt2860=
/common/cmm_wep.c
--- a/drivers/staging/rt2860/common/cmm_wep.c	2009-11-06 08:03:10.000000000=
 +0100
+++ b/drivers/staging/rt2860/common/cmm_wep.c	2009-11-07 15:39:07.099183276=
 +0100
@@ -245,7 +245,7 @@
 	crc32 ^=3D 0xffffffff;	/* complement */
=20
 	if (crc32 !=3D cpu2le32(trailfcs)) {
-		DBGPRINT(RT_DEBUG_TRACE, ("! WEP Data CRC Error !\n"));	/*CRC error. */
+		DBGPRINT(RT_DEBUG_TRACE, ("WEP Data CRC Error!\n"));	/*CRC error. */
 		return (FALSE);
 	}
 	return (TRUE);
diff -ru a/drivers/staging/rt2860/common/cmm_wpa.c b/drivers/staging/rt2860=
/common/cmm_wpa.c
--- a/drivers/staging/rt2860/common/cmm_wpa.c	2009-11-06 08:03:10.000000000=
 +0100
+++ b/drivers/staging/rt2860/common/cmm_wpa.c	2009-11-07 15:39:07.129182919=
 +0100
@@ -1292,7 +1292,7 @@
 	os_alloc_mem(NULL, (u8 **) & input, 1024);
=20
 	if (input =3D=3D NULL) {
-		DBGPRINT(RT_DEBUG_ERROR, ("!!!PRF: no memory!!!\n"));
+		DBGPRINT(RT_DEBUG_ERROR, ("PRF: no memory!\n"));
 		return;
 	}
 	/* Generate concatenation input */
@@ -2672,7 +2672,7 @@
 	os_alloc_mem(NULL, (u8 **) & OutBuffer, 512);
=20
 	if (OutBuffer =3D=3D NULL) {
-		DBGPRINT(RT_DEBUG_ERROR, ("!!!CalculateMIC: no memory!!!\n"));
+		DBGPRINT(RT_DEBUG_ERROR, ("CalculateMIC: no memory!\n"));
 		return;
 	}
 	/* make a frame for calculating MIC. */
diff -ru a/drivers/staging/rt2860/common/mlme.c b/drivers/staging/rt2860/co=
mmon/mlme.c
--- a/drivers/staging/rt2860/common/mlme.c	2009-11-06 08:03:10.000000000 +0=
100
+++ b/drivers/staging/rt2860/common/mlme.c	2009-11-07 15:39:07.229182285 +0=
100
@@ -483,7 +483,7 @@
 #ifdef RTMP_MAC_USB
 			if (Elem->MsgType =3D=3D MT2_RESET_CONF) {
 				DBGPRINT_RAW(RT_DEBUG_TRACE,
-					     ("!!! reset MLME state machine !!!\n"));
+					     ("reset MLME state machine!\n"));
 				MlmeRestartStateMachine(pAd);
 				Elem->Occupied =3D FALSE;
 				Elem->MsgLen =3D 0;
@@ -4042,7 +4042,7 @@
 			}
 			/* Since the AP is using hidden SSID, and we are trying to connect to A=
NY */
 			/* It definitely will fail. So, skip it. */
-			/* CCX also require not even try to connect it!! */
+			/* CCX also require not even try to connect it! */
 			if (SsidLen =3D=3D 0)
 				continue;
=20
@@ -4600,8 +4600,8 @@
  * input params:
  *		Buffer - pointer to a pre-allocated memory segment
  *		args - a list of <int arg_size, arg> pairs.
- *		NOTE NOTE NOTE!!!! the last argument must be NULL, otherwise this
- *						   function will FAIL!!!
+ *		NOTE NOTE NOTE! the last argument must be NULL, otherwise this
+ *						   function will FAIL!
  * return:
  *		Size of the buffer
  * usage:
diff -ru a/drivers/staging/rt2860/common/rtmp_init.c b/drivers/staging/rt28=
60/common/rtmp_init.c
--- a/drivers/staging/rt2860/common/rtmp_init.c	2009-11-07 06:08:23.2168052=
40 +0100
+++ b/drivers/staging/rt2860/common/rtmp_init.c	2009-11-07 15:39:07.2891829=
63 +0100
@@ -75,7 +75,7 @@
 	{BCN_OFFSET0, 0xece8e4e0},	/* 0x3800, 0x3A00, 0x3C00, 0x3E00, 512B for ea=
ch beacon */
 	{BCN_OFFSET1, 0xfcf8f4f0},	/* 0x3800, 0x3A00, 0x3C00, 0x3E00, 512B for ea=
ch beacon */
 #else
-#error You must re-calculate new value for BCN_OFFSET0 & BCN_OFFSET1 in MA=
CRegTable[]!!!
+#error You must re-calculate new value for BCN_OFFSET0 & BCN_OFFSET1 in MA=
CRegTable[]!
 #endif /* HW_BEACON_OFFSET // */
=20
 	{LEGACY_BASIC_RATE, 0x0000013f},	/*  Basic rate set bitmap */
@@ -1272,7 +1272,7 @@
 		pAd->bAutoTxAgcA =3D pAd->bAutoTxAgcG =3D FALSE;
 	/* */
 	/* Since BBP has been progamed, to make sure BBP setting will be */
-	/* upate inside of AsicAntennaSelect, so reset to UNKNOWN_BAND!! */
+	/* upate inside of AsicAntennaSelect, so reset to UNKNOWN_BAND! */
 	/* */
 	pAd->CommonCfg.BandState =3D UNKNOWN_BAND;
=20
@@ -3470,7 +3470,7 @@
 err0:
 #endif /* ST // */
=20
-	DBGPRINT(RT_DEBUG_ERROR, ("!!! rt28xx Initialized fail !!!\n"));
+	DBGPRINT(RT_DEBUG_ERROR, ("rt28xx Initialized fail!\n"));
 	return FALSE;
 }
=20
diff -ru a/drivers/staging/rt2860/common/rt_rf.c b/drivers/staging/rt2860/c=
ommon/rt_rf.c
--- a/drivers/staging/rt2860/common/rt_rf.c	2009-11-06 08:03:10.000000000 +=
0100
+++ b/drivers/staging/rt2860/common/rt_rf.c	2009-11-07 15:39:07.299183402 +=
0100
@@ -72,7 +72,7 @@
 	if ((i =3D=3D RETRY_LIMIT)
 	    || (RTMP_TEST_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST))) {
 		DBGPRINT_RAW(RT_DEBUG_ERROR,
-			     ("Retry count exhausted or device removed!!!\n"));
+			     ("Retry count exhausted or device removed!\n"));
 		return STATUS_UNSUCCESSFUL;
 	}
=20
diff -ru a/drivers/staging/rt2860/oid.h b/drivers/staging/rt2860/oid.h
--- a/drivers/staging/rt2860/oid.h	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/oid.h	2009-11-07 15:39:07.349183360 +0100
@@ -557,7 +557,7 @@
 /* New for MeetingHouse Api support */
 #define OID_MH_802_1X_SUPPORTED               0xFFEDC100
=20
-/* MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!!! */
+/* MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition! */
 typedef union _HTTRANSMIT_SETTING {
 	struct {
 		u16 MCS:7;	/* MCS */
@@ -614,7 +614,7 @@
 	struct rt_802_11_event_log Log[MAX_NUMBER_OF_EVENT];
 };
=20
-/* MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!!! */
+/* MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition! */
 typedef union _MACHTTRANSMIT_SETTING {
 	struct {
 		u16 MCS:7;	/* MCS */
diff -ru a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_li=
nux.c
--- a/drivers/staging/rt2860/rt_linux.c	2009-11-07 06:08:23.216805240 +0100
+++ b/drivers/staging/rt2860/rt_linux.c	2009-11-07 15:39:07.379182719 +0100
@@ -51,7 +51,7 @@
 	"connects with our wireless client",	/* IW_STA_LINKUP_EVENT_FLAG */
 	"disconnects with our wireless client",	/* IW_STA_LINKDOWN_EVENT_FLAG */
 	"scan completed"	/* IW_SCAN_COMPLETED_EVENT_FLAG */
-	    "scan terminate!! Busy!! Enqueue fail!!"	/* IW_SCAN_ENQUEUE_FAIL_EVEN=
T_FLAG */
+	    "scan terminate! Busy! Enqueue fail!"	/* IW_SCAN_ENQUEUE_FAIL_EVENT_F=
LAG */
 };
=20
 /* for wireless IDS_spoof_attack event message */
@@ -1282,7 +1282,7 @@
 {
=20
 	/* TODO: Need to fix this */
-	printk("WARNING: This function(%s) not implement yet!!!\n", __func__);
+	printk("WARNING: This function(%s) not implement yet!\n", __func__);
 	return 0;
 }
=20
diff -ru a/drivers/staging/rt2860/rt_linux.h b/drivers/staging/rt2860/rt_li=
nux.h
--- a/drivers/staging/rt2860/rt_linux.h	2009-11-07 06:08:13.895971697 +0100
+++ b/drivers/staging/rt2860/rt_linux.h	2009-11-07 15:39:07.389183157 +0100
@@ -427,7 +427,7 @@
=20
 #define DBGPRINT_ERR(Fmt)           \
 {                                   \
-    printk("ERROR!!! ");          \
+    printk("ERROR! ");          \
     printk Fmt;                  \
 }
=20
diff -ru a/drivers/staging/rt2860/rt_main_dev.c b/drivers/staging/rt2860/rt=
_main_dev.c
--- a/drivers/staging/rt2860/rt_main_dev.c	2009-11-06 08:03:10.000000000 +0=
100
+++ b/drivers/staging/rt2860/rt_main_dev.c	2009-11-07 15:39:07.399182757 +0=
100
@@ -321,7 +321,7 @@
=20
 		if (brc =3D=3D FALSE) {
 			DBGPRINT(RT_DEBUG_ERROR,
-				 ("%s call RT28xxPciAsicRadioOff fail !!\n",
+				 ("%s call RT28xxPciAsicRadioOff fail!\n",
 				  __func__));
 		}
 	}
diff -ru a/drivers/staging/rt2860/rtmp_chip.h b/drivers/staging/rt2860/rtmp=
_chip.h
--- a/drivers/staging/rt2860/rtmp_chip.h	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/rtmp_chip.h	2009-11-07 15:39:07.402515864 +0100
@@ -197,7 +197,7 @@
 		u16 DynamicTxAgcControl:1;	/* */
 		u16 ExternalLNAForG:1;	/* */
 		u16 ExternalLNAForA:1;	/* external LNA enable for 2.4G */
-		u16 CardbusAcceleration:1;	/* !!! NOTE: 0 - enable, 1 - disable */
+		u16 CardbusAcceleration:1;	/* ! NOTE: 0 - enable, 1 - disable */
 		u16 BW40MSidebandForG:1;
 		u16 BW40MSidebandForA:1;
 		u16 EnableWPSPBC:1;	/* WPS PBC Control bit */
diff -ru a/drivers/staging/rt2860/rtmp_def.h b/drivers/staging/rt2860/rtmp_=
def.h
--- a/drivers/staging/rt2860/rtmp_def.h	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/rtmp_def.h	2009-11-07 15:39:07.419182795 +0100
@@ -409,7 +409,7 @@
 #define MAX_LEN_OF_MAC_TABLE            MAX_NUMBER_OF_MAC	/* if MAX_MBSSID=
_NUM is 8, this value can't be larger than 211 */
=20
 #if MAX_LEN_OF_MAC_TABLE>MAX_AVAILABLE_CLIENT_WCID
-#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!!!!
+#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!
 #endif
=20
 #define MAX_NUM_OF_WDS_LINK_PERBSSID	            3
diff -ru a/drivers/staging/rt2860/sta/assoc.c b/drivers/staging/rt2860/sta/=
assoc.c
--- a/drivers/staging/rt2860/sta/assoc.c	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/sta/assoc.c	2009-11-07 15:39:07.515849333 +0100
@@ -563,7 +563,7 @@
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_WAIT_RSP;
 	} else {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - MlmeAssocReqAction() sanity check failed. BUG!!!!!! \n"));
+			 ("ASSOC - MlmeAssocReqAction() sanity check failed. BUG!\n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_ASSOC_CONF, 2,
@@ -746,7 +746,7 @@
 		pAd->Mlme.AssocMachine.CurrState =3D REASSOC_WAIT_RSP;
 	} else {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - MlmeReassocReqAction() sanity check failed. BUG!!!! \n"));
+			 ("ASSOC - MlmeReassocReqAction() sanity check failed. BUG!\n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_REASSOC_CONF, 2,
diff -ru a/drivers/staging/rt2860/sta/connect.c b/drivers/staging/rt2860/st=
a/connect.c
--- a/drivers/staging/rt2860/sta/connect.c	2009-11-06 08:03:10.000000000 +0=
100
+++ b/drivers/staging/rt2860/sta/connect.c	2009-11-07 15:39:07.552516030 +0=
100
@@ -214,7 +214,7 @@
 		break;
 #endif /* RTMP_MAC_USB // */
 	default:
-		DBGPRINT_ERR(("!ERROR! CNTL - Illegal message type(=3D%ld)",
+		DBGPRINT_ERR(("ERROR! CNTL - Illegal message type(=3D%ld)",
 			      Elem->MsgType));
 		break;
 	}
@@ -911,7 +911,7 @@
 				  pAd->CommonCfg.Bssid[5]));
 		} else {
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("CNTL - Start IBSS fail. BUG!!!!!\n"));
+				 ("CNTL - Start IBSS fail. BUG!\n"));
 			pAd->Mlme.CntlMachine.CurrState =3D CNTL_IDLE;
 		}
 	}
@@ -1184,7 +1184,7 @@
 	/* */
 	/* ASSOC - DisassocTimeoutAction */
 	/* CNTL - Dis-associate successful */
-	/* !!! LINK DOWN !!! */
+	/* ! LINK DOWN ! */
 	/* [88888] OID_802_11_SSID should have returned NDTEST_WEP_AP2(Returned: =
) */
 	/* */
 	/* To prevent DisassocTimeoutAction to call Link down after we link up, */
@@ -1218,12 +1218,12 @@
 		if (pAd->CommonCfg.PhyMode >=3D PHY_11ABGN_MIXED)
 			AdhocTurnOnQos(pAd);
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!!Adhoc LINK UP !!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("Adhoc LINK UP!\n"));
 	} else {
 		OPSTATUS_SET_FLAG(pAd, fOP_STATUS_INFRA_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_ADHOC_ON);
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!!Infra LINK UP !!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("Infra LINK UP!\n"));
 	}
=20
 	/* 3*3 */
@@ -1262,11 +1262,11 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("rt2860C !\n"));
 		}
=20
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!!40MHz Lower LINK UP !!! Control Channel at Below. Central =3D %d =
\n",
+			 ("40MHz Lower LINK UP! Control Channel at Below. Central =3D %d \n",
 			  pAd->CommonCfg.CentralChannel));
 	} else if ((pAd->CommonCfg.CentralChannel < pAd->CommonCfg.Channel)
 		   && (pAd->MlmeAux.HtCapability.HtCapInfo.ChannelWidth =3D=3D
@@ -1296,11 +1296,11 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("rt2860C !\n"));
 		}
=20
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! 40MHz Upper LINK UP !!! Control Channel at UpperCentral =3D %d \=
n",
+			 ("40MHz Upper LINK UP! Control Channel at UpperCentral =3D %d \n",
 			  pAd->CommonCfg.CentralChannel));
 	} else {
 		pAd->CommonCfg.BBPCurrentBW =3D BW_20;
@@ -1327,10 +1327,10 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x16);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x08);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x11);
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("rt2860C !\n"));
 		}
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! 20MHz LINK UP !!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("20MHz LINK UP!\n"));
 	}
=20
 	RTMPSetAGCInitValue(pAd, pAd->CommonCfg.BBPCurrentBW);
@@ -1342,12 +1342,12 @@
 				    &pAd->BbpTuning.R66CurrentValue);
=20
 	DBGPRINT(RT_DEBUG_TRACE,
-		 ("!!! LINK UP !!! (BssType=3D%d, AID=3D%d, ssid=3D%s, Channel=3D%d, Cen=
tralChannel =3D %d)\n",
+		 ("LINK UP! (BssType=3D%d, AID=3D%d, ssid=3D%s, Channel=3D%d, CentralCha=
nnel =3D %d)\n",
 		  BssType, pAd->StaActive.Aid, pAd->CommonCfg.Ssid,
 		  pAd->CommonCfg.Channel, pAd->CommonCfg.CentralChannel));
=20
 	DBGPRINT(RT_DEBUG_TRACE,
-		 ("!!! LINK UP !!! (Density =3D%d, )\n",
+		 ("LINK UP! (Density =3D%d, )\n",
 		  pAd->MacTab.Content[BSSID_WCID].MpduDensity));
=20
 	AsicSetBssid(pAd, pAd->CommonCfg.Bssid);
@@ -1634,13 +1634,13 @@
 		NdisReleaseSpinLock(&pAd->MacTabLock);
=20
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! LINK UP !!!  ClientStatusFlags=3D%lx)\n",
+			 ("LINK UP!  ClientStatusFlags=3D%lx)\n",
 			  pAd->MacTab.Content[BSSID_WCID].ClientStatusFlags));
=20
 		MlmeUpdateTxRates(pAd, TRUE, BSS0);
 		MlmeUpdateHtTxRates(pAd, BSS0);
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! LINK UP !! (StaActive.bHtEnable =3D%d, )\n",
+			 ("LINK UP! (StaActive.bHtEnable =3D%d, )\n",
 			  pAd->StaActive.SupportedPhyInfo.bHtEnable));
=20
 		if (pAd->CommonCfg.bAggregationCapable) {
@@ -1811,7 +1811,7 @@
 	pAd->CommonCfg.IOTestParm.bLastAtheros =3D FALSE;
 	COPY_MAC_ADDR(pAd->CommonCfg.LastBssid, pAd->CommonCfg.Bssid);
 	DBGPRINT(RT_DEBUG_TRACE,
-		 ("!!!pAd->bNextDisableRxBA=3D %d \n",
+		 ("pAd->bNextDisableRxBA=3D %d \n",
 		  pAd->CommonCfg.IOTestParm.bNextDisableRxBA));
 	/* BSSID add in one MAC entry too.  Because in Tx, ASIC need to check Cip=
her and IV/EIV, BAbitmap */
 	/* Pther information in MACTab.Content[BSSID_WCID] is not necessary for d=
river. */
@@ -1893,7 +1893,7 @@
 				      BSS0, 0);
 	}
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN !!!\n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN!\n"));
 	OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_AGGREGATION_INUSED);
=20
 #ifdef RTMP_MAC_PCI
@@ -1921,7 +1921,7 @@
=20
 	if (ADHOC_ON(pAd))	/* Adhoc mode link down */
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN 1!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN 1!\n"));
=20
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_ADHOC_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED);
@@ -1931,10 +1931,10 @@
 		BssTableDeleteEntry(&pAd->ScanTab, pAd->CommonCfg.Bssid,
 				    pAd->CommonCfg.Channel);
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! MacTab.Size=3D%d !!!\n", pAd->MacTab.Size));
+			 (" MacTab.Size=3D%d !\n", pAd->MacTab.Size));
 	} else			/* Infra structure mode */
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN 2!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN 2!\n"));
=20
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_INFRA_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED);
diff -ru a/drivers/staging/rt2860/sta/rtmp_data.c b/drivers/staging/rt2860/=
sta/rtmp_data.c
--- a/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-06 08:03:10.000000000 =
+0100
+++ b/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-07 15:39:07.612516153 =
+0100
@@ -192,7 +192,7 @@
 						  pRxWI->RSSI1, pRxWI->RSSI2,
 						  pRxD->PlcpSignal);
 			DBGPRINT_RAW(RT_DEBUG_TRACE,
-				     ("!!! report EAPOL/AIRONET DATA to MLME (len=3D%d) !!!\n",
+				     ("report EAPOL/AIRONET DATA to MLME (len=3D%d) !\n",
 				      pRxBlk->DataSize));
 		}
 	}
@@ -940,7 +940,7 @@
=20
 	if (pSrcBufVA =3D=3D NULL) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("STASendPacket --> pSrcBufVA =3D=3D NULL !!!SrcBufLen=3D%x\n",
+			 ("STASendPacket --> pSrcBufVA =3D=3D NULL !SrcBufLen=3D%x\n",
 			  SrcBufLen));
 		/* Resourece is low, system did not allocate virtual address */
 		/* return NDIS_STATUS_FAILURE directly to upper layer */
@@ -950,7 +950,7 @@
=20
 	if (SrcBufLen < 14) {
 		DBGPRINT(RT_DEBUG_ERROR,
-			 ("STASendPacket --> Ndis Packet buffer error !!!\n"));
+			 ("STASendPacket --> Ndis Packet buffer error!\n"));
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
 		return (NDIS_STATUS_FAILURE);
 	}
@@ -1007,7 +1007,7 @@
 	    && (RTMP_GET_PACKET_EAPOL(pPacket) =3D=3D FALSE)
 	    ) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("STASendPacket --> Drop packet before port secured !!!\n"));
+			 ("STASendPacket --> Drop packet before port secured!\n"));
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
=20
 		return (NDIS_STATUS_FAILURE);
@@ -1680,7 +1680,7 @@
=20
 		pMacEntry =3D pTxBlk->pMacEntry;
 		if (pMacEntry->isCached) {
-			/* NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]!!!! */
+			/* NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]! */
 			NdisMoveMemory((u8 *)& pTxBlk->
 				       HeaderBuf[TXINFO_SIZE],
 				       (u8 *)& pMacEntry->CachedBuf[0],
@@ -2506,7 +2506,7 @@
 		{
 			/* It should not happened! */
 			DBGPRINT(RT_DEBUG_ERROR,
-				 ("Send a pacekt was not classified!! It should not happen!\n"));
+				 ("Send a packet was not classified! It should not happen!\n"));
 			while (pTxBlk->TxPacketList.Number) {
 				pQEntry =3D
 				    RemoveHeadQueue(&pTxBlk->TxPacketList);
diff -ru a/drivers/staging/rt2860/sta/sanity.c b/drivers/staging/rt2860/sta=
/sanity.c
--- a/drivers/staging/rt2860/sta/sanity.c	2009-11-06 08:03:10.000000000 +01=
00
+++ b/drivers/staging/rt2860/sta/sanity.c	2009-11-07 15:39:07.615849820 +01=
00
@@ -150,7 +150,7 @@
=20
 		case IE_HT_CAP:
 		case IE_HT_CAP2:
-			if (pEid->Len >=3D SIZE_HT_CAP_IE)	/*Note: allow extension.!! */
+			if (pEid->Len >=3D SIZE_HT_CAP_IE)	/*Note: allow extension! */
 			{
 				NdisMoveMemory(pHtCapability, pEid->Octet,
 					       SIZE_HT_CAP_IE);
diff -ru a/drivers/staging/rt2860/sta_ioctl.c b/drivers/staging/rt2860/sta_=
ioctl.c
--- a/drivers/staging/rt2860/sta_ioctl.c	2009-11-06 08:03:10.000000000 +0100
+++ b/drivers/staging/rt2860/sta_ioctl.c	2009-11-07 15:39:07.585849339 +0100
@@ -600,7 +600,7 @@
 	if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE) {
 		RTMP_MLME_RESET_STATE_MACHINE(pAdapter);
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! MLME busy, reset MLME state machine !!!\n"));
+			 ("MLME busy, reset MLME state machine!\n"));
 	}
 	/* tell CNTL state machine to call NdisMSetInformationComplete() after co=
mpleting */
 	/* this request, because this request is initiated by NDIS. */
@@ -741,7 +741,7 @@
=20
 	if (MONITOR_ON(pAdapter)) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("!!! Driver is in Monitor Mode now !!!\n"));
+			 ("Driver is in Monitor Mode now!\n"));
 		return -EINVAL;
 	}
=20
@@ -758,7 +758,7 @@
 		if ((pAdapter->StaCfg.WpaSupplicantUP =3D=3D WPA_SUPPLICANT_ENABLE)
 		    && (pAdapter->StaCfg.WpaSupplicantScanCount > 3)) {
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("!!! WpaSupplicantScanCount > 3\n"));
+				 ("WpaSupplicantScanCount > 3\n"));
 			Status =3D NDIS_STATUS_SUCCESS;
 			break;
 		}
@@ -771,7 +771,7 @@
 		    && (pAdapter->StaCfg.PortSecured =3D=3D
 			WPA_802_1X_PORT_NOT_SECURED)) {
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("!!! Link UP, Port Not Secured! ignore this set::OID_802_11_BSSID_LI=
ST_SCAN\n"));
+				 ("Link UP, Port Not Secured! ignore this set::OID_802_11_BSSID_LIST_S=
CAN\n"));
 			Status =3D NDIS_STATUS_SUCCESS;
 			break;
 		}
@@ -779,7 +779,7 @@
 		if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE) {
 			RTMP_MLME_RESET_STATE_MACHINE(pAdapter);
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("!!! MLME busy, reset MLME state machine !!!\n"));
+				 ("MLME busy, reset MLME state machine!\n"));
 		}
 		/* tell CNTL state machine to call NdisMSetInformationComplete() after c=
ompleting */
 		/* this request, because this request is initiated by NDIS. */
@@ -2256,7 +2256,7 @@
 		break;
 	default:
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			 ("rt_ioctl_siwpmksa - Unknown Command!\n"));
 		break;
 	}
=20
@@ -2664,7 +2664,7 @@
 		if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE) {
 			RTMP_MLME_RESET_STATE_MACHINE(pAdapter);
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("!!! MLME busy, reset MLME state machine !!!\n"));
+				 ("MLME busy, reset MLME state machine!\n"));
 		}
=20
 		if ((pAdapter->StaCfg.WpaPassPhraseLen >=3D 8) &&
diff -ru a/drivers/staging/rt2860/usb_main_dev.c b/drivers/staging/rt2860/u=
sb_main_dev.c
--- a/drivers/staging/rt2860/usb_main_dev.c	2009-11-06 08:03:10.000000000 +=
0100
+++ b/drivers/staging/rt2860/usb_main_dev.c	2009-11-07 15:39:07.652515955 +=
0100
@@ -584,7 +584,7 @@
 	RTMP_IO_READ32(pAd, TXRXQ_PCNT, &MACValue);
 	if ((MACValue & 0xff) !=3D 0) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("TX QUEUE 0 Not EMPTY(Value=3D0x%0x). !!!!!!!!!!!!!!!\n",
+			 ("TX QUEUE 0 Not EMPTY(Value=3D0x%0x)!\n",
 			  MACValue));
 		RTMP_IO_WRITE32(pAd, PBF_CFG, 0xf40012);
 		while ((MACValue & 0xff) !=3D 0 && (idx++ < 10)) {
@@ -707,7 +707,7 @@
 					}
 				} else {
 					DBGPRINT(RT_DEBUG_ERROR,
-						 ("Unkonw bulkOut URB maybe hanged!!!!!!!!!!!!\n"));
+						 ("Unknown bulkOut URB maybe hanged!\n"));
 				}
 			} else {
 				RTMP_IRQ_UNLOCK(&pAd->BulkOutLock[idx],


--Dxnq1zWXvFF0Q93v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr1oNAACgkQQfdJUNXnsjryDACgi7EFWJzOE8iVrz4oi3MS4oFH
nVkAoKvDwbiNo6Iz6d7gNG7Wk2s6Iwxs
=1P1x
-----END PGP SIGNATURE-----

--Dxnq1zWXvFF0Q93v--
