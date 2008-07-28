Return-Path: <linux-kernel-owner+w=401wt.eu-S1753978AbYG1L7z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753978AbYG1L7z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:59:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751485AbYG1L7s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:59:48 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:49311 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751317AbYG1L7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:59:47 -0400
Subject: [PATCH] do_try_to_free_page: update comments related to vmscan
	functions
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 28 Jul 2008 20:59:46 +0900
Message-Id: <1217246386.3087.19.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26/mm/vmscan.c linux-2.6.26-fixes/mm/vmscan.c
--- linux-2.6.26/mm/vmscan.c	2008-07-28 20:50:47.000000000 +0900
+++ linux-2.6.26-fixes/mm/vmscan.c	2008-07-28 20:56:23.000000000 +0900
@@ -1371,7 +1371,7 @@ static unsigned long do_try_to_free_page
 		if (sc->nr_scanned && priority < DEF_PRIORITY - 2)
 			congestion_wait(WRITE, HZ/10);
 	}
-	/* top priority shrink_caches still had more to do? don't OOM, then */
+	/* top priority shrink_zones still had more to do? don't OOM, then */
 	if (!sc->all_unreclaimable && scan_global_lru(sc))
 		ret = nr_reclaimed;
 out:


