Return-Path: <linux-kernel-owner+w=401wt.eu-S1754427AbZAKNks@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbZAKNks (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 08:40:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752297AbZAKNkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 08:40:39 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:57906 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751964AbZAKNki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 08:40:38 -0500
Date: Sun, 11 Jan 2009 14:43:11 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Ben Dooks <ben-linux@fluff.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Balaji Rao <balajirrao@openmoko.org>
Subject: [GIT] MFD pull request
Message-ID: <20090111134310.GA2554@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

I know it's a bit late, but I had one driver left and a couple fixes left to
be merged.

It's the pcf50633 driver and its sub devices. They're standalone drivers.
This pull request also includes a build fix for twl4030, another fix for
sm501, and the SD card detection for dm355.
I hope you'll be ok with merging this code:

The following changes since commit c59765042f53a79a7a65585042ff463b69cb248c:
  Linus Torvalds (1):
        Linux 2.6.29-rc1

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-next

Balaji Rao (7):
      mfd: PCF50633 core driver
      mfd: PCF50633 adc driver
      mfd: PCF50633 gpio support
      rtc: PCF50633 rtc driver
      power_supply: PCF50633 battery charger driver
      input: PCF50633 input driver
      regulator: PCF50633 pmic driver

Ben Dooks (1):
      mfd: Ensure sm501 GPIO pin mode is GPIO when configured

David Brownell (1):
      mfd: dm355 evm MMC/SD card detection

Samuel Ortiz (1):
      mfd: Fix twl4030-core build

 drivers/input/misc/Kconfig             |    7 +
 drivers/input/misc/Makefile            |    1 +
 drivers/input/misc/pcf50633-input.c    |  132 ++++++
 drivers/mfd/Kconfig                    |   23 +
 drivers/mfd/Makefile                   |    4 +
 drivers/mfd/dm355evm_msp.c             |   10 +
 drivers/mfd/pcf50633-adc.c             |  277 +++++++++++++
 drivers/mfd/pcf50633-core.c            |  710 ++++++++++++++++++++++++++++++++
 drivers/mfd/pcf50633-gpio.c            |  118 ++++++
 drivers/mfd/sm501.c                    |   30 ++-
 drivers/mfd/twl4030-core.c             |    3 +
 drivers/power/Kconfig                  |    6 +
 drivers/power/Makefile                 |    1 +
 drivers/power/pcf50633-charger.c       |  358 ++++++++++++++++
 drivers/regulator/Kconfig              |    7 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/pcf50633-regulator.c |  329 +++++++++++++++
 drivers/rtc/Kconfig                    |    7 +
 drivers/rtc/Makefile                   |    1 +
 drivers/rtc/rtc-pcf50633.c             |  344 +++++++++++++++
 include/linux/mfd/pcf50633/adc.h       |   72 ++++
 include/linux/mfd/pcf50633/core.h      |  218 ++++++++++
 include/linux/mfd/pcf50633/gpio.h      |   52 +++
 include/linux/mfd/pcf50633/mbc.h       |  134 ++++++
 include/linux/mfd/pcf50633/pmic.h      |   67 +++
 25 files changed, 2910 insertions(+), 2 deletions(-)
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
 create mode 100644 include/linux/mfd/pcf50633/mbc.h
 create mode 100644 include/linux/mfd/pcf50633/pmic.h


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
