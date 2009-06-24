Return-Path: <linux-kernel-owner+w=401wt.eu-S1754286AbZFXWiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286AbZFXWiR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 18:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZFXWhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 18:37:52 -0400
Received: from kroah.org ([198.145.64.141]:47858 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752239AbZFXWhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 18:37:51 -0400
Date: Wed, 24 Jun 2009 15:33:43 -0700
From: Greg KH <greg@kroah.com>
To: asdf@kroah.com, Richard Purdie <rpurdie@rpsys.net>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Guennadi Liakhovetski <lg@denx.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] LED: Reply-To: use correct name for
	/sys/devices/virtual/leds/ entries
Message-ID: <20090624223343.GA17235@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olh@suse.de>

This is needed to get kde-powersave to work properly on some g4
powerbooks.

From: Olaf Hering <olh@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
This has been shipping in the SuSE kernels for a while.  I do not know
why it was not sent to you previously, sorry - gregkh

 drivers/leds/leds-cobalt-qube.c   |    2 +-
 drivers/leds/leds-cobalt-raq.c    |    4 ++--
 drivers/leds/ledtrig-default-on.c |    2 +-
 drivers/macintosh/via-pmu-led.c   |    2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/leds/leds-cobalt-qube.c
+++ b/drivers/leds/leds-cobalt-qube.c
@@ -28,7 +28,7 @@ static void qube_front_led_set(struct le
 }
 
 static struct led_classdev qube_front_led = {
-	.name			= "qube-front",
+	.name			= "qube::front",
 	.brightness		= LED_FULL,
 	.brightness_set		= qube_front_led_set,
 	.default_trigger	= "ide-disk",
--- a/drivers/leds/leds-cobalt-raq.c
+++ b/drivers/leds/leds-cobalt-raq.c
@@ -49,7 +49,7 @@ static void raq_web_led_set(struct led_c
 }
 
 static struct led_classdev raq_web_led = {
-	.name		= "raq-web",
+	.name		= "raq::web",
 	.brightness_set	= raq_web_led_set,
 };
 
@@ -70,7 +70,7 @@ static void raq_power_off_led_set(struct
 }
 
 static struct led_classdev raq_power_off_led = {
-	.name			= "raq-power-off",
+	.name			= "raq::power-off",
 	.brightness_set		= raq_power_off_led_set,
 	.default_trigger	= "power-off",
 };
--- a/drivers/leds/ledtrig-default-on.c
+++ b/drivers/leds/ledtrig-default-on.c
@@ -23,7 +23,7 @@ static void defon_trig_activate(struct l
 }
 
 static struct led_trigger defon_led_trigger = {
-	.name     = "default-on",
+	.name     = "default::on",
 	.activate = defon_trig_activate,
 };
 
--- a/drivers/macintosh/via-pmu-led.c
+++ b/drivers/macintosh/via-pmu-led.c
@@ -72,7 +72,7 @@ static void pmu_led_set(struct led_class
 }
 
 static struct led_classdev pmu_led = {
-	.name = "pmu-front-led",
+	.name = "pmu-led::front",
 #ifdef CONFIG_ADB_PMU_LED_IDE
 	.default_trigger = "ide-disk",
 #endif
