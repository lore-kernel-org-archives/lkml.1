Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZKEGka@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZKEGka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 01:40:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754953AbZKEGk3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 01:40:29 -0500
Received: from sedf.de ([212.83.34.151]:37874 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944AbZKEGk1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 01:40:27 -0500
X-Greylist: delayed 2007 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Nov 2009 01:40:27 EST
Date: Thu, 5 Nov 2009 07:07:56 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/3] staging: rt2860: remove superfluous exclamation marks
Message-ID: <20091105060756.GC8664@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lMM8JwqTlfDpEaS6"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lMM8JwqTlfDpEaS6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>
Subject: [Patch 3/3] staging: rt2860: remove superfluous exclamation marks

This patch is based on 2.6.32-rc6 and needs to be applied on top of
[1/3] and [2/3].

This patch removes an estimated bazillion exclamation marks from
DBGPRINT() and printk() strings and also comments. No-one needs a dozen
of exclamation marks in a single debug message, so i condensed each
chain of exclamation marks to a single one. I removed leading
exclamation marks from strings as well.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru c/drivers/staging/rt2860/common/ba_action.c d/drivers/staging/rt28=
60/common/ba_action.c
--- c/drivers/staging/rt2860/common/ba_action.c	2009-11-03 20:37:49.0000000=
00 +0100
+++ d/drivers/staging/rt2860/common/ba_action.c	2009-11-05 01:08:30.7925038=
61 +0100
@@ -1584,7 +1584,7 @@
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_ERROR,  ("!!! (%d) Can't allocate reordering mpdu blk\=
n",
+		DBGPRINT(RT_DEBUG_ERROR,  ("(%d) Can't allocate reordering mpdu blk\n",
 								   pBAEntry->list.qlen));
=20
 		/*
@@ -1652,7 +1652,7 @@
 	}
 	else
 	{
-		// impossible !!!
+		// impossible !
 		ASSERT(0);
 		// release packet
 		RELEASE_NDIS_PACKET(pAd, pRxBlk->pRxPacket, NDIS_STATUS_FAILURE);
diff -ru c/drivers/staging/rt2860/common/cmm_data_2860.c d/drivers/staging/=
rt2860/common/cmm_data_2860.c
--- c/drivers/staging/rt2860/common/cmm_data_2860.c	2009-11-03 20:37:49.000=
000000 +0100
+++ d/drivers/staging/rt2860/common/cmm_data_2860.c	2009-11-05 01:08:30.805=
836012 +0100
@@ -847,7 +847,7 @@
 		AutoWakeupCfg.word =3D 0;
 		RTMP_IO_WRITE32(pAd, AUTO_WAKEUP_CFG, AutoWakeupCfg.word);
=20
-		// If this is called from Halt. ALWAYS force wakeup!!!
+		// If this is called from Halt. ALWAYS force wakeup!
 		if (Level =3D=3D RTMP_HALT)
 		{
 			RT28xxPciAsicRadioOn(pAd, RTMP_HALT);
diff -ru c/drivers/staging/rt2860/common/cmm_data.c d/drivers/staging/rt286=
0/common/cmm_data.c
--- c/drivers/staging/rt2860/common/cmm_data.c	2009-11-03 20:37:49.00000000=
0 +0100
+++ d/drivers/staging/rt2860/common/cmm_data.c	2009-11-05 01:08:30.85583626=
0 +0100
@@ -423,7 +423,7 @@
 		&& (pAd->CommonCfg.bIEEE80211H =3D=3D 1)
 		&& (pAd->CommonCfg.RadarDetect.RDMode !=3D RD_NORMAL_MODE))
 	{
-		DBGPRINT(RT_DEBUG_ERROR,("MlmeHardTransmit --> radar detect not in norma=
l mode !!!\n"));
+		DBGPRINT(RT_DEBUG_ERROR,("MlmeHardTransmit --> radar detect not in norma=
l mode !\n"));
 		return (NDIS_STATUS_FAILURE);
 	}
=20
@@ -605,7 +605,7 @@
 		&& (pAd->CommonCfg.bIEEE80211H =3D=3D 1)
 		&& (pAd->CommonCfg.RadarDetect.RDMode !=3D RD_NORMAL_MODE))
 	{
-		DBGPRINT(RT_DEBUG_ERROR,("MlmeHardTransmit --> radar detect not in norma=
l mode !!!\n"));
+		DBGPRINT(RT_DEBUG_ERROR,("MlmeHardTransmit --> radar detect not in norma=
l mode !\n"));
 		RTMP_SEM_UNLOCK(&pAd->MgmtRingLock);
 		return (NDIS_STATUS_FAILURE);
 	}
@@ -1194,7 +1194,7 @@
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
@@ -2305,7 +2305,7 @@
 				pProbeEntry =3D pProbeEntry->pNext;
 			} while (pProbeEntry);
=20
-			// not found !!!
+			// not found !
 			ASSERT(pProbeEntry !=3D NULL);
=20
 			RT28XX_STA_ENTRY_KEY_DEL(pAd, BSS0, wcid);
@@ -2324,7 +2324,7 @@
 		}
 		else
 		{
-			printk("\n%s: Impossible Wcid =3D %d !!!!!\n", __func__, wcid);
+			printk("\n%s: Impossible Wcid =3D %d !\n", __func__, wcid);
 		}
 	}
=20
diff -ru c/drivers/staging/rt2860/common/cmm_sanity.c d/drivers/staging/rt2=
860/common/cmm_sanity.c
--- c/drivers/staging/rt2860/common/cmm_sanity.c	2009-11-03 20:37:49.000000=
000 +0100
+++ d/drivers/staging/rt2860/common/cmm_sanity.c	2009-11-05 01:08:30.902502=
560 +0100
@@ -295,7 +295,7 @@
=20
 	// For some 11a AP which didn't have DS_IE, we use two conditions to deci=
de the channel
 	//	1. If the AP is 11n enabled, then check the control channel.
-	//	2. If the AP didn't have any info about channel, use the channel we re=
ceived this frame as the channel. (May inaccuracy!!)
+	//	2. If the AP didn't have any info about channel, use the channel we re=
ceived this frame as the channel. (May inaccuracy!)
 	UCHAR			CtrlChannel =3D 0;
=20
     // Add for 3 necessary EID field check
@@ -414,7 +414,7 @@
                 break;
=20
             case IE_HT_CAP:
-			if (pEid->Len >=3D SIZE_HT_CAP_IE)  //Note: allow extension.!!
+			if (pEid->Len >=3D SIZE_HT_CAP_IE)  //Note: allow extension.!
 			{
 				NdisMoveMemory(pHtCapability, pEid->Octet, sizeof(HT_CAPABILITY_IE));
 				*pHtCapabilityLen =3D SIZE_HT_CAP_IE;	// Nnow we only support 26 bytes.
diff -ru c/drivers/staging/rt2860/common/cmm_wpa.c d/drivers/staging/rt2860=
/common/cmm_wpa.c
--- c/drivers/staging/rt2860/common/cmm_wpa.c	2009-11-03 20:37:49.000000000=
 +0100
+++ d/drivers/staging/rt2860/common/cmm_wpa.c	2009-11-05 01:08:30.922502603=
 +0100
@@ -103,7 +103,7 @@
=20
     if (input =3D=3D NULL)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("!!!PRF: no memory!!!\n"));
+        DBGPRINT(RT_DEBUG_ERROR, ("PRF: no memory!\n"));
         return;
     }
=20
@@ -797,7 +797,7 @@
=20
 	if (R =3D=3D NULL)
     {
-        DBGPRINT(RT_DEBUG_ERROR, ("!!!AES_GTK_KEY_UNWRAP: no memory!!!\n")=
);
+        DBGPRINT(RT_DEBUG_ERROR, ("AES_GTK_KEY_UNWRAP: no memory!\n"));
         return;
     } /* End of if */
=20
diff -ru c/drivers/staging/rt2860/common/eeprom.c d/drivers/staging/rt2860/=
common/eeprom.c
--- c/drivers/staging/rt2860/common/eeprom.c	2009-11-03 20:37:49.000000000 =
+0100
+++ d/drivers/staging/rt2860/common/eeprom.c	2009-11-05 01:08:30.945835752 =
+0100
@@ -692,7 +692,7 @@
=20
 	if(BlkNum =3D=3D 0xffff)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space=
!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space=
!\n"));
 		return FALSE;
 	}
=20
@@ -814,7 +814,7 @@
 			DBGPRINT(RT_DEBUG_TRACE, ("Not bWriteSuccess new BlkNum =3D %d\n", BlkN=
um));
 			if(BlkNum =3D=3D 0xffff)
 			{
-				DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse spa=
ce!!!\n"));
+				DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse spa=
ce!\n"));
 				return FALSE;
 			}
=20
@@ -1093,7 +1093,7 @@
 			}
 			else
 			{
-						DBGPRINT(RT_DEBUG_ERROR, ("--> Error!! System doest not support read=
 function\n"));
+						DBGPRINT(RT_DEBUG_ERROR, ("--> Error! System doest not support read =
function\n"));
 						kfree(PDATA);
 						kfree(buffer);
 						kfree(src);
@@ -1231,7 +1231,7 @@
=20
 	if(BlkNum =3D=3D 0xffff)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space=
!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegisters: out of free E-fuse space=
!\n"));
 		return FALSE;
 	}
 	//Step 1.1.0
@@ -1429,7 +1429,7 @@
 			DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegistersFromBin::Not bWriteSucces=
s new BlkNum =3D %d\n", BlkNum));
 			if(BlkNum =3D=3D 0xffff)
 			{
-				DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegistersFromBin: out of free E-f=
use space!!!\n"));
+				DBGPRINT(RT_DEBUG_TRACE, ("eFuseWriteRegistersFromBin: out of free E-f=
use space!\n"));
 				return FALSE;
 			}
=20
diff -ru c/drivers/staging/rt2860/common/mlme.c d/drivers/staging/rt2860/co=
mmon/mlme.c
--- c/drivers/staging/rt2860/common/mlme.c	2009-11-03 20:37:49.000000000 +0=
100
+++ d/drivers/staging/rt2860/common/mlme.c	2009-11-05 01:08:31.065836024 +0=
100
@@ -570,7 +570,7 @@
 #ifdef RT2870
 			if (Elem->MsgType =3D=3D MT2_RESET_CONF)
 			{
-				DBGPRINT_RAW(RT_DEBUG_TRACE, ("!!! reset MLME state machine !!!\n"));
+				DBGPRINT_RAW(RT_DEBUG_TRACE, ("reset MLME state machine !\n"));
 				MlmeRestartStateMachine(pAd);
 				Elem->Occupied =3D FALSE;
 				Elem->MsgLen =3D 0;
@@ -863,7 +863,7 @@
 		{
 			if ((pAd->StaCfg.bRadio =3D=3D TRUE) && (pAd->SameRxByteCount < 700))
 			{
-				DBGPRINT(RT_DEBUG_TRACE, ("--->  SameRxByteCount =3D %lu !!!!!!!!!!!!!=
!! \n", pAd->SameRxByteCount));
+				DBGPRINT(RT_DEBUG_TRACE, ("--->  SameRxByteCount =3D %lu ! \n", pAd->S=
ameRxByteCount));
 				pAd->SameRxByteCount =3D 700;
 				AsicResetBBP(pAd);
 			}
@@ -3950,7 +3950,7 @@
=20
 			// Since the AP is using hidden SSID, and we are trying to connect to A=
NY
 			// It definitely will fail. So, skip it.
-			// CCX also require not even try to connect it!!
+			// CCX also require not even try to connect it!
 			if (SsidLen =3D=3D 0)
 				continue;
=20
@@ -4510,8 +4510,8 @@
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
@@ -8571,7 +8571,7 @@
 	UINT32		Data;
 	BOOLEAN		bCtrl =3D FALSE;
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("--->  AsicResetFromDMABusy  !!!!!!!!!!!!!!!!!!=
!!!!! \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("--->  AsicResetFromDMABusy  ! \n"));
=20
 	// Be sure restore link control value so we can write register.
 	RTMP_CLEAR_PSFLAG(pAd, fRTMP_PS_CAN_GO_SLEEP);
@@ -8609,13 +8609,13 @@
=20
 	RTMP_SET_PSFLAG(pAd, fRTMP_PS_CAN_GO_SLEEP);
 	RTMP_CLEAR_FLAG(pAd, fRTMP_ADAPTER_NIC_NOT_EXIST | fRTMP_ADAPTER_HALT_IN_=
PROGRESS);
-	DBGPRINT(RT_DEBUG_TRACE, ("<---  AsicResetFromDMABusy !!!!!!!!!!!!!!!!!!!=
!!!!  \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("<---  AsicResetFromDMABusy !  \n"));
 }
=20
 VOID AsicResetBBP(
 	IN PRTMP_ADAPTER pAd)
 {
-	DBGPRINT(RT_DEBUG_TRACE, ("--->  Asic HardReset BBP  !!!!!!!!!!!!!!!!!!!!=
!!! \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("--->  Asic HardReset BBP  ! \n"));
=20
 	RTMP_IO_WRITE32(pAd, MAC_SYS_CTRL, 0x0);
 	RTMP_IO_WRITE32(pAd, MAC_SYS_CTRL, 0x2);
@@ -8623,7 +8623,7 @@
=20
 	// After hard-reset BBP, initialize all BBP values.
 	NICRestoreBBPValue(pAd);
-	DBGPRINT(RT_DEBUG_TRACE, ("<---  Asic HardReset BBP !!!!!!!!!!!!!!!!!!!!!=
!!  \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("<---  Asic HardReset BBP !  \n"));
 }
=20
 VOID AsicResetMAC(
@@ -8631,14 +8631,14 @@
 {
 	ULONG		Data;
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("--->  AsicResetMAC   !!!! \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("--->  AsicResetMAC   ! \n"));
 	RTMP_IO_READ32(pAd, PBF_SYS_CTRL, &Data);
 	Data |=3D 0x4;
 	RTMP_IO_WRITE32(pAd, PBF_SYS_CTRL, Data);
 	Data &=3D 0xfffffffb;
 	RTMP_IO_WRITE32(pAd, PBF_SYS_CTRL, Data);
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("<---  AsicResetMAC   !!!! \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("<---  AsicResetMAC   ! \n"));
 }
=20
 VOID AsicResetPBF(
@@ -8654,14 +8654,14 @@
 	// sum should be equals to 0xff, which is the total buffer size.
 	if ((Value1 + Value2) < 0xff)
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("--->  Asic HardReset PBF !!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("--->  Asic HardReset PBF ! \n"));
 		RTMP_IO_READ32(pAd, PBF_SYS_CTRL, &Data);
 		Data |=3D 0x8;
 		RTMP_IO_WRITE32(pAd, PBF_SYS_CTRL, Data);
 		Data &=3D 0xfffffff7;
 		RTMP_IO_WRITE32(pAd, PBF_SYS_CTRL, Data);
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("<---  Asic HardReset PBF !!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("<---  Asic HardReset PBF ! \n"));
 	}
 }
 #endif /* RT2860 */
diff -ru c/drivers/staging/rt2860/common/rtmp_init.c d/drivers/staging/rt28=
60/common/rtmp_init.c
--- c/drivers/staging/rt2860/common/rtmp_init.c	2009-11-05 00:47:16.2217985=
63 +0100
+++ d/drivers/staging/rt2860/common/rtmp_init.c	2009-11-05 01:08:31.1225024=
91 +0100
@@ -120,7 +120,7 @@
 	{BCN_OFFSET0,			0xece8e4e0}, /* 0x3800, 0x3A00, 0x3C00, 0x3E00, 512B for =
each beacon */
 	{BCN_OFFSET1,			0xfcf8f4f0}, /* 0x3800, 0x3A00, 0x3C00, 0x3E00, 512B for =
each beacon */
 #else
-    #error You must re-calculate new value for BCN_OFFSET0 & BCN_OFFSET1 i=
n MACRegTable[]!!!
+    #error You must re-calculate new value for BCN_OFFSET0 & BCN_OFFSET1 i=
n MACRegTable[]!
 #endif // HW_BEACON_OFFSET //
=20
 	{LEGACY_BASIC_RATE,		0x0000013f}, //  Basic rate set bitmap
@@ -2430,7 +2430,7 @@
 	UCHAR		Value =3D 0;
 	ULONG		Data;
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("--->  NICRestoreBBPValue !!!!!!!!!!!!!!!!!!!!!=
!!  \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("--->  NICRestoreBBPValue !  \n"));
 	// Initialize BBP register to default value (rtmp_init.c)
 	for (index =3D 0; index < NUM_BBP_REG_PARMS; index++)
 	{
@@ -2475,10 +2475,10 @@
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-				DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+				DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 			}
=20
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!40MHz Lower LINK UP !!! Control Channel a=
t Below. Central =3D %d \n", pAd->CommonCfg.CentralChannel ));
+			DBGPRINT(RT_DEBUG_TRACE, ("40MHz Lower LINK UP ! Control Channel at Bel=
ow. Central =3D %d \n", pAd->CommonCfg.CentralChannel ));
 		}
 		else if ((pAd->CommonCfg.CentralChannel < pAd->CommonCfg.Channel) && (pA=
d->MlmeAux.HtCapability.HtCapInfo.ChannelWidth =3D=3D BW_40))
 		{
@@ -2507,10 +2507,10 @@
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-				DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+				DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 			}
=20
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!40MHz Upper LINK UP !!! Control Channel a=
t UpperCentral =3D %d \n", pAd->CommonCfg.CentralChannel ));
+			DBGPRINT(RT_DEBUG_TRACE, ("40MHz Upper LINK UP ! Control Channel at Upp=
erCentral =3D %d \n", pAd->CommonCfg.CentralChannel ));
 		}
 		else
 		{
@@ -2537,14 +2537,14 @@
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x16);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x08);
 				RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x11);
-				DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+				DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 			}
=20
-			DBGPRINT(RT_DEBUG_TRACE, ("!!!20MHz LINK UP !!! \n" ));
+			DBGPRINT(RT_DEBUG_TRACE, ("20MHz LINK UP ! \n" ));
 		}
 	}
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("<---  NICRestoreBBPValue !!!!!!!!!!!!!!!!!!!!!=
!!  \n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("<---  NICRestoreBBPValue !  \n"));
 }
 #endif /* RT2860 */
=20
diff -ru c/drivers/staging/rt2860/common/rtmp_wep.c d/drivers/staging/rt286=
0/common/rtmp_wep.c
--- c/drivers/staging/rt2860/common/rtmp_wep.c	2009-11-03 20:37:49.00000000=
0 +0100
+++ d/drivers/staging/rt2860/common/rtmp_wep.c	2009-11-05 01:08:31.14583787=
8 +0100
@@ -247,7 +247,7 @@
=20
     if(crc32 !=3D cpu2le32(trailfcs))
     {
-		DBGPRINT(RT_DEBUG_TRACE, ("! WEP Data CRC Error !\n"));	 //CRC error.
+		DBGPRINT(RT_DEBUG_TRACE, ("WEP Data CRC Error !\n"));	 //CRC error.
 		return (FALSE);
 	}
 	return (TRUE);
diff -ru c/drivers/staging/rt2860/oid.h d/drivers/staging/rt2860/oid.h
--- c/drivers/staging/rt2860/oid.h	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/oid.h	2009-11-05 01:08:31.202502386 +0100
@@ -557,7 +557,7 @@
 #define OID_MH_802_1X_SUPPORTED               0xFFEDC100
 #endif
=20
-// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!!!
+// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!
 typedef union  _HTTRANSMIT_SETTING {
 	struct	{
 	USHORT   	MCS:7;                 // MCS
@@ -614,7 +614,7 @@
     RT_802_11_EVENT_LOG   Log[MAX_NUMBER_OF_EVENT];
 } RT_802_11_EVENT_TABLE, PRT_802_11_EVENT_TABLE;
=20
-// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!!!
+// MIMO Tx parameter, ShortGI, MCS, STBC, etc.  these are fields in TXWI. =
Don't change this definition!
 typedef union  _MACHTTRANSMIT_SETTING {
 	struct	{
 	USHORT   	MCS:7;                 // MCS
diff -ru c/drivers/staging/rt2860/rt28xx.h d/drivers/staging/rt2860/rt28xx.h
--- c/drivers/staging/rt2860/rt28xx.h	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/rt28xx.h	2009-11-05 01:08:31.225835816 +0100
@@ -1588,7 +1588,7 @@
 		USHORT		DynamicTxAgcControl:1;			//
 		USHORT		ExternalLNAForG:1;				//
 		USHORT		ExternalLNAForA:1;			// external LNA enable for 2.4G
-		USHORT		CardbusAcceleration:1;	// !!! NOTE: 0 - enable, 1 - disable
+		USHORT		CardbusAcceleration:1;	// ! NOTE: 0 - enable, 1 - disable
 		USHORT		BW40MSidebandForG:1;
 		USHORT		BW40MSidebandForA:1;
 		USHORT		EnableWPSPBC:1;                 // WPS PBC Control bit
diff -ru c/drivers/staging/rt2860/rt_linux.c d/drivers/staging/rt2860/rt_li=
nux.c
--- c/drivers/staging/rt2860/rt_linux.c	2009-11-05 00:47:16.228496640 +0100
+++ d/drivers/staging/rt2860/rt_linux.c	2009-11-05 01:08:31.239169085 +0100
@@ -73,7 +73,7 @@
 	"connects with our wireless client",                    /* IW_STA_LINKUP_=
EVENT_FLAG */
 	"disconnects with our wireless client",                 /* IW_STA_LINKDOW=
N_EVENT_FLAG */
 	"scan completed"								/* IW_SCAN_COMPLETED_EVENT_FLAG */
-	"scan terminate!! Busy!! Enqueue fail!!"				/* IW_SCAN_ENQUEUE_FAIL_EVENT=
_FLAG */
+	"scan terminate! Busy! Enqueue fail!"				/* IW_SCAN_ENQUEUE_FAIL_EVENT_FL=
AG */
 	};
=20
 // for wireless IDS_spoof_attack event message
diff -ru c/drivers/staging/rt2860/rt_linux.h d/drivers/staging/rt2860/rt_li=
nux.h
--- c/drivers/staging/rt2860/rt_linux.h	2009-11-05 00:47:25.769344075 +0100
+++ d/drivers/staging/rt2860/rt_linux.h	2009-11-05 01:08:31.249169246 +0100
@@ -347,7 +347,7 @@
=20
 #define DBGPRINT_ERR(Fmt)           \
 {                                   \
-    printk("ERROR!!! ");          \
+    printk("ERROR! ");          \
     printk Fmt;                  \
 }
=20
diff -ru c/drivers/staging/rt2860/rt_main_dev.c d/drivers/staging/rt2860/rt=
_main_dev.c
--- c/drivers/staging/rt2860/rt_main_dev.c	2009-11-05 00:47:25.772631654 +0=
100
+++ d/drivers/staging/rt2860/rt_main_dev.c	2009-11-05 01:08:31.262501956 +0=
100
@@ -572,7 +572,7 @@
 	// shall not set ml_priv to NULL here because the ml_priv didn't been fre=
e yet.
 	//net_dev->ml_priv =3D 0;
=20
-	printk("!!! %s Initialized fail !!!\n", RT28xx_CHIP_NAME);
+	printk("%s Initialized fail !\n", RT28xx_CHIP_NAME);
 	return FALSE;
 } /* End of rt28xx_init */
=20
diff -ru c/drivers/staging/rt2860/rtmp_def.h d/drivers/staging/rt2860/rtmp_=
def.h
--- c/drivers/staging/rt2860/rtmp_def.h	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/rtmp_def.h	2009-11-05 01:08:31.282502837 +0100
@@ -418,7 +418,7 @@
 #define MAX_LEN_OF_MAC_TABLE            MAX_NUMBER_OF_MAC // if MAX_MBSSID=
_NUM is 8, this value can't be larger than 211
=20
 #if MAX_LEN_OF_MAC_TABLE>MAX_AVAILABLE_CLIENT_WCID
-#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!!!!
+#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!
 #endif
=20
 #define MAX_NUM_OF_WDS_LINK_PERBSSID	            3
diff -ru c/drivers/staging/rt2860/sta/assoc.c d/drivers/staging/rt2860/sta/=
assoc.c
--- c/drivers/staging/rt2860/sta/assoc.c	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/sta/assoc.c	2009-11-05 01:08:31.412502408 +0100
@@ -569,7 +569,7 @@
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_TRACE,("ASSOC - MlmeAssocReqAction() sanity check fail=
ed. BUG!!!!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE,("ASSOC - MlmeAssocReqAction() sanity check fail=
ed. BUG! \n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_ASSOC_CONF, 2, &Status);
@@ -771,7 +771,7 @@
 	}
 	else
 	{
-		DBGPRINT(RT_DEBUG_TRACE,("ASSOC - MlmeReassocReqAction() sanity check fa=
iled. BUG!!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE,("ASSOC - MlmeReassocReqAction() sanity check fa=
iled. BUG! \n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_REASSOC_CONF, 2, &Status);
diff -ru c/drivers/staging/rt2860/sta/connect.c d/drivers/staging/rt2860/st=
a/connect.c
--- c/drivers/staging/rt2860/sta/connect.c	2009-11-03 20:37:49.000000000 +0=
100
+++ d/drivers/staging/rt2860/sta/connect.c	2009-11-05 01:08:31.449169381 +0=
100
@@ -221,7 +221,7 @@
 			break;
 #endif // RT2870 //
 		default:
-			DBGPRINT_ERR(("!ERROR! CNTL - Illegal message type(=3D%ld)", Elem->MsgT=
ype));
+			DBGPRINT_ERR(("ERROR! CNTL - Illegal message type(=3D%ld)", Elem->MsgTy=
pe));
 			break;
 	}
 }
@@ -861,7 +861,7 @@
 		}
 		else
 		{
-			DBGPRINT(RT_DEBUG_TRACE, ("CNTL - Start IBSS fail. BUG!!!!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("CNTL - Start IBSS fail. BUG!\n"));
 			pAd->Mlme.CntlMachine.CurrState =3D CNTL_IDLE;
 		}
 	}
@@ -1128,7 +1128,7 @@
 	//
 	// ASSOC - DisassocTimeoutAction
 	// CNTL - Dis-associate successful
-	// !!! LINK DOWN !!!
+	// ! LINK DOWN !
 	// [88888] OID_802_11_SSID should have returned NDTEST_WEP_AP2(Returned: )
 	//
 	// To prevent DisassocTimeoutAction to call Link down after we link up,
@@ -1187,14 +1187,14 @@
 			AdhocTurnOnQos(pAd);
 #endif
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!!Adhoc LINK UP !!! \n" ));
+		DBGPRINT(RT_DEBUG_TRACE, ("Adhoc LINK UP ! \n" ));
 	}
 	else
 	{
 		OPSTATUS_SET_FLAG(pAd, fOP_STATUS_INFRA_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_ADHOC_ON);
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!!Infra LINK UP !!! \n" ));
+		DBGPRINT(RT_DEBUG_TRACE, ("Infra LINK UP ! \n" ));
 	}
=20
 	// 3*3
@@ -1234,10 +1234,10 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-            DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+            DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 		}
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!!40MHz Lower LINK UP !!! Control Channel at=
 Below. Central =3D %d \n", pAd->CommonCfg.CentralChannel ));
+		DBGPRINT(RT_DEBUG_TRACE, ("40MHz Lower LINK UP ! Control Channel at Belo=
w. Central =3D %d \n", pAd->CommonCfg.CentralChannel ));
 	}
 	else if ((pAd->CommonCfg.CentralChannel < pAd->CommonCfg.Channel) && (pAd=
->MlmeAux.HtCapability.HtCapInfo.ChannelWidth =3D=3D BW_40))
     {
@@ -1267,10 +1267,10 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x1A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x0A);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x16);
-			    DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+			    DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 		}
=20
-	    DBGPRINT(RT_DEBUG_TRACE, ("!!! 40MHz Upper LINK UP !!! Control Channe=
l at UpperCentral =3D %d \n", pAd->CommonCfg.CentralChannel ));
+	    DBGPRINT(RT_DEBUG_TRACE, ("40MHz Upper LINK UP ! Control Channel at U=
pperCentral =3D %d \n", pAd->CommonCfg.CentralChannel ));
     }
     else
     {
@@ -1299,10 +1299,10 @@
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R69, 0x16);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R70, 0x08);
 			RTMP_BBP_IO_WRITE8_BY_REG_ID(pAd, BBP_R73, 0x11);
-            DBGPRINT(RT_DEBUG_TRACE, ("!!!rt2860C !!! \n" ));
+            DBGPRINT(RT_DEBUG_TRACE, ("rt2860C ! \n" ));
 		}
=20
-	    DBGPRINT(RT_DEBUG_TRACE, ("!!! 20MHz LINK UP !!! \n" ));
+	    DBGPRINT(RT_DEBUG_TRACE, ("20MHz LINK UP ! \n" ));
     }
=20
 	RTMPSetAGCInitValue(pAd, pAd->CommonCfg.BBPCurrentBW);
@@ -1311,10 +1311,10 @@
 	//
 	RTMP_BBP_IO_READ8_BY_REG_ID(pAd, BBP_R66, &pAd->BbpTuning.R66CurrentValue=
);
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK UP !!! (BssType=3D%d, AID=3D%d, ssid=
=3D%s, Channel=3D%d, CentralChannel =3D %d)\n",
+	DBGPRINT(RT_DEBUG_TRACE, ("LINK UP ! (BssType=3D%d, AID=3D%d, ssid=3D%s, =
Channel=3D%d, CentralChannel =3D %d)\n",
 		BssType, pAd->StaActive.Aid, pAd->CommonCfg.Ssid, pAd->CommonCfg.Channel=
, pAd->CommonCfg.CentralChannel));
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK UP !!! (Density =3D%d, )\n", pAd->Mac=
Tab.Content[BSSID_WCID].MpduDensity));
+	DBGPRINT(RT_DEBUG_TRACE, ("LINK UP ! (Density =3D%d, )\n", pAd->MacTab.Co=
ntent[BSSID_WCID].MpduDensity));
=20
 		AsicSetBssid(pAd, pAd->CommonCfg.Bssid);
=20
@@ -1587,12 +1587,12 @@
 		pAd->MacTab.Content[BSSID_WCID].WepStatus =3D pAd->StaCfg.WepStatus;
         NdisReleaseSpinLock(&pAd->MacTabLock);
=20
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK UP !!!  ClientStatusFlags=3D%lx)\n",
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK UP !  ClientStatusFlags=3D%lx)\n",
 			pAd->MacTab.Content[BSSID_WCID].ClientStatusFlags));
=20
 		MlmeUpdateTxRates(pAd, TRUE, BSS0);
 		MlmeUpdateHtTxRates(pAd, BSS0);
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK UP !! (StaActive.bHtEnable =3D%d, )\=
n", pAd->StaActive.SupportedPhyInfo.bHtEnable));
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK UP ! (StaActive.bHtEnable =3D%d, )\n", p=
Ad->StaActive.SupportedPhyInfo.bHtEnable));
=20
 		if (pAd->CommonCfg.bAggregationCapable)
 		{
@@ -1763,7 +1763,7 @@
=20
 	pAd->CommonCfg.IOTestParm.bLastAtheros =3D FALSE;
 	COPY_MAC_ADDR(pAd->CommonCfg.LastBssid, pAd->CommonCfg.Bssid);
-	DBGPRINT(RT_DEBUG_TRACE, ("!!!pAd->bNextDisableRxBA=3D %d \n", pAd->Commo=
nCfg.IOTestParm.bNextDisableRxBA));
+	DBGPRINT(RT_DEBUG_TRACE, ("pAd->bNextDisableRxBA=3D %d \n", pAd->CommonCf=
g.IOTestParm.bNextDisableRxBA));
 	// BSSID add in one MAC entry too.  Because in Tx, ASIC need to check Cip=
her and IV/EIV, BAbitmap
 	// Pther information in MACTab.Content[BSSID_WCID] is not necessary for d=
river.
 	// Note: As STA, The MACTab.Content[BSSID_WCID]. PairwiseKey and Shared K=
ey for BSS0 are the same.
@@ -1848,7 +1848,7 @@
 		RTMPSendWirelessEvent(pAd, IW_STA_LINKDOWN_EVENT_FLAG, pAd->MacTab.Conte=
nt[BSSID_WCID].Addr, BSS0, 0);
 	}
=20
-	DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN !!!\n"));
+	DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN !\n"));
 	OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_AGGREGATION_INUSED);
=20
 #ifdef RT2860
@@ -1871,7 +1871,7 @@
 #endif
 	if (ADHOC_ON(pAd))		// Adhoc mode link down
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN 1!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN 1!\n"));
=20
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_ADHOC_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED);
@@ -1879,11 +1879,11 @@
 		RTMP_IndicateMediaState(pAd);
         pAd->ExtraInfo =3D GENERAL_LINK_DOWN;
 		BssTableDeleteEntry(&pAd->ScanTab, pAd->CommonCfg.Bssid, pAd->CommonCfg.=
Channel);
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! MacTab.Size=3D%d !!!\n", pAd->MacTab.Size=
));
+		DBGPRINT(RT_DEBUG_TRACE, ("MacTab.Size=3D%d !\n", pAd->MacTab.Size));
 	}
 	else					// Infra structure mode
 	{
-		DBGPRINT(RT_DEBUG_TRACE, ("!!! LINK DOWN 2!!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("LINK DOWN 2!\n"));
=20
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_INFRA_ON);
 		OPSTATUS_CLEAR_FLAG(pAd, fOP_STATUS_MEDIA_STATE_CONNECTED);
diff -ru c/drivers/staging/rt2860/sta/rtmp_data.c d/drivers/staging/rt2860/=
sta/rtmp_data.c
--- c/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-03 20:37:49.000000000 =
+0100
+++ d/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-05 01:08:31.535835494 =
+0100
@@ -137,7 +137,7 @@
 			pTmpBuf =3D pRxBlk->pData - LENGTH_802_11;
 			NdisMoveMemory(pTmpBuf, pRxBlk->pHeader, LENGTH_802_11);
 			REPORT_MGMT_FRAME_TO_MLME(pAd, pRxWI->WirelessCliID, pTmpBuf, pRxBlk->D=
ataSize + LENGTH_802_11, pRxWI->RSSI0, pRxWI->RSSI1, pRxWI->RSSI2, pRxD->Pl=
cpSignal);
-			DBGPRINT_RAW(RT_DEBUG_TRACE, ("!!! report EAPOL/AIRONET DATA to MLME (l=
en=3D%d) !!!\n", pRxBlk->DataSize));
+			DBGPRINT_RAW(RT_DEBUG_TRACE, ("report EAPOL/AIRONET DATA to MLME (len=
=3D%d) !\n", pRxBlk->DataSize));
 		}
 	}
=20
@@ -926,7 +926,7 @@
=20
 	if (pSrcBufVA =3D=3D NULL)
 	{
-		DBGPRINT(RT_DEBUG_ERROR,("STASendPacket --> pSrcBufVA =3D=3D NULL !!!Src=
BufLen=3D%x\n",SrcBufLen));
+		DBGPRINT(RT_DEBUG_ERROR,("STASendPacket --> pSrcBufVA =3D=3D NULL !SrcBu=
fLen=3D%x\n",SrcBufLen));
 		// Resourece is low, system did not allocate virtual address
 		// return NDIS_STATUS_FAILURE directly to upper layer
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
@@ -936,7 +936,7 @@
=20
 	if (SrcBufLen < 14)
 	{
-		DBGPRINT(RT_DEBUG_ERROR,("STASendPacket --> Ndis Packet buffer error !!!=
\n"));
+		DBGPRINT(RT_DEBUG_ERROR,("STASendPacket --> Ndis Packet buffer error !\n=
"));
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
 		return (NDIS_STATUS_FAILURE);
 	}
@@ -1002,7 +1002,7 @@
 		  && (RTMP_GET_PACKET_EAPOL(pPacket)=3D=3D FALSE)
 		  )
 	{
-		DBGPRINT(RT_DEBUG_TRACE,("STASendPacket --> Drop packet before port secu=
red !!!\n"));
+		DBGPRINT(RT_DEBUG_TRACE,("STASendPacket --> Drop packet before port secu=
red !\n"));
 		RELEASE_NDIS_PACKET(pAd, pPacket, NDIS_STATUS_FAILURE);
=20
 		return (NDIS_STATUS_FAILURE);
@@ -1677,7 +1677,7 @@
 		pMacEntry =3D pTxBlk->pMacEntry;
 		if (pMacEntry->isCached)
 		{
-			// NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]!!!!
+			// NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]!
 			NdisMoveMemory((PUCHAR)&pTxBlk->HeaderBuf[TXINFO_SIZE], (PUCHAR)&pMacEn=
try->CachedBuf[0], TXWI_SIZE + sizeof(HEADER_802_11));
 			pHeaderBufPtr =3D (PUCHAR)(&pTxBlk->HeaderBuf[TXINFO_SIZE + TXWI_SIZE]);
 			STABuildCache802_11Header(pAd, pTxBlk, pHeaderBufPtr);
@@ -2470,7 +2470,7 @@
 		default:
 			{
 				// It should not happened!
-				DBGPRINT(RT_DEBUG_ERROR, ("Send a pacekt was not classified!! It shoul=
d not happen!\n"));
+				DBGPRINT(RT_DEBUG_ERROR, ("Send a pacekt was not classified! It should=
 not happen!\n"));
 				while(pTxBlk->TxPacketList.Number)
 				{
 					pQEntry =3D RemoveHeadQueue(&pTxBlk->TxPacketList);
diff -ru c/drivers/staging/rt2860/sta/sanity.c d/drivers/staging/rt2860/sta=
/sanity.c
--- c/drivers/staging/rt2860/sta/sanity.c	2009-11-03 20:37:49.000000000 +01=
00
+++ d/drivers/staging/rt2860/sta/sanity.c	2009-11-05 01:08:31.545835935 +01=
00
@@ -169,7 +169,7 @@
=20
              case IE_HT_CAP:
             case IE_HT_CAP2:
-			if (pEid->Len >=3D SIZE_HT_CAP_IE)  //Note: allow extension.!!
+			if (pEid->Len >=3D SIZE_HT_CAP_IE)  //Note: allow extension.!
 			{
 				NdisMoveMemory(pHtCapability, pEid->Octet, SIZE_HT_CAP_IE);
=20
diff -ru c/drivers/staging/rt2860/sta/wpa.c d/drivers/staging/rt2860/sta/wp=
a.c
--- c/drivers/staging/rt2860/sta/wpa.c	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/sta/wpa.c	2009-11-05 01:08:31.605836067 +0100
@@ -800,13 +800,13 @@
 	//if (!RTMPEqualMemory(pMsg3->KeyDesc.KeyData, pAd->MacTab.Content[BSSID_=
WCID].RSN_IE, pAd->MacTab.Content[BSSID_WCID].RSNIE_Len))
 	if (!CheckRSNIE(pAd, pMsg3->KeyDesc.KeyData, pMsg3->KeyDesc.KeyDataLen[1]=
, &skip_offset))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, ("RSN_IE Different in Msg 3 of WPA1 4-way hands=
hake!! \n"));
+		DBGPRINT(RT_DEBUG_ERROR, ("RSN_IE Different in Msg 3 of WPA1 4-way hands=
hake! \n"));
 		hex_dump("The original RSN_IE", pAd->MacTab.Content[BSSID_WCID].RSN_IE, =
pAd->MacTab.Content[BSSID_WCID].RSNIE_Len);
 		hex_dump("The received RSN_IE", pMsg3->KeyDesc.KeyData, pMsg3->KeyDesc.K=
eyDataLen[1]);
 		return;
 	}
 	else
-		DBGPRINT(RT_DEBUG_TRACE, ("RSN_IE VALID in Msg 3 of WPA1 4-way handshake=
!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, ("RSN_IE VALID in Msg 3 of WPA1 4-way handshake=
! \n"));
=20
=20
 	// 2. Check MIC value
@@ -828,11 +828,11 @@
=20
 	if(!NdisEqualMemory(OldMic, Mic, LEN_KEY_DESC_MIC))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in msg 3 of 4-way handshake!!!=
!!!!!!! \n"));
+		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in msg 3 of 4-way handshake! \=
n"));
 		return;
 	}
 	else
-		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in msg 3 of 4-way handshake!!!!!!!=
!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in msg 3 of 4-way handshake! \n"));
=20
 	// 3. Check Replay Counter, it has to be larger than last one. No need to=
 be exact one larger
 	if(RTMPCompareMemory(pMsg3->KeyDesc.ReplayCounter, pAd->StaCfg.ReplayCoun=
ter, LEN_KEY_DESC_REPLAY) !=3D 1)
@@ -1032,12 +1032,12 @@
=20
 	if(!NdisEqualMemory(OldMic, Mic, LEN_KEY_DESC_MIC))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in msg 3 of 4-way handshake!!!=
!!!!!!! \n"));
+		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in msg 3 of 4-way handshake! \=
n"));
 		os_free_mem(pAd, (PUCHAR)mpool);
 		return;
 	}
 	else
-		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in msg 3 of 4-way handshake!!!!!!!=
!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in msg 3 of 4-way handshake! \n"));
=20
 	// 3. Check Replay Counter, it has to be larger than last one. No need to=
 be exact one larger
 	if(RTMPCompareMemory(pMsg3->KeyDesc.ReplayCounter, pAd->StaCfg.ReplayCoun=
ter, LEN_KEY_DESC_REPLAY) !=3D 1)
@@ -1324,12 +1324,12 @@
=20
 	if(!NdisEqualMemory(OldMic, Mic, LEN_KEY_DESC_MIC))
 	{
-		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in group msg 1 of 2-way handsh=
ake!!!!!!!!!! \n"));
+		DBGPRINT(RT_DEBUG_ERROR, (" MIC Different in group msg 1 of 2-way handsh=
ake! \n"));
 		MlmeFreeMemory(pAd, (PUCHAR)mpool);
 		return;
 	}
 	else
-		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in group msg 1 of 2-way handshake!=
!!!!!!!!! \n"));
+		DBGPRINT(RT_DEBUG_TRACE, (" MIC VALID in group msg 1 of 2-way handshake!=
 \n"));
=20
=20
 	// 3. Decrypt GTK from Key Data
diff -ru c/drivers/staging/rt2860/sta_ioctl.c d/drivers/staging/rt2860/sta_=
ioctl.c
--- c/drivers/staging/rt2860/sta_ioctl.c	2009-11-03 20:37:49.000000000 +0100
+++ d/drivers/staging/rt2860/sta_ioctl.c	2009-11-05 01:08:31.509169233 +0100
@@ -709,7 +709,7 @@
 	if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE)
     {
         RT28XX_MLME_RESET_STATE_MACHINE(pAdapter);
-        DBGPRINT(RT_DEBUG_TRACE, ("!!! MLME busy, reset MLME state machine=
 !!!\n"));
+        DBGPRINT(RT_DEBUG_TRACE, ("MLME busy, reset MLME state machine !\n=
"));
     }
=20
     // tell CNTL state machine to call NdisMSetInformationComplete() after=
 completing
@@ -851,7 +851,7 @@
=20
 	if (MONITOR_ON(pAdapter))
     {
-        DBGPRINT(RT_DEBUG_TRACE, ("!!! Driver is in Monitor Mode now !!!\n=
"));
+        DBGPRINT(RT_DEBUG_TRACE, ("Driver is in Monitor Mode now !\n"));
         return -EINVAL;
     }
 #ifdef RT2860
@@ -879,7 +879,7 @@
 		if ((pAdapter->StaCfg.WpaSupplicantUP =3D=3D WPA_SUPPLICANT_ENABLE) &&
 			(pAdapter->StaCfg.WpaSupplicantScanCount > 3))
 		{
-			DBGPRINT(RT_DEBUG_TRACE, ("!!! WpaSupplicantScanCount > 3\n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("WpaSupplicantScanCount > 3\n"));
 			Status =3D NDIS_STATUS_SUCCESS;
 			break;
 		}
@@ -889,7 +889,7 @@
 			(pAdapter->StaCfg.AuthMode =3D=3D Ndis802_11AuthModeWPAPSK)) &&
 			(pAdapter->StaCfg.PortSecured =3D=3D WPA_802_1X_PORT_NOT_SECURED))
 		{
-			DBGPRINT(RT_DEBUG_TRACE, ("!!! Link UP, Port Not Secured! ignore this s=
et::OID_802_11_BSSID_LIST_SCAN\n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("Link UP, Port Not Secured! ignore this set::=
OID_802_11_BSSID_LIST_SCAN\n"));
 			Status =3D NDIS_STATUS_SUCCESS;
 			break;
 		}
@@ -897,7 +897,7 @@
 		if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE)
 		{
 			RT28XX_MLME_RESET_STATE_MACHINE(pAdapter);
-			DBGPRINT(RT_DEBUG_TRACE, ("!!! MLME busy, reset MLME state machine !!!\=
n"));
+			DBGPRINT(RT_DEBUG_TRACE, ("MLME busy, reset MLME state machine !\n"));
 		}
=20
 		// tell CNTL state machine to call NdisMSetInformationComplete() after c=
ompleting
@@ -2464,7 +2464,7 @@
 			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - IW_PMKSA_ADD\n"));
 			break;
 		default:
-			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!!\n"));
+			DBGPRINT(RT_DEBUG_TRACE ,("rt_ioctl_siwpmksa - Unknow Command!\n"));
 			break;
 	}
=20
@@ -2907,7 +2907,7 @@
         if (pAdapter->Mlme.CntlMachine.CurrState !=3D CNTL_IDLE)
         {
             RT28XX_MLME_RESET_STATE_MACHINE(pAdapter);
-            DBGPRINT(RT_DEBUG_TRACE, ("!!! MLME busy, reset MLME state mac=
hine !!!\n"));
+            DBGPRINT(RT_DEBUG_TRACE, ("MLME busy, reset MLME state machine=
 !\n"));
         }
=20
         pAdapter->MlmeAux.CurrReqIsFromNdis =3D TRUE;
@@ -3620,7 +3620,7 @@
=20
     if ((strlen(arg) < 8) || (strlen(arg) > 64))
     {
-        DBGPRINT(RT_DEBUG_TRACE, ("Set failed!!(WPAPSK=3D%s), WPAPSK key-s=
tring required 8 ~ 64 characters \n", arg));
+        DBGPRINT(RT_DEBUG_TRACE, ("Set failed!(WPAPSK=3D%s), WPAPSK key-st=
ring required 8 ~ 64 characters \n", arg));
         return FALSE;
     }
=20


--lMM8JwqTlfDpEaS6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrya7wACgkQQfdJUNXnsjrZQQCgh8u7quTBgSSzHMEcN+3/5/BC
IcQAoIY+jwuo+TL9V6/TYIsVB+BKzDLS
=Chul
-----END PGP SIGNATURE-----

--lMM8JwqTlfDpEaS6--
