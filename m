Return-Path: <linux-kernel-owner+w=401wt.eu-S1756552AbYGWXlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756552AbYGWXlX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 19:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754732AbYGWXlK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 19:41:10 -0400
Received: from tim.rpsys.net ([194.106.48.114]:44441 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274AbYGWXlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 19:41:08 -0400
Subject: [GIT PULL] LED updates for 2.6.26
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 24 Jul 2008 00:39:44 +0100
Message-Id: <1216856384.7981.70.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the led tree updates for 2.6.26. This includes a couple of new LED
drivers and various bug fixes/tweaks. These have seen extensive testing
in -mm/-next.

Thanks, Richard

 arch/arm/mach-iop32x/n2100.c  |   52 +++++
 drivers/leds/Kconfig          |   16 +
 drivers/leds/Makefile         |    2 
 drivers/leds/led-triggers.c   |    3 
 drivers/leds/leds-atmel-pwm.c |    2 
 drivers/leds/leds-h1940.c     |    9 
 drivers/leds/leds-pca9532.c   |  337 ++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-pca955x.c   |  384 ++++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-pca9532.h  |   45 ++++
 include/linux/leds.h          |   16 +
 10 files changed, 860 insertions(+), 6 deletions(-)

Anton Vorontsov (1):
      leds: mark led_classdev.default_trigger as const

Ben Dooks (1):
      leds: Fix sparse warnings in leds-h1940 driver

Dmitry Baryshkov (1):
      leds: Ensure led->trigger is set earlier

Li Zefan (1):
      leds: fix unsigned value overflow in atmel pwm driver

Nate Case (1):
      leds: Add support for Philips PCA955x I2C LED drivers

Riku Voipio (2):
      leds: Add pca9532 led driver
      leds: Add pca9532 platform data for Thecus N2100


