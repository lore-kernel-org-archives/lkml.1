Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751885Ab0CMVwB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Mar 2010 16:52:01 -0500
Received: from bamako.nerim.net ([62.4.17.28]:56878 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751129Ab0CMVv7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Mar 2010 16:51:59 -0500
Date: Sat, 13 Mar 2010 22:51:57 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.34
Message-ID: <20100313225157.34190a35@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull i2c subsystem fixes for Linux 2.6.34 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

 drivers/i2c/Kconfig                   |    9 ---------
 drivers/i2c/Makefile                  |    2 +-
 drivers/i2c/algos/i2c-algo-bit.c      |    9 +++++++++
 drivers/i2c/busses/i2c-i801.c         |    6 ++++--
 drivers/i2c/busses/i2c-powermac.c     |   25 ++++++++++++++++++-------
 drivers/i2c/chips/Kconfig             |   19 -------------------
 drivers/i2c/chips/Makefile            |   18 ------------------
 drivers/i2c/i2c-smbus.c               |    5 ++---
 drivers/misc/Kconfig                  |   10 ++++++++++
 drivers/misc/Makefile                 |    1 +
 drivers/misc/eeprom/at24.c            |    1 +
 drivers/{i2c/chips => misc}/tsl2550.c |    4 ++--
 include/linux/i2c-algo-bit.h          |    2 ++
 13 files changed, 50 insertions(+), 61 deletions(-)
 delete mode 100644 drivers/i2c/chips/Kconfig
 delete mode 100644 drivers/i2c/chips/Makefile
 rename drivers/{i2c/chips => misc}/tsl2550.c (99%)

---------------

Jean Delvare (5):
      i2c-powermac: Be less verbose in the absence of real errors.
      i2c-i801: Don't use the block buffer for I2C block writes
      tsl2550: Move from i2c/chips to misc
      i2c: Drop configure option I2C_DEBUG_CHIP
      i2c-algo-bit: Add pre- and post-xfer hooks

Stephen Rothwell (1):
      i2c-smbus: Use device_lock/device_unlock

Wolfram Sang (1):
      at24: Init dynamic bin_attribute structures

Thanks,
-- 
Jean Delvare
