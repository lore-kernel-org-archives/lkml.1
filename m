Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab0BBHWn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Feb 2010 02:22:43 -0500
Received: from mail.perches.com ([173.55.12.10]:1767 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755586Ab0BBHW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Feb 2010 02:22:26 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: [PATCH 10/10] sound/soc/s3c24xx/s2c-pcm.c: Fix continuation line formats
Date: Mon,  1 Feb 2010 23:22:16 -0800
Message-Id: <56a3bdf490f3fe20c266b43bdc070c7af65b14b9.1265095094.git.joe@perches.com>
X-Mailer: git-send-email 1.6.6.rc0.57.gad7a
In-Reply-To: <cover.1265095093.git.joe@perches.com>
References: <cover.1265095093.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

String constants that are continued on subsequent lines with \
are not good.

Signed-off-by: Joe Perches <joe@perches.com>
---
 sound/soc/s3c24xx/s3c-pcm.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/sound/soc/s3c24xx/s3c-pcm.c b/sound/soc/s3c24xx/s3c-pcm.c
index 9e61a7c..a98f40c 100644
--- a/sound/soc/s3c24xx/s3c-pcm.c
+++ b/sound/soc/s3c24xx/s3c-pcm.c
@@ -229,8 +229,7 @@ static int s3c_pcm_hw_params(struct snd_pcm_substream *substream,
 
 	spin_unlock_irqrestore(&pcm->lock, flags);
 
-	dev_dbg(pcm->dev, "PCMSOURCE_CLK-%lu SCLK=%ufs \
-				SCLK_DIV=%d SYNC_DIV=%d\n",
+	dev_dbg(pcm->dev, "PCMSOURCE_CLK-%lu SCLK=%ufs SCLK_DIV=%d SYNC_DIV=%d\n",
 				clk_get_rate(clk), pcm->sclk_per_fs,
 				sclk_div, sync_div);
 
-- 
1.6.6.rc0.57.gad7a

