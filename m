Return-Path: <linux-kernel-owner+w=401wt.eu-S1759213AbZKFNsP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759213AbZKFNsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Nov 2009 08:48:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757491AbZKFNsP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Nov 2009 08:48:15 -0500
Received: from sedf.de ([212.83.34.151]:57923 "EHLO sedf.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbZKFNsO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Nov 2009 08:48:14 -0500
Date: Fri, 6 Nov 2009 14:48:12 +0100
From: Sebastian =?utf-8?Q?Dalfu=C3=9F?= <sd@sedf.de>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 3/3 v2] staging: rt2860: reduce superfluous exclamation
 marks
Message-ID: <20091106134812.GA27210@sedf.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Ckj6UjgE2iN1+kY"
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Ckj6UjgE2iN1+kY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

=46rom: Sebastian Dalfu=C3=9F <sd@sedf.de>

This patch is based on next-20091106.
This patch reduces the number of exclamation marks in DBGPRINT() and
printk() strings (also comments) to a slightly less insane number.

Signed-off-by: Sebastian Dalfu=C3=9F <sd@sedf.de>
---
diff -ru b/drivers/staging/rt2860/common/cmm_data.c c/drivers/staging/rt286=
0/common/cmm_data.c
--- b/drivers/staging/rt2860/common/cmm_data.c	2009-11-06 08:03:10.00000000=
0 +0100
+++ c/drivers/staging/rt2860/common/cmm_data.c	2009-11-06 12:04:42.20163995=
9 +0100
@@ -1729,7 +1729,7 @@
 				  pAd->MacTab.Size));
 		} else {
 			DBGPRINT(RT_DEBUG_OFF,
-				 ("\n%s: Impossible Wcid =3D %d !!!!!\n",
+				 ("\n%s: Impossible Wcid =3D %d !!!\n",
 				  __func__, wcid));
 		}
 	}
diff -ru b/drivers/staging/rt2860/common/mlme.c c/drivers/staging/rt2860/co=
mmon/mlme.c
--- b/drivers/staging/rt2860/common/mlme.c	2009-11-06 08:03:10.000000000 +0=
100
+++ c/drivers/staging/rt2860/common/mlme.c	2009-11-06 12:04:42.431640138 +0=
100
@@ -4600,7 +4600,7 @@
  * input params:
  *		Buffer - pointer to a pre-allocated memory segment
  *		args - a list of <int arg_size, arg> pairs.
- *		NOTE NOTE NOTE!!!! the last argument must be NULL, otherwise this
+ *		NOTE NOTE NOTE!!! the last argument must be NULL, otherwise this
  *						   function will FAIL!!!
  * return:
  *		Size of the buffer
diff -ru b/drivers/staging/rt2860/rtmp_def.h c/drivers/staging/rt2860/rtmp_=
def.h
--- b/drivers/staging/rt2860/rtmp_def.h	2009-11-06 08:03:10.000000000 +0100
+++ c/drivers/staging/rt2860/rtmp_def.h	2009-11-06 12:04:42.614973444 +0100
@@ -409,7 +409,7 @@
 #define MAX_LEN_OF_MAC_TABLE            MAX_NUMBER_OF_MAC	/* if MAX_MBSSID=
_NUM is 8, this value can't be larger than 211 */
=20
 #if MAX_LEN_OF_MAC_TABLE>MAX_AVAILABLE_CLIENT_WCID
-#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!!!!
+#error MAX_LEN_OF_MAC_TABLE can not be larger than MAX_AVAILABLE_CLIENT_WC=
ID!!!
 #endif
=20
 #define MAX_NUM_OF_WDS_LINK_PERBSSID	            3
diff -ru b/drivers/staging/rt2860/sta/assoc.c c/drivers/staging/rt2860/sta/=
assoc.c
--- b/drivers/staging/rt2860/sta/assoc.c	2009-11-06 08:03:10.000000000 +0100
+++ c/drivers/staging/rt2860/sta/assoc.c	2009-11-06 12:04:42.714973141 +0100
@@ -563,7 +563,7 @@
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_WAIT_RSP;
 	} else {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - MlmeAssocReqAction() sanity check failed. BUG!!!!!! \n"));
+			 ("ASSOC - MlmeAssocReqAction() sanity check failed. BUG!!! \n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_ASSOC_CONF, 2,
@@ -746,7 +746,7 @@
 		pAd->Mlme.AssocMachine.CurrState =3D REASSOC_WAIT_RSP;
 	} else {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("ASSOC - MlmeReassocReqAction() sanity check failed. BUG!!!! \n"));
+			 ("ASSOC - MlmeReassocReqAction() sanity check failed. BUG!!! \n"));
 		pAd->Mlme.AssocMachine.CurrState =3D ASSOC_IDLE;
 		Status =3D MLME_INVALID_FORMAT;
 		MlmeEnqueue(pAd, MLME_CNTL_STATE_MACHINE, MT2_REASSOC_CONF, 2,
diff -ru b/drivers/staging/rt2860/sta/connect.c c/drivers/staging/rt2860/st=
a/connect.c
--- b/drivers/staging/rt2860/sta/connect.c	2009-11-06 08:03:10.000000000 +0=
100
+++ c/drivers/staging/rt2860/sta/connect.c	2009-11-06 12:04:42.751640132 +0=
100
@@ -911,7 +911,7 @@
 				  pAd->CommonCfg.Bssid[5]));
 		} else {
 			DBGPRINT(RT_DEBUG_TRACE,
-				 ("CNTL - Start IBSS fail. BUG!!!!!\n"));
+				 ("CNTL - Start IBSS fail. BUG!!!\n"));
 			pAd->Mlme.CntlMachine.CurrState =3D CNTL_IDLE;
 		}
 	}
diff -ru b/drivers/staging/rt2860/sta/rtmp_data.c c/drivers/staging/rt2860/=
sta/rtmp_data.c
--- b/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-06 08:03:10.000000000 =
+0100
+++ c/drivers/staging/rt2860/sta/rtmp_data.c	2009-11-06 12:04:42.808307173 =
+0100
@@ -1680,7 +1680,7 @@
=20
 		pMacEntry =3D pTxBlk->pMacEntry;
 		if (pMacEntry->isCached) {
-			/* NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]!!!! */
+			/* NOTE: Please make sure the size of pMacEntry->CachedBuf[] is smaller=
 than pTxBlk->HeaderBuf[]!!! */
 			NdisMoveMemory((u8 *)& pTxBlk->
 				       HeaderBuf[TXINFO_SIZE],
 				       (u8 *)& pMacEntry->CachedBuf[0],
diff -ru b/drivers/staging/rt2860/usb_main_dev.c c/drivers/staging/rt2860/u=
sb_main_dev.c
--- b/drivers/staging/rt2860/usb_main_dev.c	2009-11-06 08:03:10.000000000 +=
0100
+++ c/drivers/staging/rt2860/usb_main_dev.c	2009-11-06 12:04:42.851640100 +=
0100
@@ -584,7 +584,7 @@
 	RTMP_IO_READ32(pAd, TXRXQ_PCNT, &MACValue);
 	if ((MACValue & 0xff) !=3D 0) {
 		DBGPRINT(RT_DEBUG_TRACE,
-			 ("TX QUEUE 0 Not EMPTY(Value=3D0x%0x). !!!!!!!!!!!!!!!\n",
+			 ("TX QUEUE 0 Not EMPTY(Value=3D0x%0x). !!!\n",
 			  MACValue));
 		RTMP_IO_WRITE32(pAd, PBF_CFG, 0xf40012);
 		while ((MACValue & 0xff) !=3D 0 && (idx++ < 10)) {
@@ -707,7 +707,7 @@
 					}
 				} else {
 					DBGPRINT(RT_DEBUG_ERROR,
-						 ("Unkonw bulkOut URB maybe hanged!!!!!!!!!!!!\n"));
+						 ("Unknown bulkOut URB maybe hanged!!!\n"));
 				}
 			} else {
 				RTMP_IRQ_UNLOCK(&pAd->BulkOutLock[idx],


--4Ckj6UjgE2iN1+kY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr0KRwACgkQQfdJUNXnsjqEEACffDEZil8iZmMu64E0ZZyRxXkY
56AAn00BgRUY7f92PXKCDzrBEYBff+Mk
=8wwf
-----END PGP SIGNATURE-----

--4Ckj6UjgE2iN1+kY--
