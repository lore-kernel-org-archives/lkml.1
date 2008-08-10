Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbYHJVlX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbYHJVlX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 17:41:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753788AbYHJVlP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 17:41:15 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:39620 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753783AbYHJVlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 17:41:14 -0400
Date: Sun, 10 Aug 2008 23:41:08 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, ian <spyro@f2s.com>,
       Pierre Ossman <drzeus@drzeus.cx>,
       David Woodhouse <David.Woodhouse@intel.com>
Subject: [GIT] MFD update
Message-ID: <20080810214108.GA6333@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest MFD updates for 2.6.27.
They are new driver for the tc6387 and the t7l66 TMIO controllers.
You will also find the corresponding MMC and NAND TMIO drivers.

The following changes since commit 796aadeb1b2db9b5d463946766c5bbfd7717158c:
  Linus Torvalds (1):
        Merge branch 'fixes' of git://git.kernel.org/.../davej/cpufreq

are available in the git repository at:

  git://git.o-hand.com/linux-mfd for-linus

Ian Molton (8):
      mfd: TMIO MMC structures and accessors.
      mfd: driver for the T7L66XB TMIO SoC
      mfd: driver for the TC6387XB TMIO controller.
      mfd: tc6387 MMC platform data
      mfd: t7l66 MMC platform data
      mfd: driver for the TMIO NAND controller
      mfd: TMIO MMC driver
      mfd: tc6393 cleanup and update

Samuel Ortiz (3):
      mfd: Fix tc6393 according to the new tmio.h
      mfd: Fix 7l66 and 6387 according to the new mfd-core API
      mfd: have TMIO drivers and subdevices depend on ARM

 drivers/mfd/Kconfig          |   21 ++
 drivers/mfd/Makefile         |    2 +
 drivers/mfd/t7l66xb.c        |  419 +++++++++++++++++++++++++
 drivers/mfd/tc6387xb.c       |  181 +++++++++++
 drivers/mfd/tc6393xb.c       |  159 ++++++----
 drivers/mmc/host/Kconfig     |    6 +
 drivers/mmc/host/Makefile    |    1 +
 drivers/mmc/host/tmio_mmc.c  |  691 ++++++++++++++++++++++++++++++++++++++++++
 drivers/mmc/host/tmio_mmc.h  |  194 ++++++++++++
 drivers/mtd/nand/Kconfig     |    7 +
 drivers/mtd/nand/Makefile    |    1 +
 drivers/mtd/nand/tmio_nand.c |  556 +++++++++++++++++++++++++++++++++
 include/linux/mfd/t7l66xb.h  |   36 +++
 include/linux/mfd/tc6387xb.h |   23 ++
 include/linux/mfd/tc6393xb.h |    9 +-
 include/linux/mfd/tmio.h     |   19 +-
 16 files changed, 2249 insertions(+), 76 deletions(-)
 create mode 100644 drivers/mfd/t7l66xb.c
 create mode 100644 drivers/mfd/tc6387xb.c
 create mode 100644 drivers/mmc/host/tmio_mmc.c
 create mode 100644 drivers/mmc/host/tmio_mmc.h
 create mode 100644 drivers/mtd/nand/tmio_nand.c
 create mode 100644 include/linux/mfd/t7l66xb.h
 create mode 100644 include/linux/mfd/tc6387xb.h
