Return-Path: <linux-kernel-owner+w=401wt.eu-S1759497AbYFYOnd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759497AbYFYOnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 10:43:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758427AbYFYOhJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 10:37:09 -0400
Received: from mtagate7.de.ibm.com ([195.212.29.156]:28913 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756582AbYFYOhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 10:37:05 -0400
Message-Id: <20080625143612.114967324@de.ibm.com>
References: <20080625143459.100139455@de.ibm.com>
User-Agent: quilt/0.46-1
Date: Wed, 25 Jun 2008 16:35:02 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel@vger.kernel.org, linux-s390@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: [patch 03/21] Cleanup xpram printk messages.
Content-Disposition: inline; filename=802-printk-xpram.diff
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Martin Schwidefsky <schwidefsky@de.ibm.com>

Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---

 drivers/s390/block/xpram.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

Index: quilt-2.6/drivers/s390/block/xpram.c
===================================================================
--- quilt-2.6.orig/drivers/s390/block/xpram.c
+++ quilt-2.6/drivers/s390/block/xpram.c
@@ -100,15 +100,10 @@ static int xpram_page_in (unsigned long 
 		: "+d" (cc) : "a" (__pa(page_addr)), "d" (xpage_index) : "cc");
 	if (cc == 3)
 		return -ENXIO;
-	if (cc == 2) {
-		PRINT_ERR("expanded storage lost!\n");
+	if (cc == 2)
 		return -ENXIO;
-	}
-	if (cc == 1) {
-		PRINT_ERR("page in failed for page index %u.\n",
-			  xpage_index);
+	if (cc == 1)
 		return -EIO;
-	}
 	return 0;
 }
 
@@ -135,15 +130,10 @@ static long xpram_page_out (unsigned lon
 		: "+d" (cc) : "a" (__pa(page_addr)), "d" (xpage_index) : "cc");
 	if (cc == 3)
 		return -ENXIO;
-	if (cc == 2) {
-		PRINT_ERR("expanded storage lost!\n");
+	if (cc == 2)
 		return -ENXIO;
-	}
-	if (cc == 1) {
-		PRINT_ERR("page out failed for page index %u.\n",
-			  xpage_index);
+	if (cc == 1)
 		return -EIO;
-	}
 	return 0;
 }
 

-- 
blue skies,
   Martin.

"Reality continues to ruin my life." - Calvin.

