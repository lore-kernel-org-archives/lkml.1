Return-Path: <linux-kernel-owner+w=401wt.eu-S1754796AbZFWTbw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796AbZFWTbw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 15:31:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752365AbZFWTbm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 15:31:42 -0400
Received: from dan.rpsys.net ([93.97.175.187]:57046 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751315AbZFWTbm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 15:31:42 -0400
Subject: [GIT PULL] LED updates for 2.6.31
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Tue, 23 Jun 2009 20:29:19 +0100
Message-Id: <1245785359.26606.13.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.31. This is mainly minor
bugfixes/cleanups and also one new driver.

Thanks, Richard

 Documentation/leds-lp3944.txt                   |   50 ++
 Documentation/powerpc/dts-bindings/gpio/led.txt |   17 
 drivers/leds/Kconfig                            |   14 
 drivers/leds/Makefile                           |    1 
 drivers/leds/leds-alix2.c                       |    7 
 drivers/leds/leds-bd2802.c                      |   96 +++-
 drivers/leds/leds-gpio.c                        |   22 -
 drivers/leds/leds-lp3944.c                      |  466 ++++++++++++++++++++++++
 drivers/leds/leds-pca9532.c                     |   58 +-
 include/linux/leds-lp3944.h                     |   53 ++
 include/linux/leds.h                            |   14 
 11 files changed, 733 insertions(+), 65 deletions(-)

Antonio Ospite (2):
      leds: pca9532 - Indent using tabs, not spaces.
      leds: LED driver for National Semiconductor LP3944 Funlight Chip

Kim Kyuwon (3):
      leds: fix led-bd2802 errors while resuming
      leds: change the license information
      leds: add the sysfs interface into the leds-bd2802 driver for changing wave pattern and led current.

Mark Brown (1):
      leds: Further document parameters for blink_set()

Richard Purdie (2):
      leds: Remove an orphan Kconfig entry
      leds: Futher document blink_set

Tobias Mueller (1):
      leds: alix-leds2 fixed for Award BIOS

Trent Piepho (1):
      leds: Add options to have GPIO LEDs start on or keep their state

Zhenwen Xu (1):
      leds: leds-gpio - fix a section mismatch

-- 
Richard Purdie
Intel Open Source Technology Centre

