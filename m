Return-Path: <linux-kernel-owner+w=401wt.eu-S932561AbXBNUYB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932561AbXBNUYB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 15:24:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932569AbXBNUYB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 15:24:01 -0500
Received: from smtp-103-wednesday.nerim.net ([62.4.16.103]:1193 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932565AbXBNUYA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 15:24:00 -0500
Date: Wed, 14 Feb 2007 21:24:17 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon updates for 2.6.21
Message-Id: <20070214212417.c61d5cfe.khali@linux-fr.org>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.20; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the hwmon subsystem updates for Linux 2.6.21 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

There is one new hardware monitoring driver (adm1029, for the
relatively rare Analog Devices ADM1029 chip), support for one new chip
(Winbond W83627DHG), PWM clock frequency control added to the it87
driver, and individual cleanups and minor fixes to a dozen drivers.

 Documentation/hwmon/it87            |   10 +
 Documentation/hwmon/sysfs-interface |   15 +
 Documentation/hwmon/w83627ehf       |   54 +++-
 MAINTAINERS                         |    6 
 drivers/hwmon/Kconfig               |   11 +
 drivers/hwmon/Makefile              |    1 
 drivers/hwmon/abituguru.c           |   30 +-
 drivers/hwmon/adm1026.c             |    1 
 drivers/hwmon/adm1029.c             |  508 +++++++++++++++++++++++++++++++++++
 drivers/hwmon/f71805f.c             |   30 --
 drivers/hwmon/hwmon.c               |    2 
 drivers/hwmon/it87.c                |   84 ++++--
 drivers/hwmon/lm70.c                |    2 
 drivers/hwmon/lm78.c                |    6 
 drivers/hwmon/lm85.c                |    8 -
 drivers/hwmon/sis5595.c             |    6 
 drivers/hwmon/via686a.c             |    5 
 drivers/hwmon/vt1211.c              |   58 ++--
 drivers/hwmon/w83627ehf.c           |   54 +++-
 drivers/hwmon/w83627hf.c            |    5 
 drivers/hwmon/w83781d.c             |   10 -
 21 files changed, 769 insertions(+), 137 deletions(-)
 create mode 100644 drivers/hwmon/adm1029.c

---------------

Corentin Labbe:
      hwmon: New driver for the Analog Devices ADM1029

David Brownell:
      hwmon: Use subsys_initcall

David Hubbard:
      hwmon/w83627ehf: Add support for the W83627DHG chip

Hans de Goede:
      hwmon/abituguru: Fix unchecked return status

Jean Delvare:
      hwmon/it87: Add PWM base frequency control
      hwmon: Drop unused mutexes in two drivers
      hwmon: Simplify the locking model of two drivers
      hwmon: Cleanup a bogus legacy comment
      hwmon/f71805f: Fix a race condition

Juerg Haefliger:
      hwmon/vt1211: Add probing of alternate config index port

Ralf Baechle:
      hwmon/lm70: Make lm70_remove a __devexit function

Thanks,
-- 
Jean Delvare
