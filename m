Return-Path: <linux-kernel-owner+w=401wt.eu-S1751322AbXBUXuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751322AbXBUXuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 18:50:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751364AbXBUXuE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 18:50:04 -0500
Received: from hera.kernel.org ([140.211.167.34]:33350 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbXBUXuA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 18:50:00 -0500
Date: Wed, 21 Feb 2007 23:49:26 +0000
From: Kyle McMartin <kyle@hera.kernel.org>
To: torvalds@osdl.org
Cc: akpm@osdl.org, parisc-linux@lists.parisc-linux.org,
       linux-kernel@vger.kernel.org
Subject: [git patches] parisc updates for 2.6.20
Message-ID: <20070221234926.GA12444@hera.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I know I missed the -rc1 deadline. Sorry about that. Unless Andrew has any
objections, I'd like to ask for a merge of the parisc-2.6 git tree...

The following changes since commit 62d0cfcb27cf755cebdc93ca95dabc83608007cd:
  Linus Torvalds (1):
        Linux 2.6.20

are found in the git repository at:

  /pub/scm/linux/kernel/git/kyle/parisc-2.6.git

Carlos O'Donell Jr (2):
      [PARISC] Reorder syscalls to match unistd.h
      [PARISC] Compat signal fixes for 64-bit parisc

David Howells (1):
      WorkStruct: Fix up some PA-RISC work items

Grant Grundler (1):
      [PARISC] Remove GCC_VERSION usage as suggested by Adrian Bunk

Guy Martin (1):
      [PARISC] Add missing statfs64 and fstatfs64 syscalls

Helge Deller (27):
      [PARISC] Show more memory information and memory layout at bootup
      [PARISC] avoid compiler warnings when compiling 64bit
      [TRIVIAL] [PARISC] Fix module.c printk message, add missing ')'
      [PARISC] lasi_82596: use BUILD_BUG_ON() and constify static array
      [PARISC] Generic BUG
      [PARISC] fix build for WARN_ON() when CONFIG_DEBUG_BUGVERBOSE=y
      [PARISC] whitespace cleanups and unify 32/64bit user-access assembler inlines
      [PARISC] fix fixup declarations for 32bit and use CONFIG_64BIT
      [PARISC] dump stack backtrace on BUG() and add syslog-levels to printk()s
      [PARISC] add missing syscalls for vmsplice, move_pages, getcpu & epoll_pwait
      [PARISC] Use fstatat64 instead of newfstatat syscall
      [PARISC] a and b in "break a,b" message were swapped
      [PARISC] GENERIC_TIME patchset for parisc
      [PARISC] disable cr16 clocksource when multiple CPUs are online
      [PARISC] Convert soft power switch driver to kthread
      [PARISC] detect recursive kernel crash earlier
      [PARISC] use less assembler statements in syscall path
      [PARISC] implement standard ENTRY(), END() and ENDPROC()
      [PARISC] Fixes /proc/cpuinfo cache output on B160L
      [PARISC] fix ENTRY() and ENDPROC() for 64bit-parisc
      [PARISC] more ENTRY(), ENDPROC(), END() conversions
      [PARISC] add ASM_EXCEPTIONTABLE_ENTRY() macro
      [PARISC] use CONFIG_64BIT instead of __LP64__
      [PARISC] convert to use CONFIG_64BIT instead of __LP64__
      [PARISC] add ENTRY()/ENDPROC() and simplify assembly of HP/UX emulation code
      [PARISC] do not export get_register/set_register
      [PARISC] fix section mismatch warnings in harmony sound driver

Kyle McMartin (20):
      [PARISC] Unbreak discontigmem mem_init()
      [PARISC] Reserve 1GB of space for vmalloc/tmpalias space on parisc64
      [PARISC] bloody printf fmt string warnings
      [PARISC] Remove duplicate PDC_PAT_CELL defines
      [PARISC] Move spinlock_t out of struct cpu_data
      [PARISC] Fix thinko in cpu_data.lock removal
      Merge branch 'parisc' from /home/kyle/repos/parisc-2.6.git
      [PARISC] "Fix" circular includes
      [PARISC] use fls_long in irq.c
      [PARISC] Add TIF_RESTORE_SIGMASK support
      [PARISC] display parisc device modalias in sysfs
      [PARISC] move parisc_device_id definition to mod_devicetable.h
      [PARISC] generate modalias for parisc_device_id tables
      [PARISC] rename *_ANY_ID to PA_*_ANY_ID in the exported header
      [PARISC] factor syscall_restart code out of do_signal
      [PARISC] clean up debugging printks in smp.c
      [PARISC] kill ENTRY_SYS_CPUS
      [PARISC] fix sys_rt_sigqueueinfo
      Revert "[PARISC] Optimize TLB flush on SMP systems"
      [PARISC] Use symbolic last syscall in __NR_Linux_syscalls

Mariusz Kozlowski (1):
      [PARISC] pdcpat remove extra brackets

Matthew Wilcox (13):
      [PARISC] Delete arch/parisc/mm/kmap.c again
      [PARISC] parisc-agp: Fix integer/pointer warning
      [PARISC] sparse fixes
      [PARISC] more sparse fixes
      [PARISC] Fix PCI bus numbering in the presence of Cardbus bridges
      [PARISC] Make Lasi Ethernet depend on GSC only
      PA-RISC: Fix bogus warnings from modpost
      [PARISC] Only write to memory in test_and_set_bit/test_and_clear_bit if we're
      [PARISC] Add prototypes for flush_user_dcache_range and flush_user_icache_range
      [PARISC] Remove sched.h from uaccess.h on parisc
      [PARISC] Fix show_stack() when we can't kmalloc
      [PARISC] lba_pci format warnings
      Revert "[PATCH] make kernel/signal.c:kill_proc_info() static"

Mike Frysinger (1):
      use __u64 rather than u64 in parisc statfs structs

Randolph Chung (2):
      [PARISC] Optimize TLB flush on SMP systems
      [PARISC] Clean up the cache and tlb headers

Randy Dunlap (1):
      parisc: fix module_param iommu permission

Ryan Bradetich (9):
      [PARISC] Fix ccio_request_resource when CONFIG_IOMMU_CCIO is not defined
      [PARISC] HPPB bus updates for E-Class systems
      [PARISC] [MUX] Mux driver bug fix
      [PARISC] [MUX] Mux driver updates
      [PARISC] [MUX] Claim resources for the Mux driver
      [PARISC] [MUX] Make the Serial Mux driver work as module
      [PARISC] [MUX] Detect multiple cards in the correct order
      [PARISC] [MUX] Correctly report the number of available ports
      [PARISC] [MUX] Get the hversion directly from the parisc_device

 arch/parisc/Kconfig                 |    9 ++
 arch/parisc/Makefile                |    8 +-
 arch/parisc/hpux/entry_hpux.S       |   10 +-
 arch/parisc/hpux/fs.c               |   26 ++--
 arch/parisc/hpux/gate.S             |   23 +--
 arch/parisc/hpux/sys_hpux.c         |   32 +++--
 arch/parisc/hpux/wrappers.S         |   45 +++----
 arch/parisc/kernel/asm-offsets.c    |    2 +-
 arch/parisc/kernel/cache.c          |  188 ++++++++++++++++++++++--
 arch/parisc/kernel/drivers.c        |   19 ++-
 arch/parisc/kernel/entry.S          |  241 +++++++++++++------------------
 arch/parisc/kernel/firmware.c       |   26 ++--
 arch/parisc/kernel/head.S           |   15 ++-
 arch/parisc/kernel/hpmc.S           |   16 +--
 arch/parisc/kernel/inventory.c      |   10 +-
 arch/parisc/kernel/irq.c            |    6 +-
 arch/parisc/kernel/module.c         |   23 ++--
 arch/parisc/kernel/pacache.S        |   89 +++++-------
 arch/parisc/kernel/parisc_ksyms.c   |   10 +-
 arch/parisc/kernel/pci-dma.c        |    2 +-
 arch/parisc/kernel/pci.c            |    4 +-
 arch/parisc/kernel/perf_asm.S       |   26 ++--
 arch/parisc/kernel/process.c        |    8 +-
 arch/parisc/kernel/processor.c      |   11 +-
 arch/parisc/kernel/ptrace.c         |   10 +-
 arch/parisc/kernel/real2.S          |   16 ++-
 arch/parisc/kernel/setup.c          |    6 +-
 arch/parisc/kernel/signal.c         |  273 +++++++++++++++++------------------
 arch/parisc/kernel/signal32.c       |   42 ++++--
 arch/parisc/kernel/smp.c            |  178 +++--------------------
 arch/parisc/kernel/syscall.S        |   71 +++-------
 arch/parisc/kernel/syscall_table.S  |   16 ++-
 arch/parisc/kernel/time.c           |  146 +++++--------------
 arch/parisc/kernel/traps.c          |  153 ++++++++++----------
 arch/parisc/kernel/unaligned.c      |  115 ++++-----------
 arch/parisc/kernel/unwind.c         |    1 +
 arch/parisc/kernel/vmlinux.lds.S    |    2 +
 arch/parisc/lib/bitops.c            |    4 +-
 arch/parisc/lib/fixup.S             |   20 ++--
 arch/parisc/lib/lusercopy.S         |   37 ++----
 arch/parisc/lib/memcpy.c            |   38 ++----
 arch/parisc/mm/fault.c              |    4 -
 arch/parisc/mm/init.c               |   72 +++++++++-
 arch/parisc/mm/ioremap.c            |    6 +-
 arch/parisc/mm/kmap.c               |  166 ---------------------
 arch/parisc/oprofile/init.c         |    2 +-
 drivers/char/agp/parisc-agp.c       |    2 +-
 drivers/net/Kconfig                 |    6 +-
 drivers/net/lasi_82596.c            |   34 +----
 drivers/parisc/hppb.c               |   14 +-
 drivers/parisc/iosapic_private.h    |    2 +-
 drivers/parisc/lba_pci.c            |   90 +++++++------
 drivers/parisc/led.c                |   14 +-
 drivers/parisc/power.c              |  201 ++++++++++++--------------
 drivers/parisc/sba_iommu.c          |    4 +-
 drivers/serial/mux.c                |  167 +++++++++++++++++-----
 include/asm-parisc/assembly.h       |   20 ++-
 include/asm-parisc/atomic.h         |   12 +-
 include/asm-parisc/bitops.h         |   24 ++--
 include/asm-parisc/bug.h            |   88 +++++++++++-
 include/asm-parisc/cache.h          |   29 +---
 include/asm-parisc/cacheflush.h     |  179 +++++------------------
 include/asm-parisc/dma-mapping.h    |    2 +-
 include/asm-parisc/elf.h            |    2 +-
 include/asm-parisc/hardware.h       |   16 +--
 include/asm-parisc/io.h             |    4 +-
 include/asm-parisc/led.h            |    2 +-
 include/asm-parisc/linkage.h        |   28 ++++-
 include/asm-parisc/mmzone.h         |    2 +-
 include/asm-parisc/module.h         |    2 +-
 include/asm-parisc/msgbuf.h         |    6 +-
 include/asm-parisc/page.h           |    8 +-
 include/asm-parisc/parisc-device.h  |    2 +-
 include/asm-parisc/pdc.h            |   10 +-
 include/asm-parisc/pdcpat.h         |   31 +----
 include/asm-parisc/pgalloc.h        |   10 +-
 include/asm-parisc/pgtable.h        |    1 -
 include/asm-parisc/posix_types.h    |    2 +-
 include/asm-parisc/processor.h      |   10 +-
 include/asm-parisc/sembuf.h         |    4 +-
 include/asm-parisc/shmbuf.h         |   10 +-
 include/asm-parisc/signal.h         |    2 +-
 include/asm-parisc/smp.h            |    8 -
 include/asm-parisc/spinlock_types.h |    4 -
 include/asm-parisc/statfs.h         |   10 +-
 include/asm-parisc/system.h         |    2 +-
 include/asm-parisc/thread_info.h    |    4 +-
 include/asm-parisc/tlbflush.h       |   30 +----
 include/asm-parisc/types.h          |    2 +-
 include/asm-parisc/uaccess.h        |  122 +++++-----------
 include/asm-parisc/unistd.h         |   12 ++-
 include/linux/mod_devicetable.h     |   12 ++
 include/linux/sched.h               |    1 +
 kernel/signal.c                     |    3 +-
 scripts/mod/file2alias.c            |   22 +++
 scripts/mod/modpost.c               |    3 +-
 sound/parisc/harmony.c              |    4 +-
 97 files changed, 1586 insertions(+), 1920 deletions(-)
 delete mode 100644 arch/parisc/mm/kmap.c
