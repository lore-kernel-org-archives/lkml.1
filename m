Return-Path: <linux-kernel-owner+w=401wt.eu-S1756735AbXJKMAU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735AbXJKMAU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 08:00:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752671AbXJKMAJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 08:00:09 -0400
Received: from nat-132.atmel.no ([80.232.32.132]:64136 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752249AbXJKMAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 08:00:07 -0400
Date: Thu, 11 Oct 2007 13:59:58 +0200
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kernel@avr32linux.org
Subject: [GIT PULL] avr32 updates for 2.6.24-rc1
Message-ID: <20071011135958.4499eb83@dhcp-255-175.norway.atmel.com>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull from

  ssh://master.kernel.org/pub/scm/linux/kernel/git/hskinnemoen/avr32-2.6.git for-linus

to receive the following updates.

David Brownell (2):
      [AVR32] /sys/kernel/debug/at32ap_clk
      [AVR32] ngw100 i2c-gpio tweaks

Haavard Skinnemoen (8):
      [AVR32] Move AT32_PM_BASE definition into pm.h
      [AVR32] Wire up USBA device
      [AVR32] checkstack support
      [AVR32] Kill a few hardcoded constants in vmlinux.lds
      [AVR32] Remove unneeded 8K alignment of .text section
      [AVR32] Make dma_sync_*_for_cpu no-ops
      [AVR32] Ignore a few irrelevant syscalls
      [AVR32] Don't use __builtin_xchg()

Kristoffer Nyborg Gregertsen (1):
      [AVR32] SMC configuration in clock cycles

Matteo Vit (2):
      [AVR32] add multidrive support for pio driver
      [AVR32] fix command line parsing in early_parse_fbmem

Philippe Rétornaz (1):
      [AVR32] Fix random segfault with preemption

Robert P. J. Day (1):
      [AVR32] Drop support for redundant "keepinitrd" boot-time parm.

Sam Ravnborg (1):
      [AVR32] rename vmlinux.lds

 arch/avr32/boards/atngw100/flash.c                 |    5 +-
 arch/avr32/boards/atngw100/setup.c                 |   14 ++-
 arch/avr32/boards/atstk1000/atstk1002.c            |    1 +
 arch/avr32/boards/atstk1000/flash.c                |    5 +-
 arch/avr32/kernel/Makefile                         |    5 -
 arch/avr32/kernel/entry-avr32b.S                   |   26 ++++-
 arch/avr32/kernel/setup.c                          |    2 +-
 arch/avr32/kernel/{vmlinux.lds.c => vmlinux.lds.S} |    9 +-
 arch/avr32/mach-at32ap/at32ap7000.c                |   74 ++++++++++-
 arch/avr32/mach-at32ap/clock.c                     |  116 ++++++++++++++++++
 arch/avr32/mach-at32ap/hsmc.c                      |  129 +++++++++++++++++---
 arch/avr32/mach-at32ap/pio.c                       |    4 +
 arch/avr32/mach-at32ap/pm.h                        |    8 ++
 arch/avr32/mm/init.c                               |   12 +--
 include/asm-avr32/arch-at32ap/board.h              |    8 ++
 include/asm-avr32/arch-at32ap/portmux.h            |    1 +
 include/asm-avr32/arch-at32ap/smc.h                |   51 ++++++--
 include/asm-avr32/dma-mapping.h                    |   17 ++-
 include/asm-avr32/system.h                         |   13 ++-
 include/asm-avr32/unistd.h                         |   13 ++
 scripts/checkstack.pl                              |    5 +
 21 files changed, 446 insertions(+), 72 deletions(-)
 rename arch/avr32/kernel/{vmlinux.lds.c => vmlinux.lds.S} (95%)
