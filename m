Return-Path: <linux-kernel-owner+w=401wt.eu-S1753697AbYLATNd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbYLATNd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 14:13:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753241AbYLATNS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 14:13:18 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:36955 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbYLATNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 14:13:17 -0500
Date: Mon, 1 Dec 2008 20:13:03 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds-ams-delta: Fix wrong loop direction on removal
Message-ID: <alpine.LNX.2.00.0812012011440.23445@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Mon, 01 Dec 2008 19:13:15 +0000
	Bayes: 0.5012 Tokens: new, 136; hammy, 1; neutral, 2; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5012]
X-Spam-Signature: 9ae6d9356c204fc63e8d5a0b7d22c95b26176d60
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We want to go upwards, not downwards.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-ams-delta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
index 1bd590b..61b2a8a 100644
--- a/drivers/leds/leds-ams-delta.c
+++ b/drivers/leds/leds-ams-delta.c
@@ -127,7 +127,7 @@ static int ams_delta_led_remove(struct platform_device *pdev)
 {
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(ams_delta_leds); i--)
+	for (i = 0; i < ARRAY_SIZE(ams_delta_leds); i++)
 		led_classdev_unregister(&ams_delta_leds[i].cdev);
 
 	return 0;
