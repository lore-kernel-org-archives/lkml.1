Return-Path: <linux-kernel-owner+w=401wt.eu-S1753138AbYITJ5Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138AbYITJ5Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2008 05:57:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYITJ5R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Sep 2008 05:57:17 -0400
Received: from smtp1.stealer.net ([88.198.224.204]:48208 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbYITJ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2008 05:57:16 -0400
Date: Sat, 20 Sep 2008 11:56:50 +0200 (CEST)
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH] leds-pca955x: Mark pca955x_led_set() static
Message-ID: <alpine.LNX.2.00.0809201155280.22510@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Sat, 20 Sep 2008 09:57:15 +0000
	Bayes: 0.5018 Tokens: new, 143; hammy, 1; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.5018]
X-Spam-Signature: e2c36942607c4fc19da54d47d284064fae0c30fe
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-pca955x.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-pca955x.c b/drivers/leds/leds-pca955x.c
index 146c069..e943e4d 100644
--- a/drivers/leds/leds-pca955x.c
+++ b/drivers/leds/leds-pca955x.c
@@ -226,7 +226,8 @@ static void pca955x_led_work(struct work_struct *work)
 	pca955x_write_ls(pca955x->client, chip_ls, ls);
 }
 
-void pca955x_led_set(struct led_classdev *led_cdev, enum led_brightness value)
+static void pca955x_led_set(struct led_classdev *led_cdev,
+				enum led_brightness value)
 {
 	struct pca955x_led *pca955x;
 
