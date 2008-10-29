Return-Path: <linux-kernel-owner+w=401wt.eu-S1753543AbYJ2Jqu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543AbYJ2Jqu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 05:46:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753135AbYJ2Jqm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 05:46:42 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:41653 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752641AbYJ2Jql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 05:46:41 -0400
From: Wolfram Sang <w.sang@pengutronix.de>
To: rpurdie@rpsys.net
Cc: linux-kernel@vger.kernel.org, Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH] led/leds.h: trivial - make naming consistent
Date: Wed, 29 Oct 2008 10:46:57 +0100
Message-Id: <1225273617-31798-1-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.5.6.5
X-SA-Exim-Connect-IP: 10.1.0.89
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is one place where the struct led_classdev as the function
argument is named differently. Fix it.

Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 include/linux/leds.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/leds.h b/include/linux/leds.h
index d3a73f5..3c1a8ce 100644
--- a/include/linux/leds.h
+++ b/include/linux/leds.h
@@ -62,7 +62,7 @@ struct led_classdev {
 
 extern int led_classdev_register(struct device *parent,
 				 struct led_classdev *led_cdev);
-extern void led_classdev_unregister(struct led_classdev *lcd);
+extern void led_classdev_unregister(struct led_classdev *led_cdev);
 extern void led_classdev_suspend(struct led_classdev *led_cdev);
 extern void led_classdev_resume(struct led_classdev *led_cdev);
 
-- 
1.5.6.5

