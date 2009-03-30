Return-Path: <linux-kernel-owner+w=401wt.eu-S1760383AbZC3UAS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760383AbZC3UAS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 16:00:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759659AbZC3T74
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 15:59:56 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2235 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759596AbZC3T7z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 15:59:55 -0400
Date: Mon, 30 Mar 2009 21:59:00 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LM Sensors <lm-sensors@lm-sensors.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] hwmon updates for 2.6.30
Message-ID: <20090330215900.3cbb2a00@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some hwmon subsystem updates for Linux 2.6.30 from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 hwmon-for-linus

There is support for 3 new chips (FSC Syleus, FSC Hades and Nuvoton
W83667HG) as well as improvements to the ds1621 and hdaps drivers.

 Documentation/hwmon/ds1621                 |   51 +------
 Documentation/{i2c/chips => hwmon}/pcf8591 |    0
 Documentation/hwmon/sysfs-interface        |   22 +++
 Documentation/hwmon/w83627ehf              |   29 +++-
 drivers/firmware/dmi_scan.c                |   18 ++-
 drivers/hwmon/Kconfig                      |   27 +++-
 drivers/hwmon/Makefile                     |    1 +
 drivers/hwmon/ds1621.c                     |  172 ++++++++++-----------
 drivers/hwmon/fschmd.c                     |  229 +++++++++++++++++++++-------
 drivers/hwmon/hdaps.c                      |   66 ++++----
 drivers/{i2c/chips => hwmon}/pcf8591.c     |   24 ++--
 drivers/hwmon/w83627ehf.c                  |  170 +++++++++++++++------
 drivers/i2c/busses/i2c-i801.c              |   77 ++++++++++
 drivers/i2c/chips/Kconfig                  |   13 --
 drivers/i2c/chips/Makefile                 |    1 -
 drivers/platform/x86/dell-laptop.c         |    4 +-
 drivers/watchdog/hpwdt.c                   |    4 +-
 include/linux/dmi.h                        |    7 +-
 18 files changed, 588 insertions(+), 327 deletions(-)
 rename Documentation/{i2c/chips => hwmon}/pcf8591 (100%)
 rename drivers/{i2c/chips => hwmon}/pcf8591.c (96%)

---------------

Frank Seidel (2):
      hwmon: (hdaps) Allow inversion of separate axis
      hwmon: (hdaps) Fix Thinkpad X41 axis inversion

Gong Jun (2):
      hwmon: (w83627ehf) Add support for W83667HG
      hwmon: (w83627ehf) Only expose in6 or temp3 on the W83667HG

Hans de Goede (3):
      i2c-i801: Instantiate FSC hardware montioring chips
      hwmon: (fschmd) Add support for the FSC Syleus IC
      hwmon: (fschmd) Add support for the FSC Hades IC

Jean Delvare (8):
      hwmon: (ds1621) Reorder code statements
      hwmon: (ds1621) Clean up register access
      hwmon: (ds1621) Avoid unneeded register access
      hwmon: (ds1621) Clean up documentation
      hwmon: (w83627ehf) Invert fan pin variables logic
      Move the pcf8591 driver to hwmon
      hwmon: Define a standard interface for chassis intrusion detection
      dmi: Let dmi_walk() users pass private data



-- 
Jean Delvare
