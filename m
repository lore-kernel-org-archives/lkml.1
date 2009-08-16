Return-Path: <linux-kernel-owner+w=401wt.eu-S1755944AbZHPTal@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755944AbZHPTal (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Aug 2009 15:30:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755850AbZHPTai
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Aug 2009 15:30:38 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:45385 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755918AbZHPTaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Aug 2009 15:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=R5QHFrEY5JFezMtOnXVuHxfHyWOpvYeAybjgRMEQCLgoI7f8d1dneWl8jtC1x+kDtG
         wC/arZSVcw3q3+pp3ipeVeyJ6P+7Oa3Pr1+CwZa5BJoKU9G42Akl8XzFlEo7fLij+HDA
         f3IKoWzybyNYmCV0TLfmus5Lk7E4FXZBb5ULQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Sun, 16 Aug 2009 21:30:32 +0200
Message-Id: <20090816193032.3789.79171.sendpatchset@localhost.localdomain>
In-Reply-To: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
References: <20090816192934.3789.3648.sendpatchset@localhost.localdomain>
Subject: [PATCH 09/22] Staging: rtxxx0: remove unused defines
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtxxx0: remove unused defines

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/oid.h      |   26 --------------------------
 drivers/staging/rt2860/rtmp.h     |    7 -------
 drivers/staging/rt2860/rtmp_def.h |    5 -----
 3 files changed, 38 deletions(-)

Index: b/drivers/staging/rt2860/oid.h
===================================================================
--- a/drivers/staging/rt2860/oid.h
+++ b/drivers/staging/rt2860/oid.h
@@ -670,32 +670,6 @@ enum {
 #define OID_802_11_GET_COUNTRY_CODE				0x0716
 #define OID_802_11_GET_CHANNEL_GEOGRAPHY		0x0717
 
-#ifdef RT30xx
-#define RT_OID_WSC_SET_PASSPHRASE                   0x0740 // passphrase for wpa(2)-psk
-#define RT_OID_WSC_DRIVER_AUTO_CONNECT              0x0741
-#define RT_OID_WSC_QUERY_DEFAULT_PROFILE            0x0742
-#define RT_OID_WSC_SET_CONN_BY_PROFILE_INDEX        0x0743
-#define RT_OID_WSC_SET_ACTION                       0x0744
-#define RT_OID_WSC_SET_SSID                         0x0745
-#define RT_OID_WSC_SET_PIN_CODE                     0x0746
-#define RT_OID_WSC_SET_MODE                         0x0747 // PIN or PBC
-#define RT_OID_WSC_SET_CONF_MODE                    0x0748 // Enrollee or Registrar
-#define RT_OID_WSC_SET_PROFILE                      0x0749
-
-#define RT_OID_802_11_WSC_QUERY_PROFILE				0x0750
-// for consistency with RT61
-#define RT_OID_WSC_QUERY_STATUS						0x0751
-#define RT_OID_WSC_PIN_CODE							0x0752
-#define RT_OID_WSC_UUID								0x0753
-#define RT_OID_WSC_SET_SELECTED_REGISTRAR			0x0754
-#define RT_OID_WSC_EAPMSG							0x0755
-#define RT_OID_WSC_MANUFACTURER						0x0756
-#define RT_OID_WSC_MODEL_NAME						0x0757
-#define RT_OID_WSC_MODEL_NO							0x0758
-#define RT_OID_WSC_SERIAL_NO						0x0759
-#define RT_OID_WSC_MAC_ADDRESS						0x0760
-#endif
-
 #ifdef LLTD_SUPPORT
 // for consistency with RT61
 #define RT_OID_GET_PHY_MODE                         0x761
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -407,8 +407,6 @@ typedef struct  _QUEUE_HEADER   {
 #define IS_RT3070(_pAd)				(((_pAd)->MACVersion & 0xffff0000) == 0x30700000)
 #ifdef RT30xx
 #define IS_RT3071(_pAd)				(((_pAd)->MACVersion & 0xffff0000) == 0x30710000)
-#define IS_RT2070(_pAd)				(((_pAd)->RfIcType == RFIC_2020) || ((_pAd)->EFuseTag == 0x27))
-
 #define IS_RT30xx(_pAd)				(((_pAd)->MACVersion & 0xfff00000) == 0x30700000)
 #endif
 
@@ -664,11 +662,6 @@ typedef struct  _QUEUE_HEADER   {
 #define BBP_IO_READ8_BY_REG_ID(_A, _I, _pV)   		RTUSBReadBBPRegister(_A, _I, _pV)
 #endif // RT2870 //
 
-#ifdef RT30xx
-#define RTMP_RF_IO_READ8_BY_REG_ID(_A, _I, _pV)    RT30xxReadRFRegister(_A, _I, _pV)
-#define RTMP_RF_IO_WRITE8_BY_REG_ID(_A, _I, _V)    RT30xxWriteRFRegister(_A, _I, _V)
-#endif // RT30xx //
-
 #define     MAP_CHANNEL_ID_TO_KHZ(ch, khz)  {               \
                 switch (ch)                                 \
                 {                                           \
Index: b/drivers/staging/rt2860/rtmp_def.h
===================================================================
--- a/drivers/staging/rt2860/rtmp_def.h
+++ b/drivers/staging/rt2860/rtmp_def.h
@@ -624,11 +624,6 @@
 #define AP_CNTL_STATE_MACHINE           15
 #define AP_WPA_STATE_MACHINE            16
 
-#ifdef RT30xx
-#define WSC_STATE_MACHINE            17
-#define WSC_UPNP_STATE_MACHINE		    18
-#endif
-
 //
 // STA's CONTROL/CONNECT state machine: states, events, total function #
 //
