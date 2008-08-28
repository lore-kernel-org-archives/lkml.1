Return-Path: <linux-kernel-owner+w=401wt.eu-S1755635AbYH1QDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbYH1QDd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 12:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753825AbYH1QDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 12:03:10 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:42030 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbYH1QDH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 12:03:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:mime-version:content-type
         :content-transfer-encoding:content-disposition:x-google-sender-auth;
        b=C98KP7tmhcGTppWvO2dJG2IelLk0TTSx36dgrW3NiVxL9xLVtyIsrHiMvg0Rd6Nfl2
         n/dd5EgRWmltSI85jRrQgGRdn4oZL7DCyNYWVOKME16gIciOt7BUxHASzj10eQGfzbNF
         CX/J4BrUJ4s5ashGnlBNaMWMK71Xep/FHBhwo=
Message-ID: <386072610808280903v7502e994p97d8c446938c9341@mail.gmail.com>
Date: Fri, 29 Aug 2008 00:03:05 +0800
From: "Bryan Wu" <cooloney@kernel.org>
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Blackfin arch updates and bug fixing
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Google-Sender-Auth: be7f955aa64e9955
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

In this git-pull request, we finished moving include/asm-blackfin
header files to arch/blackfin and also fixed some critical bugs.
It's time to shift blackfin to the new header file layout for further
development.

So please pull from 'for-linus' branch of

master.kernel.org:/pub/scm/linux/kernel/git/cooloney/blackfin-2.6.git for-linus

to receive the following updates:

 arch/blackfin/Kconfig                              |    1 +
 arch/blackfin/Makefile                             |   26 +---
 .../blackfin/include/asm}/.gitignore               |    0
 .../blackfin/include/asm}/Kbuild                   |    0
 .../blackfin/include/asm}/a.out.h                  |    0
 .../blackfin/include/asm}/atomic.h                 |    0
 .../blackfin/include/asm}/auxvec.h                 |    0
 .../blackfin/include/asm}/bfin-global.h            |    0
 .../blackfin/include/asm}/bfin5xx_spi.h            |    0
 .../blackfin/include/asm}/bfin_simple_timer.h      |    0
 .../blackfin/include/asm}/bfin_sport.h             |    0
 .../blackfin/include/asm}/bitops.h                 |    0
 .../blackfin/include/asm}/blackfin.h               |    4 +-
 .../blackfin/include/asm}/bug.h                    |    0
 .../blackfin/include/asm}/bugs.h                   |    0
 .../blackfin/include/asm}/byteorder.h              |    0
 .../blackfin/include/asm}/cache.h                  |    0
 .../blackfin/include/asm}/cacheflush.h             |    0
 .../blackfin/include/asm}/cdef_LPBlackfin.h        |    2 +-
 .../blackfin/include/asm}/checksum.h               |    0
 .../blackfin/include/asm}/clocks.h                 |    0
 .../blackfin/include/asm}/context.S                |    0
 .../blackfin/include/asm}/cplb-mpu.h               |    0
 .../blackfin/include/asm}/cplb.h                   |    2 +-
 .../blackfin/include/asm}/cplbinit.h               |    0
 .../blackfin/include/asm}/cpumask.h                |    0
 .../blackfin/include/asm}/cputime.h                |    0
 .../blackfin/include/asm}/current.h                |    0
 .../blackfin/include/asm}/def_LPBlackfin.h         |    2 +-
 .../blackfin/include/asm}/delay.h                  |    2 +-
 .../blackfin/include/asm}/device.h                 |    0
 .../blackfin/include/asm}/div64.h                  |    0
 .../blackfin/include/asm}/dma-mapping.h            |    0
 .../blackfin/include/asm}/dma.h                    |    2 +-
 .../blackfin/include/asm}/dpmc.h                   |    0
 .../blackfin/include/asm}/early_printk.h           |    0
 .../blackfin/include/asm}/elf.h                    |    0
 .../blackfin/include/asm}/emergency-restart.h      |    0
 .../blackfin/include/asm}/entry.h                  |    0
 .../blackfin/include/asm}/errno.h                  |    0
 .../blackfin/include/asm}/fb.h                     |    0
 .../blackfin/include/asm}/fcntl.h                  |    0
 .../blackfin/include/asm}/fixed_code.h             |    0
 .../blackfin/include/asm}/flat.h                   |    0
 .../blackfin/include/asm}/futex.h                  |    0
 .../blackfin/include/asm}/gpio.h                   |    2 +-
 .../blackfin/include/asm}/gptimers.h               |    0
 .../blackfin/include/asm}/hardirq.h                |    0
 .../blackfin/include/asm}/hw_irq.h                 |    0
 .../blackfin/include/asm}/io.h                     |    0
 .../blackfin/include/asm}/ioctl.h                  |    0
 .../blackfin/include/asm}/ioctls.h                 |    0
 .../blackfin/include/asm}/ipcbuf.h                 |    0
 .../blackfin/include/asm}/irq.h                    |    4 +-
 .../blackfin/include/asm}/irq_handler.h            |    0
 .../blackfin/include/asm}/irq_regs.h               |    0
 .../blackfin/include/asm}/kdebug.h                 |    0
 .../blackfin/include/asm}/kgdb.h                   |    0
 .../blackfin/include/asm}/kmap_types.h             |    0
 .../blackfin/include/asm}/l1layout.h               |    0
 .../blackfin/include/asm}/linkage.h                |    0
 .../blackfin/include/asm}/local.h                  |    0
 .../blackfin/include/asm}/mem_map.h                |    2 +-
 .../blackfin/include/asm}/mman.h                   |    0
 .../blackfin/include/asm}/mmu.h                    |    0
 .../blackfin/include/asm}/mmu_context.h            |    6 +-
 .../blackfin/include/asm}/module.h                 |    0
 .../blackfin/include/asm}/msgbuf.h                 |    0
 .../blackfin/include/asm}/mutex.h                  |    0
 .../blackfin/include/asm}/nand.h                   |    0
 .../blackfin/include/asm}/page.h                   |    0
 .../blackfin/include/asm}/page_offset.h            |    0
 .../blackfin/include/asm}/param.h                  |    0
 .../blackfin/include/asm}/pci.h                    |    0
 .../blackfin/include/asm}/percpu.h                 |    0
 .../blackfin/include/asm}/pgalloc.h                |    0
 .../blackfin/include/asm}/pgtable.h                |    2 +-
 .../blackfin/include/asm}/poll.h                   |    0
 .../blackfin/include/asm}/portmux.h                |    2 +-
 .../blackfin/include/asm}/posix_types.h            |    0
 .../blackfin/include/asm}/processor.h              |    0
 .../blackfin/include/asm}/ptrace.h                 |    0
 .../blackfin/include/asm}/reboot.h                 |    0
 .../blackfin/include/asm}/resource.h               |    0
 .../blackfin/include/asm}/scatterlist.h            |    0
 .../blackfin/include/asm}/sections.h               |    0
 .../blackfin/include/asm}/segment.h                |    0
 .../blackfin/include/asm}/sembuf.h                 |    0
 .../blackfin/include/asm}/serial.h                 |    0
 .../blackfin/include/asm}/setup.h                  |    0
 .../blackfin/include/asm}/shmbuf.h                 |    0
 .../blackfin/include/asm}/shmparam.h               |    0
 .../blackfin/include/asm}/sigcontext.h             |    0
 .../blackfin/include/asm}/siginfo.h                |    0
 .../blackfin/include/asm}/signal.h                 |    0
 .../blackfin/include/asm}/socket.h                 |    0
 .../blackfin/include/asm}/sockios.h                |    0
 .../blackfin/include/asm}/spinlock.h               |    0
 .../blackfin/include/asm}/stat.h                   |    0
 .../blackfin/include/asm}/statfs.h                 |    0
 .../blackfin/include/asm}/string.h                 |    0
 .../blackfin/include/asm}/system.h                 |    2 +-
 .../blackfin/include/asm}/termbits.h               |    0
 .../blackfin/include/asm}/termios.h                |    0
 .../blackfin/include/asm}/thread_info.h            |    0
 .../blackfin/include/asm}/time.h                   |    0
 .../blackfin/include/asm}/timex.h                  |    0
 .../blackfin/include/asm}/tlb.h                    |    0
 .../blackfin/include/asm}/tlbflush.h               |    0
 .../blackfin/include/asm}/topology.h               |    0
 .../blackfin/include/asm}/trace.h                  |    0
 .../blackfin/include/asm}/traps.h                  |    0
 .../blackfin/include/asm}/types.h                  |    0
 .../blackfin/include/asm}/uaccess.h                |    0
 .../blackfin/include/asm}/ucontext.h               |    0
 .../blackfin/include/asm}/unaligned.h              |    0
 .../blackfin/include/asm}/unistd.h                 |    0
 .../blackfin/include/asm}/user.h                   |    0
 arch/blackfin/kernel/entry.S                       |    2 +-
 arch/blackfin/mach-bf527/head.S                    |    4 +-
 .../blackfin/mach-bf527/include/mach}/anomaly.h    |    0
 .../blackfin/mach-bf527/include/mach}/bf527.h      |    0
 .../mach-bf527/include/mach}/bfin_serial_5xx.h     |    0
 .../blackfin/mach-bf527/include/mach}/bfin_sir.h   |    0
 .../blackfin/mach-bf527/include/mach}/blackfin.h   |    0
 .../blackfin/mach-bf527/include/mach}/cdefBF522.h  |    2 +-
 .../blackfin/mach-bf527/include/mach}/cdefBF525.h  |    2 +-
 .../blackfin/mach-bf527/include/mach}/cdefBF527.h  |    2 +-
 .../mach-bf527/include/mach}/cdefBF52x_base.h      |    2 +-
 .../blackfin/mach-bf527/include/mach}/defBF522.h   |    2 +-
 .../blackfin/mach-bf527/include/mach}/defBF525.h   |    2 +-
 .../blackfin/mach-bf527/include/mach}/defBF527.h   |    2 +-
 .../mach-bf527/include/mach}/defBF52x_base.h       |  185 +++++++++----------
 .../blackfin/mach-bf527/include/mach}/dma.h        |    0
 .../blackfin/mach-bf527/include/mach}/irq.h        |    0
 .../blackfin/mach-bf527/include/mach}/mem_init.h   |    0
 .../blackfin/mach-bf527/include/mach}/mem_map.h    |    0
 .../blackfin/mach-bf527/include/mach}/portmux.h    |    0
 arch/blackfin/mach-bf533/head.S                    |    4 +-
 .../blackfin/mach-bf533/include/mach}/anomaly.h    |    0
 .../blackfin/mach-bf533/include/mach}/bf533.h      |    0
 .../mach-bf533/include/mach}/bfin_serial_5xx.h     |    0
 .../blackfin/mach-bf533/include/mach}/bfin_sir.h   |    0
 .../blackfin/mach-bf533/include/mach}/blackfin.h   |    0
 .../blackfin/mach-bf533/include/mach}/cdefBF532.h  |    2 +-
 .../blackfin/mach-bf533/include/mach}/defBF532.h   |    2 +-
 .../blackfin/mach-bf533/include/mach}/dma.h        |    0
 .../blackfin/mach-bf533/include/mach}/irq.h        |    0
 .../blackfin/mach-bf533/include/mach}/mem_init.h   |    0
 .../blackfin/mach-bf533/include/mach}/mem_map.h    |    0
 .../blackfin/mach-bf533/include/mach}/portmux.h    |    0
 arch/blackfin/mach-bf537/boards/stamp.c            |   27 +++-
 arch/blackfin/mach-bf537/head.S                    |    4 +-
 .../blackfin/mach-bf537/include/mach}/anomaly.h    |    0
 .../blackfin/mach-bf537/include/mach}/bf537.h      |    0
 .../mach-bf537/include/mach}/bfin_serial_5xx.h     |    0
 .../blackfin/mach-bf537/include/mach}/bfin_sir.h   |    0
 .../blackfin/mach-bf537/include/mach}/blackfin.h   |    0
 .../blackfin/mach-bf537/include/mach}/cdefBF534.h  |    2 +-
 .../blackfin/mach-bf537/include/mach}/cdefBF537.h  |    0
 .../blackfin/mach-bf537/include/mach}/defBF534.h   |    2 +-
 .../blackfin/mach-bf537/include/mach}/defBF537.h   |    2 +-
 .../blackfin/mach-bf537/include/mach}/dma.h        |    0
 .../blackfin/mach-bf537/include/mach}/irq.h        |    0
 .../blackfin/mach-bf537/include/mach}/mem_init.h   |    0
 .../blackfin/mach-bf537/include/mach}/mem_map.h    |    0
 .../blackfin/mach-bf537/include/mach}/portmux.h    |    0
 arch/blackfin/mach-bf548/boards/cm_bf548.c         |    4 +-
 arch/blackfin/mach-bf548/boards/ezkit.c            |    4 +-
 arch/blackfin/mach-bf548/head.S                    |    4 +-
 .../blackfin/mach-bf548/include/mach}/anomaly.h    |    0
 .../blackfin/mach-bf548/include/mach}/bf548.h      |    0
 .../mach-bf548/include/mach}/bf54x-lq043.h         |    0
 .../blackfin/mach-bf548/include/mach}/bf54x_keys.h |    0
 .../mach-bf548/include/mach}/bfin_serial_5xx.h     |    0
 .../blackfin/mach-bf548/include/mach}/bfin_sir.h   |    0
 .../blackfin/mach-bf548/include/mach}/blackfin.h   |    0
 .../blackfin/mach-bf548/include/mach}/cdefBF542.h  |    2 +-
 .../blackfin/mach-bf548/include/mach}/cdefBF544.h  |    2 +-
 .../blackfin/mach-bf548/include/mach}/cdefBF547.h  |    2 +-
 .../blackfin/mach-bf548/include/mach}/cdefBF548.h  |    2 +-
 .../blackfin/mach-bf548/include/mach}/cdefBF549.h  |    2 +-
 .../mach-bf548/include/mach}/cdefBF54x_base.h      |    0
 .../blackfin/mach-bf548/include/mach}/defBF542.h   |    2 +-
 .../blackfin/mach-bf548/include/mach}/defBF544.h   |    2 +-
 .../blackfin/mach-bf548/include/mach}/defBF547.h   |    2 +-
 .../blackfin/mach-bf548/include/mach}/defBF548.h   |    2 +-
 .../blackfin/mach-bf548/include/mach}/defBF549.h   |    2 +-
 .../mach-bf548/include/mach}/defBF54x_base.h       |    0
 .../blackfin/mach-bf548/include/mach}/dma.h        |    0
 .../blackfin/mach-bf548/include/mach}/gpio.h       |    0
 .../blackfin/mach-bf548/include/mach}/irq.h        |    0
 .../blackfin/mach-bf548/include/mach}/mem_init.h   |    0
 .../blackfin/mach-bf548/include/mach}/mem_map.h    |    0
 .../blackfin/mach-bf548/include/mach}/portmux.h    |    0
 arch/blackfin/mach-bf561/head.S                    |    4 +-
 .../blackfin/mach-bf561/include/mach}/anomaly.h    |    0
 .../blackfin/mach-bf561/include/mach}/bf561.h      |    0
 .../mach-bf561/include/mach}/bfin_serial_5xx.h     |    0
 .../blackfin/mach-bf561/include/mach}/bfin_sir.h   |    0
 .../blackfin/mach-bf561/include/mach}/blackfin.h   |    0
 .../blackfin/mach-bf561/include/mach}/cdefBF561.h  |    2 +-
 .../blackfin/mach-bf561/include/mach}/defBF561.h   |    2 +-
 .../blackfin/mach-bf561/include/mach}/dma.h        |    0
 .../blackfin/mach-bf561/include/mach}/irq.h        |    0
 .../blackfin/mach-bf561/include/mach}/mem_init.h   |    0
 .../blackfin/mach-bf561/include/mach}/mem_map.h    |    0
 .../blackfin/mach-bf561/include/mach}/portmux.h    |    0
 arch/blackfin/mach-common/arch_checks.c            |    4 +-
 arch/blackfin/mach-common/dpmc_modes.S             |    2 +-
 arch/blackfin/mach-common/entry.S                  |    2 +-
 arch/blackfin/mach-common/interrupt.S              |    4 +-
 arch/blackfin/mach-common/ints-priority.c          |    4 +-
 arch/blackfin/mm/blackfin_sram.c                   |   24 ++--
 drivers/input/keyboard/bf54x-keys.c                |    2 +-
 drivers/serial/bfin_5xx.c                          |    2 +-
 drivers/video/bf54x-lq043fb.c                      |    2 +-
 217 files changed, 200 insertions(+), 197 deletions(-)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/.gitignore (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/Kbuild (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/a.out.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/atomic.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/auxvec.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bfin-global.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bfin5xx_spi.h (100%)
 rename {include/asm-blackfin =>
arch/blackfin/include/asm}/bfin_simple_timer.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bfin_sport.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bitops.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/blackfin.h (96%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bug.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/bugs.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/byteorder.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cache.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cacheflush.h (100%)
 rename {include/asm-blackfin/mach-common =>
arch/blackfin/include/asm}/cdef_LPBlackfin.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/checksum.h (100%)
 rename {include/asm-blackfin/mach-common =>
arch/blackfin/include/asm}/clocks.h (100%)
 rename {include/asm-blackfin/mach-common =>
arch/blackfin/include/asm}/context.S (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cplb-mpu.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cplb.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cplbinit.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cpumask.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/cputime.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/current.h (100%)
 rename {include/asm-blackfin/mach-common =>
arch/blackfin/include/asm}/def_LPBlackfin.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/delay.h (97%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/device.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/div64.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/dma-mapping.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/dma.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/dpmc.h (100%)
 rename {include/asm-blackfin =>
arch/blackfin/include/asm}/early_printk.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/elf.h (100%)
 rename {include/asm-blackfin =>
arch/blackfin/include/asm}/emergency-restart.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/entry.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/errno.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/fb.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/fcntl.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/fixed_code.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/flat.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/futex.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/gpio.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/gptimers.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/hardirq.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/hw_irq.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/io.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/ioctl.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/ioctls.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/ipcbuf.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/irq.h (96%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/irq_handler.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/irq_regs.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/kdebug.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/kgdb.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/kmap_types.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/l1layout.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/linkage.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/local.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/mem_map.h (83%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/mman.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/mmu.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/mmu_context.h (97%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/module.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/msgbuf.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/mutex.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/nand.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/page.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/page_offset.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/param.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/pci.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/percpu.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/pgalloc.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/pgtable.h (98%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/poll.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/portmux.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/posix_types.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/processor.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/ptrace.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/reboot.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/resource.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/scatterlist.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/sections.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/segment.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/sembuf.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/serial.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/setup.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/shmbuf.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/shmparam.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/sigcontext.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/siginfo.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/signal.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/socket.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/sockios.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/spinlock.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/stat.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/statfs.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/string.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/system.h (99%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/termbits.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/termios.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/thread_info.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/time.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/timex.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/tlb.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/tlbflush.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/topology.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/trace.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/traps.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/types.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/uaccess.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/ucontext.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/unaligned.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/unistd.h (100%)
 rename {include/asm-blackfin => arch/blackfin/include/asm}/user.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/anomaly.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/bf527.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/bfin_serial_5xx.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/bfin_sir.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/blackfin.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/cdefBF522.h (96%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/cdefBF525.h (99%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/cdefBF527.h (99%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/cdefBF52x_base.h (99%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/defBF522.h (96%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/defBF525.h (99%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/defBF527.h (99%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/defBF52x_base.h (96%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/dma.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/irq.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/mem_init.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/mem_map.h (100%)
 rename {include/asm-blackfin/mach-bf527 =>
arch/blackfin/mach-bf527/include/mach}/portmux.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/anomaly.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/bf533.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/bfin_serial_5xx.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/bfin_sir.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/blackfin.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/cdefBF532.h (99%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/defBF532.h (99%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/dma.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/irq.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/mem_init.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/mem_map.h (100%)
 rename {include/asm-blackfin/mach-bf533 =>
arch/blackfin/mach-bf533/include/mach}/portmux.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/anomaly.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/bf537.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/bfin_serial_5xx.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/bfin_sir.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/blackfin.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/cdefBF534.h (99%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/cdefBF537.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/defBF534.h (99%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/defBF537.h (99%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/dma.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/irq.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/mem_init.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/mem_map.h (100%)
 rename {include/asm-blackfin/mach-bf537 =>
arch/blackfin/mach-bf537/include/mach}/portmux.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/anomaly.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/bf548.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/bf54x-lq043.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/bf54x_keys.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/bfin_serial_5xx.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/bfin_sir.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/blackfin.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF542.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF544.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF547.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF548.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF549.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/cdefBF54x_base.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF542.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF544.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF547.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF548.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF549.h (99%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/defBF54x_base.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/dma.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/gpio.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/irq.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/mem_init.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/mem_map.h (100%)
 rename {include/asm-blackfin/mach-bf548 =>
arch/blackfin/mach-bf548/include/mach}/portmux.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/anomaly.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/bf561.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/bfin_serial_5xx.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/bfin_sir.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/blackfin.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/cdefBF561.h (99%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/defBF561.h (99%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/dma.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/irq.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/mem_init.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/mem_map.h (100%)
 rename {include/asm-blackfin/mach-bf561 =>
arch/blackfin/mach-bf561/include/mach}/portmux.h (100%)

Adrian Bunk (1):
      Blackfin arch: let PCI depend on BROKEN

Bernd Schmidt (1):
      Blackfin arch: fix bug - MPU crashes under stress

Bryan Wu (1):
      Blackfin arch: move include/asm-blackfin header files to arch/blackfin

Michael Hennerich (2):
      Blackfin arch: Add MTD Partitions for MTD_DATAFLASH, increase max SPI SCLK
      Blackfin arch: Fix PM building on BF52x: No ROTWE on BF52x, add USBWE

Mike Frysinger (1):
      Blackfin arch: dont actually need to muck with EMAC_SYSTAT for
BF52x for demuxing

Sonic Zhang (1):
      Blackfin arch: Fix bug - when to rmmod the L1_module, it stucks
and then reboot the board.

Vegard Nossum (1):
      Blackfin arch: sram: use 'unsigned long' for irqflags

----
Thanks a lot
-Bryan
