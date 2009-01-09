Return-Path: <linux-kernel-owner+w=401wt.eu-S1756047AbZAILgc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047AbZAILgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2009 06:36:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752791AbZAILgK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Jan 2009 06:36:10 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:53441 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698AbZAILgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2009 06:36:08 -0500
X-Greylist: delayed 821 seconds by postgrey-1.27 at vger.kernel.org; Fri, 09 Jan 2009 06:36:06 EST
Subject: [GIT PULL] LED updates for 2.6.29
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 09 Jan 2009 11:23:06 +0000
Message-Id: <1231500186.5317.9.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.29. This includes some new drivers,
bugfixes and a core improvement resulting in nicer code.

Thanks, Richard

 drivers/leds/Kconfig                 |   15 +
 drivers/leds/Makefile                |    2 
 drivers/leds/led-class.c             |   24 ++
 drivers/leds/leds-alix2.c            |  181 ++++++++++++++++++++
 drivers/leds/leds-ams-delta.c        |   33 ---
 drivers/leds/leds-clevo-mail.c       |   21 --
 drivers/leds/leds-fsg.c              |   37 ----
 drivers/leds/leds-gpio.c             |   36 ----
 drivers/leds/leds-hp-disk.c          |   20 --
 drivers/leds/leds-hp6xx.c            |   22 --
 drivers/leds/leds-net48xx.c          |   21 --
 drivers/leds/leds-pca9532.c          |   77 ++++++--
 drivers/leds/leds-s3c24xx.c          |   25 --
 drivers/leds/leds-wm8350.c           |  311 +++++++++++++++++++++++++++++++++++
 drivers/leds/leds-wrap.c             |   27 ---
 drivers/leds/ledtrig-timer.c         |    5 
 drivers/mfd/wm8350-core.c            |    3 
 drivers/regulator/wm8350-regulator.c |   91 ++++++++++
 include/linux/leds-pca9532.h         |    2 
 include/linux/leds.h                 |    5 
 include/linux/mfd/wm8350/pmic.h      |   36 ++++
 21 files changed, 749 insertions(+), 245 deletions(-)

Constantin Baranov (1):
      leds: ALIX.2 LEDs driver

Mark Brown (1):
      leds: Add WM8350 LED driver

Richard Purdie (1):
      leds: Add suspend/resume to the core class

Riku Voipio (1):
      leds: leds-pcs9532 - Move i2c work to a workqueque

Rodolfo Giometti (1):
      leds: ledtrig-timer - on deactivation hardware blinking should be disabled

Sven Wegener (5):
      leds: eds-pca9532: mark pca9532_event() static
      leds: Fixup kdoc comment to match parameter names
      leds: Fix sparse warning in leds-ams-delta
      leds: Fix wrong loop direction on removal in leds-ams-delta
      leds: leds-pca9532 - fix memory leak and properly handle errors

Wolfram Sang (1):
      leds: Make header variable naming consistent

Yoichi Yuasa (1):
      leds: fix Cobalt Raq LED dependency


-- 
Richard Purdie
Intel Open Source Technology Centre

