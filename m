Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753628Ab0BHJJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 04:09:56 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40595 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753134Ab0BHJJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 04:09:55 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org,
       Andrew Morton <akpm@linux-foundation.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Jani Nikula <ext-jani.1.nikula@nokia.com>,
       =?UTF-8?q?Daniel=20Gl=C3=B6ckner?= <dg@emlix.com>,
       Nate Case <ncase@xes-inc.com>,
       H Hartley Sweeten <hsweeten@visionengravers.com>,
       Daniel Silverstone <dsilvers@simtec.co.uk>,
       Arnd Bergmann <arnd@arndb.de>, Mike Frysinger <vapier@gentoo.org>
Subject: [PATCH 2/3] gpiolib: a gpio is unsigned, so use %u to print it
Date: Mon,  8 Feb 2010 10:09:39 +0100
Message-Id: <1265620180-14150-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.6.6
In-Reply-To: <20100203155558.GH11354@pengutronix.de>
References: <20100203155558.GH11354@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/gpio/gpiolib.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
index 8543685..20988c8 100644
--- a/drivers/gpio/gpiolib.c
+++ b/drivers/gpio/gpiolib.c
@@ -747,7 +747,7 @@ int gpio_export(unsigned gpio, bool direction_may_change)
 		struct device	*dev;
 
 		dev = device_create(&gpio_class, desc->chip->dev, MKDEV(0, 0),
-				desc, ioname ? ioname : "gpio%d", gpio);
+				desc, ioname ? ioname : "gpio%u", gpio);
 		if (!IS_ERR(dev)) {
 			status = sysfs_create_group(&dev->kobj,
 						&gpio_attr_group);
-- 
1.6.6

