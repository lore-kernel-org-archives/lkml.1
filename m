Return-Path: <linux-kernel-owner+w=401wt.eu-S1764682AbXGRTQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764682AbXGRTQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 15:16:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbXGRTQl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 15:16:41 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:58628 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752808AbXGRTQk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 15:16:40 -0400
Date: Wed, 18 Jul 2007 21:16:31 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] AVR32 update
Message-ID: <20070718211631.1652e400@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 2.10.0 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull

  git://git.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates.

David Brownell (2):
      [AVR32] faster avr32 unaligned access
      [AVR32] Make STK1000 mux settings configurable

Haavard Skinnemoen (5):
      [AVR32] Split SM device into PM, RTC, WDT and EIC
      [AVR32] Remove optimization of unaligned word loads
      [AVR32] Fix build error in parse_tag_rdimg()
      [AVR32] Fix atomic_add_unless() and atomic_sub_unless()
      [AVR32] Initialize phy_mask for both macb devices

Hans-Christian Egtvedt (3):
      [AVR32] CPU frequency scaling for AT32AP
      [AVR32] Add Atmel SSC driver platform device to AT32AP architecture
      [AVR32] Wire up SSC platform device 0 as TX on ATSTK1000 board

Kristoffer Nyborg Gregertsen (1):
      [AVR32] Don't wire up macb0 unless SW6 is in default position

Robert P. J. Day (1):
      [AVR32] Correct misspelled CONFIG_BLK_DEV_INITRD variable.

 arch/avr32/Kconfig                      |   25 +++
 arch/avr32/boards/atstk1000/Kconfig     |   53 +++++
 arch/avr32/boards/atstk1000/atstk1002.c |   50 ++++-
 arch/avr32/kernel/setup.c               |    4 +-
 arch/avr32/mach-at32ap/Makefile         |    1 +
 arch/avr32/mach-at32ap/at32ap.c         |   31 ---
 arch/avr32/mach-at32ap/at32ap7000.c     |  340 +++++++++++++++++++++++--------
 arch/avr32/mach-at32ap/cpufreq.c        |  112 ++++++++++
 arch/avr32/mach-at32ap/extint.c         |  200 ++++++++++++------
 arch/avr32/mach-at32ap/pm.h             |  112 ++++++++++
 arch/avr32/mach-at32ap/sm.h             |  242 ----------------------
 include/asm-avr32/arch-at32ap/board.h   |   14 ++
 include/asm-avr32/arch-at32ap/sm.h      |   27 ---
 include/asm-avr32/atomic.h              |    4 +-
 include/asm-avr32/unaligned.h           |   15 +-
 15 files changed, 751 insertions(+), 479 deletions(-)
 create mode 100644 arch/avr32/boards/atstk1000/Kconfig
 create mode 100644 arch/avr32/mach-at32ap/cpufreq.c
 create mode 100644 arch/avr32/mach-at32ap/pm.h
 delete mode 100644 arch/avr32/mach-at32ap/sm.h
 delete mode 100644 include/asm-avr32/arch-at32ap/sm.h
