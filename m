Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZGNR6M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZGNR6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 13:58:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbZGNR6M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 13:58:12 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:51212 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752425AbZGNR6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 13:58:11 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: me@felipebalbi.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org, rpurdie@linux.intel.com,
       rpurdie@rpsys.net, srcvale@holoscopio.com,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] Trivial: Fix coding style in worker thread code for ledtrig-gpio.
Date: Tue, 14 Jul 2009 14:58:00 -0300
Message-Id: <1247594280-3643-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1247591015-2428-1-git-send-email-cascardo@holoscopio.com>
References: <1247591015-2428-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Signed-off-by: Samuel R. C. Vale <srcvale@holoscopio.com>
---
 drivers/leds/ledtrig-gpio.c |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/leds/ledtrig-gpio.c b/drivers/leds/ledtrig-gpio.c
index 1bc5db4..f591337 100644
--- a/drivers/leds/ledtrig-gpio.c
+++ b/drivers/leds/ledtrig-gpio.c
@@ -44,22 +44,22 @@ static void gpio_trig_work(struct work_struct *work)
 			struct gpio_trig_data, work);
 	int tmp;
 
-       if (!gpio_data->gpio)
-	       return;
-
-       tmp = gpio_get_value(gpio_data->gpio);
-       if (gpio_data->inverted)
-	       tmp = !tmp;
-
-       if (tmp) {
-               if (gpio_data->desired_brightness)
-                       led_set_brightness(gpio_data->led,
-                                       gpio_data->desired_brightness);
-               else
-                       led_set_brightness(gpio_data->led, LED_FULL);
-       } else {
-               led_set_brightness(gpio_data->led, LED_OFF);
-       }
+	if (!gpio_data->gpio)
+		return;
+
+	tmp = gpio_get_value(gpio_data->gpio);
+	if (gpio_data->inverted)
+		tmp = !tmp;
+
+	if (tmp) {
+		if (gpio_data->desired_brightness)
+			led_set_brightness(gpio_data->led,
+					   gpio_data->desired_brightness);
+		else
+			led_set_brightness(gpio_data->led, LED_FULL);
+	} else {
+		led_set_brightness(gpio_data->led, LED_OFF);
+	}
 }
 
 static ssize_t gpio_trig_brightness_show(struct device *dev,
-- 
1.6.3.3

