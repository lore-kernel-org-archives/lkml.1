Return-Path: <linux-kernel-owner+w=401wt.eu-S934177AbXG2PSk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934177AbXG2PSk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:18:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765446AbXG2PDQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:03:16 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47942 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1765435AbXG2PDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:03:07 -0400
Date: Sun, 29 Jul 2007 17:02:43 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>, linux-kernel@vger.kernel.org
Subject: [2.6 patch] lib/ioremap.c should #include <linux/io.h>
Message-ID: <20070729150243.GZ16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions (in this case ioremap_page_range()).

Signed-off-by: Adrian Bunk <bunk@stusta.de>
Acked-by: Haavard Skinnemoen <hskinnemoen@atmel.com>

---

This patch has been sent on:
- 6 Jul 2007

--- linux-2.6.22-rc6-mm1/lib/ioremap.c.old	2007-07-03 05:02:10.000000000 +0200
+++ linux-2.6.22-rc6-mm1/lib/ioremap.c	2007-07-03 05:02:22.000000000 +0200
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 

