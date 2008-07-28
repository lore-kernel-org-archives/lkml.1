Return-Path: <linux-kernel-owner+w=401wt.eu-S1754422AbYG1L2x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422AbYG1L2x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:28:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751945AbYG1L2p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:28:45 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48465 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898AbYG1L2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:28:45 -0400
Subject: [PATCH] swap: update function comment of release_pages
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 28 Jul 2008 20:28:44 +0900
Message-Id: <1217244524.3087.8.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26/mm/swap.c linux-2.6.26-fixes/mm/swap.c
--- linux-2.6.26/mm/swap.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-fixes/mm/swap.c	2008-07-28 20:24:42.000000000 +0900
@@ -278,9 +278,10 @@ int lru_add_drain_all(void)
  * Avoid taking zone->lru_lock if possible, but if it is taken, retain it
  * for the remainder of the operation.
  *
- * The locking in this function is against shrink_cache(): we recheck the
- * page count inside the lock to see whether shrink_cache grabbed the page
- * via the LRU.  If it did, give up: shrink_cache will free it.
+ * The locking in this function is against shrink_inactive_list(): we recheck
+ * the page count inside the lock to see whether shrink_inactive_list()
+ * grabbed the page via the LRU.  If it did, give up: shrink_inactive_list()
+ * will free it.
  */
 void release_pages(struct page **pages, int nr, int cold)
 {


