Return-Path: <linux-kernel-owner+w=401wt.eu-S1754311AbZKHQEm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311AbZKHQEm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:04:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZKHQEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:04:41 -0500
Received: from mail.issp.bas.bg ([195.96.236.10]:42161 "EHLO mail.issp.bas.bg"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751484AbZKHQEl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:04:41 -0500
From: Marin Mitov <mitov@issp.bas.bg>
Organization: Institute of Solid State Physics
To: Daniel Gloeckner <dg@emlix.com>
Subject: [PATCH]Use DMA_BIT_MASK(32) instead of deprecated DMA_32BIT_MASK
Date: Sun, 8 Nov 2009 18:03:07 +0200
User-Agent: KMail/1.11.4 (Linux/2.6.32-rc6; KDE/4.2.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200911081803.07386.mitov@issp.bas.bg>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Use DMA_BIT_MASK(32) instead of deprecated DMA_32BIT_MASK

Signed-off-by: Marin Mitov <mitov@issp.bas.bg>

=========================================================
--- sound/soc/s6000/s6000-pcm.c.orig	2009-11-08 17:49:09.000000000 +0200
+++ sound/soc/s6000/s6000-pcm.c	2009-11-08 17:50:56.000000000 +0200
@@ -423,7 +423,7 @@
 	snd_pcm_lib_preallocate_free_for_all(pcm);
 }
 
-static u64 s6000_pcm_dmamask = DMA_32BIT_MASK;
+static u64 s6000_pcm_dmamask = DMA_BIT_MASK(32);
 
 static int s6000_pcm_new(struct snd_card *card,
 			 struct snd_soc_dai *dai, struct snd_pcm *pcm)
@@ -435,7 +435,7 @@
 	if (!card->dev->dma_mask)
 		card->dev->dma_mask = &s6000_pcm_dmamask;
 	if (!card->dev->coherent_dma_mask)
-		card->dev->coherent_dma_mask = DMA_32BIT_MASK;
+		card->dev->coherent_dma_mask = DMA_BIT_MASK(32);
 
 	if (params->dma_in) {
 		s6dmac_disable_chan(DMA_MASK_DMAC(params->dma_in),
