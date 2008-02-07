Return-Path: <linux-kernel-owner+w=401wt.eu-S1760081AbYBGKgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760081AbYBGKgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 05:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932237AbYBGKfx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 05:35:53 -0500
Received: from tim.rpsys.net ([194.106.48.114]:36412 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932277AbYBGKfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 05:35:50 -0500
Subject: [GIT PULL] LED updates
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 07 Feb 2008 10:35:03 +0000
Message-Id: <1202380503.9519.21.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.25. This includes a couple of new
drivers, removal of a now superseded driver, some extensions to some
existing drivers and some LED class enhancements/bugfixes. Most of this
has been testing in -mm for quite a while.

Thanks, Richard

 Documentation/leds-class.txt         |   29 +++-
 arch/arm/mach-ixp4xx/dsmg600-setup.c |    4 
 arch/arm/mach-ixp4xx/nas100d-setup.c |    6 
 arch/arm/mach-ixp4xx/nslu2-setup.c   |    8 -
 drivers/hwmon/applesmc.c             |    2 
 drivers/input/misc/wistron_btns.c    |    4 
 drivers/leds/Kconfig                 |   48 ++++++-
 drivers/leds/Makefile                |    3 
 drivers/leds/leds-ams-delta.c        |   12 -
 drivers/leds/leds-clevo-mail.c       |  219 +++++++++++++++++++++++++++++++++++
 drivers/leds/leds-corgi.c            |    4 
 drivers/leds/leds-gpio.c             |    2 
 drivers/leds/leds-hp6xx.c            |  120 +++++++++++++++++++
 drivers/leds/leds-ixp4xx-gpio.c      |  214 ----------------------------------
 drivers/leds/leds-locomo.c           |    4 
 drivers/leds/leds-net48xx.c          |    2 
 drivers/leds/leds-spitz.c            |    8 -
 drivers/leds/leds-tosa.c             |    4 
 drivers/leds/leds-wrap.c             |   47 ++++++-
 drivers/leds/ledtrig-timer.c         |   41 +++++-
 drivers/misc/asus-laptop.c           |    2 
 drivers/net/wireless/b43/leds.c      |    8 -
 include/linux/leds.h                 |    5 
 23 files changed, 519 insertions(+), 277 deletions(-)

Kristoffer Ericson (1):
      leds: Add HP Jornada 6xx driver

Michael Loeffler (1):
      leds: Add power LED to the wrap driver

Márton Németh (3):
      leds: Add clevo notebook LED driver
      leds: Add support for hardware accelerated LED flashing
      leds: hw acceleration for Clevo mail LED driver

Raphael Assenat (1):
      leds: Fix led-gpio active_low default brightness

Richard Purdie (1):
      leds: Standardise LED naming scheme

Rod Whitby (1):
      leds: Remove the now uneeded ixp4xx driver



