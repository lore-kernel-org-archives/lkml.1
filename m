Return-Path: <linux-kernel-owner+w=401wt.eu-S1030816AbXD1TTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030816AbXD1TTs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2007 15:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030657AbXD1TTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 28 Apr 2007 15:19:33 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:37494 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756106AbXD1TTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2007 15:19:30 -0400
Date: Sat, 28 Apr 2007 21:19:42 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Andrew Morton <akpm@linux-foundation.org>, drzeus-mmc@drzeus.cx
Cc: linux-kernel@vger.kernel.org
Subject: [-mm patch] MMC: make tifm_sd_set_dma_data() static
Message-ID: <20070428191941.GP3468@stusta.de>
References: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20070425225716.8e9b28ca.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2007 at 10:57:16PM -0700, Andrew Morton wrote:
>...
> Changes since 2.6.21-rc7-mm1:
>...
>  git-mmc.patch
>...
>  git trees
>...


This patch makes the needlessly global tifm_sd_set_dma_data() static.

Signed-off-by: Adrian Bunk <bunk@stusta.de>

---
--- linux-2.6.21-rc7-mm2/drivers/mmc/host/tifm_sd.c.old	2007-04-28 01:36:33.000000000 +0200
+++ linux-2.6.21-rc7-mm2/drivers/mmc/host/tifm_sd.c	2007-04-28 01:36:41.000000000 +0200
@@ -259,7 +259,7 @@
 	}
 }
 
-int tifm_sd_set_dma_data(struct tifm_sd *host, struct mmc_data *r_data)
+static int tifm_sd_set_dma_data(struct tifm_sd *host, struct mmc_data *r_data)
 {
 	struct tifm_dev *sock = host->dev;
 	unsigned int t_size = TIFM_DMA_TSIZE * r_data->blksz;

