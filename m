Return-Path: <linux-kernel-owner+w=401wt.eu-S1756816AbYKTRCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbYKTRCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 12:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756692AbYKTRBf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 12:01:35 -0500
Received: from rv-out-0506.google.com ([209.85.198.237]:3507 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755056AbYKTRBc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 12:01:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZbF4WzwNr3DUGXYUkch9P1rMN9fzIc1Lf/jLYUz+kgb8S9xoWBHdeu5kQRJ0XMvkwN
         TGQxRSH73MVXbphwsC+3eyrb62qlqiNSUoUq+MBpMfDvDGBxQfUZWz10Smkg3yoEEQSE
         4cr61D/mJVwpXUa4w9PtaqJ7tI5q1MGC6/C6k=
From: "Richard A. Holden III" <aciddeath@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jaroslav Kysela <perex@perex.cz>,
       Takashi Iwai <tiwai@suse.de>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       alsa-devel@alsa-project.org
Subject: [PATCH] Remove unused variable from tlv320aic23 codec
Date: Thu, 20 Nov 2008 11:03:23 -0700
Message-Id: <1227204203-32112-3-git-send-email-aciddeath@gmail.com>
X-Mailer: git-send-email 1.5.6.4
In-Reply-To: <1227204203-32112-2-git-send-email-aciddeath@gmail.com>
References: <1227204203-32112-1-git-send-email-aciddeath@gmail.com>
 <1227204203-32112-2-git-send-email-aciddeath@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove codec var from tlv320aic23_set_dai_sysclk, it is assigned to
but never read.

Signed-off-by: Richard A. Holden III <aciddeath@gmail.com>

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org
---
 sound/soc/codecs/tlv320aic23.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 44308da..45395d0 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -421,8 +421,6 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int tlv320aic23_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				      int clk_id, unsigned int freq, int dir)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
-
 	switch (freq) {
 	case 12000000:
 		return 0;
-- 
1.5.6.4

