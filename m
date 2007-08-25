Return-Path: <linux-kernel-owner+w=401wt.eu-S933299AbXHYH7J@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933299AbXHYH7J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2007 03:59:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763127AbXHYH6s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 25 Aug 2007 03:58:48 -0400
Received: from general-networks3.cust.sloane.cz ([88.146.176.14]:33580 "EHLO
	server.generalnetworks.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764189AbXHYH6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2007 03:58:46 -0400
Message-id: <2109718751164215004@pripojeni.net>
In-reply-to: <149438602455517207@pripojeni.net>
Subject: [PATCH 3/4] Net: ath5k, use short preamble for some rates
From: Jiri Slaby <jirislaby@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
To: <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>
Cc: <netdev@vger.kernel.org>
Date: Sat, 25 Aug 2007 03:58:46 -0400
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ath5k, use short preamble for some rates

2, 5.5 and 11 in b/g are now in short preamble mode

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: <linville@tuxdriver.com>

---
commit 0a11d301ccb5caf1c9738a7307002a5295aecd58
tree f812c3fb91651437c7b434afbd4f8dc8435611f0
parent 0aebc8bb5574b6b0cc8f9f0d73672c1bee5cbfbb
author Jiri Slaby <jirislaby@gmail.com> Sat, 25 Aug 2007 09:24:05 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sat, 25 Aug 2007 09:24:05 +0200

 drivers/net/wireless/ath5k.h |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/ath5k.h b/drivers/net/wireless/ath5k.h
index c70cd30..ad5e196 100644
--- a/drivers/net/wireless/ath5k.h
+++ b/drivers/net/wireless/ath5k.h
@@ -613,9 +613,9 @@ struct ath5k_rate_table {
 	255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {				\
 	{ 1, MODULATION_CCK, 1000, 27, 130, 0 },	\
-	{ 1, MODULATION_CCK, 2000, 26, 132, 1 },	\
-	{ 1, MODULATION_CCK, 5500, 25, 139, 1 },	\
-	{ 1, MODULATION_CCK, 11000, 24, 150, 1 } }	\
+	{ 1, MODULATION_CCK_SP, 2000, 26, 132, 1 },	\
+	{ 1, MODULATION_CCK_SP, 5500, 25, 139, 1 },	\
+	{ 1, MODULATION_CCK_SP, 11000, 24, 150, 1 } }	\
 }
 
 #define AR5K_RATES_11G { 12, {					\
@@ -623,9 +623,9 @@ struct ath5k_rate_table {
 	11, 9, 7, 5, 255, 255, 255, 255, 255, 255, 255, 255,	\
 	3, 2, 1, 0, 255, 255, 255, 255 }, {			\
 	{ 1, MODULATION_CCK, 1000, 27, 2, 0 },		\
-	{ 1, MODULATION_CCK, 2000, 26, 4, 1 },		\
-	{ 1, MODULATION_CCK, 5500, 25, 11, 1 },		\
-	{ 1, MODULATION_CCK, 11000, 24, 22, 1 },	\
+	{ 1, MODULATION_CCK_SP, 2000, 26, 4, 1 },		\
+	{ 1, MODULATION_CCK_SP, 5500, 25, 11, 1 },		\
+	{ 1, MODULATION_CCK_SP, 11000, 24, 22, 1 },	\
 	{ 0, MODULATION_OFDM, 6000, 11, 12, 4 },	\
 	{ 0, MODULATION_OFDM, 9000, 15, 18, 4 },	\
 	{ 1, MODULATION_OFDM, 12000, 10, 24, 6 },	\
