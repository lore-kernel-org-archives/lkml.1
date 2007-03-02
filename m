Return-Path: <linux-kernel-owner+w=401wt.eu-S2992547AbXCBP4X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992547AbXCBP4X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 10:56:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992555AbXCBP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 10:56:03 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:49699 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992547AbXCBPzS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 10:55:18 -0500
Subject: [PATCH 7/9] mtd: Fix number of free oob spaces in onenand driver
From: Richard Purdie <rpurdie@openedhand.com>
To: Nick Piggin <nickpiggin@yahoo.com.au>, Hugh Dickins <hugh@veritas.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-mtd@lists.infradead.org, dwmw2@infradead.org
Content-Type: text/plain
Date: Fri, 02 Mar 2007 15:54:59 +0000
Message-Id: <1172850899.11149.128.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Correct the number of free OOB data positions in the onenand
driver.

Signed-off-by: Richard Purdie <rpurdie@openedhand.com>

---
 drivers/mtd/onenand/onenand_base.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/drivers/mtd/onenand/onenand_base.c
===================================================================
--- linux.orig/drivers/mtd/onenand/onenand_base.c	2007-03-02 15:02:31.000000000 +0000
+++ linux/drivers/mtd/onenand/onenand_base.c	2007-03-02 15:37:05.000000000 +0000
@@ -33,8 +33,8 @@ static struct nand_ecclayout onenand_oob
 		56, 57, 58, 59, 60,
 		},
 	.oobfree	= {
-		{2, 3}, {14, 2}, {18, 3}, {30, 2},
-		{34, 3}, {46, 2}, {50, 3}, {62, 2}
+		{2, 6}, {14, 4}, {18, 6}, {30, 4},
+		{34, 6}, {46, 4}, {50, 6}, {62, 2}
 	}
 };
 
@@ -47,7 +47,7 @@ static struct nand_ecclayout onenand_oob
 		8, 9, 10, 11, 12,
 		24, 25, 26, 27, 28,
 		},
-	.oobfree	= { {2, 3}, {14, 2}, {18, 3}, {30, 2} }
+	.oobfree	= { {2, 6}, {14, 4}, {18, 6}, {30, 2} }
 };
 
 static const unsigned char ffchars[] = {


