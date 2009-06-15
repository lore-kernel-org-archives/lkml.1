Return-Path: <linux-kernel-owner+w=401wt.eu-S1761754AbZFORzd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761754AbZFORzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 13:55:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753423AbZFORz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 13:55:26 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:28168 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753203AbZFORzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 13:55:25 -0400
Date: Mon, 15 Jun 2009 19:55:17 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.31
Message-ID: <20090615195517.74b2657d@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull hwmon subsystem updates for Linux 2.6.31 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

 Documentation/hwmon/f71882fg        |   12 +-
 Documentation/hwmon/ibmaem          |    2 +-
 Documentation/hwmon/sysfs-interface |   19 +
 Documentation/hwmon/tmp401          |   42 +++
 Documentation/hwmon/w83627ehf       |   11 +-
 drivers/hwmon/Kconfig               |   16 +-
 drivers/hwmon/Makefile              |    1 +
 drivers/hwmon/f71882fg.c            |  250 ++++++++++---
 drivers/hwmon/hwmon.c               |   29 ++
 drivers/hwmon/ibmaem.c              |    1 +
 drivers/hwmon/max6650.c             |   86 +++++-
 drivers/hwmon/sht15.c               |   10 +-
 drivers/hwmon/tmp401.c              |  690 +++++++++++++++++++++++++++++++++++
 drivers/hwmon/w83627ehf.c           |   10 +-
 14 files changed, 1103 insertions(+), 76 deletions(-)
 create mode 100644 Documentation/hwmon/tmp401
 create mode 100644 drivers/hwmon/tmp401.c

---------------

Andre Prendel (2):
      hwmon: (tmp401) Add support for TI's TMP411 sensors chip
      hwmon: (tmp401) Add documentation

Christian Engelmayer (1):
      hwmon: (max6650) Add support for alarms

Darrick J. Wong (1):
      hwmon: (ibmaem) Automatically load on HC10 blade

Hans de Goede (5):
      hwmon: (tmp401) Add support for TI's TMP401 sensor chip
      hwmon: (f71882fg) Cleanup f8000 pwm handling
      hwmon: (f71882fg) Sanity check f8000 pwm settings
      hwmon: (f71882fg) Add temp#_fault sysfs attr for f8000
      hwmon: (f71882fg) Add support for the F71858F

Jean Delvare (3):
      hwmon: Fix more __devexit_p glitches
      hwmon: (w83627ehf) Add W83627DHG-P support
      hwmon: PCI quirk for hwmon access on MSI MS-7031 board

Thanks,
-- 
Jean Delvare
