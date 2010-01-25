Return-Path: <linux-kernel-owner+w=401wt.eu-S1754818Ab0AYT0A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754818Ab0AYT0A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jan 2010 14:26:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751676Ab0AYTZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jan 2010 14:25:58 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51047 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751524Ab0AYTZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jan 2010 14:25:57 -0500
Date: Mon, 25 Jan 2010 19:25:54 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] WM8994 core driver
Message-ID: <20100125192554.GA11200@rakim.wolfsonmicro.main>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Cookie: A penny saved is a penny taxed.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements core support for the WM8994 audio CODEC.
Since the WM8994 is a large device and includes both GPIOs and
integrated LDOs which need be represented via the relevant subsystems
for integration with the rest of the kernel a MFD core device is
provided to manage chip access.

The CODEC and regulator parts of the driver will be submitted separately
via the relevant subsystems, merge issues make merging via the MFD tree
difficult.

Mark Brown (3):
      mfd: Add WM8994 register definitions
      mfd: Add initial WM8994 support
      gpiolib: Add WM8994 GPIO support

 drivers/gpio/Kconfig                 |    7 +
 drivers/gpio/Makefile                |    1 +
 drivers/gpio/wm8994-gpio.c           |  204 ++
 drivers/mfd/Kconfig                  |   12 +
 drivers/mfd/Makefile                 |    1 +
 drivers/mfd/wm8994-core.c            |  537 +++++
 include/linux/mfd/wm8994/core.h      |   54 +
 include/linux/mfd/wm8994/gpio.h      |   72 +
 include/linux/mfd/wm8994/pdata.h     |   43 +
 include/linux/mfd/wm8994/registers.h | 4292 ++++++++++++++++++++++++++++++++++
 10 files changed, 5223 insertions(+), 0 deletions(-)
 create mode 100644 drivers/gpio/wm8994-gpio.c
 create mode 100644 drivers/mfd/wm8994-core.c
 create mode 100644 include/linux/mfd/wm8994/core.h
 create mode 100644 include/linux/mfd/wm8994/gpio.h
 create mode 100644 include/linux/mfd/wm8994/pdata.h
 create mode 100644 include/linux/mfd/wm8994/registers.h
