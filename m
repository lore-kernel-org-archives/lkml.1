Return-Path: <linux-kernel-owner+w=401wt.eu-S1753382AbYG1Ltl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382AbYG1Ltl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:49:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751247AbYG1Ltd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:49:33 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49037 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750835AbYG1Ltc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:49:32 -0400
Subject: [PATCH] swapfile/vmscan: update comments related to vmscan
	functions
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 28 Jul 2008 20:49:30 +0900
Message-Id: <1217245770.3087.15.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26/mm/swapfile.c linux-2.6.26-fixes/mm/swapfile.c
--- linux-2.6.26/mm/swapfile.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-fixes/mm/swapfile.c	2008-07-28 20:42:46.000000000 +0900
@@ -655,8 +655,8 @@ static int unuse_mm(struct mm_struct *mm
 
 	if (!down_read_trylock(&mm->mmap_sem)) {
 		/*
-		 * Activate page so shrink_cache is unlikely to unmap its
-		 * ptes while lock is dropped, so swapoff can make progress.
+		 * Activate page so shrink_inactive_list is unlikely to unmap
+		 * its ptes while lock is dropped, so swapoff can make progress.
 		 */
 		activate_page(page);
 		unlock_page(page);
diff -urNp linux-2.6.26/mm/vmscan.c linux-2.6.26-fixes/mm/vmscan.c
--- linux-2.6.26/mm/vmscan.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-fixes/mm/vmscan.c	2008-07-28 20:39:38.000000000 +0900
@@ -1940,7 +1940,7 @@ module_init(kswapd_init)
 int zone_reclaim_mode __read_mostly;
 
 #define RECLAIM_OFF 0
-#define RECLAIM_ZONE (1<<0)	/* Run shrink_cache on the zone */
+#define RECLAIM_ZONE (1<<0)	/* Run shrink_inactive_list on the zone */
 #define RECLAIM_WRITE (1<<1)	/* Writeout pages during reclaim */
 #define RECLAIM_SWAP (1<<2)	/* Swap pages out during reclaim */
 


