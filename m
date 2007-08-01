Return-Path: <linux-kernel-owner+w=401wt.eu-S1763984AbXHABMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763984AbXHABMj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 21:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762100AbXHABMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 21:12:22 -0400
Received: from emerald.lightlink.com ([205.232.34.14]:2265 "EHLO
	emerald.lightlink.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761026AbXHABMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 21:12:20 -0400
Date: Tue, 31 Jul 2007 21:08:25 -0400
From: "Mark M. Hoffman" <mhoffman@lightlink.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       lm-sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PATCH] hwmon updates against ~v2.6.23-rc1-git8
Message-ID: <20070801010825.GC3747@jupiter.solarsys.private>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus:

Please pull from:
	git://lm-sensors.org/kernel/mhoffman/hwmon-2.6.git release

You'll get a handful of cleanups and bugfixes (including a couple that fix
regressions since 2.6.22).  The Macbook gets some additional sensors, and
there's also one brand new driver, which has spent some time in the latest -mm.

This patch series was also posted to the lm-sensors list yesterday:
http://lists.lm-sensors.org/pipermail/lm-sensors/2007-July/020730.html

Thanks & regards,

 Documentation/hwmon/adm1031  |    4 +-
 Documentation/hwmon/thmc50   |   74 +++++++
 drivers/hwmon/Kconfig        |   10 +
 drivers/hwmon/Makefile       |    1 +
 drivers/hwmon/abituguru3.c   |    5 +-
 drivers/hwmon/ams/ams-core.c |    1 -
 drivers/hwmon/applesmc.c     |   14 +-
 drivers/hwmon/dme1737.c      |    2 +-
 drivers/hwmon/fscher.c       |    4 +-
 drivers/hwmon/it87.c         |    2 +-
 drivers/hwmon/lm78.c         |    2 +-
 drivers/hwmon/lm90.c         |    2 +-
 drivers/hwmon/lm93.c         |    2 +-
 drivers/hwmon/pc87360.c      |    2 +-
 drivers/hwmon/sis5595.c      |    2 +-
 drivers/hwmon/smsc47m1.c     |    2 +-
 drivers/hwmon/thmc50.c       |  440 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/via686a.c      |    2 +-
 drivers/hwmon/vt8231.c       |    4 +-
 drivers/hwmon/w83627hf.c     |    2 +-
 20 files changed, 554 insertions(+), 23 deletions(-)
 create mode 100644 Documentation/hwmon/thmc50
 create mode 100644 drivers/hwmon/thmc50.c

Adrian Bunk (1):
      hwmon: make abituguru3_read_increment_offset() static

Guillaume Chazarain (1):
      hwmon: Fix regression caused by typo in lm90.c

Hans de Goede (3):
      hwmon: fix lm78 detection regression
      hwmon: fscher control update bugfix
      hwmon: fscher read control bugfix

Hans-Jürgen Koch (1):
      hwmon: fix array overruns in lm93.c

Jean Delvare (2):
      hwmon: Add missing __devexit tags in various drivers
      hwmon: (adm1031) Fix broken links in documentation

Jesper Juhl (1):
      hwmon: clean up duplicate includes

Juerg Haefliger (1):
      hwmon: fix dme1737 temp fault attribute

Krzysztof Helt (1):
      hwmon: add support for THMC50 and ADM1022

Martin Szulecki (1):
      hwmon: (applesmc) add temperature sensors set for Macbook

-- 
Mark M. Hoffman
mhoffman@lightlink.com

