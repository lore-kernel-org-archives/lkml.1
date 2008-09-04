Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYIDI2U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYIDI2U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 04:28:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758045AbYIDIZp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 04:25:45 -0400
Received: from nwd2mail11.analog.com ([137.71.25.57]:65089 "EHLO
	nwd2mail11.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037AbYIDIZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 04:25:43 -0400
X-IronPort-AV: E=Sophos;i="4.32,320,1217822400"; 
   d="scan'208";a="59018002"
From: Bryan Wu <cooloney@kernel.org>
To: broonie@opensource.wolfsonmicro.com
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Cliff Cai <cliff.cai@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 1/1] ASoC codec: fix compiling error in ad1980 driver after ASoC API changed
Date: Thu,  4 Sep 2008 16:25:54 +0800
Message-Id: <1220516754-20865-1-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cliff Cai <cliff.cai@analog.com>

Signed-off-by: Cliff Cai <cliff.cai@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 sound/soc/codecs/ad1980.c |    2 +-
 sound/soc/codecs/ad1980.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/ad1980.c b/sound/soc/codecs/ad1980.c
index bfbab3d..4e09c1f 100644
--- a/sound/soc/codecs/ad1980.c
+++ b/sound/soc/codecs/ad1980.c
@@ -141,7 +141,7 @@ static int ac97_write(struct snd_soc_codec *codec, unsigned int reg,
 	return 0;
 }
 
-struct snd_soc_codec_dai ad1980_dai = {
+struct snd_soc_dai ad1980_dai = {
 	.name = "AC97",
 	.playback = {
 		.stream_name = "Playback",
diff --git a/sound/soc/codecs/ad1980.h b/sound/soc/codecs/ad1980.h
index 5d4710d..db6c850 100644
--- a/sound/soc/codecs/ad1980.h
+++ b/sound/soc/codecs/ad1980.h
@@ -17,7 +17,7 @@
 #define PR5		0x2000
 #define PR6		0x4000
 
-extern struct snd_soc_codec_dai ad1980_dai;
+extern struct snd_soc_dai ad1980_dai;
 extern struct snd_soc_codec_device soc_codec_dev_ad1980;
 
 #endif
-- 
1.5.6
