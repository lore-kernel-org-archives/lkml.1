Return-Path: <linux-kernel-owner+w=401wt.eu-S1756117AbZLNAWL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756117AbZLNAWL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 19:22:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090AbZLNAU6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 19:20:58 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34058 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754844AbZLMX5i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:57:38 -0500
From: re.emese@gmail.com
To: linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, sfr@canb.auug.org.au,
       benh@kernel.crashing.org, gregkh@suse.de, geoffrey.levand@am.sony.com,
       torvalds@linux-foundation.org
Subject: [PATCH 05/10] Constify struct dma_map_ops for 2.6.32-git-053fe57ac v2
Date: Mon, 14 Dec 2009 00:59:20 +0100
Message-Id: <c3fc8eaec7176bccaa9f3259a05af67385380088.1260662996.git.re.emese@gmail.com>
X-Mailer: git-send-email 1.6.5.3
In-Reply-To: <cover.1260662995.git.re.emese@gmail.com>
References: <cover.1260662995.git.re.emese@gmail.com>
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emese Revfy <re.emese@gmail.com>


Signed-off-by: Emese Revfy <re.emese@gmail.com>
---
 arch/powerpc/platforms/ps3/system-bus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/ps3/system-bus.c b/arch/powerpc/platforms/ps3/system-bus.c
index e34b305..20e48ec 100644
--- a/arch/powerpc/platforms/ps3/system-bus.c
+++ b/arch/powerpc/platforms/ps3/system-bus.c
@@ -694,7 +694,7 @@ static int ps3_dma_supported(struct device *_dev, u64 mask)
 	return mask >= DMA_BIT_MASK(32);
 }
 
-static struct dma_map_ops ps3_sb_dma_ops = {
+static const struct dma_map_ops ps3_sb_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_sb_map_sg,
@@ -704,7 +704,7 @@ static struct dma_map_ops ps3_sb_dma_ops = {
 	.unmap_page = ps3_unmap_page,
 };
 
-static struct dma_map_ops ps3_ioc0_dma_ops = {
+static const struct dma_map_ops ps3_ioc0_dma_ops = {
 	.alloc_coherent = ps3_alloc_coherent,
 	.free_coherent = ps3_free_coherent,
 	.map_sg = ps3_ioc0_map_sg,
-- 
1.6.5.3

