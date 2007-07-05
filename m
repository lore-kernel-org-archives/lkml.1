Return-Path: <linux-kernel-owner+w=401wt.eu-S1762996AbXGEXWp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762996AbXGEXWp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 19:22:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760376AbXGEXWA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 19:22:00 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:52122 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760266AbXGEXV7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 19:21:59 -0400
Date: Fri, 6 Jul 2007 01:22:28 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] lib/ioremap.c should #include <linux/io.h>
Message-ID: <20070705232228.GU3492@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the prototypes for
its global functions.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.22-rc6-mm1/lib/ioremap.c.old	2007-07-03 05:02:10.000000000 +0200
+++ linux-2.6.22-rc6-mm1/lib/ioremap.c	2007-07-03 05:02:22.000000000 +0200
@@ -8,6 +8,7 @@
 #include <linux/vmalloc.h>
 #include <linux/mm.h>
 #include <linux/sched.h>
+#include <linux/io.h>
 #include <asm/cacheflush.h>
 #include <asm/pgtable.h>
 

