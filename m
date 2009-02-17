Return-Path: <linux-kernel-owner+w=401wt.eu-S1756575AbZBQFTa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575AbZBQFTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 00:19:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754182AbZBQFSE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 00:18:04 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62197 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756099AbZBQFSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 00:18:03 -0500
Message-ID: <499A4877.6050600@cn.fujitsu.com>
Date: Tue, 17 Feb 2009 13:17:43 +0800
From: Wei Yongjun <yjwei@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Richard Purdie <rpurdie@linux.intel.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] leds: Fix typo of || to && in drivers/leds/leds-pca9532.c
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the typo of || to &&.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
---
 drivers/leds/leds-pca9532.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 76ec749..c4a1265 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -169,7 +169,7 @@ static int pca9532_event(struct input_dev *dev, unsigned int type,
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
-	if (type != EV_SND && (code != SND_BELL || code != SND_TONE))
+	if (type != EV_SND && code != SND_BELL && code != SND_TONE)
 		return -1;
 
 	/* XXX: allow different kind of beeps with psc/pwm modifications */
-- 
1.5.3.8




