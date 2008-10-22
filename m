Return-Path: <linux-kernel-owner+w=401wt.eu-S1756737AbYJVS1d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737AbYJVS1d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 14:27:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752219AbYJVS1Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 14:27:24 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:7392 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064AbYJVS1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 14:27:23 -0400
Date: Wed, 22 Oct 2008 20:27:02 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux I2C <i2c@lm-sensors.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] i2c updates for 2.6.28, round 2
Message-ID: <20081022202702.77ee9e44@hyperion.delvare>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.9; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the second round of i2c subsystem updates for Linux 2.6.28
from:

git://jdelvare.pck.nerim.net/jdelvare-2.6 i2c-for-linus

There are fixes to the i2c-algo-pcf driver, support for a new Intel
chip (Ibex Peak), documentation updates and a few other fixes.

 Documentation/feature-removal-schedule.txt |    8 +
 Documentation/i2c/busses/i2c-i801          |    7 +-
 Documentation/i2c/porting-clients          |  160 ---------
 Documentation/i2c/writing-clients          |  495 +++++++---------------------
 drivers/i2c/algos/i2c-algo-pcf.c           |   21 +-
 drivers/i2c/busses/Kconfig                 |    1 +
 drivers/i2c/busses/i2c-elektor.c           |    3 +-
 drivers/i2c/busses/i2c-hydra.c             |    2 +-
 drivers/i2c/busses/i2c-i801.c              |    3 +
 drivers/i2c/chips/Kconfig                  |    2 +
 drivers/i2c/chips/Makefile                 |    3 +-
 drivers/i2c/i2c-core.c                     |    3 +
 include/linux/device.h                     |    2 +-
 include/linux/i2c-algo-pcf.h               |    5 +-
 include/linux/i2c.h                        |  163 +++++-----
 15 files changed, 245 insertions(+), 633 deletions(-)
 delete mode 100644 Documentation/i2c/porting-clients

---------------

Anton Vorontsov (1):
      i2c: Add info->archdata field

Arjan van de Ven (1):
      i2c: Use pci_ioremap_bar()

David Miller (3):
      i2c-algo-pcf: Pass adapter data into ->waitforpin() method
      i2c-algo-pcf: Add adapter hooks around xfer begin and end
      i2c-algo-pcf: Fix typo in debugging log message

Jean Delvare (7):
      i2c: Delete outdated client porting guide
      i2c: Constify i2c_get_clientdata's parameter
      i2c: Delete legacy model documentation
      i2c: Drop 2-byte address block transfer defines
      i2c: Update and clean up writing-clients document
      i2c: Clean up <linux/i2c.h>
      Schedule removal of the legacy i2c device driver binding model

Seth Heasley (1):
      i2c-i801: Add support for Intel Ibex Peak

Wolfram Sang (2):
      i2c: Make clear what the class field of i2c_adapter is good for
      i2c: Inform about deprecated chips directory

Thanks,
-- 
Jean Delvare
