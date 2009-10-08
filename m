Return-Path: <linux-kernel-owner+w=401wt.eu-S932637AbZJHPQN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbZJHPQN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 11:16:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932560AbZJHPQM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 11:16:12 -0400
Received: from mail.atmel.fr ([81.80.104.162]:51878 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932557AbZJHPQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 11:16:12 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: alsa-devel@alsa-project.org, broonie@opensource.wolfsonmicro.com,
       linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, sedji.gaouaou@atmel.com,
       Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH] sound: at91sam9g20ek_2mmc board uses same audio connexion as at91sam9g20ek
Date: Thu,  8 Oct 2009 18:19:49 +0200
Message-Id: <1255018789-3437-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The modified revision of at91sam9g20 Evaluation Kit rev. C and onwards share
with previous ones its audio connexion to Wolfson wm8731. Modify the SoC file
to extend the machine ID checking.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 sound/soc/atmel/sam9g20_wm8731.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/sound/soc/atmel/sam9g20_wm8731.c b/sound/soc/atmel/sam9g20_wm8731.c
index 885ba01..e028744 100644
--- a/sound/soc/atmel/sam9g20_wm8731.c
+++ b/sound/soc/atmel/sam9g20_wm8731.c
@@ -207,7 +207,7 @@ static int __init at91sam9g20ek_init(void)
 	struct clk *pllb;
 	int ret;
 
-	if (!machine_is_at91sam9g20ek())
+	if (!(machine_is_at91sam9g20ek() || machine_is_at91sam9g20ek_2mmc()))
 		return -ENODEV;
 
 	/*
-- 
1.5.6.5

