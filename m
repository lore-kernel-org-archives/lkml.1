Return-Path: <linux-kernel-owner+w=401wt.eu-S1753203AbZLPUr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbZLPUr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:47:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751487AbZLPUr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:47:27 -0500
Received: from bamako.nerim.net ([62.4.17.28]:54729 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751043AbZLPUr0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:47:26 -0500
Date: Wed, 16 Dec 2009 21:47:21 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
Subject: [GIT PULL] hwmon updates for 2.6.33, round 2
Message-ID: <20091216214721.3a8a75d6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.33 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git hwmon-for-linus

We have 2 new drivers for integrated CPU sensors, one for the AMD
family 10h and 11h, and one for the VIA C7 and Nano. Plus random driver
fixes.

 Documentation/hwmon/k10temp |   60 +++++++
 drivers/hwmon/Kconfig       |   20 +++
 drivers/hwmon/Makefile      |    2 +
 drivers/hwmon/k10temp.c     |  197 ++++++++++++++++++++++++
 drivers/hwmon/sht15.c       |    6 +-
 drivers/hwmon/smsc47m1.c    |  153 +++++++++++++++---
 drivers/hwmon/via-cputemp.c |  356 +++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/w83627hf.c    |    2 +-
 8 files changed, 766 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/hwmon/k10temp
 create mode 100644 drivers/hwmon/k10temp.c
 create mode 100644 drivers/hwmon/via-cputemp.c

---------------

Christian Schulte (1):
      hwmon: (w83627hf) Fix for "No such device"

Clemens Ladisch (1):
      hwmon: New driver for AMD Family 10h/11h CPUs

Harald Welte (1):
      hwmon: Add driver for VIA CPU core temperature

Jean Delvare (3):
      hwmon: (smsc47m1) Only request I/O ports we really use
      hwmon: (smsc47m1) Fail module loading on error
      hwmon: (smsc47m1) Enable device if needed

Jonathan Cameron (1):
      hwmon: (sht15) Off-by-one error in array index + incorrect constants

Thanks,
-- 
Jean Delvare
