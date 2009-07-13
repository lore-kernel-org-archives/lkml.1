Return-Path: <linux-kernel-owner+w=401wt.eu-S1756495AbZGMRyu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756495AbZGMRyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:54:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756352AbZGMRys
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:54:48 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:56224 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834AbZGMRyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:54:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=Zfj9M9L1OX4kN7F4e9bxB6+8slo2/SDM2qwItI3Qu6Qb407m0+zlksiljX6Knli89u
         GGhbn/b8hk4M9vB3co+9wtIs+0nOHSauRGACFpd89KbbZAEtzaZhsP2ST/HxP8cgR80Z
         Ju3VcO6hAGA1dHjxqLhyP/Cdf1b9s2wmmrTi8=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:01:25 +0200
Message-Id: <20090713180125.15985.68225.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
References: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 02/10] Staging: rtl8187se/ieee80211: remove FEDORACORE_9 ifdef
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se/ieee80211: remove FEDORACORE_9 ifdef

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c |    6 ------
 1 file changed, 6 deletions(-)

Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -39,12 +39,6 @@ static const char *ieee80211_modes[] = {
 	"?", "a", "b", "ab", "g", "ag", "bg", "abg"
 };
 
-#ifdef FEDORACORE_9
-#define IN_FEDORACORE_9 1
-#else
-#define IN_FEDORACORE_9 0
-#endif
-
 #define MAX_CUSTOM_LEN 64
 static inline char *rtl818x_translate_scan(struct ieee80211_device *ieee,
 		                           char *start, char *stop,
