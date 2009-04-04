Return-Path: <linux-kernel-owner+w=401wt.eu-S1754575AbZDDQIZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575AbZDDQIZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 12:08:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbZDDQIQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 12:08:16 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:51150 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbZDDQIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 12:08:14 -0400
Date: Sun, 5 Apr 2009 01:03:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [GIT PULL] sh updates for 2.6.30-rc1, part 2.
Message-ID: <20090404160333.GC17834@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please pull from:

	master.kernel.org:/pub/scm/linux/kernel/git/lethal/sh-2.6.git

Which contains:

Francesco VIRLINZI (1):
      sh: Sanitize asm/mmu.h for assembly use.

Kuninori Morimoto (5):
      sh: Remove buggy definition from SH7786 pinmux_data[]
      sh: urquell: enable LAN device
      sh: Tidy up sh7786 pinmux table.
      sh: ap325rxa: Add ov772x support, again.
      sh: ap325 and Migo-R use new sh_mobile_ceu_info flags

Magnus Damm (6):
      clocksource: sh_cmt: use remove_irq() and remove clockevent workaround
      sh: intc: install enable, disable and shutdown callbacks
      sh: intc: set_irq_wake() support
      input: sh_keysc: use enable/disable_irq_wake()
      rtc: rtc-sh: use set_irq_wake()
      input: migor_ts: add wakeup support

Michael Trimarchi (1):
      sh: Fix up DSP context save/restore.

Nobuhiro Iwamatsu (1):
      sh: Add MMU dependency for kexec

Paul Mundt (8):
      sh: Fix up -Wformat-security whining.
      sh: migor: Fix up CEU use flags.
      sh: Select ARCH_HIBERNATION_POSSIBLE.
      sh: Add a command line option for disabling I/O trapping.
      sh: Wire up ARCH_HAS_DEFAULT_IDLE for cpuidle.
      sh: Kill off broken direct-mapped cache mode.
      sh: update defconfigs.
      sh: Fix up number of on-chip DMA channels on SH7091.

Takashi Yoshii (1):
      sh: sh7785lcr: Map whole PCI address space.

 Documentation/kernel-parameters.txt       |    2 +
 arch/sh/Kconfig                           |    6 +-
 arch/sh/boards/board-ap325rxa.c           |   57 ++++++-
 arch/sh/boards/board-urquell.c            |    4 +
 arch/sh/boards/mach-migor/setup.c         |    4 +-
 arch/sh/configs/ap325rxa_defconfig        |   70 ++++++---
 arch/sh/configs/cayman_defconfig          |  235 ++++++++++++++---------------
 arch/sh/configs/dreamcast_defconfig       |   71 ++++++---
 arch/sh/configs/edosk7705_defconfig       |   29 +++--
 arch/sh/configs/edosk7760_defconfig       |   78 +++++++---
 arch/sh/configs/espt_defconfig            |   39 +++--
 arch/sh/configs/hp6xx_defconfig           |   54 +++++--
 arch/sh/configs/landisk_defconfig         |   97 ++++++++----
 arch/sh/configs/lboxre2_defconfig         |   69 ++++++---
 arch/sh/configs/magicpanelr2_defconfig    |   73 ++++++---
 arch/sh/configs/microdev_defconfig        |   74 +++++++---
 arch/sh/configs/migor_defconfig           |   82 +++++++----
 arch/sh/configs/polaris_defconfig         |   31 ++--
 arch/sh/configs/r7780mp_defconfig         |   91 +++++++++---
 arch/sh/configs/r7785rp_defconfig         |   96 +++++++++---
 arch/sh/configs/rsk7201_defconfig         |   57 +++++---
 arch/sh/configs/rsk7203_defconfig         |   94 ++++++++----
 arch/sh/configs/rts7751r2d1_defconfig     |   83 ++++++++---
 arch/sh/configs/rts7751r2dplus_defconfig  |   83 ++++++++---
 arch/sh/configs/sdk7780_defconfig         |   78 +++++++---
 arch/sh/configs/se7206_defconfig          |   82 +++++++---
 arch/sh/configs/se7343_defconfig          |   89 ++++++++----
 arch/sh/configs/se7619_defconfig          |   55 +++++---
 arch/sh/configs/se7705_defconfig          |   75 +++++++---
 arch/sh/configs/se7712_defconfig          |   79 +++++++---
 arch/sh/configs/se7721_defconfig          |   82 +++++++---
 arch/sh/configs/se7722_defconfig          |   76 +++++++---
 arch/sh/configs/se7750_defconfig          |   71 ++++++---
 arch/sh/configs/se7751_defconfig          |   74 +++++++---
 arch/sh/configs/se7780_defconfig          |   78 +++++++---
 arch/sh/configs/sh03_defconfig            |   79 +++++++---
 arch/sh/configs/sh7710voipgw_defconfig    |   69 ++++++---
 arch/sh/configs/sh7763rdp_defconfig       |   82 +++++++---
 arch/sh/configs/sh7785lcr_32bit_defconfig |   42 +++--
 arch/sh/configs/sh7785lcr_defconfig       |   90 ++++++++----
 arch/sh/configs/shmin_defconfig           |   73 ++++++---
 arch/sh/configs/shx3_defconfig            |   99 ++++++++----
 arch/sh/configs/snapgear_defconfig        |   62 ++++++--
 arch/sh/configs/systemh_defconfig         |   54 +++++--
 arch/sh/configs/titan_defconfig           |  101 +++++++++---
 arch/sh/configs/ul2_defconfig             |   93 +++++++++---
 arch/sh/configs/urquell_defconfig         |   45 ++++---
 arch/sh/drivers/dma/Kconfig               |   20 ++-
 arch/sh/drivers/pci/ops-sh7785lcr.c       |    9 +-
 arch/sh/drivers/pci/pci-sh7780.c          |   16 +--
 arch/sh/include/asm/mmu.h                 |   35 +++--
 arch/sh/include/asm/processor_32.h        |   13 ++
 arch/sh/include/asm/ptrace.h              |    8 -
 arch/sh/include/asm/system.h              |    1 +
 arch/sh/include/asm/system_32.h           |  170 +++++++++++++++------
 arch/sh/include/cpu-sh4/cpu/sh7786.h      |  214 ++++++++++-----------------
 arch/sh/kernel/cpu/sh3/entry.S            |   85 +----------
 arch/sh/kernel/cpu/sh4/probe.c            |    5 -
 arch/sh/kernel/cpu/sh4a/pinmux-sh7786.c   |  185 +++++------------------
 arch/sh/kernel/idle.c                     |    2 +-
 arch/sh/kernel/io_trapped.c               |   13 ++
 arch/sh/kernel/process_32.c               |   14 ++-
 arch/sh/kernel/ptrace_32.c                |    6 +-
 arch/sh/kernel/setup.c                    |    5 +-
 arch/sh/kernel/traps_32.c                 |    2 +
 arch/sh/mm/Kconfig                        |   12 --
 drivers/clocksource/sh_cmt.c              |    3 +-
 drivers/input/keyboard/sh_keysc.c         |   17 ++-
 drivers/input/touchscreen/migor_ts.c      |   23 +++
 drivers/rtc/rtc-sh.c                      |   36 +++++
 drivers/sh/intc.c                         |   68 +++++++++
 71 files changed, 2754 insertions(+), 1515 deletions(-)
