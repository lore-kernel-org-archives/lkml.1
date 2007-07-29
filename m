Return-Path: <linux-kernel-owner+w=401wt.eu-S932211AbXG2PGK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932211AbXG2PGK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:06:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764511AbXG2O6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 10:58:37 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:47819 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1764491AbXG2O6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 10:58:36 -0400
Date: Sun, 29 Jul 2007 16:58:12 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>,
       Kyungmin Park <kyungmin.park@samsung.com>, dwmw2@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org
Subject: [-mm patch] MTD onenand_sim.c: make struct info static
Message-ID: <20070729145812.GW16817@stusta.de>
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
>  git-mtd.patch
>...
>  git trees
>...

This patch makes the needlessly global struct info static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.23-rc1-mm1/drivers/mtd/onenand/onenand_sim.c.old	2007-07-26 16:11:57.000000000 +0200
+++ linux-2.6.23-rc1-mm1/drivers/mtd/onenand/onenand_sim.c	2007-07-26 16:12:19.000000000 +0200
@@ -78,7 +78,7 @@
 	struct onenand_flash	flash;
 };
 
-struct onenand_info *info;
+static struct onenand_info *info;
 
 #define DPRINTK(format, args...)					\
 do {									\

