Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994Ab0BCSkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 13:40:49 -0500
Received: from mail-fx0-f215.google.com ([209.85.220.215]:60838 "EHLO
	mail-fx0-f215.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756862Ab0BCSks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 13:40:48 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:mime-version:message-id
         :content-type:content-transfer-encoding;
        b=KaALi2X00t+THaaysoqCdUgMWXGViDlwxFd4Si4ASmXLZ+PFfyVPgTfzwFNiHkiBDx
         DN1dedvy9cnGQ6Cf9mva9VYqkJrruhNo9pOk1CzS1fQr8FyTtiF4RxMnhX5SAGYvMQ9p
         8guTJmCynWmon5w9c4H0AfXC9ZkYrpuzs5Dio=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: linux-ide@vger.kernel.org
Subject: [git patches] new hardware support for atang tree
Date: Wed, 3 Feb 2010 19:40:20 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.8-0.1-desktop; KDE/4.3.1; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Thomas Abraham <thomas.ab@samsung.com>,
       ben-linux@fluff.org, linux-arm-kernel@lists.infradead.org,
       Thomas Chou <thomas@wytron.com.tw>,
       Nios2 development list <nios2-dev@sopc.et.ntust.edu.tw>,
       Ian Abbott <abbotti@mev.co.uk>
MIME-Version: 1.0
Message-Id: <201002031940.20129.bzolnier@gmail.com>
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since I haven't seen any progress on mainstreaming of s3c-ide and
pata_altera_cf patches in the recent months I decided to merge them
into staging section of my tree in order to help in keeping them
in-sync with ongoing changes..


DISCLAIMER: the fact of getting patches merged into atang tree means
that from now on they will be getting updates for changes happening
in atang tree and it should not be treated as an indication regarding
decisions taken by 'upstream' kernel trees


The following changes since commit 18c77417cbb9c595935d5ccb2e55309f0fb75a06:
  Bartlomiej Zolnierkiewicz (1):
        ide: remove hwif_chipset_t type

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/bart/misc.git atang-v4.4

Thomas Abraham (8):
      S3C64XX: Add physical address definition for Compact Flash controller.
      S3C64XX: Add MEM_SYS_CFG register definition.
      S3C64XX: Add IDE controller register definitions.
      S3C64XX: Add clock source definition for IDE controller.
      S3C64XX: Add platform data and driver resources for IDE controller driver.
      S3C6410: Add platform data for S3C IDE controller driver
      S3C64XX: Include IDE device code in compilation.
      drivers/staging: Add Samsung S3C IDE controller driver

Thomas Chou (1):
      drivers/staging: New PATA driver for Altera CompactFlash.

 arch/arm/mach-s3c6400/include/mach/map.h        |    4 +
 arch/arm/mach-s3c6410/mach-smdk6410.c           |   14 +-
 arch/arm/plat-s3c/include/plat/devs.h           |    1 +
 arch/arm/plat-s3c/include/plat/ide.h            |   36 +
 arch/arm/plat-s3c/include/plat/regs-ide.h       |   56 ++
 arch/arm/plat-s3c64xx/Makefile                  |    1 +
 arch/arm/plat-s3c64xx/clock.c                   |    6 +
 arch/arm/plat-s3c64xx/dev-ide.c                 |   88 +++
 arch/arm/plat-s3c64xx/include/plat/regs-clock.h |    3 +
 drivers/staging/Kconfig                         |    4 +
 drivers/staging/Makefile                        |    2 +
 drivers/staging/pata_altera_cf/Kconfig          |   11 +
 drivers/staging/pata_altera_cf/Makefile         |    1 +
 drivers/staging/pata_altera_cf/TODO             |    5 +
 drivers/staging/pata_altera_cf/pata_altera_cf.c |  582 ++++++++++++++++
 drivers/staging/s3c-ide/Kconfig                 |    8 +
 drivers/staging/s3c-ide/Makefile                |    1 +
 drivers/staging/s3c-ide/TODO                    |    6 +
 drivers/staging/s3c-ide/s3c-ide.c               |  822 +++++++++++++++++++++++
 19 files changed, 1650 insertions(+), 1 deletions(-)
 create mode 100644 arch/arm/plat-s3c/include/plat/ide.h
 create mode 100644 arch/arm/plat-s3c/include/plat/regs-ide.h
 create mode 100644 arch/arm/plat-s3c64xx/dev-ide.c
 create mode 100644 drivers/staging/pata_altera_cf/Kconfig
 create mode 100644 drivers/staging/pata_altera_cf/Makefile
 create mode 100644 drivers/staging/pata_altera_cf/TODO
 create mode 100644 drivers/staging/pata_altera_cf/pata_altera_cf.c
 create mode 100644 drivers/staging/s3c-ide/Kconfig
 create mode 100644 drivers/staging/s3c-ide/Makefile
 create mode 100644 drivers/staging/s3c-ide/TODO
 create mode 100644 drivers/staging/s3c-ide/s3c-ide.c
