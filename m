Return-Path: <linux-kernel-owner+w=401wt.eu-S1756634AbZDFPs7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634AbZDFPs7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 11:48:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752467AbZDFPst
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 11:48:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:31009 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452AbZDFPst (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 11:48:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.39,331,1235980800"; 
   d="scan'208";a="400754756"
Subject: [GIT PULL] LED updates for 2.6.30
From: Richard Purdie <rpurdie@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Date: Mon, 06 Apr 2009 16:49:26 +0100
Message-Id: <1239032966.5323.55.camel@dax.rpnet.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Could you please pull from:

git://git.o-hand.com/linux-rpurdie-leds for-linus

for the LED tree updates for 2.6.30. The bulk of the changes are a new
driver, new gpio trigger and extending the gpio driver to handle
openfirmware devices for powerpc along with several cleanups/fixes. Most
of this has been tested in -next/-mm for a while.

Thanks, Richard

 Documentation/powerpc/dts-bindings/gpio/led.txt |   46 +
 drivers/leds/Kconfig                            |   75 ++
 drivers/leds/Makefile                           |    7 
 drivers/leds/led-class.c                        |   21 
 drivers/leds/led-triggers.c                     |   10 
 drivers/leds/leds-bd2802.c                      |  765 ++++++++++++++++++++++++
 drivers/leds/leds-dac124s085.c                  |  150 ++++
 drivers/leds/leds-gpio.c                        |  225 +++++--
 drivers/leds/leds-h1940.c                       |    2 
 drivers/leds/leds-pca9532.c                     |    2 
 drivers/leds/leds-pwm.c                         |  153 ++++
 drivers/leds/leds-rb532.c                       |   77 ++
 drivers/leds/leds-s3c24xx.c                     |    7 
 drivers/leds/leds.h                             |    4 
 drivers/leds/ledtrig-default-on.c               |    2 
 drivers/leds/ledtrig-gpio.c                     |  239 +++++++
 drivers/leds/ledtrig-heartbeat.c                |    4 
 drivers/leds/ledtrig-ide-disk.c                 |    3 
 drivers/leds/ledtrig-timer.c                    |    2 
 include/linux/leds-bd2802.h                     |   26 
 include/linux/leds.h                            |    4 
 include/linux/leds_pwm.h                        |   21 
 22 files changed, 1772 insertions(+), 73 deletions(-)

Adam Nielsen (1):
      leds: Prevent multiple LED triggers with the same name

David Brownell (1):
      leds: just ignore invalid GPIOs in leds-gpio

Felipe Balbi (2):
      leds: Add gpio-led trigger
      leds: introduce lp5521 led driver

Guennadi Liakhovetski (2):
      leds: allow led-drivers to use a variable range of brightness values
      leds: Add dac124s085 driver

Kim Kyuwon (1):
      leds: add BD2802GU LED driver

Luotao Fu (1):
      leds: simple driver for pwm driven LEDs

Németh Márton (1):
      leds: remove experimental flag from leds-clevo-mail

Phil Sutter (1):
      leds: Add rb532 LED driver for the User LED

Richard Purdie (2):
      leds: Fix leds-gpio driver multiple module_init/exit usage
      leds: Add suspend/resume state flags to leds-gpio

Riku Voipio (1):
      leds: Fix &&/|| confusion in leds-pca9532.c

Trent Piepho (1):
      leds: Add openfirmware platform device support

Uwe Kleine-König (1):
      leds: move h1940-leds's probe function to .devinit.text

Zhenwen Xu (1):
      leds: remove an unnecessary "goto" on drivers/leds/leds-s3c24.c


