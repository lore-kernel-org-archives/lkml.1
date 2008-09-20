Return-Path: <linux-kernel-owner+w=401wt.eu-S1753352AbYITJ6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753352AbYITJ6k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYITJ6e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:58:34 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:48221 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236AbYITJ6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:58:33 -0400
Date: Sat, 20 Sep 2008 11:58:23 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] leds-pca9532: Mark pca9532_event() static
Message-ID: <alpine.LNX.2.00.0809201156580.22510@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 20 Sep 2008 09:58:32 +0000
	Bayes: 0.4959 Tokens: new, 146; hammy, 2; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4959]
X-Spam-Signature: 065e7b18c6c4c621bcee0ec8828f5aa02c8b0c04
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-pca9532.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 4064d4f..f0883e6 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -151,8 +151,8 @@ static int pca9532_set_blink(struct led_classdev *led_cdev,
 	return pca9532_setpwm(client, 0, psc, led_cdev->brightness);
 }
 
-int pca9532_event(struct input_dev *dev, unsigned int type, unsigned int code,
-	int value)
+static int pca9532_event(struct input_dev *dev, unsigned int type,
+	unsigned int code, int value)
 {
 	struct pca9532_data *data = input_get_drvdata(dev);
 
