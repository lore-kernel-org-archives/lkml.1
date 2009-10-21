Return-Path: <linux-kernel-owner+w=401wt.eu-S1755227AbZJUUpb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755227AbZJUUpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 16:45:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753589AbZJUUp2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 16:45:28 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:39437 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754729AbZJUUpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 16:45:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=pk1LI+pQUcshnHXMh4qgXKtdV0G7pA6+sITyuLQKPbssL+URixE8TvezhAMOYYqlqa
         Iuf1fvCtW3sHMHqeUUUCGWaZR2I1fwzsDV0Nu0k8XX4Xd658/EBha4U8qgDfh2B8TyII
         SF5PGhRWxWmgeehqlXQnowV3wMgV6Prn4CexM=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Wed, 21 Oct 2009 22:45:09 +0200
Message-Id: <20091021204509.4593.72323.sendpatchset@localhost.localdomain>
In-Reply-To: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
References: <20091021204344.4593.99070.sendpatchset@localhost.localdomain>
Subject: [PATCH 12/12] Staging: rt28x0: remove dead code
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rt28x0: remove dead code

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rt2860/oid.h       |   19 -------------------
 drivers/staging/rt2860/rt_config.h |    8 --------
 drivers/staging/rt2860/rt_linux.h  |   10 ----------
 drivers/staging/rt2860/rtmp.h      |   13 -------------
 drivers/staging/rt2860/rtmp_def.h  |    9 ---------
 5 files changed, 59 deletions(-)

Index: b/drivers/staging/rt2860/oid.h
===================================================================
--- a/drivers/staging/rt2860/oid.h
+++ b/drivers/staging/rt2860/oid.h
@@ -502,19 +502,6 @@ typedef struct _NDIS_802_11_AUTHENTICATI
     NDIS_802_11_AUTHENTICATION_REQUEST  Request[1];
 } NDIS_802_11_AUTHENTICATION_EVENT, *PNDIS_802_11_AUTHENTICATION_EVENT;
 
-/*
-typedef struct _NDIS_802_11_TEST
-{
-    ULONG Length;
-    ULONG Type;
-    union
-    {
-        NDIS_802_11_AUTHENTICATION_EVENT AuthenticationEvent;
-        NDIS_802_11_RSSI RssiTrigger;
-    };
-} NDIS_802_11_TEST, *PNDIS_802_11_TEST;
- */
-
 // 802.11 Media stream constraints, associated with OID_802_11_MEDIA_STREAM_MODE
 typedef enum _NDIS_802_11_MEDIA_STREAM_MODE
 {
@@ -553,10 +540,6 @@ typedef struct _NDIS_802_11_CAPABILITY
      NDIS_802_11_AUTHENTICATION_ENCRYPTION AuthenticationEncryptionSupported[1];
 } NDIS_802_11_CAPABILITY, *PNDIS_802_11_CAPABILITY;
 
-#ifdef LINUX
-#endif // LINUX //
-
-
 #define RT_PRIV_IOCTL							(SIOCIWFIRSTPRIV + 0x01) // Sync. with AP for wsc upnp daemon
 #define RTPRIV_IOCTL_SET							(SIOCIWFIRSTPRIV + 0x02)
 
@@ -593,8 +576,6 @@ enum {
 #define OID_802_11_GET_COUNTRY_CODE				0x0716
 #define OID_802_11_GET_CHANNEL_GEOGRAPHY		0x0717
 
-//#define RT_OID_802_11_STATISTICS              (OID_GET_SET_TOGGLE | OID_802_11_STATISTICS)
-
 #define RT_OID_WSC_SET_PASSPHRASE                   0x0740 // passphrase for wpa(2)-psk
 #define RT_OID_WSC_DRIVER_AUTO_CONNECT              0x0741
 #define RT_OID_WSC_QUERY_DEFAULT_PROFILE            0x0742
Index: b/drivers/staging/rt2860/rt_config.h
===================================================================
--- a/drivers/staging/rt2860/rt_config.h
+++ b/drivers/staging/rt2860/rt_config.h
@@ -64,14 +64,6 @@
 #include "rtmp_mcu.h"
 #endif
 
-#undef AP_WSC_INCLUDED
-#undef STA_WSC_INCLUDED
-#undef WSC_INCLUDED
-
-
-
-
-
 #ifdef IGMP_SNOOP_SUPPORT
 #include "igmp_snoop.h"
 #endif // IGMP_SNOOP_SUPPORT //
Index: b/drivers/staging/rt2860/rt_linux.h
===================================================================
--- a/drivers/staging/rt2860/rt_linux.h
+++ b/drivers/staging/rt2860/rt_linux.h
@@ -75,16 +75,6 @@
 #include <linux/kthread.h>
 #endif // KTHREAD_SUPPORT //
 
-#undef AP_WSC_INCLUDED
-#undef STA_WSC_INCLUDED
-#undef WSC_INCLUDED
-
-
-
-
-#ifdef KTHREAD_SUPPORT
-#endif // KTHREAD_SUPPORT //
-
 /***********************************************************************************
  *	Profile related sections
  ***********************************************************************************/
Index: b/drivers/staging/rt2860/rtmp.h
===================================================================
--- a/drivers/staging/rt2860/rtmp.h
+++ b/drivers/staging/rt2860/rtmp.h
@@ -41,23 +41,10 @@
 #define __RTMP_H__
 
 #include "spectrum_def.h"
-
 #include "rtmp_dot11.h"
-
-#undef AP_WSC_INCLUDED
-#undef STA_WSC_INCLUDED
-#undef WSC_INCLUDED
-
-
-
-#if defined(AP_WSC_INCLUDED) || defined(STA_WSC_INCLUDED)
-#define WSC_INCLUDED
-#endif
-
 #include "rtmp_chip.h"
 
 
-
 typedef struct _RTMP_ADAPTER		RTMP_ADAPTER;
 typedef struct _RTMP_ADAPTER		*PRTMP_ADAPTER;
 
Index: b/drivers/staging/rt2860/rtmp_def.h
===================================================================
--- a/drivers/staging/rt2860/rtmp_def.h
+++ b/drivers/staging/rt2860/rtmp_def.h
@@ -41,15 +41,6 @@
 
 #include "oid.h"
 
-#undef AP_WSC_INCLUDED
-#undef STA_WSC_INCLUDED
-#undef WSC_INCLUDED
-
-
-
-#if defined(AP_WSC_INCLUDED) || defined(STA_WSC_INCLUDED)
-#define WSC_INCLUDED
-#endif
 //
 //  Debug information verbosity: lower values indicate higher urgency
 //
