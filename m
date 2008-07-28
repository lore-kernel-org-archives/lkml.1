Return-Path: <linux-kernel-owner+w=401wt.eu-S1753912AbYG1LZu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753912AbYG1LZu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 07:25:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbYG1LZn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 07:25:43 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:48364 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380AbYG1LZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 07:25:42 -0400
X-Greylist: delayed 1099 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Jul 2008 07:25:42 EDT
Subject: [PATCH] madvise: update function comment of madvise_dontneed
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: cl@linux-foundation.org
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Mon, 28 Jul 2008 20:07:21 +0900
Message-Id: <1217243241.3087.6.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26/mm/madvise.c linux-2.6.26-fixes/mm/madvise.c
--- linux-2.6.26/mm/madvise.c	2008-07-14 06:51:29.000000000 +0900
+++ linux-2.6.26-fixes/mm/madvise.c	2008-07-28 19:53:27.000000000 +0900
@@ -132,10 +132,10 @@ static long madvise_willneed(struct vm_a
  * Application no longer needs these pages.  If the pages are dirty,
  * it's OK to just throw them away.  The app will be more careful about
  * data it wants to keep.  Be sure to free swap resources too.  The
- * zap_page_range call sets things up for refill_inactive to actually free
+ * zap_page_range call sets things up for shrink_active_list to actually free
  * these pages later if no one else has touched them in the meantime,
  * although we could add these pages to a global reuse list for
- * refill_inactive to pick up before reclaiming other pages.
+ * shrink_active_list to pick up before reclaiming other pages.
  *
  * NB: This interface discards data rather than pushes it out to swap,
  * as some implementations do.  This has performance implications for


