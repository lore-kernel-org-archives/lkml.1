Return-Path: <linux-kernel-owner+w=401wt.eu-S1755207AbXHRJjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207AbXHRJjc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2007 05:39:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbXHRJjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Aug 2007 05:39:23 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:53386 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751325AbXHRJjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2007 05:39:22 -0400
Message-id: <21572844081791984@wsc.cz>
In-reply-to: <737828602404912540@wsc.cz>
Subject: [PATCH 3/9] i2c-pxa, rename BIT macro to PXA_BIT
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: <nico@cam.org>
Date: Sat, 18 Aug 2007 11:40:41 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

i2c-pxa, rename BIT macro to PXA_BIT

BIT macro will be global definiton of (1 << x)

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit 6aec5d2e526e319488e6cdd627ca370086d458df
tree 322ca256a63baf90c75688c6aff3e253352c2321
parent e99a73f0e9d20869736b5cbd106f63fe31d63c85
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:45:38 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 21:45:38 +0200

 drivers/i2c/busses/i2c-pxa.c |   54 +++++++++++++++++++++---------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/i2c/busses/i2c-pxa.c b/drivers/i2c/busses/i2c-pxa.c
index 9d6b790..2e8fee7 100644
--- a/drivers/i2c/busses/i2c-pxa.c
+++ b/drivers/i2c/busses/i2c-pxa.c
@@ -82,7 +82,7 @@ struct bits {
 	const char *set;
 	const char *unset;
 };
-#define BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
+#define PXA_BIT(m, s, u)	{ .mask = m, .set = s, .unset = u }
 
 static inline void
 decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
@@ -97,17 +97,17 @@ decode_bits(const char *prefix, const struct bits *bits, int num, u32 val)
 }
 
 static const struct bits isr_bits[] = {
-	BIT(ISR_RWM,	"RX",		"TX"),
-	BIT(ISR_ACKNAK,	"NAK",		"ACK"),
-	BIT(ISR_UB,	"Bsy",		"Rdy"),
-	BIT(ISR_IBB,	"BusBsy",	"BusRdy"),
-	BIT(ISR_SSD,	"SlaveStop",	NULL),
-	BIT(ISR_ALD,	"ALD",		NULL),
-	BIT(ISR_ITE,	"TxEmpty",	NULL),
-	BIT(ISR_IRF,	"RxFull",	NULL),
-	BIT(ISR_GCAD,	"GenCall",	NULL),
-	BIT(ISR_SAD,	"SlaveAddr",	NULL),
-	BIT(ISR_BED,	"BusErr",	NULL),
+	PXA_BIT(ISR_RWM,	"RX",		"TX"),
+	PXA_BIT(ISR_ACKNAK,	"NAK",		"ACK"),
+	PXA_BIT(ISR_UB,		"Bsy",		"Rdy"),
+	PXA_BIT(ISR_IBB,	"BusBsy",	"BusRdy"),
+	PXA_BIT(ISR_SSD,	"SlaveStop",	NULL),
+	PXA_BIT(ISR_ALD,	"ALD",		NULL),
+	PXA_BIT(ISR_ITE,	"TxEmpty",	NULL),
+	PXA_BIT(ISR_IRF,	"RxFull",	NULL),
+	PXA_BIT(ISR_GCAD,	"GenCall",	NULL),
+	PXA_BIT(ISR_SAD,	"SlaveAddr",	NULL),
+	PXA_BIT(ISR_BED,	"BusErr",	NULL),
 };
 
 static void decode_ISR(unsigned int val)
@@ -117,21 +117,21 @@ static void decode_ISR(unsigned int val)
 }
 
 static const struct bits icr_bits[] = {
-	BIT(ICR_START,  "START",	NULL),
-	BIT(ICR_STOP,   "STOP",		NULL),
-	BIT(ICR_ACKNAK, "ACKNAK",	NULL),
-	BIT(ICR_TB,     "TB",		NULL),
-	BIT(ICR_MA,     "MA",		NULL),
-	BIT(ICR_SCLE,   "SCLE",		"scle"),
-	BIT(ICR_IUE,    "IUE",		"iue"),
-	BIT(ICR_GCD,    "GCD",		NULL),
-	BIT(ICR_ITEIE,  "ITEIE",	NULL),
-	BIT(ICR_IRFIE,  "IRFIE",	NULL),
-	BIT(ICR_BEIE,   "BEIE",		NULL),
-	BIT(ICR_SSDIE,  "SSDIE",	NULL),
-	BIT(ICR_ALDIE,  "ALDIE",	NULL),
-	BIT(ICR_SADIE,  "SADIE",	NULL),
-	BIT(ICR_UR,     "UR",		"ur"),
+	PXA_BIT(ICR_START,  "START",	NULL),
+	PXA_BIT(ICR_STOP,   "STOP",	NULL),
+	PXA_BIT(ICR_ACKNAK, "ACKNAK",	NULL),
+	PXA_BIT(ICR_TB,     "TB",	NULL),
+	PXA_BIT(ICR_MA,     "MA",	NULL),
+	PXA_BIT(ICR_SCLE,   "SCLE",	"scle"),
+	PXA_BIT(ICR_IUE,    "IUE",	"iue"),
+	PXA_BIT(ICR_GCD,    "GCD",	NULL),
+	PXA_BIT(ICR_ITEIE,  "ITEIE",	NULL),
+	PXA_BIT(ICR_IRFIE,  "IRFIE",	NULL),
+	PXA_BIT(ICR_BEIE,   "BEIE",	NULL),
+	PXA_BIT(ICR_SSDIE,  "SSDIE",	NULL),
+	PXA_BIT(ICR_ALDIE,  "ALDIE",	NULL),
+	PXA_BIT(ICR_SADIE,  "SADIE",	NULL),
+	PXA_BIT(ICR_UR,     "UR",		"ur"),
 };
 
 static void decode_ICR(unsigned int val)
