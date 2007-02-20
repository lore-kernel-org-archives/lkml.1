Return-Path: <linux-kernel-owner+w=401wt.eu-S965634AbXBTAPU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965634AbXBTAPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Feb 2007 19:15:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965637AbXBTAPS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Feb 2007 19:15:18 -0500
Received: from mailout.stusta.mhn.de ([141.84.69.5]:36117 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750939AbXBTAHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Feb 2007 19:07:45 -0500
Date: Tue, 20 Feb 2007 01:07:44 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, TJ <linux@tjworld.net>
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] make fs/partitions/msdos.c:check_sane_values() static
Message-ID: <20070220000744.GB13958@stusta.de>
References: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070215051408.a7fb7d81.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 15, 2007 at 05:14:08AM -0800, Andrew Morton wrote:
>...
> Changes since 2.6.20-rc6-mm3:
>...
> +filesystem-disk-errors-at-boot-time-caused-by-probe.patch
>...
>  Misc
>...


check_sane_values() can become static.

---
--- linux-2.6.20-mm2/fs/partitions/msdos.c.old	2007-02-18 22:44:25.000000000 +0100
+++ linux-2.6.20-mm2/fs/partitions/msdos.c	2007-02-18 22:44:32.000000000 +0100
@@ -431,7 +431,7 @@
  *
  * Copyright 31 January 2007, TJ <linux@tjworld.net>
  */
-int check_sane_values(struct partition *p, struct block_device *bdev)
+static int check_sane_values(struct partition *p, struct block_device *bdev)
 {
 	unsigned char *data;
 	struct partition *ext;

