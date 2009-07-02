Return-Path: <linux-kernel-owner+w=401wt.eu-S1754248AbZGBGe5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbZGBGe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 02:34:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751072AbZGBGeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 02:34:50 -0400
Received: from mailhub4.uq.edu.au ([130.102.149.131]:56424 "EHLO
	mailhub4.uq.edu.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbZGBGet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 02:34:49 -0400
X-Greylist: delayed 1303 seconds by postgrey-1.27 at vger.kernel.org; Thu, 02 Jul 2009 02:34:49 EDT
From: monstr@monstr.eu
To: linux-kernel@vger.kernel.org
Cc: raph@8d.com, dbrownell@users.sourceforge.net, diego.dompe@ridgerun.com,
       rpurdie@linux.intel.com, grant.likely@secretlab.ca,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH] leds: gpio-leds: Fix typographics fault
Date: Thu,  2 Jul 2009 16:12:35 +1000
Message-Id: <1246515155-23823-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.3.5
X-Spam-Score: 0 () 
X-ITEE-Spam-Score: 0 () 
X-UQ-FilterTime: 1246515167
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 drivers/leds/leds-gpio.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/leds/leds-gpio.c b/drivers/leds/leds-gpio.c
index 6b06638..107e5ae 100644
--- a/drivers/leds/leds-gpio.c
+++ b/drivers/leds/leds-gpio.c
@@ -80,7 +80,7 @@ static int __devinit create_gpio_led(const struct gpio_led *template,
 
 	/* skip leds that aren't available */
 	if (!gpio_is_valid(template->gpio)) {
-		printk(KERN_INFO "Skipping unavilable LED gpio %d (%s)\n", 
+		printk(KERN_INFO "Skipping unavailable LED gpio %d (%s)\n", 
 				template->gpio, template->name);
 		return 0;
 	}
-- 
1.5.5.1

