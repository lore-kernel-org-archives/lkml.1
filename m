Return-Path: <linux-kernel-owner+w=401wt.eu-S1753441AbYKQPpW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753441AbYKQPpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 10:45:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751745AbYKQPpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 10:45:09 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59527 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751461AbYKQPpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 10:45:08 -0500
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Richard Purdie <rpurdie@linux.intel.com>
Cc: Frederik Deweerdt <frederik.deweerdt@xprog.eu>,
       linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH] leds: Handle maximum current setting over maximum supported for WM8350
Date: Mon, 17 Nov 2008 15:45:07 +0000
Message-Id: <1226936707-24875-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <20081117152506.GA29949@gambetta>
References: <20081117152506.GA29949@gambetta>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
---
 drivers/leds/leds-wm8350.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-wm8350.c b/drivers/leds/leds-wm8350.c
index e6d1fb9..e38756d 100644
--- a/drivers/leds/leds-wm8350.c
+++ b/drivers/leds/leds-wm8350.c
@@ -262,7 +262,7 @@ static int wm8350_led_probe(struct platform_device *pdev)
 	led->isink = isink;
 	led->dcdc = dcdc;
 
-	for (i = 0; i < ARRAY_SIZE(isink_cur); i++)
+	for (i = 0; i < ARRAY_SIZE(isink_cur) - 1; i++)
 		if (isink_cur[i] >= pdata->max_uA)
 			break;
 	led->max_uA_index = i;
-- 
1.5.6.5

