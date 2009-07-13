Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZGMRyo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZGMRyo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:54:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756082AbZGMRyn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:54:43 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56224 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756051AbZGMRym (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:54:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=mRr92Wp6dc9IQ3zbDWhoGn2JopX+aL+GwXJGVLJblQo+p7TciUGDuk+ZeKa3uDqvwy
         xdoUpDt3A+kb/Qb7TIezKnI0z5NtQMJT+OPTUERoM7zh/EiqptMxW38MfferuTmfxGfZ
         rKlIL3WR4sj+p3BV9M/xXOUXWyn2ILKT0i5mo=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:01:19 +0200
Message-Id: <20090713180119.15985.56209.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
References: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 01/10] Staging: rtl8187se/ieee80211: remove OPENSUSE_SLED ifdefs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se/ieee80211: remove OPENSUSE_SLED ifdefs

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/TODO                             |    1 -
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c |    5 -----
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c |    5 -----
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c  |    5 -----
 4 files changed, 16 deletions(-)

Index: b/drivers/staging/rtl8187se/TODO
===================================================================
--- a/drivers/staging/rtl8187se/TODO
+++ b/drivers/staging/rtl8187se/TODO
@@ -1,6 +1,5 @@
 TODO:
 - prepare private ieee80211 stack for merge with rtl8192su's version:
-  - remove [IN]_OPENSUSE_SLED definitions
   - remove ENABLE_IPS ifdefs
   - rename struct ieee80211_hdr to struct ieee80211_hdr_4addr
   - rename struct ieee80211_hdr_3addr_QOS to struct ieee80211_hdr_3addrqos
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -31,11 +31,6 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: CCMP");
 MODULE_LICENSE("GPL");
 
-#ifdef OPENSUSE_SLED
-#ifndef IN_OPENSUSE_SLED
-#define IN_OPENSUSE_SLED 1
-#endif
-#endif
 
 #define AES_BLOCK_LEN 16
 #define CCMP_HDR_LEN 8
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -31,11 +31,6 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: TKIP");
 MODULE_LICENSE("GPL");
 
-#ifdef OPENSUSE_SLED
-#ifndef IN_OPENSUSE_SLED
-#define IN_OPENSUSE_SLED 1
-#endif
-#endif
 
 struct ieee80211_tkip_data {
 #define TKIP_KEY_LEN 32
Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -28,11 +28,6 @@ MODULE_AUTHOR("Jouni Malinen");
 MODULE_DESCRIPTION("Host AP crypt: WEP");
 MODULE_LICENSE("GPL");
 
-#ifdef OPENSUSE_SLED
-#ifndef IN_OPENSUSE_SLED
-#define IN_OPENSUSE_SLED 1
-#endif
-#endif
 
 
 struct prism2_wep_data {
