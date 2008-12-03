Return-Path: <linux-kernel-owner+w=401wt.eu-S1755859AbYLCHYf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755859AbYLCHYf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:24:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752991AbYLCHY1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:24:27 -0500
Received: from smtp1.stealer.net ([88.198.224.204]:60620 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240AbYLCHY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:24:26 -0500
Date: Wed, 3 Dec 2008 08:24:19 +0100 (CET)
From: Sven Wegener <sven.wegener@stealer.net>
To: rpurdie@rpsys.net
cc: linux-kernel@vger.kernel.org
Subject: [PATCH] leds-ams-delta: Fix sparse warning
Message-ID: <alpine.LNX.2.00.0812030823440.23445@titan.stealer.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
Organization: STEALER.net
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Score: 0.1
X-Spam-Bar: /
X-Spam-Report: Scanned by SpamAssassin 3.2.1-gr1 2007-05-02 on smtp1.stealer.net at Wed, 03 Dec 2008 07:24:25 +0000
	Bayes: 0.4828 Tokens: new, 131; hammy, 3; neutral, 1; spammy, 1.
	AutoLearn: no
	*  0.1 RDNS_NONE Delivered to trusted network by a host with no rDNS
	*  0.0 BAYES_50 BODY: Bayesian spam probability is 40 to 60%
	*      [score: 0.4828]
X-Spam-Signature: d3380d010515a10edb44bab4b9e851e88e72cc4a
X-DomainKey-Status: no signature
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/leds/leds-ams-delta.c:154:2: warning: returning void-valued expression

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 drivers/leds/leds-ams-delta.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-ams-delta.c b/drivers/leds/leds-ams-delta.c
index 61b2a8a..072157c 100644
--- a/drivers/leds/leds-ams-delta.c
+++ b/drivers/leds/leds-ams-delta.c
@@ -151,7 +151,7 @@ static int __init ams_delta_led_init(void)
 
 static void __exit ams_delta_led_exit(void)
 {
-	return platform_driver_unregister(&ams_delta_led_driver);
+	platform_driver_unregister(&ams_delta_led_driver);
 }
 
 module_init(ams_delta_led_init);
