Return-Path: <linux-kernel-owner+w=401wt.eu-S1765644AbYBUMdE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765644AbYBUMdE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2008 07:33:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501AbYBUMcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Feb 2008 07:32:53 -0500
Received: from emerald.lightlink.com ([205.232.34.14]:20530 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754942AbYBUMcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2008 07:32:52 -0500
Date: Thu, 21 Feb 2008 07:28:47 -0500
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates vs. 2.6.25-rc2
Message-ID: <20080221122847.GF27110@jupiter.solarsys.private>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get one new driver, one bugfix (adm1026), a few cleanups and
enhancements.  This branch also includes the last of the patches which
add individual alarm sysfs files to all drivers (thank you Jean!).

Hopefully this is the last you'll hear from me before 2.6.25 final.

Thanks & regards,

 Documentation/hwmon/adt7473  |   79 +++
 Documentation/hwmon/coretemp |    6 +-
 MAINTAINERS                  |    2 +-
 drivers/hwmon/Kconfig        |   10 +
 drivers/hwmon/Makefile       |    1 +
 drivers/hwmon/ad7418.c       |    2 +-
 drivers/hwmon/adm1021.c      |    6 +-
 drivers/hwmon/adm1025.c      |    2 +-
 drivers/hwmon/adm1026.c      |    4 +-
 drivers/hwmon/adm1029.c      |    6 +-
 drivers/hwmon/adm1031.c      |    2 +-
 drivers/hwmon/adm9240.c      |    2 +-
 drivers/hwmon/ads7828.c      |    2 +-
 drivers/hwmon/adt7470.c      |    2 +-
 drivers/hwmon/adt7473.c      | 1157 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/applesmc.c     |   29 +-
 drivers/hwmon/asb100.c       |    2 +-
 drivers/hwmon/atxp1.c        |    2 +-
 drivers/hwmon/coretemp.c     |  119 +++--
 drivers/hwmon/dme1737.c      |    2 +-
 drivers/hwmon/ds1621.c       |    2 +-
 drivers/hwmon/f75375s.c      |    2 +-
 drivers/hwmon/fscher.c       |    2 +-
 drivers/hwmon/fschmd.c       |    2 +-
 drivers/hwmon/fscpos.c       |    2 +-
 drivers/hwmon/gl518sm.c      |    2 +-
 drivers/hwmon/gl520sm.c      |    2 +-
 drivers/hwmon/lm63.c         |    2 +-
 drivers/hwmon/lm75.c         |    2 +-
 drivers/hwmon/lm77.c         |    3 +-
 drivers/hwmon/lm78.c         |    4 +-
 drivers/hwmon/lm80.c         |    4 +-
 drivers/hwmon/lm83.c         |    6 +-
 drivers/hwmon/lm85.c         |    2 +-
 drivers/hwmon/lm87.c         |    2 +-
 drivers/hwmon/lm90.c         |    6 +-
 drivers/hwmon/lm92.c         |   20 +-
 drivers/hwmon/lm93.c         |    2 +-
 drivers/hwmon/max1619.c      |   23 +-
 drivers/hwmon/max6650.c      |    3 +-
 drivers/hwmon/smsc47m1.c     |   25 +-
 drivers/hwmon/smsc47m192.c   |    2 +-
 drivers/hwmon/thmc50.c       |    8 +-
 drivers/hwmon/via686a.c      |   28 +
 drivers/hwmon/vt8231.c       |   44 ++-
 drivers/hwmon/w83781d.c      |    4 +-
 drivers/hwmon/w83791d.c      |    3 +-
 drivers/hwmon/w83792d.c      |    3 +-
 drivers/hwmon/w83793.c       |    3 +-
 drivers/hwmon/w83l785ts.c    |    2 +-
 drivers/hwmon/w83l786ng.c    |    2 +-
 51 files changed, 1534 insertions(+), 120 deletions(-)
 create mode 100644 Documentation/hwmon/adt7473
 create mode 100644 drivers/hwmon/adt7473.c

Darrick J. Wong (1):
      hwmon: New driver for Analog Devices ADT7473 sensor chip

Jean Delvare (6):
      hwmon: (lm92) Add individual alarm files
      hwmon: (max1619) Add individual alarm and fault files
      hwmon: (smsc47m1) Add individual alarm files
      hwmon: (via686a) Add individual alarm files
      hwmon: (vt8231) Add individual alarm files
      hwmon: (adm1026) Properly terminate sysfs groups

Mark M. Hoffman (1):
      hwmon: normal_i2c arrays should be const

Riki Oktarianto (1):
      hwmon: (applesmc) sensors set for MacBook2

Roger Lucas (1):
      hwmon: (vt8231) Update maintainer email address

Rudolf Marek (3):
      hwmon: (coretemp) Add maximum cooling temperature readout
      hwmon: (coretemp) Add TjMax detection for mobile CPUs
      hwmon: (coretemp) Add Penryn CPU to coretemp

Sam Ravnborg (1):
      hwmon: (coretemp) fix section mismatch warning

Tobias Klauser (1):
      hwmon: (thmc50) Storage class should be before const qualifier

-- 
Mark M. Hoffman
mhoffman@lightlink.com

