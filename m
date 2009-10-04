Return-Path: <linux-kernel-owner+w=401wt.eu-S1758137AbZJDVKY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137AbZJDVKY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Oct 2009 17:10:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758112AbZJDVKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Oct 2009 17:10:23 -0400
Received: from bamako.nerim.net ([62.4.17.28]:54509 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758103AbZJDVKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Oct 2009 17:10:22 -0400
Date: Sun, 4 Oct 2009 23:09:43 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <linux-i2c@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c fixes for 2.6.32
Message-ID: <20091004230943.4a18b2f6@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull some more i2c subsystem updates for Linux 2.6.32 from:

git://git.kernel.org/pub/scm/linux/kernel/git/jdelvare/staging.git i2c-for-linus

There are fixes for bugs replicated across many drivers, cleanups
removing obsolete code from random i2c chip drivers, and minor
documentation cleanups.

 Documentation/hwmon/ltc4215                       |    7 +-
 Documentation/hwmon/ltc4245                       |    7 +-
 Documentation/i2c/instantiating-devices           |    2 +-
 Documentation/{i2c/chips => misc-devices}/eeprom  |    0
 Documentation/{i2c/chips => misc-devices}/max6875 |    6 +-
 Documentation/w1/masters/ds2482                   |    6 +-
 drivers/hwmon/ltc4215.c                           |   47 +-------
 drivers/hwmon/ltc4245.c                           |  131 +--------------------
 drivers/i2c/busses/i2c-amd756.c                   |    2 +-
 drivers/i2c/busses/i2c-amd8111.c                  |    4 +-
 drivers/i2c/busses/i2c-i801.c                     |    4 +-
 drivers/i2c/busses/i2c-isch.c                     |    2 +-
 drivers/i2c/busses/i2c-piix4.c                    |    4 +-
 drivers/i2c/busses/i2c-sis96x.c                   |    2 +-
 drivers/i2c/busses/i2c-viapro.c                   |    2 +-
 drivers/leds/leds-pca9532.c                       |    3 -
 drivers/macintosh/therm_adt746x.c                 |    4 +-
 drivers/macintosh/therm_pm72.c                    |    4 +-
 drivers/macintosh/windfarm_lm75_sensor.c          |    4 +-
 drivers/macintosh/windfarm_max6690_sensor.c       |    4 +-
 drivers/macintosh/windfarm_smu_sat.c              |    4 +-
 drivers/mfd/ab3100-core.c                         |    4 +-
 drivers/misc/eeprom/max6875.c                     |   29 +----
 drivers/staging/iio/light/tsl2561.c               |    4 -
 drivers/w1/masters/ds2482.c                       |   35 +-----
 25 files changed, 64 insertions(+), 257 deletions(-)
 rename Documentation/{i2c/chips => misc-devices}/eeprom (100%)
 rename Documentation/{i2c/chips => misc-devices}/max6875 (94%)

---------------

Jean Delvare (10):
      i2c: Move misc devices documentation
      max6875: Discard obsolete detect method
      ds2482: Discard obsolete detect method
      ltc4215/ltc4245: Discard obsolete detect methods
      leds: leds-pca9532 - Drop unused module parameters
      Staging: IIO: tsl2561: Drop unused module parameters
      mfd: AB3100 drop unused module parameters
      i2c: Minor documentation update
      i2c: Hide probe errors caused by ACPI resource conflicts
      macintosh: Don't assume i2c device probing always succeeds

Thanks,
-- 
Jean Delvare
