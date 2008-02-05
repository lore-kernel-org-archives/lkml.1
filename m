Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbYBEKTz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbYBEKTz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 05:19:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757042AbYBEKTq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 05:19:46 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43899 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757031AbYBEKTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 05:19:45 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
       Liam Girdwood <liam.girdwood@wolfsonmicro.com>,
       Roel Kluin <12o3l@tiscali.nl>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] duplicate strcasecmp test for "rj-master" in mpc8610_hpcd_probe()
Date: Tue,  5 Feb 2008 10:19:43 +0000
Message-Id: <1202206783-22390-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.4
In-Reply-To: <47A79D09.6090806@freescale.com>
References: <47A79D09.6090806@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <12o3l@tiscali.nl>

In linus' git tree I found this problem. Is it also in the alsa tree?
please confirm it's the right fix. The patch was not yet tested.

Signed-off-by: Roel Kluin <12o3l@tiscali.nl>
Acked-by: Timur Tabi <timur@freescale.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
Applied to the ASoC tree too.

 sound/soc/fsl/mpc8610_hpcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/fsl/mpc8610_hpcd.c b/sound/soc/fsl/mpc8610_hpcd.c
index f26c4b2..a00aac7 100644
--- a/sound/soc/fsl/mpc8610_hpcd.c
+++ b/sound/soc/fsl/mpc8610_hpcd.c
@@ -315,7 +315,7 @@ static int mpc8610_hpcd_probe(struct of_device *ofdev,
 		machine_data->dai_format = SND_SOC_DAIFMT_LEFT_J;
 		machine_data->codec_clk_direction = SND_SOC_CLOCK_IN;
 		machine_data->cpu_clk_direction = SND_SOC_CLOCK_OUT;
-	} else if (strcasecmp(sprop, "rj-master") == 0) {
+	} else if (strcasecmp(sprop, "rj-slave") == 0) {
 		machine_data->dai_format = SND_SOC_DAIFMT_RIGHT_J;
 		machine_data->codec_clk_direction = SND_SOC_CLOCK_OUT;
 		machine_data->cpu_clk_direction = SND_SOC_CLOCK_IN;
-- 
1.5.4

