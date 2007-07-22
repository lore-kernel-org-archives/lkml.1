Return-Path: <linux-kernel-owner+w=401wt.eu-S1762726AbXGVPBX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726AbXGVPBX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 11:01:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbXGVPBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 11:01:14 -0400
Received: from tim.rpsys.net ([194.106.48.114]:55607 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756AbXGVPBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 11:01:12 -0400
Subject: [GIT PULL #2] LED updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sun, 22 Jul 2007 16:00:26 +0100
Message-Id: <1185116426.6819.33.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

This adds a couple of new LED drivers and converts the LED class away
from struct class_device as well as some bug fixes. Most of this has
been in -mm for a while as it just missed the 2.6.22 merge window.

Thanks,

Richard (LED maintainer)

 arch/avr32/boards/atngw100/setup.c    |   31 +++++
 arch/avr32/configs/atngw100_defconfig |   16 ++
 drivers/leds/Kconfig                  |   22 ++-
 drivers/leds/Makefile                 |    1 
 drivers/leds/led-class.c              |   49 +++-----
 drivers/leds/led-triggers.c           |   27 +++-
 drivers/leds/leds-gpio.c              |  199 ++++++++++++++++++++++++++++++++++
 drivers/leds/leds-locomo.c            |    2 
 drivers/leds/leds.h                   |    8 -
 drivers/leds/ledtrig-timer.c          |   49 +++-----
 include/linux/leds.h                  |   17 ++
 11 files changed, 343 insertions(+), 78 deletions(-)

David Brownell (2):
      leds: Teach leds-gpio to handle timer-unsafe GPIOs
      leds: leds-gpio for ngw100

Jan Engelhardt (1):
      leds: Use menuconfig objects II - LED

Raphael Assenat (1):
      leds: Add generic GPIO LED driver

Richard Purdie (3):
      leds: Fix trigger unregister_simple if register_simple fails
      leds: Add warning printks in error paths
      leds: Convert from struct class_device to struct device


