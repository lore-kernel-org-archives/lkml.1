Return-Path: <linux-kernel-owner+w=401wt.eu-S1757970AbZIQOI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970AbZIQOI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 10:08:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754378AbZIQOIz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 10:08:55 -0400
Received: from mga09.intel.com ([134.134.136.24]:16498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754279AbZIQOIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 10:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.44,403,1249282800"; 
   d="scan'208";a="449342924"
Date: Thu, 17 Sep 2009 16:10:31 +0200
From: Samuel Ortiz <samuel@sortiz.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Linus Walleij <linus.walleij@stericsson.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Rodolfo Giometti <giometti@linux.it>,
       Amit Kucheria <amit.kucheria@verdurent.com>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Antonio Ospite <ospite@studenti.unina.it>,
       Daniel Ribeiro <drwyrm@gmail.com>,
       Vipin Bhandari <vipin.bhandari@ti.com>,
       Paul Fertser <fercerpav@gmail.com>,
       Felipe Balbi <felipe.balbi@nokia.com>, Joe Perches <joe@perches.com>,
       Jean Delvare <khali@linux-fr.org>
Subject: Re: [GIT PULL] MFD update for 2.6.32
Message-ID: <20090917141031.GA3085@sortiz.org>
References: <20090917093302.GA8467@sortiz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090917093302.GA8467@sortiz.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On Thu, Sep 17, 2009 at 11:33:03AM +0200, Samuel Ortiz wrote:
> Hi Linus,
> 
> This is a pull request for the MFD tree.
> 
> The update is fairly big this time, with several new MFD drivers: Wolfson
> WM831x, Freescale MC13783, ST-Ericsson AB3100, and Winbond W83627.
> 
> Since they depend on their MFD cores, my tree is also carrying several rtc,
> regulator, and hwmon subdevices drivers.
> All of them have been reviewed and acked by the relevant maintainers.
> 
> Thanks in advance for pulling them in.
I accidentally pushed a driver that was not reviewed yet, the W83627 one.
I rebased my tree so that this patch is removed. Here goes the corrected pull
request:


The following changes since commit ab86e5765d41a5eb4239a1c04d613db87bea5ed8:
  Linus Torvalds (1):
        Merge git://git.kernel.org/.../gregkh/driver-core-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Amit Kucheria (3):
      mfd: Add support for TWL4030/5030 dynamic power switching
      mfd: Print warning for twl4030 out-of-order script loading
      mfd: OMAP: Board-specifc twl4030 DPS scripts for RX51 board

Antonio Ospite (3):
      mfd: register ezx-pcap earlier
      regulator: register pcap earlier
      regulator: get pcap data from the parent device

Daniel Ribeiro (8):
      mfd: Introduce irq_to_pcap()
      mfd: add set_ts_bits for pcap
      mfd: fix pcap irq bottom handler
      mfd: add ezx_pcap_setbits
      regulator: add pcap driver
      mfd: Remove VIB defines from pcap header file
      input: PCAP2 based touchscreen driver
      input: PCAP2 misc input driver

Felipe Balbi (1):
      mfd: Add twl4030-pwrbutton as a twl4030 child

Joe Perches (1):
      mfd: remove unnecessary semicolons from twl4030

Linus Walleij (8):
      mfd: AB3100 accessor function cleanups
      mfd: AB3100 propagate error
      mfd: AB3100 alter default setting
      mfd: AB3100 disable irq nosync
      mfd: AB3100 OTP readout
      rtc: AB3100 RTC support
      regulator: AB3100 support
      regulator: Voltage count for AB3100

Mark Brown (22):
      MAINTAINERS: Add entry for Wolfson PMIC drivers
      hwmon: Add WM835x PMIC hardware monitoring driver
      mfd: Allow multiple MFD cells with the same name
      mfd: Initial core support for WM831x series devices
      mfd: Add WM831x interrupt support
      mfd: Add WM831x AUXADC support
      mfd: Conditionally add WM831x backlight subdevice
      mfd: Add basic WM831x OTP support
      mfd: Export ISEL values from WM831x core
      mfd: Hook WM831x into build system
      gpio: Add WM831X GPIO driver
      hwmon: WM831x PMIC hardware monitoring driver
      input: Add support for the WM831x ON pin
      regulator: Provide mode to status conversion function
      regulator: Add WM831x DC-DC buck convertor support
      regulator: Add WM831x LDO support
      regulator: Add WM831x EPE support
      regulator: Add WM831x DC-DC boost convertor support
      regulator: Add WM831x ISINK support
      rtc: Add support for RTCs on Wolfson WM831x devices
      mfd: Update MAINTAINERS patterns for WM831x
      mfd: Convert WM8350 to use request_threaded_irq()

Paul Fertser (3):
      mfd: use a dedicated workqueue for pcf50633 irq processing
      mfd: revise locking for pcf50633 ADC
      mfd: fix wrong define for 10bit pcf50633 ADC mode

Samuel Ortiz (3):
      mfd: fix ab3100 warning on x86_64
      mfd: Fix ab3100-otp build failure
      mfd: Fix twl4030-power warnings

Sascha Hauer (2):
      mfd: Add Freescale MC13783 driver
      regulator: Add Freescale MC13783 driver

Vipin Bhandari (1):
      mfd: Correct ro and cd implemantion on DM355

 Documentation/hwmon/wm831x                   |   37 +
 Documentation/hwmon/wm8350                   |   26 +
 MAINTAINERS                                  |   20 +
 arch/arm/mach-omap2/board-rx51-peripherals.c |  122 ++-
 drivers/gpio/Kconfig                         |    7 +
 drivers/gpio/Makefile                        |    1 +
 drivers/gpio/wm831x-gpio.c                   |  252 +++++
 drivers/hwmon/Kconfig                        |   21 +
 drivers/hwmon/Makefile                       |    2 +
 drivers/hwmon/wm831x-hwmon.c                 |  226 ++++
 drivers/hwmon/wm8350-hwmon.c                 |  151 +++
 drivers/input/misc/Kconfig                   |   20 +
 drivers/input/misc/Makefile                  |    3 +
 drivers/input/misc/pcap_keys.c               |  144 +++
 drivers/input/misc/wm831x-on.c               |  163 +++
 drivers/input/touchscreen/Kconfig            |    9 +
 drivers/input/touchscreen/Makefile           |    1 +
 drivers/input/touchscreen/pcap_ts.c          |  271 +++++
 drivers/mfd/Kconfig                          |   42 +
 drivers/mfd/Makefile                         |    6 +
 drivers/mfd/ab3100-core.c                    |   62 +-
 drivers/mfd/ab3100-otp.c                     |  268 +++++
 drivers/mfd/dm355evm_msp.c                   |   12 +-
 drivers/mfd/ezx-pcap.c                       |  105 ++-
 drivers/mfd/mc13783-core.c                   |  427 +++++++
 drivers/mfd/mfd-core.c                       |    2 +-
 drivers/mfd/pcf50633-adc.c                   |   32 +-
 drivers/mfd/pcf50633-core.c                  |    5 +-
 drivers/mfd/twl4030-core.c                   |   23 +
 drivers/mfd/twl4030-irq.c                    |    2 +-
 drivers/mfd/twl4030-power.c                  |  472 ++++++++
 drivers/mfd/wm831x-core.c                    | 1549 ++++++++++++++++++++++++++
 drivers/mfd/wm831x-irq.c                     |  559 ++++++++++
 drivers/mfd/wm831x-otp.c                     |   83 ++
 drivers/mfd/wm8350-core.c                    |   27 +-
 drivers/regulator/Kconfig                    |   31 +
 drivers/regulator/Makefile                   |    6 +
 drivers/regulator/ab3100.c                   |  700 ++++++++++++
 drivers/regulator/core.c                     |   24 +
 drivers/regulator/mc13783.c                  |  410 +++++++
 drivers/regulator/pcap-regulator.c           |  318 ++++++
 drivers/regulator/wm831x-dcdc.c              |  862 ++++++++++++++
 drivers/regulator/wm831x-isink.c             |  260 +++++
 drivers/regulator/wm831x-ldo.c               |  852 ++++++++++++++
 drivers/rtc/Kconfig                          |   19 +
 drivers/rtc/Makefile                         |    2 +
 drivers/rtc/rtc-ab3100.c                     |  281 +++++
 drivers/rtc/rtc-wm831x.c                     |  523 +++++++++
 include/linux/i2c/twl4030.h                  |   94 ++-
 include/linux/mfd/ab3100.h                   |   37 +-
 include/linux/mfd/core.h                     |    1 +
 include/linux/mfd/ezx-pcap.h                 |    7 +-
 include/linux/mfd/mc13783-private.h          |  396 +++++++
 include/linux/mfd/mc13783.h                  |   84 ++
 include/linux/mfd/pcf50633/adc.h             |    3 +-
 include/linux/mfd/pcf50633/core.h            |    1 +
 include/linux/mfd/wm831x/auxadc.h            |  216 ++++
 include/linux/mfd/wm831x/core.h              |  289 +++++
 include/linux/mfd/wm831x/gpio.h              |   55 +
 include/linux/mfd/wm831x/irq.h               |  764 +++++++++++++
 include/linux/mfd/wm831x/otp.h               |  162 +++
 include/linux/mfd/wm831x/pdata.h             |  113 ++
 include/linux/mfd/wm831x/regulator.h         | 1218 ++++++++++++++++++++
 include/linux/mfd/wm8350/core.h              |    7 +-
 include/linux/regulator/driver.h             |    2 +
 65 files changed, 12770 insertions(+), 119 deletions(-)
 create mode 100644 Documentation/hwmon/wm831x
 create mode 100644 Documentation/hwmon/wm8350
 create mode 100644 drivers/gpio/wm831x-gpio.c
 create mode 100644 drivers/hwmon/wm831x-hwmon.c
 create mode 100644 drivers/hwmon/wm8350-hwmon.c
 create mode 100644 drivers/input/misc/pcap_keys.c
 create mode 100644 drivers/input/misc/wm831x-on.c
 create mode 100644 drivers/input/touchscreen/pcap_ts.c
 create mode 100644 drivers/mfd/ab3100-otp.c
 create mode 100644 drivers/mfd/mc13783-core.c
 create mode 100644 drivers/mfd/twl4030-power.c
 create mode 100644 drivers/mfd/wm831x-core.c
 create mode 100644 drivers/mfd/wm831x-irq.c
 create mode 100644 drivers/mfd/wm831x-otp.c
 create mode 100644 drivers/regulator/ab3100.c
 create mode 100644 drivers/regulator/mc13783.c
 create mode 100644 drivers/regulator/pcap-regulator.c
 create mode 100644 drivers/regulator/wm831x-dcdc.c
 create mode 100644 drivers/regulator/wm831x-isink.c
 create mode 100644 drivers/regulator/wm831x-ldo.c
 create mode 100644 drivers/rtc/rtc-ab3100.c
 create mode 100644 drivers/rtc/rtc-wm831x.c
 create mode 100644 include/linux/mfd/mc13783-private.h
 create mode 100644 include/linux/mfd/mc13783.h
 create mode 100644 include/linux/mfd/wm831x/auxadc.h
 create mode 100644 include/linux/mfd/wm831x/core.h
 create mode 100644 include/linux/mfd/wm831x/gpio.h
 create mode 100644 include/linux/mfd/wm831x/irq.h
 create mode 100644 include/linux/mfd/wm831x/otp.h
 create mode 100644 include/linux/mfd/wm831x/pdata.h
 create mode 100644 include/linux/mfd/wm831x/regulator.h

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
