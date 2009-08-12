Return-Path: <linux-kernel-owner+w=401wt.eu-S1753483AbZHLPGI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753483AbZHLPGI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Aug 2009 11:06:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753450AbZHLPGH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Aug 2009 11:06:07 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54479 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438AbZHLPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Aug 2009 11:06:06 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.arm.linux.org.uk,
       Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH V2] Freescale MC13783 PMIC support
Date: Wed, 12 Aug 2009 17:05:26 +0200
Message-Id: <1250089531-10399-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.6.3.3
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the second version of the Freescale MC13783 PMIC support.

This series adds support for the Freescale MC13783 PMIC. The MC13783
is connected via SPI, the first patch adds basic support for it in
drivers/mfd. The rest of the patches can be applied independently.
Individual Maintainers are on Cc, the whole series can be found on
lkml and the Arm Linux Kernel mailing list.

Sascha

The following changes since commit ed680c4ad478d0fee9740f7d029087f181346564:
  Linus Torvalds (1):
        Linux 2.6.31-rc5

are available in the git repository at:

  ssh://sha@pasiphae/git/sha/linux-2.6.git mc13783

Luotao Fu (1):
      [hwmon] add Freescale MC13783 adc driver

Sascha Hauer (4):
      drivers/mfd: Add Freescale MC13783 driver
      [input] add mc13783 touchscreen driver
      [RTC] Add Freescale MC13783 RTC driver
      [regulator] Add a Freescale MC13783 regulator driver

 drivers/hwmon/Kconfig                  |    6 +
 drivers/hwmon/Makefile                 |    1 +
 drivers/hwmon/mc13783-adc.c            |  181 ++++++++++++++
 drivers/input/touchscreen/Kconfig      |   12 +
 drivers/input/touchscreen/Makefile     |    1 +
 drivers/input/touchscreen/mc13783_ts.c |  222 +++++++++++++++++
 drivers/mfd/Kconfig                    |    9 +
 drivers/mfd/Makefile                   |    2 +
 drivers/mfd/mc13783-core.c             |  427 ++++++++++++++++++++++++++++++++
 drivers/regulator/Kconfig              |    8 +
 drivers/regulator/Makefile             |    1 +
 drivers/regulator/mc13783.c            |  410 ++++++++++++++++++++++++++++++
 drivers/rtc/Kconfig                    |    6 +
 drivers/rtc/Makefile                   |    1 +
 drivers/rtc/rtc-mc13783.c              |  135 ++++++++++
 include/linux/mfd/mc13783-private.h    |  396 +++++++++++++++++++++++++++++
 include/linux/mfd/mc13783.h            |   84 +++++++
 17 files changed, 1902 insertions(+), 0 deletions(-)
 create mode 100644 drivers/hwmon/mc13783-adc.c
 create mode 100644 drivers/input/touchscreen/mc13783_ts.c
 create mode 100644 drivers/mfd/mc13783-core.c
 create mode 100644 drivers/regulator/mc13783.c
 create mode 100644 drivers/rtc/rtc-mc13783.c
 create mode 100644 include/linux/mfd/mc13783-private.h
 create mode 100644 include/linux/mfd/mc13783.h

