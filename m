Return-Path: <linux-kernel-owner+w=401wt.eu-S1754241Ab0AaUCs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241Ab0AaUCs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 15:02:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754191Ab0AaUCk
	(ORCPT <rfc822;linux-kernel-outgoing-6734>);
	Sun, 31 Jan 2010 15:02:40 -0500
Received: from mail.perches.com ([173.55.12.10]:1660 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754151Ab0AaUCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 15:02:25 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: [PATCH 10/10] sound/soc/blackfin: Fix continuation line formats
Date: Sun, 31 Jan 2010 12:02:12 -0800
Message-Id: <aee58f4fc07709fe8a34021899e701824a0a6b53.1264967500.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1264967493.git.joe@perches.com>
References: <cover.1264967493.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/blackfin/bf5xx-ac97-pcm.c |    8 ++------
 sound/soc/blackfin/bf5xx-i2s-pcm.c  |    3 +--
 sound/soc/blackfin/bf5xx-tdm-pcm.c  |    3 +--
 3 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/sound/soc/blackfin/bf5xx-ac97-pcm.c b/sound/soc/blackfin/bf5xx-ac97-pcm.c
index cf0dfb7..67cbfe7 100644
--- a/sound/soc/blackfin/bf5xx-ac97-pcm.c
+++ b/sound/soc/blackfin/bf5xx-ac97-pcm.c
@@ -349,9 +349,7 @@ static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 			sport_handle->tx_dma_buf = dma_alloc_coherent(NULL, \
 				size, &sport_handle->tx_dma_phy, GFP_KERNEL);
 			if (!sport_handle->tx_dma_buf) {
-				pr_err("Failed to allocate memory for tx dma \
-					buf - Please increase uncached DMA \
-					memory region\n");
+				pr_err("Failed to allocate memory for tx dma buf - Please increase uncached DMA memory region\n");
 				return -ENOMEM;
 			} else
 				memset(sport_handle->tx_dma_buf, 0, size);
@@ -362,9 +360,7 @@ static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 			sport_handle->rx_dma_buf = dma_alloc_coherent(NULL, \
 				size, &sport_handle->rx_dma_phy, GFP_KERNEL);
 			if (!sport_handle->rx_dma_buf) {
-				pr_err("Failed to allocate memory for rx dma \
-					buf - Please increase uncached DMA \
-					memory region\n");
+				pr_err("Failed to allocate memory for rx dma buf - Please increase uncached DMA memory region\n");
 				return -ENOMEM;
 			} else
 				memset(sport_handle->rx_dma_buf, 0, size);
diff --git a/sound/soc/blackfin/bf5xx-i2s-pcm.c b/sound/soc/blackfin/bf5xx-i2s-pcm.c
index 62fbb84..c6c6a4a 100644
--- a/sound/soc/blackfin/bf5xx-i2s-pcm.c
+++ b/sound/soc/blackfin/bf5xx-i2s-pcm.c
@@ -207,8 +207,7 @@ static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 	buf->area = dma_alloc_coherent(pcm->card->dev, size,
 			&buf->addr, GFP_KERNEL);
 	if (!buf->area) {
-		pr_err("Failed to allocate dma memory \
-			Please increase uncached DMA memory region\n");
+		pr_err("Failed to allocate dma memory - Please increase uncached DMA memory region\n");
 		return -ENOMEM;
 	}
 	buf->bytes = size;
diff --git a/sound/soc/blackfin/bf5xx-tdm-pcm.c b/sound/soc/blackfin/bf5xx-tdm-pcm.c
index a8c73cb..5e03bb2 100644
--- a/sound/soc/blackfin/bf5xx-tdm-pcm.c
+++ b/sound/soc/blackfin/bf5xx-tdm-pcm.c
@@ -244,8 +244,7 @@ static int bf5xx_pcm_preallocate_dma_buffer(struct snd_pcm *pcm, int stream)
 	buf->area = dma_alloc_coherent(pcm->card->dev, size * 4,
 		&buf->addr, GFP_KERNEL);
 	if (!buf->area) {
-		pr_err("Failed to allocate dma memory \
-			Please increase uncached DMA memory region\n");
+		pr_err("Failed to allocate dma memory - Please increase uncached DMA memory region\n");
 		return -ENOMEM;
 	}
 	buf->bytes = size;
-- 
1.6.6.rc0.57.gad7a

