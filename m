Return-Path: <linux-kernel-owner+w=401wt.eu-S1758161AbZCNVkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758161AbZCNVkV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 17:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757630AbZCNVjr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 17:39:47 -0400
Received: from pne-smtpout2-sn2.hy.skanova.net ([81.228.8.164]:57987 "EHLO
	pne-smtpout2-sn2.hy.skanova.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248AbZCNVjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 17:39:46 -0400
From: =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
To: greg@kroah.com
Cc: linux-kernel@vger.kernel.org,
       =?utf-8?q?Erik=20Andr=C3=A9n?= <erik.andren@gmail.com>
Subject: [PATCH 01/09] Checkpatch.pl: Fixup agnx.h
Date: Sat, 14 Mar 2009 22:39:28 +0100
Message-Id: <1237066776-14697-2-git-send-email-erik.andren@gmail.com>
X-Mailer: git-send-email 1.6.0.4
In-Reply-To: <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
References: <1>
 <1237066776-14697-1-git-send-email-erik.andren@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Erik Andrén <erik.andren@gmail.com>
---
 drivers/staging/agnx/agnx.h |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/agnx/agnx.h b/drivers/staging/agnx/agnx.h
index 20f36da..9b5fc6c 100644
--- a/drivers/staging/agnx/agnx.h
+++ b/drivers/staging/agnx/agnx.h
@@ -41,16 +41,16 @@ static const struct ieee80211_rate agnx_rates_80211g[] = {
 /* 	{ .bitrate = 20, .hw_value = 2, .flags = IEEE80211_RATE_SHORT_PREAMBLE }, */
 /* 	{ .bitrate = 55, .hw_value = 3, .flags = IEEE80211_RATE_SHORT_PREAMBLE }, */
 /* 	{ .bitrate = 110, .hw_value = 4, .flags = IEEE80211_RATE_SHORT_PREAMBLE }, */
- 	{ .bitrate = 10, .hw_value = 1, },
- 	{ .bitrate = 20, .hw_value = 2, },
- 	{ .bitrate = 55, .hw_value = 3, },
- 	{ .bitrate = 110, .hw_value = 4,},
+	{ .bitrate = 10, .hw_value = 1, },
+	{ .bitrate = 20, .hw_value = 2, },
+	{ .bitrate = 55, .hw_value = 3, },
+	{ .bitrate = 110, .hw_value = 4,},
 
 	{ .bitrate = 60, .hw_value = 0xB, },
 	{ .bitrate = 90, .hw_value = 0xF, },
 	{ .bitrate = 120, .hw_value = 0xA },
 	{ .bitrate = 180, .hw_value = 0xE, },
-//	{ .bitrate = 240, .hw_value = 0xd, },
+/*	{ .bitrate = 240, .hw_value = 0xd, }, */
 	{ .bitrate = 360, .hw_value = 0xD, },
 	{ .bitrate = 480, .hw_value = 0x8, },
 	{ .bitrate = 540, .hw_value = 0xC, },
@@ -110,10 +110,10 @@ struct agnx_priv {
 	/* Need volatile? */
 	u32 irq_status;
 
-        struct delayed_work periodic_work; /* Periodic tasks like recalibrate*/
+	struct delayed_work periodic_work; /* Periodic tasks like recalibrate */
 	struct ieee80211_low_level_stats stats;
 
-//        unsigned int phymode;
+	/* unsigned int phymode; */
 	int mode;
 	int channel;
 	u8 bssid[ETH_ALEN];
-- 
1.6.0.4

