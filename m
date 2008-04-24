Return-Path: <linux-kernel-owner+w=401wt.eu-S1752086AbYDXXoh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086AbYDXXoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 19:44:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752540AbYDXXo3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 19:44:29 -0400
Received: from tim.rpsys.net ([194.106.48.114]:59850 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723AbYDXXo2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 19:44:28 -0400
Subject: [GIT PULL] LED tree pull request
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 25 Apr 2008 00:44:04 +0100
Message-Id: <1209080644.28694.13.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.26. Most of the noise is from a
whitespace cleanup but there are also some core enhancements and some
driver tweaks all of which has been in -mm for a while.

I've also included a new driver which depended on ARM patches merging
and has therefore not been in -mm and a new LED trigger. 

Thanks, Richard

 Documentation/leds-class.txt      |   12 +
 drivers/leds/Kconfig              |   17 ++
 drivers/leds/Makefile             |    2 
 drivers/leds/led-class.c          |   12 +
 drivers/leds/led-core.c           |    4 
 drivers/leds/led-triggers.c       |  120 +++++++++--------
 drivers/leds/leds-clevo-mail.c    |   16 +-
 drivers/leds/leds-cobalt-qube.c   |    2 
 drivers/leds/leds-cobalt-raq.c    |    6 
 drivers/leds/leds-corgi.c         |   11 +
 drivers/leds/leds-fsg.c           |  261 ++++++++++++++++++++++++++++++++++++++
 drivers/leds/leds-gpio.c          |   15 ++
 drivers/leds/leds-h1940.c         |   64 ++++-----
 drivers/leds/leds-hp6xx.c         |    6 
 drivers/leds/leds-s3c24xx.c       |    4 
 drivers/leds/leds-spitz.c         |   11 +
 drivers/leds/leds.h               |   11 +
 drivers/leds/ledtrig-default-on.c |   45 ++++++
 drivers/leds/ledtrig-ide-disk.c   |    2 
 drivers/leds/ledtrig-timer.c      |   35 +++--
 include/linux/leds.h              |    6 
 21 files changed, 536 insertions(+), 126 deletions(-)

Henrique de Moraes Holschuh (1):
      leds: Add support to leds with readable status

Herbert Valerio Riedel (1):
      leds: enable support for blink_set() platform hook in leds-gpio

Mrton Nmeth (1):
      leds: Add mail LED support for "Clevo D400P"

Nick Forbes (1):
      leds: Add default-on trigger

Németh Márton (2):
      leds: disable triggers on brightness set
      leds: Cleanup various whitespace and code style issues

Richard Purdie (1):
      leds: Document the context brightness_set needs

Rod Whitby (1):
      leds: Add new driver for the LEDs on the Freecom FSG-3



