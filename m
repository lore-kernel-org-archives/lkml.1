Return-Path: <linux-kernel-owner+w=401wt.eu-S1756807AbZGMSHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807AbZGMSHe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 14:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbZGMSHc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 14:07:32 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:57004 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851AbZGMSHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 14:07:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=j1qzrQKtCwfL4pz4ExlpNbdev03UmgiaE55JnU22HuO5imx3yxP3k8tybG3SGG9ckq
         y94n+iNBWQOFDqBsbVykHnCDlx/vwM6TtxXX0sH2RIyog0oP7QrUqVjtzuwIAVoRZkl7
         FRfUkOzVuXjOIvjvtbjQDyeCYOMW9HoAd4LjQ=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:14:02 +0200
Message-Id: <20090713181402.16765.87452.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
References: <20090713181329.16765.68428.sendpatchset@localhost.localdomain>
Subject: [PATCH 04/10] Staging: rtl8192su/ieee80211: remove OPENSUSE_SLED ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8192su/ieee80211: remove OPENSUSE_SLED ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8192su/TODO                             |    1 -
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c |    4 ----
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c |    4 ----
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c  |    3 ---
 4 files changed, 12 deletions(-)

Index: b/drivers/staging/rtl8192su/TODO
===================================================================
--- a/drivers/staging/rtl8192su/TODO
+++ b/drivers/staging/rtl8192su/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8187se's version:
-  - remove [IN]_OPENSUSE_SLED definitions
   - remove superflous container_of definition from ieee80211.h
   - remove rtl8192su's specific dead code
   - cleanup ieee80211.h
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
@@ -31,10 +31,6 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: CCMP");
 MODULE_LICENSE("GPL");
 
-#ifndef OPENSUSE_SLED
-#define OPENSUSE_SLED 0
-#endif
-
 #define AES_BLOCK_LEN 16
 #define CCMP_HDR_LEN 8
 #define CCMP_MIC_LEN 8
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
@@ -31,10 +31,6 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: TKIP");
 MODULE_LICENSE("GPL");
 
-#ifndef OPENSUSE_SLED
-#define OPENSUSE_SLED 0
-#endif
-
 struct ieee80211_tkip_data {
 #define TKIP_KEY_LEN 32
 	u8 key[TKIP_KEY_LEN];
Index: b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
===================================================================
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
@@ -27,9 +27,6 @@
 MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: WEP");
 MODULE_LICENSE("GPL");
-#ifndef OPENSUSE_SLED
-#define OPENSUSE_SLED 0
-#endif
 
 struct prism2_wep_data {
 	u32 iv;
