Return-Path: <linux-kernel-owner+w=401wt.eu-S1755195AbYLNLgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195AbYLNLgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 06:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754585AbYLNLfi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 06:35:38 -0500
Received: from mail.openmoko.org ([88.198.124.205]:34175 "EHLO
	mail.openmoko.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754260AbYLNLfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 06:35:37 -0500
From: Balaji Rao <balajirrao@openmoko.org>
Subject: [PATCH 0/7] PCF50633 support
To: linux-kernel@vger.kernel.org
Date: Sun, 14 Dec 2008 16:31:53 +0530
Message-ID: <20081214110152.3307.50843.stgit@cff.thadambail>
User-Agent: StGIT/0.14.3.270.g0f36
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dropped LKML accidently - resending]

The following series implements support for NXP PCF50633. It's basically
an I2C device with 9 regulators, an ADC, a PMIC, a Battery Charger
and a RTC.

This chip is used in Openmoko Neo Freerunner mobile phone.

Driver for a similar chip PCF50606, used in Openmoko Neo 1973 device
will follow soon.

The specs are open and are available at 
http://people.openmoko.org/tony_tu/GTA02/datasheet/PMU/PCF50633DS_02.pdf

---
Balaji Rao (7):
      mfd: PCF50633 core driver
      mfd: PCF50633 adc driver
      mfd: PCF50633 gpio support
      rtc: PCF50633 rtc driver
      power_supply: PCF50633 battery charger driver
      input: PCF50633 input driver
      regulator: PCF50633 pmic driver

 drivers/input/misc/Kconfig             |    6 
 drivers/input/misc/Makefile            |    1 
 drivers/input/misc/pcf50633-input.c    |  119 ++++++
 drivers/mfd/Kconfig                    |   23 +
 drivers/mfd/Makefile                   |    6 
 drivers/mfd/pcf50633-adc.c             |  263 ++++++++++++
 drivers/mfd/pcf50633-core.c            |  681 ++++++++++++++++++++++++++++++++
 drivers/mfd/pcf50633-gpio.c            |   86 ++++
 drivers/power/Kconfig                  |    6 
 drivers/power/Makefile                 |    2 
 drivers/power/pcf50633-charger.c       |  285 +++++++++++++
 drivers/regulator/Kconfig              |    7 
 drivers/regulator/Makefile             |    1 
 drivers/regulator/pcf50633-regulator.c |  338 ++++++++++++++++
 drivers/rtc/Kconfig                    |    6 
 drivers/rtc/Makefile                   |    1 
 drivers/rtc/rtc-pcf50633.c             |  302 ++++++++++++++
 include/linux/mfd/pcf50633/adc.h       |   88 ++++
 include/linux/mfd/pcf50633/core.h      |  212 ++++++++++
 include/linux/mfd/pcf50633/gpio.h      |   52 ++
 include/linux/mfd/pcf50633/input.h     |   29 +
 include/linux/mfd/pcf50633/led.h       |   24 +
 include/linux/mfd/pcf50633/mbc.h       |  137 ++++++
 include/linux/mfd/pcf50633/pmic.h      |   75 ++++
 include/linux/mfd/pcf50633/rtc.h       |   43 ++
 25 files changed, 2792 insertions(+), 1 deletions(-)
 create mode 100644 drivers/input/misc/pcf50633-input.c
 create mode 100644 drivers/mfd/pcf50633-adc.c
 create mode 100644 drivers/mfd/pcf50633-core.c
 create mode 100644 drivers/mfd/pcf50633-gpio.c
 create mode 100644 drivers/power/pcf50633-charger.c
 create mode 100644 drivers/regulator/pcf50633-regulator.c
 create mode 100644 drivers/rtc/rtc-pcf50633.c
 create mode 100644 include/linux/mfd/pcf50633/adc.h
 create mode 100644 include/linux/mfd/pcf50633/core.h
 create mode 100644 include/linux/mfd/pcf50633/gpio.h
 create mode 100644 include/linux/mfd/pcf50633/input.h
 create mode 100644 include/linux/mfd/pcf50633/led.h
 create mode 100644 include/linux/mfd/pcf50633/mbc.h
 create mode 100644 include/linux/mfd/pcf50633/pmic.h
 create mode 100644 include/linux/mfd/pcf50633/rtc.h

-- 
Balaji Rao

