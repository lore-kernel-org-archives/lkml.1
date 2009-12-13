Return-Path: <linux-kernel-owner+w=401wt.eu-S1754679AbZLMXxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754679AbZLMXxI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:53:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbZLMXxH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:53:07 -0500
Received: from mga10.intel.com ([192.55.52.92]:34159 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753139AbZLMXxE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:53:04 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,391,1257148800"; 
   d="scan'208";a="755734979"
Date: Mon, 14 Dec 2009 00:54:32 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Rajendra Nayak <rnayak@ti.com>, Balaji T K <balajitk@ti.com>,
       Santosh Shilimkar <santosh.shilimkar@ti.com>,
       Liam Girdwood <lrg@slimlogic.co.uk>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Juha Keski-Saari <ext-juha.1.keski-saari@nokia.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Dan Carpenter <error27@gmail.com>, Alan Cox <alan@linux.intel.com>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Ilkka Koskinen <ilkka.koskinen@nokia.com>, Ben Dooks <ben@simtec.co.uk>,
       Lars-Peter Clausen <lars@metafoo.de>,
       Aaro Koskinen <aaro.koskinen@nokia.com>,
       Arnaud Patard <arnaud.patard@rtp-net.org>,
       Paul Fertser <fercerpav@gmail.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Haojian Zhuang <haojian.zhuang@marvell.com>,
       Jean Delvare <khali@linux-fr.org>,
       Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Subject: [GIT] [2.6.32] MFD pull request
Message-ID: <20091213235431.GA27219@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This is the MFD pull request for the 2.6.33 merge window.
With this round, we mainly get:

- Support for Marvell 88PM8607.
- Support for ST-Ericsson AB4500.
- Support for Analog Devices ADP5520.
- Support for Wolfson Electronics 8320.
- Initial TI twl6030 and twl5031 support.
- Several twl4030 cleanup patches.
- A big mc13783 rewrite.
- Our usual wm83xx cleanup round.

Thanks in advance for pulling the following bits:

The following changes since commit f40542532e96dda5506eb76badea322f2ae4731c:
  Linus Torvalds (1):
        Merge branch 'ixp4xx' of git://git.kernel.org/.../chris/linux-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Aaro Koskinen (1):
      mfd: fix undefined twl4030-power resconfig value checks

Alan Cox (1):
      mfd: Fix twl4030 warning

Amit Kucheria (6):
      mfd: twl4030-power: Rename DEVGROUP to DEV_GRP
      mfd: Add comments for the twl4030-power register and bit layout
      mfd: Add support for remapping twl4030-power power states
      mfd: Optimised twl4030-power power scripts for the rx51
      mfd: Fix more undefined twl4030-power resconfig value checks
      mfd: Clarify twl4030 return value for read and write

Antonio Ospite (2):
      mfd: ezx-pcap: Don't pass pcap pointer as subdev drvdata.
      mfd: Remove ezx-pcap defines for custom led gpio encoding

Arnaud Patard (1):
      mfd: Move pcf50633 messages to appropriate log levels

Balaji T K (4):
      mfd: Rename all twl4030_i2c*
      mfd: Rename twl4030_ routines in rtc-twl.c
      mfd: Add support for twl6030 irq framework
      rtc: Add twl6030 RTC support

Ben Dooks (2):
      mfd: Allow the board to choose any GPIO base for tps65010
      mfd: Allow configuration of VDCDC2 for tps65010

Dan Carpenter (1):
      mfd: Fix incorrect error check for wm8350-core

Haojian Zhuang (2):
      mfd: Add 88PM8607 driver
      mfd: Fix 88PM8607 I2C dependency

Ilkka Koskinen (2):
      mfd: Enable twl4030 32kHz oscillator low-power mode
      mfd: Initial support for twl5031

Jean Delvare (1):
      mfd: Don't abuse i2c_client.name

Juha Keski-Saari (1):
      mfd: Add all twl4030 regulators to the twl4030 mfd driver

Lars-Peter Clausen (5):
      mfd: Make pcf50633 suspend/resume belong to i2c_driver
      mfd: Fix memleak in pcf50633_client_dev_register
      mfd: Use platform_device_add_data to set pcf50633 regulator platform data
      mfd: Fix pcf50633-regulator drvdata usage
      mfd: Cleanup pcf50633_probe error handling

Linus Walleij (1):
      mfd: Remove default selection of AB4500

Mark Brown (14):
      mfd: Refactor WM831x chip identification
      gpiolib: Make WM831x GPIO count dynamic
      mfd: Add support for WM8320 PMICs
      mfd: Split wm8350 IRQ code into a separate file
      mfd: Convert WM835x IRQ handling to use a data table
      mfd: Staticise __adp5520_ack_bits()
      mfd: Allow platforms to specify an IRQ base for WM8350
      mfd: Convert wm8350 IRQ handlers to irq_handler_t
      mfd: Mask and unmask wm8350 IRQs on request and free
      mfd: Move WM831x to generic IRQ
      gpiolib: Implement gpio_to_irq() for wm831x
      mfd: Don't allow wm831x to be built as a module
      mfd: Force I2C to be built in when building WM831x
      mfd: Remove build time warning for WM835x register default tables

Michael Hennerich (4):
      backlight: adp5520: rename common defines and typos
      gpio: adp5520: rename common defines and typos
      mfd: Add ADP5520/ADP5501 driver
      input/keyboard: new driver for ADP5520 MFD PMICs

Paul Fertser (1):
      mfd: Disable unnecessary pcf50633 shutdown on lowsys

Rajendra Nayak (3):
      mfd: Rename twl4030_ routines in twl-regulator.c
      regulator: Add support for twl6030 regulators
      mfd: Add twl6030 regulator subdevices

Samuel Ortiz (1):
      mfd: Fix ab4500 compilation warnings

Santosh Shilimkar (1):
      mfd: Rename twl4030* driver files to enable re-use

Srinidhi Kasagar (1):
      mfd: add AB4500 driver

Uwe Kleine-König (3):
      mfd: Move asic3_remove to .devexit.text
      mfd: Near complete mc13783 rewrite
      mfd: Don't set mc13783 ADREFMODE for touch conversions

 arch/arm/mach-omap2/board-2430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-3430sdp.c                |    2 +-
 arch/arm/mach-omap2/board-ldp.c                    |    2 +-
 arch/arm/mach-omap2/board-omap3beagle.c            |    2 +-
 arch/arm/mach-omap2/board-omap3pandora.c           |    2 +-
 arch/arm/mach-omap2/board-overo.c                  |    2 +-
 arch/arm/mach-omap2/board-rx51-peripherals.c       |  118 ++-
 arch/arm/plat-omap/include/plat/irqs.h             |   16 +-
 drivers/gpio/adp5520-gpio.c                        |   36 +-
 drivers/gpio/twl4030-gpio.c                        |   20 +-
 drivers/gpio/wm831x-gpio.c                         |   17 +-
 drivers/input/keyboard/Kconfig                     |   10 +
 drivers/input/keyboard/Makefile                    |    1 +
 drivers/input/keyboard/adp5520-keys.c              |  220 ++++++
 drivers/input/keyboard/twl4030_keypad.c            |    6 +-
 drivers/input/misc/pcf50633-input.c                |    7 +-
 drivers/input/misc/twl4030-pwrbutton.c             |    4 +-
 drivers/mfd/88pm8607.c                             |  302 ++++++++
 drivers/mfd/Kconfig                                |   41 +-
 drivers/mfd/Makefile                               |    6 +-
 drivers/mfd/ab3100-core.c                          |    3 -
 drivers/mfd/ab4500-core.c                          |  208 ++++++
 drivers/mfd/adp5520.c                              |  379 ++++++++++
 drivers/mfd/asic3.c                                |    2 +-
 drivers/mfd/ezx-pcap.c                             |    1 -
 drivers/mfd/mc13783-core.c                         |  757 +++++++++++++-------
 drivers/mfd/pcf50633-adc.c                         |    5 +-
 drivers/mfd/pcf50633-core.c                        |   76 +-
 drivers/mfd/tps65010.c                             |   30 +-
 drivers/mfd/{twl4030-core.c => twl-core.c}         |  385 ++++++++---
 drivers/mfd/twl4030-irq.c                          |  158 ++++-
 drivers/mfd/twl4030-power.c                        |  126 +++-
 drivers/mfd/twl6030-irq.c                          |  299 ++++++++
 drivers/mfd/wm831x-core.c                          |  223 +++++-
 drivers/mfd/wm831x-irq.c                           |  209 +++---
 drivers/mfd/wm8350-core.c                          |  771 +-------------------
 drivers/mfd/wm8350-irq.c                           |  529 ++++++++++++++
 drivers/mfd/wm8350-regmap.c                        |    8 -
 drivers/power/pcf50633-charger.c                   |    3 +-
 drivers/power/wm8350_power.c                       |   63 +-
 drivers/regulator/Kconfig                          |    2 +-
 drivers/regulator/Makefile                         |    2 +-
 drivers/regulator/pcf50633-regulator.c             |    5 +-
 .../{twl4030-regulator.c => twl-regulator.c}       |  287 +++++---
 drivers/regulator/wm8350-regulator.c               |   10 +-
 drivers/rtc/Kconfig                                |    6 +-
 drivers/rtc/Makefile                               |    2 +-
 drivers/rtc/rtc-pcf50633.c                         |    5 +-
 drivers/rtc/{rtc-twl4030.c => rtc-twl.c}           |  284 +++++---
 drivers/rtc/rtc-wm8350.c                           |   25 +-
 drivers/usb/otg/twl4030-usb.c                      |   38 +-
 drivers/video/backlight/adp5520_bl.c               |  123 ++--
 drivers/video/omap/lcd_2430sdp.c                   |    4 +-
 drivers/watchdog/twl4030_wdt.c                     |    4 +-
 include/linux/i2c/tps65010.h                       |   19 +
 include/linux/i2c/{twl4030.h => twl.h}             |  209 +++++-
 include/linux/mfd/88pm8607.h                       |  217 ++++++
 include/linux/mfd/ab4500.h                         |  262 +++++++
 include/linux/mfd/adp5520.h                        |  299 ++++++++
 include/linux/mfd/ezx-pcap.h                       |    3 -
 include/linux/mfd/mc13783-private.h                |  208 +-----
 include/linux/mfd/mc13783.h                        |  120 +++-
 include/linux/mfd/pcf50633/core.h                  |   10 +-
 include/linux/mfd/wm831x/core.h                    |   43 +-
 include/linux/mfd/wm831x/pdata.h                   |    1 +
 include/linux/mfd/wm8350/core.h                    |   14 +-
 include/linux/mfd/wm8350/gpio.h                    |   18 +
 sound/soc/codecs/twl4030.c                         |   10 +-
 sound/soc/codecs/wm8350.c                          |   25 +-
 69 files changed, 5204 insertions(+), 2102 deletions(-)
 create mode 100644 drivers/input/keyboard/adp5520-keys.c
 create mode 100644 drivers/mfd/88pm8607.c
 create mode 100644 drivers/mfd/ab4500-core.c
 create mode 100644 drivers/mfd/adp5520.c
 rename drivers/mfd/{twl4030-core.c => twl-core.c} (66%)
 create mode 100644 drivers/mfd/twl6030-irq.c
 create mode 100644 drivers/mfd/wm8350-irq.c
 rename drivers/regulator/{twl4030-regulator.c => twl-regulator.c} (55%)
 rename drivers/rtc/{rtc-twl4030.c => rtc-twl.c} (59%)
 rename include/linux/i2c/{twl4030.h => twl.h} (71%)
 create mode 100644 include/linux/mfd/88pm8607.h
 create mode 100644 include/linux/mfd/ab4500.h
 create mode 100644 include/linux/mfd/adp5520.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
