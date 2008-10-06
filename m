Return-Path: <linux-kernel-owner+w=401wt.eu-S1754002AbYJFMdJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002AbYJFMdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2008 08:33:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752984AbYJFMc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Oct 2008 08:32:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58193 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752842AbYJFMc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2008 08:32:56 -0400
Date: Mon, 6 Oct 2008 13:32:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@openedhand.com>, Liam Girdwood <lrg@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/13] WM8350 support
Message-ID: <20081006123254.GA9664@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches against the regulator tree add initial support for the
WM8350, a multi-function device with several subsystems targetted at
embedded systems.  This series adds a core driver providing device acess
under drivers/mfd and support for the PMIC functionality of the device
via the regulator API.  Due to their use in the core some definitions
for other parts of the device are also included - drivers for these will
follow.

All the WM8350 drivers submitted here were originally written by Liam
Girdwood with some updates from me for submission to mainline.

Samuel, as with the WM8400 are you OK with merging this via the
regulator tree?

The following changes since commit fcbd54dd718e6741b05f8e5b08cbc75548acf0e4:
  Mark Brown (1):
        regulator: Add WM8400 regulator support

are available in the git repository at:

  git://opensource.wolfsonmicro.com/linux-2.6-audioplus for-lrg

Mark Brown (13):
      mfd: Add WM8350 audio register definitions
      mfd: Add WM8350 GPIO register definitions
      mfd: Add WM8350 PMIC register definitions
      mfd: Add WM8350 PMU register definitions
      mfd: Add WM8350 comparator register definitions
      mfd: Add WM8350 RTC register definitions
      mfd: Add WM8350 watchdog register definitions
      mfd: Core support for the WM8350 AudioPlus PMIC
      mfd: Add I2C control support for WM8350
      mfd: Add GPIO pin configuration support for WM8350
      mfd: Add initialisation callback for WM8350
      mfd: Add WM8350 interrupt support
      regulator: Add WM8350 regulator support

 drivers/mfd/Kconfig                   |   58 ++
 drivers/mfd/Makefile                  |    3 +
 drivers/mfd/wm8350-core.c             | 1239 ++++++++++++++++++++++++++++
 drivers/mfd/wm8350-gpio.c             |  222 +++++
 drivers/mfd/wm8350-i2c.c              |  120 +++
 drivers/mfd/wm8350-regmap.c           | 1323 ++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig             |   10 +
 drivers/regulator/Makefile            |    1 +
 drivers/regulator/wm8350-regulator.c  | 1430 +++++++++++++++++++++++++++++++++
 include/linux/mfd/wm8350/audio.h      |  592 ++++++++++++++
 include/linux/mfd/wm8350/comparator.h |  167 ++++
 include/linux/mfd/wm8350/core.h       |  621 ++++++++++++++
 include/linux/mfd/wm8350/gpio.h       |  336 ++++++++
 include/linux/mfd/wm8350/pmic.h       |  741 +++++++++++++++++
 include/linux/mfd/wm8350/rtc.h        |  260 ++++++
 include/linux/mfd/wm8350/supply.h     |  105 +++
 include/linux/mfd/wm8350/wdt.h        |   22 +
 17 files changed, 7250 insertions(+), 0 deletions(-)
 create mode 100644 drivers/mfd/wm8350-core.c
 create mode 100644 drivers/mfd/wm8350-gpio.c
 create mode 100644 drivers/mfd/wm8350-i2c.c
 create mode 100644 drivers/mfd/wm8350-regmap.c
 create mode 100644 drivers/regulator/wm8350-regulator.c
 create mode 100644 include/linux/mfd/wm8350/audio.h
 create mode 100644 include/linux/mfd/wm8350/comparator.h
 create mode 100644 include/linux/mfd/wm8350/core.h
 create mode 100644 include/linux/mfd/wm8350/gpio.h
 create mode 100644 include/linux/mfd/wm8350/pmic.h
 create mode 100644 include/linux/mfd/wm8350/rtc.h
 create mode 100644 include/linux/mfd/wm8350/supply.h
 create mode 100644 include/linux/mfd/wm8350/wdt.h
