Return-Path: <linux-kernel-owner+w=401wt.eu-S1765341AbXG2PKw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765341AbXG2PKw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:10:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764734AbXG2O7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:59:54 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47865 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764477AbXG2O7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:59:41 -0400
Date: Sun, 29 Jul 2007 16:59:18 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] kernel/printk.c: make 2 variables static
Message-ID: <20070729145918.GG16817@stusta.de>
References: <20070725040304.111550f4.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070725040304.111550f4.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2007 at 04:03:04AM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.22-rc6-mm1:
>...
> +slow-down-printk-during-boot.patch
>...
>  Misc
>...

This patch makes two needlessly global variables static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/kernel/printk.c.old	2007-07-26 22:40:09.000000000 +0200
+++ linux-2.6.23-rc1-mm1/kernel/printk.c	2007-07-26 22:40:50.000000000 +0200
@@ -166,8 +166,8 @@
 
 #ifdef CONFIG_BOOT_PRINTK_DELAY
 
-unsigned int boot_delay; /* msecs delay after each printk during bootup */
-unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
+static unsigned int boot_delay; /* msecs delay after each printk during bootup */
+static unsigned long long printk_delay_msec; /* per msec, based on boot_delay */
 
 static int __init boot_delay_setup(char *str)
 {

