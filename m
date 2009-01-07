Return-Path: <linux-kernel-owner+w=401wt.eu-S1752738AbZAGMEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752738AbZAGMEI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 07:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753055AbZAGMDk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 07:03:40 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:63528 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752762AbZAGMDj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 07:03:39 -0500
Date: Wed, 7 Jan 2009 13:03:28 +0100
From: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       AVR32 Linux Kernel <kernel@avr32linux.org>
Subject: [GIT PULL] AVR32 update for 2.6.29
Message-ID: <20090107130328.7f18e2e2@hskinnemoen-d830>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git master

to receive the following updates.

Unfortunately, I didn't manage to get the AP7200 patches I promised
ready in time, so they'll have to wait for 2.6.30.

Alex Raimondi (2):
      avr32: Allow reserving multiple pins at once
      avr32: Hammerhead board support

Ben Nizette (1):
      avr32: Remove DMATEST from defconfigs

Haavard Skinnemoen (7):
      favr-32: Remove deprecated call
      Merge branch 'cleanups' into boards
      Merge branch 'move-atmel-mci-h' into boards
      avr32: data param to at32_add_device_mci() must be non-NULL
      avr32: Define DIE_OOPS
      Merge branches 'fixes', 'cleanups' and 'boards'
      avr32: Move syscalls.h under arch/avr32/include/asm/

Jaswinder Singh (1):
      avr32: Introducing asm/syscalls.h

Julia Lawall (1):
      arch/avr32: Eliminate NULL test and memset after alloc_bootmem

Kay Sievers (1):
      avr: struct device - replace bus_id with dev_name(), dev_set_name()

Mark Jackson (1):
      MIMC200: Remove deprecated call

Nicolas Ferre (1):
      atmel-mci: move atmel-mci.h file to include/linux

 arch/avr32/Kconfig                                 |   19 +
 arch/avr32/Makefile                                |    1 +
 arch/avr32/boards/atngw100/setup.c                 |    2 +-
 arch/avr32/boards/atstk1000/atstk1002.c            |   20 +-
 arch/avr32/boards/atstk1000/atstk1003.c            |   20 +-
 arch/avr32/boards/atstk1000/atstk1004.c            |    2 +-
 arch/avr32/boards/favr-32/setup.c                  |   31 +-
 arch/avr32/boards/hammerhead/Kconfig               |   43 +
 arch/avr32/boards/hammerhead/Makefile              |    1 +
 arch/avr32/boards/hammerhead/flash.c               |  377 +++++
 arch/avr32/boards/hammerhead/flash.h               |    6 +
 arch/avr32/boards/hammerhead/setup.c               |  245 ++++
 arch/avr32/boards/mimc200/setup.c                  |    4 +-
 arch/avr32/configs/atngw100_defconfig              |    2 +-
 arch/avr32/configs/atstk1002_defconfig             |    2 +-
 arch/avr32/configs/atstk1003_defconfig             |    2 +-
 arch/avr32/configs/atstk1006_defconfig             |    2 +-
 arch/avr32/configs/hammerhead_defconfig            | 1467 ++++++++++++++++++++
 arch/avr32/include/asm/kdebug.h                    |    1 +
 arch/avr32/include/asm/syscalls.h                  |   39 +
 arch/avr32/kernel/process.c                        |    1 +
 arch/avr32/kernel/signal.c                         |    1 +
 arch/avr32/kernel/sys_avr32.c                      |    1 +
 arch/avr32/mach-at32ap/at32ap700x.c                |    6 +-
 arch/avr32/mach-at32ap/clock.h                     |    3 +
 arch/avr32/mach-at32ap/include/mach/at32ap700x.h   |    3 +
 arch/avr32/mach-at32ap/include/mach/portmux.h      |    2 +-
 arch/avr32/mach-at32ap/pio.c                       |   19 +-
 arch/avr32/mm/cache.c                              |    1 +
 arch/avr32/mm/init.c                               |    1 -
 drivers/mmc/host/atmel-mci.c                       |    2 +-
 .../include/asm => include/linux}/atmel-mci.h      |    6 +-
 32 files changed, 2252 insertions(+), 80 deletions(-)
 create mode 100644 arch/avr32/boards/hammerhead/Kconfig
 create mode 100644 arch/avr32/boards/hammerhead/Makefile
 create mode 100644 arch/avr32/boards/hammerhead/flash.c
 create mode 100644 arch/avr32/boards/hammerhead/flash.h
 create mode 100644 arch/avr32/boards/hammerhead/setup.c
 create mode 100644 arch/avr32/configs/hammerhead_defconfig
 create mode 100644 arch/avr32/include/asm/syscalls.h
 rename {arch/avr32/include/asm => include/linux}/atmel-mci.h (91%)
