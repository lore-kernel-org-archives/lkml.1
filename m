Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbZIZQLV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbZIZQLV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:11:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752976AbZIZQLS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:11:18 -0400
Received: from dan.rpsys.net ([93.97.175.187]:61426 "EHLO dan.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752156AbZIZQLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:11:15 -0400
Subject: [GIT PULL] LED updates for 2.6.32
From: Richard Purdie <rpurdie@rpsys.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Sat, 26 Sep 2009 17:10:51 +0100
Message-Id: <1253981451.7598.61.camel@ted>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.32. This is mainly minor
bugfixes/cleanups and also one new driver.

Thanks, Richard

 drivers/leds/Kconfig              |   13 +-
 drivers/leds/Makefile             |    1 +
 drivers/leds/leds-clevo-mail.c    |    2 +-
 drivers/leds/leds-cobalt-qube.c   |    2 +-
 drivers/leds/leds-cobalt-raq.c    |    4 +-
 drivers/leds/leds-gpio.c          |    2 +-
 drivers/leds/leds-pca9532.c       |   12 +-
 drivers/leds/leds-wm831x-status.c |  341 +++++++++++++++++++++++++++++++++++++
 drivers/leds/ledtrig-gpio.c       |   28 ++--
 drivers/macintosh/via-pmu-led.c   |    2 +-
 include/linux/mfd/wm831x/status.h |   34 ++++
 11 files changed, 412 insertions(+), 29 deletions(-)
 create mode 100644 drivers/leds/leds-wm831x-status.c
 create mode 100644 include/linux/mfd/wm831x/status.h

Antonio Ospite (1):
      leds: Fix indentation in LEDS_LP3944 Kconfig entry

Mark Brown (1):
      leds: Add WM831x status LED driver

Michal Simek (1):
      leds: gpio-leds: fix typographics fault

Olaf Hering (1):
      leds: Fix LED names

Richard Purdie (1):
      leds: Fix leds-pca9532 whitespace issues

Thadeu Lima de Souza Cascardo (1):
      leds: fix coding style in worker thread code for ledtrig-gpio.

Uwe Kleine-König (1):
      leds: move leds-clevo-mail's probe function to .devinit.text


-- 
Richard Purdie
Intel Open Source Technology Centre

