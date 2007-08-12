Return-Path: <linux-kernel-owner+w=401wt.eu-S937301AbXHLPZq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937301AbXHLPZq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2007 11:25:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764595AbXHLPYe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Aug 2007 11:24:34 -0400
Received: from cacti.profiwh.com ([85.93.165.66]:59661 "EHLO smtp.wsc.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758891AbXHLPYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2007 11:24:32 -0400
Message-id: <2586869682263120842@wsc.cz>
In-reply-to: <261712744987112084@wsc.cz>
Subject: [PATCH 3/3] Char: mxser_new, remove useless comments in mxser_cards
From: Jiri Slaby <jirislaby@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sun, 12 Aug 2007 17:25:38 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

mxser_new, remove useless comments in mxser_cards

It was rest from times, where info about the card was separated (name,
ports number and flags).

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>

---
commit edbf03cecb93301ce1087ebbf46811c2c3af6534
tree f0bc804634fa587efed972a98c679859469494c9
parent 49b870ecc51c0e1aeb28ae329d825e9ca35cc973
author Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:23:04 +0200
committer Jiri Slaby <jirislaby@gmail.com> Sun, 12 Aug 2007 17:23:04 +0200

 drivers/char/mxser_new.c |   42 +++++++++++++++++++++---------------------
 1 files changed, 21 insertions(+), 21 deletions(-)

diff --git a/drivers/char/mxser_new.c b/drivers/char/mxser_new.c
index a03e391..854dbf5 100644
--- a/drivers/char/mxser_new.c
+++ b/drivers/char/mxser_new.c
@@ -113,29 +113,29 @@ struct mxser_cardinfo {
 };
 
 static const struct mxser_cardinfo mxser_cards[] = {
-/* 0*/	{ 8, "C168 series", },			/* C168-ISA */
-	{ 4, "C104 series", },			/* C104-ISA */
-	{ 4, "CI-104J series", },		/* CI104J */
-	{ 8, "C168H/PCI series", },		/* C168-PCI */
-	{ 4, "C104H/PCI series", },		/* C104-PCI */
+/* 0*/	{ 8, "C168 series", },
+	{ 4, "C104 series", },
+	{ 4, "CI-104J series", },
+	{ 8, "C168H/PCI series", },
+	{ 4, "C104H/PCI series", },
 /* 5*/	{ 4, "C102 series", MXSER_HAS2 },	/* C102-ISA */
-	{ 4, "CI-132 series", MXSER_HAS2 },	/* CI132 */
-	{ 4, "CI-134 series", },		/* CI134 */
-	{ 2, "CP-132 series", },		/* CP132 */
-	{ 4, "CP-114 series", },		/* CP114 */
-/*10*/	{ 4, "CT-114 series", },		/* CT114 */
-	{ 2, "CP-102 series", MXSER_HIGHBAUD },	/* CP102 */
-	{ 4, "CP-104U series", },		/* CP104U */
-	{ 8, "CP-168U series", },		/* CP168U */
-	{ 2, "CP-132U series", },		/* CP132U */
-/*15*/	{ 4, "CP-134U series", },		/* CP134U */
-	{ 4, "CP-104JU series", },		/* CP104JU */
+	{ 4, "CI-132 series", MXSER_HAS2 },
+	{ 4, "CI-134 series", },
+	{ 2, "CP-132 series", },
+	{ 4, "CP-114 series", },
+/*10*/	{ 4, "CT-114 series", },
+	{ 2, "CP-102 series", MXSER_HIGHBAUD },
+	{ 4, "CP-104U series", },
+	{ 8, "CP-168U series", },
+	{ 2, "CP-132U series", },
+/*15*/	{ 4, "CP-134U series", },
+	{ 4, "CP-104JU series", },
 	{ 8, "Moxa UC7000 Serial", },		/* RC7000 */
-	{ 8, "CP-118U series", },		/* CP118U */
-	{ 2, "CP-102UL series", },		/* CP102UL */
-/*20*/	{ 2, "CP-102U series", },		/* CP102U */
-	{ 8, "CP-118EL series", },		/* CP118EL */
-	{ 8, "CP-168EL series", },		/* CP168EL */
+	{ 8, "CP-118U series", },
+	{ 2, "CP-102UL series", },
+/*20*/	{ 2, "CP-102U series", },
+	{ 8, "CP-118EL series", },
+	{ 8, "CP-168EL series", },
 	{ 4, "CP-104EL series", },
 	{ 8, "CB-108 series", },
 /*25*/	{ 4, "CB-114 series", },
