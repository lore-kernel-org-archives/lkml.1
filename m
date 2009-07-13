Return-Path: <linux-kernel-owner+w=401wt.eu-S1756857AbZGMRzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857AbZGMRzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 13:55:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756844AbZGMRzl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 13:55:41 -0400
Received: from mail-bw0-f228.google.com ([209.85.218.228]:60894 "EHLO
	mail-bw0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756777AbZGMRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 13:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:date:message-id:in-reply-to:references:subject;
        b=aF5yBdFR0H9Q8RiFbuIKkvC5u0PjRx1NdulVUw6whxFKOeScOty/+TgNK5Yd3+bD03
         ysQQI5uogxk+dfM9CVHA0VIYq2a8yywnIJJTp4AvvvFXFCNCARozgzEW63QJ9HicmRoE
         oo8ce5yXRoTDChkNYlcjoPIJuv2yGkC+NAa0w=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Cc: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>,
       linux-kernel@vger.kernel.org
Date: Mon, 13 Jul 2009 20:02:17 +0200
Message-Id: <20090713180217.15985.50263.sendpatchset@localhost.localdomain>
In-Reply-To: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
References: <20090713180112.15985.88819.sendpatchset@localhost.localdomain>
Subject: [PATCH 10/10] Staging: rtl8187se/ieee80211: convert MMIE_TYPE_* defines to enums
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Subject: [PATCH] Staging: rtl8187se/ieee80211: convert MMIE_TYPE_* defines to enums

Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
---
 drivers/staging/rtl8187se/ieee80211/ieee80211.h |   28 ++++++++++++------------
 1 file changed, 15 insertions(+), 13 deletions(-)

Index: b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
===================================================================
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211.h
@@ -457,19 +457,21 @@ Total: 28-2340 bytes
 */
 
 /* Management Frame Information Element Types */
-#define MFIE_TYPE_SSID       0
-#define MFIE_TYPE_RATES      1
-#define MFIE_TYPE_FH_SET     2
-#define MFIE_TYPE_DS_SET     3
-#define MFIE_TYPE_CF_SET     4
-#define MFIE_TYPE_TIM        5
-#define MFIE_TYPE_IBSS_SET   6
-#define MFIE_TYPE_COUNTRY  7 //+YJ,080625
-#define MFIE_TYPE_CHALLENGE  16
-#define MFIE_TYPE_ERP        42
-#define MFIE_TYPE_RSN	     48
-#define MFIE_TYPE_RATES_EX   50
-#define MFIE_TYPE_GENERIC    221
+enum {
+	MFIE_TYPE_SSID = 0,
+	MFIE_TYPE_RATES = 1,
+	MFIE_TYPE_FH_SET = 2,
+	MFIE_TYPE_DS_SET = 3,
+	MFIE_TYPE_CF_SET = 4,
+	MFIE_TYPE_TIM = 5,
+	MFIE_TYPE_IBSS_SET = 6,
+	MFIE_TYPE_COUNTRY = 7,
+	MFIE_TYPE_CHALLENGE = 16,
+	MFIE_TYPE_ERP = 42,
+	MFIE_TYPE_RSN = 48,
+	MFIE_TYPE_RATES_EX = 50,
+	MFIE_TYPE_GENERIC = 221,
+};
 
 struct ieee80211_header_data {
 	u16 frame_ctl;
