Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYJMVlP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYJMVlP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 17:41:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754040AbYJMVk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 17:40:59 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:59431 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753977AbYJMVk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 17:40:58 -0400
Subject: [Fwd: [GIT PULL] voltage regulator updates for 2.6.28]
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="=-l/L1oXhyreWjPel8UR14"
Date: Mon, 13 Oct 2008 22:40:55 +0100
Message-Id: <1223934055.6814.385.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-l/L1oXhyreWjPel8UR14
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

forgot to cc the list....

--=-l/L1oXhyreWjPel8UR14
Content-Disposition: inline
Content-Description: Forwarded message - [GIT PULL] voltage regulator
	updates for 2.6.28
Content-Type: message/rfc822

Subject: [GIT PULL] voltage regulator updates for 2.6.28
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Eric Miao <eric.y.miao@gmail.com>, Mark Brown <broonie@sirena.org.uk>,  Samuel Ortiz <sameo@openedhand.com>
Content-Type: text/plain
Message-Id: <1223933533.6814.383.camel@dell-desktop.example.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Date: Mon, 13 Oct 2008 22:32:14 +0100
Content-Transfer-Encoding: 7bit

Linus,

Please pull the voltage regulator updates for 2.6.28. Main changes are
improvements to the machine level API and the addition of the Wolfson
WM8350, WM8400 and Dialog DA903x PMIC's.

Thanks

Liam

---

The following changes since commit a447c0932445f92ce6f4c1bd020f62c5097a7842:
  Steven Whitehouse (1):
        vfs: Use const for kernel parser table

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/lrg/voltage-2.6.git for-linus

Eric Miao (1):
      da903x: add regulator support for DA9030/DA9034

Liam Girdwood (2):
      regulator: core - Rework machine API to remove string based functions.
      regulator: update email address for Liam Girdwood

Mark Brown (23):
      regulator: Fix typo
      regulator: check for init_data on registration
      regulator: Additional diagnostics for machine constraints
      regulator: Enable regulators marked as always_on
      mfd: Core support for the WM8400 AudioPlus HiFi CODEC and PMU
      regulator: Add WM8400 regulator support
      regulator: Export regulator name via sysfs
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
      mfd: Add WM8350 subdevice registration helper
      mfd: Add placeholders for WM8350 client devices
      mfd: Fix warning in WM8350

 Documentation/ABI/testing/sysfs-class-regulator |   55 +-
 Documentation/power/regulator/machine.txt       |  140 ++--
 Documentation/power/regulator/regulator.txt     |    8 +-
 MAINTAINERS                                     |    3 +-
 drivers/mfd/Kconfig                             |   38 +
 drivers/mfd/Makefile                            |    5 +
 drivers/mfd/wm8350-core.c                       | 1273 ++++++++++++++++++++
 drivers/mfd/wm8350-gpio.c                       |  222 ++++
 drivers/mfd/wm8350-i2c.c                        |  120 ++
 drivers/mfd/wm8350-regmap.c                     | 1347 +++++++++++++++++++++
 drivers/mfd/wm8400-core.c                       |  455 +++++++
 drivers/regulator/Kconfig                       |   24 +
 drivers/regulator/Makefile                      |    3 +
 drivers/regulator/bq24022.c                     |   21 +-
 drivers/regulator/core.c                        |  508 +++++----
 drivers/regulator/da903x.c                      |  513 ++++++++
 drivers/regulator/wm8350-regulator.c            | 1431 +++++++++++++++++++++++
 drivers/regulator/wm8400-regulator.c            |  368 ++++++
 include/linux/mfd/wm8350/audio.h                |  598 ++++++++++
 include/linux/mfd/wm8350/comparator.h           |  167 +++
 include/linux/mfd/wm8350/core.h                 |  631 ++++++++++
 include/linux/mfd/wm8350/gpio.h                 |  342 ++++++
 include/linux/mfd/wm8350/pmic.h                 |  741 ++++++++++++
 include/linux/mfd/wm8350/rtc.h                  |  266 +++++
 include/linux/mfd/wm8350/supply.h               |  111 ++
 include/linux/mfd/wm8350/wdt.h                  |   28 +
 include/linux/mfd/wm8400-audio.h                | 1186 +++++++++++++++++++
 include/linux/mfd/wm8400-private.h              |  936 +++++++++++++++
 include/linux/mfd/wm8400.h                      |   40 +
 include/linux/regulator/driver.h                |   10 +-
 include/linux/regulator/machine.h               |   30 +-
 31 files changed, 11267 insertions(+), 353 deletions(-)
 create mode 100644 drivers/mfd/wm8350-core.c
 create mode 100644 drivers/mfd/wm8350-gpio.c
 create mode 100644 drivers/mfd/wm8350-i2c.c
 create mode 100644 drivers/mfd/wm8350-regmap.c
 create mode 100644 drivers/mfd/wm8400-core.c
 create mode 100644 drivers/regulator/da903x.c
 create mode 100644 drivers/regulator/wm8350-regulator.c
 create mode 100644 drivers/regulator/wm8400-regulator.c
 create mode 100644 include/linux/mfd/wm8350/audio.h
 create mode 100644 include/linux/mfd/wm8350/comparator.h
 create mode 100644 include/linux/mfd/wm8350/core.h
 create mode 100644 include/linux/mfd/wm8350/gpio.h
 create mode 100644 include/linux/mfd/wm8350/pmic.h
 create mode 100644 include/linux/mfd/wm8350/rtc.h
 create mode 100644 include/linux/mfd/wm8350/supply.h
 create mode 100644 include/linux/mfd/wm8350/wdt.h
 create mode 100644 include/linux/mfd/wm8400-audio.h
 create mode 100644 include/linux/mfd/wm8400-private.h
 create mode 100644 include/linux/mfd/wm8400.h


--=-l/L1oXhyreWjPel8UR14--

