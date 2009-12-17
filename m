Return-Path: <linux-kernel-owner+w=401wt.eu-S1764353AbZLQQeW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764353AbZLQQeW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 11:34:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761695AbZLQQeR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 11:34:17 -0500
Received: from 93-97-173-237.zone5.bethere.co.uk ([93.97.173.237]:59408 "EHLO
	tim.rpsys.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759469AbZLQQeQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 11:34:16 -0500
Subject: [GIT PULL] LED updates for 2.6.33
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Thu, 17 Dec 2009 16:33:20 +0000
Message-Id: <1261067600.26215.36.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.33. This mainly includes new drivers
but also some bugfixes and tweaks. Most patches have been in -mm for a
while.

Thanks, Richard

 drivers/leds/Kconfig            |   33 ++
 drivers/leds/Makefile           |    4 
 drivers/leds/leds-adp5520.c     |  230 ++++++++++++++++
 drivers/leds/leds-alix2.c       |  115 ++++++--
 drivers/leds/leds-cobalt-qube.c |    4 
 drivers/leds/leds-cobalt-raq.c  |    2 
 drivers/leds/leds-lt3593.c      |  217 +++++++++++++++
 drivers/leds/leds-pwm.c         |    5 
 drivers/leds/leds-regulator.c   |  242 +++++++++++++++++
 drivers/leds/leds-ss4200.c      |  556 ++++++++++++++++++++++++++++++++++++++++
 include/linux/leds-lp3944.h     |    3 
 include/linux/leds-pca9532.h    |    2 
 include/linux/leds-regulator.h  |   46 +++
 13 files changed, 1418 insertions(+), 41 deletions(-)

Antonio Ospite (3):
      leds: Add LED class driver for regulator driven LEDs.
      leds: leds-pca9532.h- indent with tabs, not spaces
      leds: leds-lp3944.h - remove unneeded includes

Daniel Mack (2):
      leds: leds-alix2c - take port address from MSR
      leds: Add driver for LT3593 controlled LEDs

Dave Hansen (2):
      leds: LED driver for Intel NAS SS4200 series (v5)
      leds-ss4200: Check pci_enable_device return

Florian Fainelli (1):
      leds: use default-on trigger for Cobalt Qube

H Hartley Sweeten (2):
      leds: leds-cobalt-raq.c - use resource_size()
      leds: leds-cobalt-qube.c: use resource_size()

Lars-Peter Clausen (1):
      leds: leds-pwm: Set led_classdev max_brightness

Michael Hennerich (1):
      leds: Add driver for ADP5520/ADP5501 MFD PMICs

akpm@linux-foundation.org (1):
      leds: drivers/leds/leds-ss4200.c: fix return statement

-- 
Richard Purdie
Intel Open Source Technology Centre

