Return-Path: <linux-kernel-owner+w=401wt.eu-S1753306AbYL2Ev2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753306AbYL2Ev2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2008 23:51:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYL2EvT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Dec 2008 23:51:19 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42317
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751089AbYL2EvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2008 23:51:17 -0500
Date: Sun, 28 Dec 2008 20:51:19 -0800 (PST)
Message-Id: <20081228.205119.127198747.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [GIT]: Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The big thing in here is the merge of sparc32 and sparc64
into a single directory hierarchy.  This is mostly thanks
to the tireless work of Sam Ravnborg and testing by Robert
Reif.

Also, pseudo-NMI oprofile support for sparc64 is in here
as well.

Please pull, thanks a lot!

The following changes since commit 3c92ec8ae91ecf59d88c798301833d7cf83f2179:
  Linus Torvalds (1):
        Merge branch 'next' of git://git.kernel.org/.../paulus/powerpc

are available in the git repository at:

  master.kernel.org:/pub/scm/linux/kernel/git/davem/sparc-next-2.6.git master

Al Viro (1):
      sparc32: pdev_to_pnode() is used from __devinit

David S. Miller (39):
      Merge branch 'master' of master.kernel.org:/.../davem/sparc-2.6
      sparc64: Rework auxio driver to save some text space.
      of: Fix comment, sparc no longer uses of_device objects on special busses.
      sparc64: Run the kernel always in the TSO memory model.
      sparc64: Stop using memory barriers for atomics and locks.
      sparc64: Add tsb-ratio sysctl.
      sparc64: Add interface for registering a performance counter IRQ handler.
      sparc: Include drivers/pcmcia/Kconfig
      sparc64: Make %pil level 15 a pseudo-NMI.
      sparc64: Make special trap return path for TRAP_NMI().
      sparc64: Block NMIs in critical section of context switch.
      sparc64: Add write_pic() helper.
      sparc64: Use NMI oprofile profiling on cheetah and derivative cpus.
      sparc32: Don't btfixup cache flush ops for viking multiple times.
      sparc64: Add save_stack_trace_tsk().
      sparc64: Add performance counter hypervisor calls for sun4v.
      sparc64: Provide oprofile pseudo-NMI on Niagara.
      sparc: Create common header file for prom_{32,64}.c
      sparc: Const'ify prom_*prop*() on sparc32.
      sparc: Create common area for OF device layer code.
      sparc: Mark prom_early_alloc non-static.
      sparc: Move irq_trans_init() and support code into seperate file.
      sparc: Move 'unique_id' into prom_common.c and rename to 'prom_unique_id'
      sparc: Move property building code into prom_common.c
      sparc: Commonize get_one_property() implementations.
      sparc: Make sparc32's create_node() assign parent pointer.
      sparc: Move create_node() and friends into prom_common.c
      sparc: Match sparc32's build_tree() up to sparc64's
      sparc: Move core of OF device tree building code into prom_common.c
      sparc: Move prom_build_devicetree() into prom_common.c
      sparc: Move of_console_{device,path,options} info prom_common.c
      sparc: Always set AUDIT_ARCH, not just on sparc64.
      sparc: Restore irq_trans_init() call in prom_create_node().
      cyber2000fb: Kill the one modular sparc prom_printf call.
      sparc: Kill memcmp_32.S code which has been ifdef'd out for centuries.
      sparc: Add asm/asm.h
      sparc: Unify strlen assembler.
      sparc: Commonize memcmp assembler.
      Merge branch 'master' of master.kernel.org:/.../torvalds/linux-2.6

Nicolas Palix (1):
      sparc: Add missing of_node_put

Robert Reif (3):
      sparc: Use sparc64 version of prom/printf.c
      sparc: use sparc64 version of scatterlist.h
      sparc: fix array overrun check in of_device_64.c

Rusty Russell (1):
      sparc: replace for_each_cpu_mask_nr with for_each_cpu

Sam Ravnborg (54):
      sparc: unify Kconfig.debug
      sparc: refactor Kconfig a little
      sparc64: added more config options to the menus
      sparc: drop UNIX98_PTYS from arch Kconfig
      sparc: use Kconfig.hz
      sparc: add menu "Executable file formats"
      sparc: add "Bus options" to Kconfig
      sparc,sparc64: unify Kconfig files
      sparc,sparc64: add BITS to arch Makefile
      sparc: cleanup math-emu
      sparc: prepare math-emu for unification
      sparc64: unify math-emu
      sparc64: unify arch/sparc64/oprofile/
      sparc: prepare mm/ for unification
      sparc,sparc64: unify mm/
      sparc,sparc64: prepare vmlinux.lds.S for unification
      sparc64: use vmlinux.lds.S from sparc
      sparc,sparc64: unify asm-offsets.c
      sparc: refactor Makefile
      sparc: clean boot/
      sparc: gitignore a few files
      sparc,sparc64: unify Makefile
      sparc: prepare prom/ for unification
      sparc,sparc64: unify prom/
      sparc: prepare lib/ for unification
      sparc,sparc64: unify lib/
      sparc: prepare kernel/ for unification
      sparc,sparc64: unify kernel/
      sparc,sparc64: unify boot/
      sparc: drop CONFIG_SUN_AUXIO
      sparc: unify kernel/init_task
      sparc: beautify kernel/cpu_32.c
      sparc: report "Unknown CPU/FPU" for unknown cpu/fpu
      sparc: fix sparse warnings in cpu_*.c
      sparc: expand cpu table
      sparc: unify kernel/cpu
      sparc: idprom_32.c cleanup
      sparc: unify kernel/idprom.c
      sparc: fix sparse warning in kernel/pmc.c
      sparc: fix trivial style issues in kernel/pmc.c
      sparc: fix sparse warnings in traps_32.c
      sparc: add include guards to kernel.h
      sparc: fix sparse warnings in irq_32.c
      sparc64: do not export pus_fs_struct
      sparc: fix hardirq.h removal fallout
      sparc: introduce CONFIG_BITS
      sparc: unify module.h
      sparc64: use bit neutral Elf symbols
      sparc64: prepare module_64.c for unification
      sparc: unify module.c
      sparc: use .data.init_task section for init_thread_union
      sparc: unify sections.h
      sparc: drop SUN_IO
      sparc: move select of ARCH_SUPPORTS_MSI

Stephen Rothwell (1):
      sparc: combine unistd_{32,64}.h

 Makefile                                           |    9 +-
 arch/sparc/Kconfig                                 |  525 +++++--
 arch/sparc/Kconfig.debug                           |   26 +
 arch/sparc/Makefile                                |   97 +-
 arch/sparc/boot/.gitignore                         |    8 +
 arch/sparc/boot/Makefile                           |   38 +-
 arch/sparc/boot/{piggyback.c => piggyback_32.c}    |    0
 .../boot/piggyback.c => sparc/boot/piggyback_64.c} |    0
 .../sparc/{defconfig => configs/sparc32_defconfig} |    0
 .../defconfig => sparc/configs/sparc64_defconfig}  |    0
 arch/sparc/include/asm/Kbuild                      |    2 -
 arch/sparc/include/asm/asm.h                       |   40 +
 arch/sparc/include/asm/atomic_64.h                 |    7 -
 arch/sparc/include/asm/bitops_64.h                 |    5 -
 arch/sparc/include/asm/hypervisor.h                |   24 +
 arch/sparc/include/asm/irq_32.h                    |    1 +
 arch/sparc/include/asm/irq_64.h                    |    3 +
 arch/sparc/include/asm/irqflags_64.h               |    6 +-
 arch/sparc/include/asm/module.h                    |   32 +-
 arch/sparc/include/asm/module_32.h                 |    7 -
 arch/sparc/include/asm/module_64.h                 |    7 -
 arch/sparc/include/asm/openprom_32.h               |    6 +-
 arch/sparc/include/asm/oplib_32.h                  |    8 +-
 arch/sparc/include/asm/pil.h                       |    9 +-
 arch/sparc/include/asm/scatterlist.h               |   33 +-
 arch/sparc/include/asm/scatterlist_32.h            |   26 -
 arch/sparc/include/asm/scatterlist_64.h            |   27 -
 arch/sparc/include/asm/sections.h                  |   16 +-
 arch/sparc/include/asm/sections_32.h               |    6 -
 arch/sparc/include/asm/sections_64.h               |    9 -
 arch/sparc/include/asm/spinlock_64.h               |   31 +-
 arch/sparc/include/asm/spitfire.h                  |    4 +-
 arch/sparc/include/asm/system_32.h                 |    5 +
 arch/sparc/include/asm/system_64.h                 |   46 +-
 arch/sparc/include/asm/tsb.h                       |    6 -
 arch/sparc/include/asm/ttable.h                    |   15 +-
 arch/sparc/include/asm/unistd.h                    |  446 +++++-
 arch/sparc/include/asm/unistd_32.h                 |  385 -----
 arch/sparc/include/asm/unistd_64.h                 |  380 -----
 arch/sparc/kernel/.gitignore                       |    1 +
 arch/sparc/kernel/Makefile                         |  117 ++-
 arch/sparc/kernel/asm-offsets.c                    |   19 +-
 arch/{sparc64 => sparc}/kernel/audit.c             |    0
 arch/sparc/kernel/{auxio.c => auxio_32.c}          |    0
 .../kernel/auxio.c => sparc/kernel/auxio_64.c}     |   70 +-
 arch/{sparc64 => sparc}/kernel/central.c           |    0
 arch/{sparc64 => sparc}/kernel/cherrs.S            |   10 +-
 arch/{sparc64 => sparc}/kernel/chmc.c              |    0
 arch/{sparc64 => sparc}/kernel/compat_audit.c      |    3 +-
 arch/sparc/kernel/cpu.c                            |  413 ++++--
 arch/sparc/kernel/devices.c                        |    2 -
 arch/{sparc64 => sparc}/kernel/ds.c                |    0
 arch/{sparc64 => sparc}/kernel/dtlb_miss.S         |    0
 arch/{sparc64 => sparc}/kernel/dtlb_prot.S         |    0
 arch/{sparc64 => sparc}/kernel/ebus.c              |    0
 arch/{sparc64 => sparc}/kernel/entry.h             |   40 +-
 arch/sparc/kernel/{etrap.S => etrap_32.S}          |    0
 .../kernel/etrap.S => sparc/kernel/etrap_64.S}     |    6 +-
 arch/{sparc64 => sparc}/kernel/fpu_traps.S         |    0
 arch/{sparc64 => sparc}/kernel/ftrace.c            |    0
 arch/{sparc64 => sparc}/kernel/getsetcc.S          |    0
 arch/sparc/kernel/{head.S => head_32.S}            |    2 +-
 .../kernel/head.S => sparc/kernel/head_64.S}       |    8 +-
 arch/{sparc64 => sparc}/kernel/helpers.S           |    0
 arch/{sparc64 => sparc}/kernel/hvapi.c             |    0
 arch/{sparc64 => sparc}/kernel/hvcalls.S           |   32 +
 arch/{sparc64 => sparc}/kernel/hvtramp.S           |    5 +-
 arch/sparc/kernel/idprom.c                         |   67 +-
 arch/sparc/kernel/init_task.c                      |    3 +-
 arch/{sparc64 => sparc}/kernel/iommu.c             |    0
 arch/{sparc64 => sparc}/kernel/iommu_common.h      |    0
 arch/sparc/kernel/ioport.c                         |    4 +-
 arch/sparc/kernel/{irq.c => irq_32.c}              |    7 +-
 .../kernel/irq.c => sparc/kernel/irq_64.c}         |   63 +
 arch/{sparc64 => sparc}/kernel/itlb_miss.S         |    0
 arch/{sparc64 => sparc}/kernel/ivec.S              |    0
 arch/sparc/kernel/kernel.h                         |   31 +
 arch/sparc/kernel/{kgdb.c => kgdb_32.c}            |    0
 .../kernel/kgdb.c => sparc/kernel/kgdb_64.c}       |    0
 arch/{sparc64 => sparc}/kernel/kprobes.c           |    0
 arch/{sparc64 => sparc}/kernel/kstack.h            |    0
 arch/{sparc64 => sparc}/kernel/ktlb.S              |    0
 arch/{sparc64 => sparc}/kernel/ldc.c               |    0
 arch/{sparc64 => sparc}/kernel/mdesc.c             |    1 +
 arch/{sparc64 => sparc}/kernel/misctrap.S          |    0
 arch/sparc/kernel/module.c                         |  140 ++-
 arch/sparc/kernel/muldiv.c                         |    5 +-
 arch/sparc/kernel/{of_device.c => of_device_32.c}  |    0
 .../of_device.c => sparc/kernel/of_device_64.c}    |   18 +-
 arch/{sparc64 => sparc}/kernel/pci.c               |    0
 arch/{sparc64 => sparc}/kernel/pci_common.c        |    0
 arch/{sparc64 => sparc}/kernel/pci_fire.c          |    0
 arch/{sparc64 => sparc}/kernel/pci_impl.h          |    0
 arch/{sparc64 => sparc}/kernel/pci_msi.c           |    0
 arch/{sparc64 => sparc}/kernel/pci_psycho.c        |    0
 arch/{sparc64 => sparc}/kernel/pci_sabre.c         |    0
 arch/{sparc64 => sparc}/kernel/pci_schizo.c        |    0
 arch/{sparc64 => sparc}/kernel/pci_sun4v.c         |    0
 arch/{sparc64 => sparc}/kernel/pci_sun4v.h         |    0
 arch/{sparc64 => sparc}/kernel/pci_sun4v_asm.S     |    0
 arch/sparc/kernel/pcic.c                           |    2 +-
 arch/sparc/kernel/pmc.c                            |   18 +-
 arch/{sparc64 => sparc}/kernel/power.c             |    0
 arch/sparc/kernel/{process.c => process_32.c}      |    2 -
 .../kernel/process.c => sparc/kernel/process_64.c} |    0
 arch/sparc/kernel/prom.c                           |  566 -------
 arch/sparc/kernel/prom.h                           |   29 +
 arch/sparc/kernel/prom_32.c                        |  295 ++++
 arch/sparc/kernel/prom_64.c                        |  571 +++++++
 arch/sparc/kernel/prom_common.c                    |  326 ++++
 arch/sparc/kernel/prom_irqtrans.c                  |  842 ++++++++++
 arch/{sparc64 => sparc}/kernel/psycho_common.c     |    0
 arch/{sparc64 => sparc}/kernel/psycho_common.h     |    0
 arch/sparc/kernel/{ptrace.c => ptrace_32.c}        |    0
 .../kernel/ptrace.c => sparc/kernel/ptrace_64.c}   |    0
 arch/{sparc64 => sparc}/kernel/reboot.c            |    0
 arch/sparc/kernel/{rtrap.S => rtrap_32.S}          |    0
 .../kernel/rtrap.S => sparc/kernel/rtrap_64.S}     |   20 +-
 arch/{sparc64 => sparc}/kernel/sbus.c              |    0
 arch/sparc/kernel/{setup.c => setup_32.c}          |    9 +-
 .../kernel/setup.c => sparc/kernel/setup_64.c}     |    1 +
 arch/{sparc64 => sparc}/kernel/signal32.c          |    0
 arch/sparc/kernel/{signal.c => signal_32.c}        |    0
 .../kernel/signal.c => sparc/kernel/signal_64.c}   |    0
 arch/sparc/kernel/{smp.c => smp_32.c}              |    0
 .../kernel/smp.c => sparc/kernel/smp_64.c}         |   17 +-
 .../kernel/{sparc_ksyms.c => sparc_ksyms_32.c}     |    4 -
 .../kernel/sparc_ksyms_64.c}                       |   11 +-
 arch/{sparc64 => sparc}/kernel/spiterrs.S          |    2 +-
 arch/{sparc64 => sparc}/kernel/sstate.c            |    0
 arch/{sparc64 => sparc}/kernel/stacktrace.c        |   32 +-
 arch/{sparc64 => sparc}/kernel/starfire.c          |    0
 arch/sparc/kernel/sun4c_irq.c                      |    2 +
 arch/sparc/kernel/sun4d_irq.c                      |    3 +-
 arch/sparc/kernel/sun4m_irq.c                      |    2 +
 arch/{sparc64 => sparc}/kernel/sun4v_ivec.S        |    8 +-
 arch/{sparc64 => sparc}/kernel/sun4v_tlb_miss.S    |    0
 arch/{sparc64 => sparc}/kernel/sys32.S             |    0
 arch/{sparc64 => sparc}/kernel/sys_sparc32.c       |    0
 arch/sparc/kernel/{sys_sparc.c => sys_sparc_32.c}  |    0
 .../sys_sparc.c => sparc/kernel/sys_sparc_64.c}    |    0
 arch/{sparc64 => sparc}/kernel/syscalls.S          |    0
 arch/{sparc64 => sparc}/kernel/sysfs.c             |    1 +
 arch/{sparc64 => sparc}/kernel/systbls.h           |    0
 arch/sparc/kernel/{systbls.S => systbls_32.S}      |    0
 .../kernel/systbls.S => sparc/kernel/systbls_64.S} |    0
 arch/sparc/kernel/{time.c => time_32.c}            |    0
 .../kernel/time.c => sparc/kernel/time_64.c}       |    0
 .../sparc/kernel/{trampoline.S => trampoline_32.S} |    0
 .../trampoline.S => sparc/kernel/trampoline_64.S}  |    4 -
 arch/sparc/kernel/{traps.c => traps_32.c}          |   34 +-
 .../kernel/traps.c => sparc/kernel/traps_64.c}     |    5 +-
 arch/{sparc64 => sparc}/kernel/tsb.S               |    6 +-
 arch/{sparc64 => sparc}/kernel/ttable.S            |    2 +-
 arch/sparc/kernel/{una_asm.S => una_asm_32.S}      |    0
 .../kernel/una_asm.S => sparc/kernel/una_asm_64.S} |    0
 arch/sparc/kernel/{unaligned.c => unaligned_32.c}  |    0
 .../unaligned.c => sparc/kernel/unaligned_64.c}    |    0
 arch/{sparc64 => sparc}/kernel/us2e_cpufreq.c      |    0
 arch/{sparc64 => sparc}/kernel/us3_cpufreq.c       |    0
 arch/{sparc64 => sparc}/kernel/utrap.S             |    0
 arch/{sparc64 => sparc}/kernel/vio.c               |    0
 arch/{sparc64 => sparc}/kernel/viohs.c             |    0
 arch/{sparc64 => sparc}/kernel/visemul.c           |    0
 arch/sparc/kernel/vmlinux.lds.S                    |  109 +-
 arch/{sparc64 => sparc}/kernel/winfixup.S          |    0
 arch/{sparc64 => sparc}/lib/GENbzero.S             |    0
 arch/{sparc64 => sparc}/lib/GENcopy_from_user.S    |    0
 arch/{sparc64 => sparc}/lib/GENcopy_to_user.S      |    0
 arch/{sparc64 => sparc}/lib/GENmemcpy.S            |    0
 arch/{sparc64 => sparc}/lib/GENpage.S              |    0
 arch/{sparc64 => sparc}/lib/GENpatch.S             |    0
 arch/sparc/lib/Makefile                            |   47 +-
 arch/{sparc64 => sparc}/lib/NG2copy_from_user.S    |    0
 arch/{sparc64 => sparc}/lib/NG2copy_to_user.S      |    0
 arch/{sparc64 => sparc}/lib/NG2memcpy.S            |    0
 arch/{sparc64 => sparc}/lib/NG2page.S              |    0
 arch/{sparc64 => sparc}/lib/NG2patch.S             |    0
 arch/{sparc64 => sparc}/lib/NGbzero.S              |    0
 arch/{sparc64 => sparc}/lib/NGcopy_from_user.S     |    0
 arch/{sparc64 => sparc}/lib/NGcopy_to_user.S       |    0
 arch/{sparc64 => sparc}/lib/NGmemcpy.S             |    0
 arch/{sparc64 => sparc}/lib/NGpage.S               |    0
 arch/{sparc64 => sparc}/lib/NGpatch.S              |    0
 arch/{sparc64 => sparc}/lib/PeeCeeI.c              |    0
 arch/{sparc64 => sparc}/lib/U1copy_from_user.S     |    0
 arch/{sparc64 => sparc}/lib/U1copy_to_user.S       |    0
 arch/{sparc64 => sparc}/lib/U1memcpy.S             |    0
 arch/{sparc64 => sparc}/lib/U3copy_from_user.S     |    0
 arch/{sparc64 => sparc}/lib/U3copy_to_user.S       |    0
 arch/{sparc64 => sparc}/lib/U3memcpy.S             |    0
 arch/{sparc64 => sparc}/lib/U3patch.S              |    0
 arch/{sparc64 => sparc}/lib/VISsave.S              |    0
 arch/sparc/lib/{atomic.S => atomic_32.S}           |    0
 .../lib/atomic.S => sparc/lib/atomic_64.S}         |   26 -
 arch/{sparc64 => sparc}/lib/bitops.S               |   24 -
 arch/{sparc64 => sparc}/lib/bzero.S                |    0
 arch/sparc/lib/{checksum.S => checksum_32.S}       |    0
 .../lib/checksum.S => sparc/lib/checksum_64.S}     |    0
 arch/{sparc64 => sparc}/lib/clear_page.S           |    0
 arch/{sparc64 => sparc}/lib/copy_in_user.S         |    0
 arch/{sparc64 => sparc}/lib/copy_page.S            |    0
 arch/{sparc64 => sparc}/lib/csum_copy.S            |    0
 arch/{sparc64 => sparc}/lib/csum_copy_from_user.S  |    0
 arch/{sparc64 => sparc}/lib/csum_copy_to_user.S    |    0
 arch/{sparc64 => sparc}/lib/ipcsum.S               |    0
 arch/{sparc64 => sparc}/lib/mcount.S               |    0
 arch/sparc/lib/memcmp.S                            |  329 +----
 arch/{sparc64 => sparc}/lib/memmove.S              |    0
 arch/sparc/lib/{memscan.S => memscan_32.S}         |    0
 .../lib/memscan.S => sparc/lib/memscan_64.S}       |    0
 arch/sparc/lib/{rwsem.S => rwsem_32.S}             |    0
 arch/{sparc64/lib/rwsem.S => sparc/lib/rwsem_64.S} |    7 -
 arch/sparc/lib/strlen.S                            |   79 +-
 arch/sparc/lib/{strlen_user.S => strlen_user_32.S} |    0
 .../strlen_user.S => sparc/lib/strlen_user_64.S}   |    0
 arch/sparc/lib/{strncmp.S => strncmp_32.S}         |    0
 .../lib/strncmp.S => sparc/lib/strncmp_64.S}       |    0
 ...{strncpy_from_user.S => strncpy_from_user_32.S} |    0
 .../lib/strncpy_from_user_64.S}                    |    0
 arch/{sparc64 => sparc}/lib/user_fixup.c           |    0
 arch/{sparc64 => sparc}/lib/xor.S                  |    0
 arch/sparc/math-emu/Makefile                       |    6 +-
 arch/sparc/math-emu/ashldi3.S                      |   36 -
 arch/sparc/math-emu/{math.c => math_32.c}          |    2 +-
 .../math-emu/math.c => sparc/math-emu/math_64.c}   |    2 +-
 arch/sparc/math-emu/{sfp-util.h => sfp-util_32.h}  |    0
 .../sfp-util.h => sparc/math-emu/sfp-util_64.h}    |    0
 arch/sparc/mm/Makefile                             |   24 +-
 arch/sparc/mm/{fault.c => fault_32.c}              |    0
 arch/{sparc64/mm/fault.c => sparc/mm/fault_64.c}   |    0
 arch/sparc/mm/{generic.c => generic_32.c}          |    0
 .../mm/generic.c => sparc/mm/generic_64.c}         |    0
 arch/{sparc64 => sparc}/mm/hugetlbpage.c           |    0
 arch/sparc/mm/{init.c => init_32.c}                |   14 +-
 arch/{sparc64/mm/init.c => sparc/mm/init_64.c}     |    6 +-
 arch/{sparc64/mm/init.h => sparc/mm/init_64.h}     |    0
 arch/sparc/mm/io-unit.c                            |    8 +-
 arch/sparc/mm/iommu.c                              |   16 +-
 arch/sparc/mm/srmmu.c                              |   25 +-
 arch/sparc/mm/sun4c.c                              |   12 +-
 arch/{sparc64 => sparc}/mm/tlb.c                   |    0
 arch/{sparc64 => sparc}/mm/tsb.c                   |   25 +-
 arch/{sparc64 => sparc}/mm/ultra.S                 |    6 +-
 arch/sparc/oprofile/init.c                         |  229 +++-
 arch/sparc/prom/Makefile                           |   19 +-
 arch/sparc/prom/{bootstr.c => bootstr_32.c}        |    0
 .../prom/bootstr.c => sparc/prom/bootstr_64.c}     |    0
 arch/{sparc64 => sparc}/prom/cif.S                 |    0
 arch/sparc/prom/{console.c => console_32.c}        |    0
 .../prom/console.c => sparc/prom/console_64.c}     |    0
 arch/sparc/prom/{devops.c => devops_32.c}          |    0
 .../prom/devops.c => sparc/prom/devops_64.c}       |    0
 arch/sparc/prom/{init.c => init_32.c}              |    0
 arch/{sparc64/prom/init.c => sparc/prom/init_64.c} |    0
 arch/sparc/prom/{misc.c => misc_32.c}              |    2 -
 arch/{sparc64/prom/misc.c => sparc/prom/misc_64.c} |    0
 arch/{sparc64 => sparc}/prom/p1275.c               |    0
 arch/sparc/prom/printf.c                           |    5 +-
 arch/sparc/prom/{tree.c => tree_32.c}              |    6 +-
 arch/{sparc64/prom/tree.c => sparc/prom/tree_64.c} |    0
 arch/sparc64/Kconfig                               |  433 -----
 arch/sparc64/Kconfig.debug                         |   44 -
 arch/sparc64/Makefile                              |   48 -
 arch/sparc64/boot/.gitignore                       |    4 -
 arch/sparc64/boot/Makefile                         |   33 -
 arch/sparc64/kernel/Makefile                       |   36 -
 arch/sparc64/kernel/asm-offsets.c                  |    1 -
 arch/sparc64/kernel/cpu.c                          |  166 --
 arch/sparc64/kernel/idprom.c                       |   46 -
 arch/sparc64/kernel/init_task.c                    |   35 -
 arch/sparc64/kernel/module.c                       |  213 ---
 arch/sparc64/kernel/prom.c                         | 1684 --------------------
 arch/sparc64/kernel/vmlinux.lds.S                  |  147 --
 arch/sparc64/lib/Makefile                          |   23 -
 arch/sparc64/lib/iomap.c                           |   48 -
 arch/sparc64/lib/memcmp.S                          |   28 -
 arch/sparc64/lib/strlen.S                          |   80 -
 arch/sparc64/math-emu/Makefile                     |    7 -
 arch/sparc64/mm/Makefile                           |    9 -
 arch/sparc64/oprofile/Makefile                     |    9 -
 arch/sparc64/oprofile/init.c                       |   23 -
 arch/sparc64/prom/Makefile                         |    9 -
 arch/sparc64/prom/printf.c                         |   47 -
 drivers/video/cyber2000fb.c                        |    2 +-
 include/linux/of_platform.h                        |    3 +-
 kernel/sysctl.c                                    |   14 +
 287 files changed, 4619 insertions(+), 5813 deletions(-)
 create mode 100644 arch/sparc/boot/.gitignore
 rename arch/sparc/boot/{piggyback.c => piggyback_32.c} (100%)
 rename arch/{sparc64/boot/piggyback.c => sparc/boot/piggyback_64.c} (100%)
 rename arch/sparc/{defconfig => configs/sparc32_defconfig} (100%)
 rename arch/{sparc64/defconfig => sparc/configs/sparc64_defconfig} (100%)
 create mode 100644 arch/sparc/include/asm/asm.h
 delete mode 100644 arch/sparc/include/asm/module_32.h
 delete mode 100644 arch/sparc/include/asm/module_64.h
 delete mode 100644 arch/sparc/include/asm/scatterlist_32.h
 delete mode 100644 arch/sparc/include/asm/scatterlist_64.h
 delete mode 100644 arch/sparc/include/asm/sections_32.h
 delete mode 100644 arch/sparc/include/asm/sections_64.h
 delete mode 100644 arch/sparc/include/asm/unistd_32.h
 delete mode 100644 arch/sparc/include/asm/unistd_64.h
 create mode 100644 arch/sparc/kernel/.gitignore
 rename arch/{sparc64 => sparc}/kernel/audit.c (100%)
 rename arch/sparc/kernel/{auxio.c => auxio_32.c} (100%)
 rename arch/{sparc64/kernel/auxio.c => sparc/kernel/auxio_64.c} (67%)
 rename arch/{sparc64 => sparc}/kernel/central.c (100%)
 rename arch/{sparc64 => sparc}/kernel/cherrs.S (98%)
 rename arch/{sparc64 => sparc}/kernel/chmc.c (100%)
 rename arch/{sparc64 => sparc}/kernel/compat_audit.c (91%)
 rename arch/{sparc64 => sparc}/kernel/ds.c (100%)
 rename arch/{sparc64 => sparc}/kernel/dtlb_miss.S (100%)
 rename arch/{sparc64 => sparc}/kernel/dtlb_prot.S (100%)
 rename arch/{sparc64 => sparc}/kernel/ebus.c (100%)
 rename arch/{sparc64 => sparc}/kernel/entry.h (79%)
 rename arch/sparc/kernel/{etrap.S => etrap_32.S} (100%)
 rename arch/{sparc64/kernel/etrap.S => sparc/kernel/etrap_64.S} (97%)
 rename arch/{sparc64 => sparc}/kernel/fpu_traps.S (100%)
 rename arch/{sparc64 => sparc}/kernel/ftrace.c (100%)
 rename arch/{sparc64 => sparc}/kernel/getsetcc.S (100%)
 rename arch/sparc/kernel/{head.S => head_32.S} (99%)
 rename arch/{sparc64/kernel/head.S => sparc/kernel/head_64.S} (99%)
 rename arch/{sparc64 => sparc}/kernel/helpers.S (100%)
 rename arch/{sparc64 => sparc}/kernel/hvapi.c (100%)
 rename arch/{sparc64 => sparc}/kernel/hvcalls.S (96%)
 rename arch/{sparc64 => sparc}/kernel/hvtramp.S (95%)
 rename arch/{sparc64 => sparc}/kernel/iommu.c (100%)
 rename arch/{sparc64 => sparc}/kernel/iommu_common.h (100%)
 rename arch/sparc/kernel/{irq.c => irq_32.c} (99%)
 rename arch/{sparc64/kernel/irq.c => sparc/kernel/irq_64.c} (94%)
 rename arch/{sparc64 => sparc}/kernel/itlb_miss.S (100%)
 rename arch/{sparc64 => sparc}/kernel/ivec.S (100%)
 create mode 100644 arch/sparc/kernel/kernel.h
 rename arch/sparc/kernel/{kgdb.c => kgdb_32.c} (100%)
 rename arch/{sparc64/kernel/kgdb.c => sparc/kernel/kgdb_64.c} (100%)
 rename arch/{sparc64 => sparc}/kernel/kprobes.c (100%)
 rename arch/{sparc64 => sparc}/kernel/kstack.h (100%)
 rename arch/{sparc64 => sparc}/kernel/ktlb.S (100%)
 rename arch/{sparc64 => sparc}/kernel/ldc.c (100%)
 rename arch/{sparc64 => sparc}/kernel/mdesc.c (99%)
 rename arch/{sparc64 => sparc}/kernel/misctrap.S (100%)
 rename arch/sparc/kernel/{of_device.c => of_device_32.c} (100%)
 rename arch/{sparc64/kernel/of_device.c => sparc/kernel/of_device_64.c} (98%)
 rename arch/{sparc64 => sparc}/kernel/pci.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_common.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_fire.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_impl.h (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_msi.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_psycho.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_sabre.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_schizo.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_sun4v.c (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_sun4v.h (100%)
 rename arch/{sparc64 => sparc}/kernel/pci_sun4v_asm.S (100%)
 rename arch/{sparc64 => sparc}/kernel/power.c (100%)
 rename arch/sparc/kernel/{process.c => process_32.c} (99%)
 rename arch/{sparc64/kernel/process.c => sparc/kernel/process_64.c} (100%)
 delete mode 100644 arch/sparc/kernel/prom.c
 create mode 100644 arch/sparc/kernel/prom.h
 create mode 100644 arch/sparc/kernel/prom_32.c
 create mode 100644 arch/sparc/kernel/prom_64.c
 create mode 100644 arch/sparc/kernel/prom_common.c
 create mode 100644 arch/sparc/kernel/prom_irqtrans.c
 rename arch/{sparc64 => sparc}/kernel/psycho_common.c (100%)
 rename arch/{sparc64 => sparc}/kernel/psycho_common.h (100%)
 rename arch/sparc/kernel/{ptrace.c => ptrace_32.c} (100%)
 rename arch/{sparc64/kernel/ptrace.c => sparc/kernel/ptrace_64.c} (100%)
 rename arch/{sparc64 => sparc}/kernel/reboot.c (100%)
 rename arch/sparc/kernel/{rtrap.S => rtrap_32.S} (100%)
 rename arch/{sparc64/kernel/rtrap.S => sparc/kernel/rtrap_64.S} (95%)
 rename arch/{sparc64 => sparc}/kernel/sbus.c (100%)
 rename arch/sparc/kernel/{setup.c => setup_32.c} (98%)
 rename arch/{sparc64/kernel/setup.c => sparc/kernel/setup_64.c} (99%)
 rename arch/{sparc64 => sparc}/kernel/signal32.c (100%)
 rename arch/sparc/kernel/{signal.c => signal_32.c} (100%)
 rename arch/{sparc64/kernel/signal.c => sparc/kernel/signal_64.c} (100%)
 rename arch/sparc/kernel/{smp.c => smp_32.c} (100%)
 rename arch/{sparc64/kernel/smp.c => sparc/kernel/smp_64.c} (99%)
 rename arch/sparc/kernel/{sparc_ksyms.c => sparc_ksyms_32.c} (98%)
 rename arch/{sparc64/kernel/sparc64_ksyms.c => sparc/kernel/sparc_ksyms_64.c} (97%)
 rename arch/{sparc64 => sparc}/kernel/spiterrs.S (99%)
 rename arch/{sparc64 => sparc}/kernel/sstate.c (100%)
 rename arch/{sparc64 => sparc}/kernel/stacktrace.c (60%)
 rename arch/{sparc64 => sparc}/kernel/starfire.c (100%)
 rename arch/{sparc64 => sparc}/kernel/sun4v_ivec.S (98%)
 rename arch/{sparc64 => sparc}/kernel/sun4v_tlb_miss.S (100%)
 rename arch/{sparc64 => sparc}/kernel/sys32.S (100%)
 rename arch/{sparc64 => sparc}/kernel/sys_sparc32.c (100%)
 rename arch/sparc/kernel/{sys_sparc.c => sys_sparc_32.c} (100%)
 rename arch/{sparc64/kernel/sys_sparc.c => sparc/kernel/sys_sparc_64.c} (100%)
 rename arch/{sparc64 => sparc}/kernel/syscalls.S (100%)
 rename arch/{sparc64 => sparc}/kernel/sysfs.c (99%)
 rename arch/{sparc64 => sparc}/kernel/systbls.h (100%)
 rename arch/sparc/kernel/{systbls.S => systbls_32.S} (100%)
 rename arch/{sparc64/kernel/systbls.S => sparc/kernel/systbls_64.S} (100%)
 rename arch/sparc/kernel/{time.c => time_32.c} (100%)
 rename arch/{sparc64/kernel/time.c => sparc/kernel/time_64.c} (100%)
 rename arch/sparc/kernel/{trampoline.S => trampoline_32.S} (100%)
 rename arch/{sparc64/kernel/trampoline.S => sparc/kernel/trampoline_64.S} (98%)
 rename arch/sparc/kernel/{traps.c => traps_32.c} (94%)
 rename arch/{sparc64/kernel/traps.c => sparc/kernel/traps_64.c} (99%)
 rename arch/{sparc64 => sparc}/kernel/tsb.S (99%)
 rename arch/{sparc64 => sparc}/kernel/ttable.S (99%)
 rename arch/sparc/kernel/{una_asm.S => una_asm_32.S} (100%)
 rename arch/{sparc64/kernel/una_asm.S => sparc/kernel/una_asm_64.S} (100%)
 rename arch/sparc/kernel/{unaligned.c => unaligned_32.c} (100%)
 rename arch/{sparc64/kernel/unaligned.c => sparc/kernel/unaligned_64.c} (100%)
 rename arch/{sparc64 => sparc}/kernel/us2e_cpufreq.c (100%)
 rename arch/{sparc64 => sparc}/kernel/us3_cpufreq.c (100%)
 rename arch/{sparc64 => sparc}/kernel/utrap.S (100%)
 rename arch/{sparc64 => sparc}/kernel/vio.c (100%)
 rename arch/{sparc64 => sparc}/kernel/viohs.c (100%)
 rename arch/{sparc64 => sparc}/kernel/visemul.c (100%)
 rename arch/{sparc64 => sparc}/kernel/winfixup.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENbzero.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENcopy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENcopy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENmemcpy.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENpage.S (100%)
 rename arch/{sparc64 => sparc}/lib/GENpatch.S (100%)
 rename arch/{sparc64 => sparc}/lib/NG2copy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/NG2copy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/NG2memcpy.S (100%)
 rename arch/{sparc64 => sparc}/lib/NG2page.S (100%)
 rename arch/{sparc64 => sparc}/lib/NG2patch.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGbzero.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGcopy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGcopy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGmemcpy.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGpage.S (100%)
 rename arch/{sparc64 => sparc}/lib/NGpatch.S (100%)
 rename arch/{sparc64 => sparc}/lib/PeeCeeI.c (100%)
 rename arch/{sparc64 => sparc}/lib/U1copy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/U1copy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/U1memcpy.S (100%)
 rename arch/{sparc64 => sparc}/lib/U3copy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/U3copy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/U3memcpy.S (100%)
 rename arch/{sparc64 => sparc}/lib/U3patch.S (100%)
 rename arch/{sparc64 => sparc}/lib/VISsave.S (100%)
 rename arch/sparc/lib/{atomic.S => atomic_32.S} (100%)
 rename arch/{sparc64/lib/atomic.S => sparc/lib/atomic_64.S} (84%)
 rename arch/{sparc64 => sparc}/lib/bitops.S (84%)
 rename arch/{sparc64 => sparc}/lib/bzero.S (100%)
 rename arch/sparc/lib/{checksum.S => checksum_32.S} (100%)
 rename arch/{sparc64/lib/checksum.S => sparc/lib/checksum_64.S} (100%)
 rename arch/{sparc64 => sparc}/lib/clear_page.S (100%)
 rename arch/{sparc64 => sparc}/lib/copy_in_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/copy_page.S (100%)
 rename arch/{sparc64 => sparc}/lib/csum_copy.S (100%)
 rename arch/{sparc64 => sparc}/lib/csum_copy_from_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/csum_copy_to_user.S (100%)
 rename arch/{sparc64 => sparc}/lib/ipcsum.S (100%)
 rename arch/{sparc64 => sparc}/lib/mcount.S (100%)
 rename arch/{sparc64 => sparc}/lib/memmove.S (100%)
 rename arch/sparc/lib/{memscan.S => memscan_32.S} (100%)
 rename arch/{sparc64/lib/memscan.S => sparc/lib/memscan_64.S} (100%)
 rename arch/sparc/lib/{rwsem.S => rwsem_32.S} (100%)
 rename arch/{sparc64/lib/rwsem.S => sparc/lib/rwsem_64.S} (92%)
 rename arch/sparc/lib/{strlen_user.S => strlen_user_32.S} (100%)
 rename arch/{sparc64/lib/strlen_user.S => sparc/lib/strlen_user_64.S} (100%)
 rename arch/sparc/lib/{strncmp.S => strncmp_32.S} (100%)
 rename arch/{sparc64/lib/strncmp.S => sparc/lib/strncmp_64.S} (100%)
 rename arch/sparc/lib/{strncpy_from_user.S => strncpy_from_user_32.S} (100%)
 rename arch/{sparc64/lib/strncpy_from_user.S => sparc/lib/strncpy_from_user_64.S} (100%)
 rename arch/{sparc64 => sparc}/lib/user_fixup.c (100%)
 rename arch/{sparc64 => sparc}/lib/xor.S (100%)
 delete mode 100644 arch/sparc/math-emu/ashldi3.S
 rename arch/sparc/math-emu/{math.c => math_32.c} (99%)
 rename arch/{sparc64/math-emu/math.c => sparc/math-emu/math_64.c} (99%)
 rename arch/sparc/math-emu/{sfp-util.h => sfp-util_32.h} (100%)
 rename arch/{sparc64/math-emu/sfp-util.h => sparc/math-emu/sfp-util_64.h} (100%)
 rename arch/sparc/mm/{fault.c => fault_32.c} (100%)
 rename arch/{sparc64/mm/fault.c => sparc/mm/fault_64.c} (100%)
 rename arch/sparc/mm/{generic.c => generic_32.c} (100%)
 rename arch/{sparc64/mm/generic.c => sparc/mm/generic_64.c} (100%)
 rename arch/{sparc64 => sparc}/mm/hugetlbpage.c (100%)
 rename arch/sparc/mm/{init.c => init_32.c} (97%)
 rename arch/{sparc64/mm/init.c => sparc/mm/init_64.c} (99%)
 rename arch/{sparc64/mm/init.h => sparc/mm/init_64.h} (100%)
 rename arch/{sparc64 => sparc}/mm/tlb.c (100%)
 rename arch/{sparc64 => sparc}/mm/tsb.c (97%)
 rename arch/{sparc64 => sparc}/mm/ultra.S (99%)
 rename arch/sparc/prom/{bootstr.c => bootstr_32.c} (100%)
 rename arch/{sparc64/prom/bootstr.c => sparc/prom/bootstr_64.c} (100%)
 rename arch/{sparc64 => sparc}/prom/cif.S (100%)
 rename arch/sparc/prom/{console.c => console_32.c} (100%)
 rename arch/{sparc64/prom/console.c => sparc/prom/console_64.c} (100%)
 rename arch/sparc/prom/{devops.c => devops_32.c} (100%)
 rename arch/{sparc64/prom/devops.c => sparc/prom/devops_64.c} (100%)
 rename arch/sparc/prom/{init.c => init_32.c} (100%)
 rename arch/{sparc64/prom/init.c => sparc/prom/init_64.c} (100%)
 rename arch/sparc/prom/{misc.c => misc_32.c} (98%)
 rename arch/{sparc64/prom/misc.c => sparc/prom/misc_64.c} (100%)
 rename arch/{sparc64 => sparc}/prom/p1275.c (100%)
 rename arch/sparc/prom/{tree.c => tree_32.c} (97%)
 rename arch/{sparc64/prom/tree.c => sparc/prom/tree_64.c} (100%)
 delete mode 100644 arch/sparc64/Kconfig
 delete mode 100644 arch/sparc64/Kconfig.debug
 delete mode 100644 arch/sparc64/Makefile
 delete mode 100644 arch/sparc64/boot/.gitignore
 delete mode 100644 arch/sparc64/boot/Makefile
 delete mode 100644 arch/sparc64/kernel/Makefile
 delete mode 100644 arch/sparc64/kernel/asm-offsets.c
 delete mode 100644 arch/sparc64/kernel/cpu.c
 delete mode 100644 arch/sparc64/kernel/idprom.c
 delete mode 100644 arch/sparc64/kernel/init_task.c
 delete mode 100644 arch/sparc64/kernel/module.c
 delete mode 100644 arch/sparc64/kernel/prom.c
 delete mode 100644 arch/sparc64/kernel/vmlinux.lds.S
 delete mode 100644 arch/sparc64/lib/Makefile
 delete mode 100644 arch/sparc64/lib/iomap.c
 delete mode 100644 arch/sparc64/lib/memcmp.S
 delete mode 100644 arch/sparc64/lib/strlen.S
 delete mode 100644 arch/sparc64/math-emu/Makefile
 delete mode 100644 arch/sparc64/mm/Makefile
 delete mode 100644 arch/sparc64/oprofile/Makefile
 delete mode 100644 arch/sparc64/oprofile/init.c
 delete mode 100644 arch/sparc64/prom/Makefile
 delete mode 100644 arch/sparc64/prom/printf.c
