Return-Path: <linux-kernel-owner+w=401wt.eu-S1753078AbZC3E2o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078AbZC3E2o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 00:28:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750873AbZC3E2f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 00:28:35 -0400
Received: from gate.crashing.org ([63.228.1.57]:52399 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZC3E2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 00:28:33 -0400
Subject: [git pull] Please pull powerpc.git merge branch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Mon, 30 Mar 2009 15:26:51 +1100
Message-Id: <1238387211.17330.5.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus !

So here's is the powerpc main batch for this merge window. 

You'll notice some x86 and ftrace changes in there, they come from a
commit I pulled from Steven Rostedt that was a pre-req for some other
powerpc work in that area. The commit was pulled from a tree that Ingo
should have pulled too, at least that's how we decided to do things
back then, so there should be no problem.

Cheers,
Ben.

The following changes since commit 0d34fb8e93ceba7b6dad0062dbb4a0813bacd75b:
  Linus Torvalds (1):
        Merge branch 'bzip2-lzma-for-linus' of git://git.kernel.org/.../x86/linux-2.6-tip

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git next

Andrew Klossner (1):
      powerpc/udbg: Fix lost byte during console handover; change LFCR to CRLF

Anton Blanchard (11):
      powerpc/mm: Move 64-bit unmapped_area to top of address space
      powerpc/mm: Reduce hashtable size when using 64kB pages
      powerpc: Move is_32bit_task
      powerpc: Rearrange mmap.c
      powerpc: Randomise mmap start address
      powerpc: More stack randomisation for 64bit binaries
      powerpc: Randomise lower bits of stack address
      powerpc: Randomise the brk region
      powerpc: Ensure random space between stack and mmaps
      powerpc: Increase stack gap on 64bit binaries
      powerpc: Randomise PIEs

Anton Vorontsov (10):
      powerpc/fsl_pci: Add MPC83xx PCI-E controller RC mode support
      powerpc/83xx: Add PCI-E support for all MPC83xx boards with PCI-E
      powerpc: Document FSL eSDHC bindings
      powerpc/83xx: Convert existing sdhc nodes to new bindings
      powerpc/83xx: Add FSL eSDHC support for MPC837x-RDB boards
      powerpc/83xx: Do not configure or probe disabled FSL DR USB controllers
      powerpc/83xx: Add power management support for MPC837x boards
      powerpc/83xx: Move gianfar mdio nodes under the ethernet nodes
      powerpc/85xx: Move gianfar mdio nodes under the ethernet nodes
      powerpc/86xx: Move gianfar mdio nodes under the ethernet nodes

Arnd Bergmann (2):
      powerpc/cell: Fix dependency in cpufreq
      powerpc/spufs: Initialize ctx->stats.tstamp correctly

Benjamin Herrenschmidt (29):
      Merge commit 'kumar/next' into next
      Merge commit 'gcl/next' into next
      powerpc/mm: Rework I$/D$ coherency (v3)
      powerpc/4xx: Add missing USB and i2c devices to Canyonlands
      powerpc/4xx: Enable PCI domains on 4xx
      Merge commit 'origin/master' into next
      Merge commit 'kumar/next' into next
      Merge commit 'ftrace/function-graph' into next
      Merge commit 'jwb/next' into next
      Merge commit 'gcl/next' into next
      Merge commit 'origin/master' into next
      powerpc: Wire up /proc/vmallocinfo to our ioremap()
      powerpc/mm: Properly wire up get_user_pages_fast() on 32-bit
      powerpc/kconfig: Kill PPC_MULTIPLATFORM
      powerpc/mm: Split the various pgtable-* headers based on MMU type
      powerpc/mm: Unify PTE_RPN_SHIFT and _PAGE_CHG_MASK definitions
      Merge commit 'kumar/next' into next
      Merge commit 'gcl/next' into next
      Merge commit 'origin/master' into next
      powerpc: Fix prom_init on 32-bit OF machines
      powerpc/mm: Tweak PTE bit combination definitions
      powerpc/mm: Merge various PTE bits and accessors definitions
      powerpc/mm: Rename arch/powerpc/kernel/mmap.c to mmap_64.c
      powerpc/mm: Fix printk type warning in mmu_context_nohash
      powerpc/mm: Add option for non-atomic PTE updates to ppc64
      powerpc/mm: Introduce early_init_mmu() on 64-bit
      powerpc: Fix bugs introduced by sysfs changes
      Merge commit 'kumar/next' into next
      Merge commit 'origin/master' into next

Benjamin Krill (1):
      powerpc/cell: Add rtas rtc calls for the QPACE platform

Brian King (1):
      powerpc/pseries: Fix partition migration hang under load

Gabriel Paubert (1):
      powerpc: Disable mv643xx Ethernet port 0 on Pegasos

Geoff Levand (2):
      powerpc: Add missing DABR flags
      powerpc/ps3: Print memory hotplug errors

Gerhard Pircher (4):
      powerpc/amigaone: Add platform support for AmigaOne
      powerpc/amigaone: Generic device tree for all AmigaOne boards
      powerpc/amigaone: Bootwrapper and serial console support for AmigaOne
      powerpc/amigaone: Default config for AmigaOne boards

Giuliano Pochini (1):
      powerpc/powermac: Hotplug /sys entries are missing

Grant Likely (12):
      powerpc/5200: Stop using device_type and port-number properties
      powerpc/5200: Trim cruft from device trees
      powerpc/5200: Don't specify IRQF_SHARED in PSC UART driver
      powerpc/5200: Remove pr_debug() from hot paths in irq driver
      powerpc/5200: Refactor mpc5200 interrupt controller driver
      powerpc/5200: Rework GPT driver to also be an IRQ controller
      powerpc/5200: Add support for the Media5200 board from Freescale
      powerpc/5200: Add 'simple-bus' to the of_platform probe list.
      powerpc/4xx: update ml507 .dts file to release reference design
      powerpc/5200: remove sysfs debug file from GPT driver
      powerpc/bootwrapper: add fixed-head.o to simpleimage wrappers
      powerpc/cpm2: fix building fs_enet driver as a module.

Grzegorz Bernacki (3):
      powerpc/5200: Add support for the digsy MTC board.
      powerpc/5200: Add digsy-mtc support to mpc5200_defconfig
      powerpc/5200: On the digsy-mtc, configure PSC4 and PSC5 as UARTs

Ilya Yanok (1):
      powerpc: Rework dma-noncoherent to use generic vmalloc layer

Jeremy Kerr (10):
      powerpc/spufs: Use correct return value for spu_handle_mm_fault
      powerpc/spufs: Clear purge status before setting up isolated mode
      powerpc/spufs: Constify context contents and coredump callback constants
      powerpc/spufs: Check file offset before calculating write size in fixed-sized files
      powerpc/spufs: Fix incorrect buffer offset in regs write
      powerpc: Fix page_ins details in lppaca comments
      powerpc: Add dispatch trace log fields to lppaca
      powerpc: Add virtual processor dispatch trace log
      powerpc/cell: Fix iommu exception reporting
      powerpc: Add write barrier before enabling DTL flags

John Linn (1):
      powerpc/virtex/spi: Xilinx SPI driver not releasing memory

Josh Boyer (1):
      powerpc: Sanitize stack pointer in signal handling code

Kumar Gala (19):
      powerpc/fsl-booke: Cleanup init/exception setup to be runtime
      powerpc/fsl: Ensure PCI_QUIRKS are enabled for FSL_PCI
      powerpc/85xx: Fixed PCI IO region sizes in mpc8572ds*.dts
      powerpc/85xx: Added 36-bit physical device tree for mpc8572ds board
      powerpc/fsl-booke: Add new ISA 2.06 page sizes and MAS defines
      powerpc/book-3e: Introduce concept of Book-3e MMU
      powerpc/fsl-booke: Fix compile warning
      powerpc: Unify opcode definitions and support
      powerpc: Fix warnings from make headers_check
      powerpc: Add support for using doorbells for SMP IPI
      powerpc/fsl-booke: Add support for tlbilx instructions
      powerpc/85xx: Update smp support to handle doorbells and non-mpic init
      powerpc/pci: Default to dma_direct_ops for pci dma_ops
      powerpc: setup default archdata for {of_}platform via bus_register_notifier
      powerpc: expect all devices calling dma ops to have archdata set
      powerpc/mm: Remove unused register usage in SW TLB miss handling
      powerpc/mm: Used free register to save a few cycles in SW TLB miss handling
      powerpc/mm: e300c2/c3/c4 TLB errata workaround
      powerpc/83xx: Update ranges in gianfar node to match other dts

Laurent Pinchart (1):
      cpm2: Round the baud-rate clock divider to the nearest integer.

Liu Yu (1):
      powerpc/math-emu: Fix efp dependence

Madhulika Madishetty (1):
      AMCC PPC 460SX redwood SoC platform initial framework

Martyn Welch (7):
      powerpc/86xx: Board support for GE Fanuc SBC310
      powerpc/86xx: Default configutation for GE Fanuc's SBC310
      powerpc/86xx: Extend GE Fanuc GPIO driver for the SBC310
      powerpc/86xx: Correct local bus registers in GE Fanuc SBC610 dts file
      powerpc/86xx: Run sbc310 USB fixup code only on the appropriate platform.
      powerpc/86xx: Board support for GE Fanuc's PPC9A
      powerpc/86xx: Default configuration for GE Fanuc's PPC9A

Michael Ellerman (20):
      powerpc: Remove unused ppc64_terminate_msg()
      powerpc: Allow debugging of LMBs with lmb=debug
      lmb: Rework lmb_dump_all() output
      powerpc/pseries: Fix MSI-X interrupt querying
      powerpc/pseries: Add support for ibm,req#msi-x
      powerpc/pseries: Check for MSI-X also in rtas_msi_pci_irq_fixup()
      powerpc/pseries: Return the number of MSIs we could allocate
      powerpc/pseries: Return req#msi(-x) if request is larger
      powerpc/pseries: Implement a quota system for MSIs
      powerpc: Deindentify identify_cpu()
      powerpc: Make sure we copy all cpu_spec features except PMC related ones
      powerpc: Remove unused asm-offsets entries for cpu_spec
      powerpc: Print linux_banner in prom_init
      powerpc/pseries: Reject discontiguous/non-zero based MSI-X requests
      powerpc/pseries: The pseries MSI code depends on EEH
      powerpc/cell: Fix Axon MSI driver dependencies
      powerpc/pseries: The RPA PCI hotplug driver depends on EEH
      powerpc/cell: Make axonram depends on BLOCK
      powerpc/msi: Mark the MSI bitmap selftest code as __init
      powerpc: Turn on self-tests in ppc64_defconfig

Michael Neuling (2):
      powerpc: Add alignment handler for new lfiwzx instruction
      powerpc: Fix load/store float double alignment handler

Mike Mason (1):
      powerpc/eeh: Only disable/enable LSI interrupts in EEH

Milton Miller (4):
      powerpc/numa: Avoid possible reference beyond prop. length in find_min_common_depth()
      powerpc/numa: Remove redundant find_cpu_node()
      powerpc/pseries: Remove write only variable in PCI DLPAR
      powerpc/pci: Move hose_list and pci_address_to_pio to pci-common

Nathan Fontenot (2):
      powerpc/numa: Cleanup hot_add_scn_to_nid
      powerpc/pseries: Failed reconfig notifier chain call cleanup

Nick Piggin (1):
      powerpc: Estimate G5 cpufreq transition latency

Octavian Purdila (2):
      powerpc/oprofile: G4 oprofile has variable number of counters
      powerpc/oprofile: Enable support for ppc750 processors

Peter Korsgaard (1):
      powerpc: convert dts-bindings/fsl/dma.txt to dts-v1 syntax

Reynes Philippe (3):
      powerpc/83xx: Add i2c eeprom to dts for MPC837x RDB
      powerpc/83xx: Add gpio to MPC837x RDB
      powerpc/83xx: Add lm75 to MPC837x RDB dts

Rusty Russell (2):
      powerpc: Make sysfs code use smp_call_function_single
      cpumask: Use mm_cpumask() wrapper instead of cpu_vm_mask

Stephen Rothwell (1):
      powerpc/pmi: Irq handlers return irqreturn_t

Steven Rostedt (11):
      tracing/function-graph-tracer: make arch generic push pop functions
      ftrace, powerpc: replace debug macro with proper pr_deug
      powerpc, ftrace: fix compile error when modules not configured
      powerpc64: port of the function graph tracer
      powerpc64, tracing: add function graph tracer with dynamic tracing
      powerpc64, ftrace: save toc only on modules for function graph
      powerpc32, ftrace: save and restore mcount regs with macro
      powerpc32, ftrace: port function graph tracer to ppc32, static only
      powerpc32, ftrace: dynamic function graph tracer
      powerpc, ftrace: use unsigned int for instruction manipulation
      powerpc, ftrace: use create_branch lib function

Ted Peters (1):
      powerpc/85xx: Fix MPC8572DS PCI protected interrupt sources

Thomas Gleixner (3):
      powerpc/irq: Convert obsolete irq_desc_t to struct irq_desc
      powerpc/irq: Convert obsolete hw_interrupt_type to struct irq_chip
      powerpc/85xx: remove setup_irq(NULL action) in ksi8560

Timur Tabi (4):
      i2c-mpc: do not allow interruptions when waiting for I2C to complete
      powerpc: add fsl,fifo-depth property to Freescale SSI device nodes
      powerpc: Add defintion for MSR[GS] to list of MSR bits
      powerpc: clean up ssi.txt, add definition for fsl,ssi-asynchronous

Tom Arbuckle (1):
      powerpc/pci: Fix PCI<->OF matching of old style multifunc devices

Trent Piepho (3):
      powerpc/fsl-booke: Remove code duplication in lowmem mapping
      powerpc/fsl-booke: Allow larger CAM sizes than 256 MB
      powerpc/fsl-booke: Make CAM entries used for lowmem configurable

Wolfgang Grandegger (4):
      powerpc/85xx: TQM85xx - fix sensitivity of CAN interrupts
      powerpc/85xx: TQM85xx - add i2c device nodes for LM75
      powerpc/5200: add function to return external clock frequency
      powerpc/85xx: Add support for the "socrates" board (MPC8544).

Wolfram Sang (2):
      powerpc/pci: Fix typo: s/resouces/resources/ in a pr_debug
      powerpc/5200: add Phytec phyCORE-MPC5200B-IO board (pcm032)

Xiaotian Feng (1):
      cpm_uart: fix non-console port startup bug

Yuri Tikhonov (1):
      powerpc/44x: Support for 256KB PAGE_SIZE

dayu@datangmobile.cn (1):
      powerpc/83xx: Fix the interrupt loss problem on ipic

roel kluin (2):
      therm_adt746x: Fix signed/unsigned confusion
      powerpc/ps3: Make ps3av_set_video_mode mode ID signed

 Documentation/powerpc/dts-bindings/fsl/dma.txt     |   34 +-
 Documentation/powerpc/dts-bindings/fsl/esdhc.txt   |   24 +
 Documentation/powerpc/dts-bindings/fsl/ssi.txt     |   68 +-
 arch/powerpc/Kconfig                               |   74 +-
 arch/powerpc/Kconfig.debug                         |    2 +-
 arch/powerpc/Makefile                              |    4 +-
 arch/powerpc/boot/Makefile                         |    9 +-
 arch/powerpc/boot/cuboot-amigaone.c                |   35 +
 arch/powerpc/boot/dts/amigaone.dts                 |  173 ++
 arch/powerpc/boot/dts/asp834x-redboot.dts          |   82 +-
 arch/powerpc/boot/dts/canyonlands.dts              |   28 +
 arch/powerpc/boot/dts/cm5200.dts                   |   49 +-
 arch/powerpc/boot/dts/digsy_mtc.dts                |  254 +++
 arch/powerpc/boot/dts/gef_ppc9a.dts                |  367 ++++
 arch/powerpc/boot/dts/gef_sbc310.dts               |  367 ++++
 arch/powerpc/boot/dts/gef_sbc610.dts               |   41 +-
 arch/powerpc/boot/dts/ksi8560.dts                  |   79 +-
 arch/powerpc/boot/dts/lite5200.dts                 |   52 +-
 arch/powerpc/boot/dts/lite5200b.dts                |   63 +-
 arch/powerpc/boot/dts/media5200.dts                |  318 ++++
 arch/powerpc/boot/dts/motionpro.dts                |   42 +-
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   11 +-
 arch/powerpc/boot/dts/mpc8315erdb.dts              |  144 ++-
 arch/powerpc/boot/dts/mpc8349emitx.dts             |   69 +-
 arch/powerpc/boot/dts/mpc8349emitxgp.dts           |   42 +-
 arch/powerpc/boot/dts/mpc834x_mds.dts              |   81 +-
 arch/powerpc/boot/dts/mpc8377_mds.dts              |  211 ++-
 arch/powerpc/boot/dts/mpc8377_rdb.dts              |  229 ++-
 arch/powerpc/boot/dts/mpc8378_mds.dts              |  209 ++-
 arch/powerpc/boot/dts/mpc8378_rdb.dts              |  229 ++-
 arch/powerpc/boot/dts/mpc8379_mds.dts              |  146 +-
 arch/powerpc/boot/dts/mpc8379_rdb.dts              |  164 ++-
 arch/powerpc/boot/dts/mpc8536ds.dts                |   78 +-
 arch/powerpc/boot/dts/mpc8540ads.dts               |  117 +-
 arch/powerpc/boot/dts/mpc8541cds.dts               |   78 +-
 arch/powerpc/boot/dts/mpc8544ds.dts                |   81 +-
 arch/powerpc/boot/dts/mpc8548cds.dts               |  156 +-
 arch/powerpc/boot/dts/mpc8555cds.dts               |   78 +-
 arch/powerpc/boot/dts/mpc8560ads.dts               |  102 +-
 arch/powerpc/boot/dts/mpc8568mds.dts               |  102 +-
 arch/powerpc/boot/dts/mpc8572ds.dts                |  160 +-
 arch/powerpc/boot/dts/mpc8572ds_36b.dts            |  799 +++++++++
 arch/powerpc/boot/dts/mpc8572ds_camp_core0.dts     |   49 +-
 arch/powerpc/boot/dts/mpc8572ds_camp_core1.dts     |    6 +-
 arch/powerpc/boot/dts/mpc8610_hpcd.dts             |    2 +
 arch/powerpc/boot/dts/mpc8641_hpcn.dts             |  157 +-
 arch/powerpc/boot/dts/pcm030.dts                   |  182 +--
 arch/powerpc/boot/dts/pcm032.dts                   |  392 ++++
 arch/powerpc/boot/dts/redwood.dts                  |  244 +++
 arch/powerpc/boot/dts/sbc8349.dts                  |   80 +-
 arch/powerpc/boot/dts/sbc8548.dts                  |   78 +-
 arch/powerpc/boot/dts/sbc8560.dts                  |  100 +-
 arch/powerpc/boot/dts/sbc8641d.dts                 |  156 +-
 arch/powerpc/boot/dts/socrates.dts                 |  338 ++++
 arch/powerpc/boot/dts/stx_gp3_8560.dts             |   78 +-
 arch/powerpc/boot/dts/tqm5200.dts                  |   32 +-
 arch/powerpc/boot/dts/tqm8540.dts                  |  122 +-
 arch/powerpc/boot/dts/tqm8541.dts                  |   95 +-
 arch/powerpc/boot/dts/tqm8548-bigflash.dts         |  177 +-
 arch/powerpc/boot/dts/tqm8548.dts                  |  177 +-
 arch/powerpc/boot/dts/tqm8555.dts                  |   95 +-
 arch/powerpc/boot/dts/tqm8560.dts                  |   99 +-
 arch/powerpc/boot/dts/virtex440-ml507.dts          |  124 ++-
 arch/powerpc/boot/serial.c                         |    3 +-
 arch/powerpc/boot/wrapper                          |    7 +-
 arch/powerpc/configs/44x/canyonlands_defconfig     |  266 +++-
 arch/powerpc/configs/44x/redwood_defconfig         | 1176 ++++++++++++
 arch/powerpc/configs/85xx/socrates_defconfig       | 1410 +++++++++++++++
 arch/powerpc/configs/86xx/gef_ppc9a_defconfig      | 1889 ++++++++++++++++++++
 arch/powerpc/configs/86xx/gef_sbc310_defconfig     | 1613 +++++++++++++++++
 arch/powerpc/configs/amigaone_defconfig            | 1636 +++++++++++++++++
 arch/powerpc/configs/mpc5200_defconfig             |   71 +-
 arch/powerpc/configs/ppc64_defconfig               |    6 +-
 arch/powerpc/include/asm/code-patching.h           |    4 +-
 arch/powerpc/include/asm/cputable.h                |    4 +-
 arch/powerpc/include/asm/dbell.h                   |   43 +
 arch/powerpc/include/asm/dma-mapping.h             |   12 +-
 arch/powerpc/include/asm/elf.h                     |   12 +-
 arch/powerpc/include/asm/fixmap.h                  |    2 +-
 arch/powerpc/include/asm/ftrace.h                  |   39 +-
 arch/powerpc/include/asm/highmem.h                 |   12 +-
 arch/powerpc/include/asm/hw_irq.h                  |    2 +-
 arch/powerpc/include/asm/io.h                      |    6 +
 arch/powerpc/include/asm/lppaca.h                  |    8 +-
 arch/powerpc/include/asm/machdep.h                 |    4 +-
 arch/powerpc/include/asm/mmu-44x.h                 |    2 +
 .../include/asm/{mmu-fsl-booke.h => mmu-book3e.h}  |   66 +-
 arch/powerpc/include/asm/mmu-hash64.h              |    2 -
 arch/powerpc/include/asm/mmu.h                     |   20 +-
 arch/powerpc/include/asm/mmu_context.h             |    2 +-
 arch/powerpc/include/asm/mpc52xx.h                 |    1 +
 arch/powerpc/include/asm/page.h                    |    6 +-
 arch/powerpc/include/asm/page_32.h                 |    4 +
 arch/powerpc/include/asm/pgtable-4k.h              |  117 --
 arch/powerpc/include/asm/pgtable-ppc32.h           |  557 +------
 arch/powerpc/include/asm/pgtable-ppc64-4k.h        |   74 +
 arch/powerpc/include/asm/pgtable-ppc64-64k.h       |   42 +
 arch/powerpc/include/asm/pgtable-ppc64.h           |  196 +--
 arch/powerpc/include/asm/pgtable.h                 |  134 ++
 arch/powerpc/include/asm/ppc-opcode.h              |   73 +
 arch/powerpc/include/asm/ppc_asm.h                 |    6 +-
 arch/powerpc/include/asm/processor.h               |   19 +
 arch/powerpc/include/asm/ps3av.h                   |    2 +-
 arch/powerpc/include/asm/ps3fb.h                   |    1 +
 arch/powerpc/include/asm/pte-40x.h                 |   64 +
 arch/powerpc/include/asm/pte-44x.h                 |  102 ++
 arch/powerpc/include/asm/pte-8xx.h                 |   67 +
 arch/powerpc/include/asm/pte-common.h              |  180 ++
 arch/powerpc/include/asm/pte-fsl-booke.h           |   48 +
 arch/powerpc/include/asm/pte-hash32.h              |   48 +
 arch/powerpc/include/asm/pte-hash64-4k.h           |   17 +
 .../asm/{pgtable-64k.h => pte-hash64-64k.h}        |  132 +-
 arch/powerpc/include/asm/pte-hash64.h              |   54 +
 arch/powerpc/include/asm/reg.h                     |    2 +
 arch/powerpc/include/asm/reg_booke.h               |    2 +
 arch/powerpc/include/asm/system.h                  |    2 +-
 arch/powerpc/include/asm/thread_info.h             |   11 +-
 arch/powerpc/include/asm/udbg.h                    |    1 +
 arch/powerpc/kernel/Makefile                       |   12 +-
 arch/powerpc/kernel/align.c                        |    2 +-
 arch/powerpc/kernel/asm-offsets.c                  |    3 -
 arch/powerpc/kernel/cpu_setup_44x.S                |    1 +
 arch/powerpc/kernel/cpu_setup_6xx.S                |    5 +
 arch/powerpc/kernel/cpu_setup_fsl_booke.S          |   31 +
 arch/powerpc/kernel/cputable.c                     |  166 ++-
 arch/powerpc/kernel/crash_dump.c                   |    2 +-
 arch/powerpc/kernel/dbell.c                        |   44 +
 arch/powerpc/kernel/entry_32.S                     |  129 +-
 arch/powerpc/kernel/entry_64.S                     |   89 +-
 arch/powerpc/kernel/ftrace.c                       |  222 ++-
 arch/powerpc/kernel/head_32.S                      |  101 +-
 arch/powerpc/kernel/head_64.S                      |    6 +-
 arch/powerpc/kernel/head_booke.h                   |   19 +-
 arch/powerpc/kernel/head_fsl_booke.S               |  101 +-
 arch/powerpc/kernel/irq.c                          |    4 +-
 arch/powerpc/kernel/module_64.c                    |    2 +-
 arch/powerpc/kernel/pci-common.c                   |   45 +-
 arch/powerpc/kernel/pci_32.c                       |   36 +-
 arch/powerpc/kernel/pci_64.c                       |   19 -
 arch/powerpc/kernel/process.c                      |   58 +
 arch/powerpc/kernel/prom.c                         |    6 +-
 arch/powerpc/kernel/prom_init.c                    |    2 +
 arch/powerpc/kernel/prom_init_check.sh             |    2 +-
 arch/powerpc/kernel/rtas.c                         |   10 +-
 arch/powerpc/kernel/setup-common.c                 |   36 +
 arch/powerpc/kernel/setup_64.c                     |   42 +-
 arch/powerpc/kernel/signal.c                       |    4 +-
 arch/powerpc/kernel/signal.h                       |   12 +-
 arch/powerpc/kernel/signal_32.c                    |    4 +-
 arch/powerpc/kernel/signal_64.c                    |    2 +-
 arch/powerpc/kernel/sysfs.c                        |   35 +-
 arch/powerpc/kernel/traps.c                        |   79 +-
 arch/powerpc/kernel/udbg.c                         |    7 +
 arch/powerpc/kernel/udbg_16550.c                   |   60 +-
 arch/powerpc/kernel/vmlinux.lds.S                  |    1 +
 arch/powerpc/lib/dma-noncoherent.c                 |  303 +---
 arch/powerpc/lib/feature-fixups.c                  |    4 +-
 arch/powerpc/math-emu/Makefile                     |    5 +-
 arch/powerpc/mm/Makefile                           |    4 +-
 arch/powerpc/mm/fault.c                            |   46 +-
 arch/powerpc/mm/fsl_booke_mmu.c                    |   95 +-
 arch/powerpc/mm/gup.c                              |   16 +-
 arch/powerpc/mm/hash_utils_64.c                    |   51 +-
 arch/powerpc/mm/mem.c                              |   33 -
 arch/powerpc/mm/{mmap.c => mmap_64.c}              |   64 +-
 arch/powerpc/mm/mmu_context_nohash.c               |    4 +-
 arch/powerpc/mm/numa.c                             |  174 +-
 arch/powerpc/mm/pgtable.c                          |  134 ++-
 arch/powerpc/mm/pgtable_32.c                       |   18 +-
 arch/powerpc/mm/pgtable_64.c                       |   25 +-
 arch/powerpc/mm/ppc_mmu_32.c                       |   10 +-
 arch/powerpc/mm/tlb_hash64.c                       |    6 +-
 arch/powerpc/mm/tlb_nohash.c                       |   18 +-
 arch/powerpc/mm/tlb_nohash_low.S                   |   44 +-
 arch/powerpc/oprofile/op_model_7450.c              |   21 +-
 arch/powerpc/platforms/44x/Kconfig                 |   19 +
 arch/powerpc/platforms/44x/ppc44x_simple.c         |    1 +
 arch/powerpc/platforms/512x/Kconfig                |    4 +-
 arch/powerpc/platforms/52xx/Kconfig                |   15 +-
 arch/powerpc/platforms/52xx/Makefile               |    3 +-
 arch/powerpc/platforms/52xx/media5200.c            |  273 +++
 arch/powerpc/platforms/52xx/mpc5200_simple.c       |    4 +-
 arch/powerpc/platforms/52xx/mpc52xx_common.c       |   40 +-
 arch/powerpc/platforms/52xx/mpc52xx_gpio.c         |   85 -
 arch/powerpc/platforms/52xx/mpc52xx_gpt.c          |  396 ++++
 arch/powerpc/platforms/52xx/mpc52xx_pic.c          |  170 +--
 arch/powerpc/platforms/82xx/Kconfig                |    2 +-
 arch/powerpc/platforms/83xx/Kconfig                |    2 +-
 arch/powerpc/platforms/83xx/asp834x.c              |    1 +
 arch/powerpc/platforms/83xx/mpc831x_rdb.c          |    2 +
 arch/powerpc/platforms/83xx/mpc834x_itx.c          |    1 +
 arch/powerpc/platforms/83xx/mpc834x_mds.c          |    1 +
 arch/powerpc/platforms/83xx/mpc837x_mds.c          |   11 +-
 arch/powerpc/platforms/83xx/mpc837x_rdb.c          |    3 +
 arch/powerpc/platforms/83xx/sbc834x.c              |    1 +
 arch/powerpc/platforms/83xx/usb.c                  |    3 +-
 arch/powerpc/platforms/85xx/Kconfig                |    6 +
 arch/powerpc/platforms/85xx/Makefile               |    1 +
 arch/powerpc/platforms/85xx/ksi8560.c              |    3 +-
 arch/powerpc/platforms/85xx/mpc8536_ds.c           |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_ads.c          |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_cds.c          |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_ds.c           |    1 +
 arch/powerpc/platforms/85xx/mpc85xx_mds.c          |    1 +
 arch/powerpc/platforms/85xx/sbc8548.c              |    1 +
 arch/powerpc/platforms/85xx/sbc8560.c              |    1 +
 arch/powerpc/platforms/85xx/smp.c                  |   43 +-
 arch/powerpc/platforms/85xx/socrates.c             |  133 ++
 arch/powerpc/platforms/85xx/socrates_fpga_pic.c    |  327 ++++
 arch/powerpc/platforms/85xx/socrates_fpga_pic.h    |   16 +
 arch/powerpc/platforms/85xx/stx_gp3.c              |    1 +
 arch/powerpc/platforms/85xx/tqm85xx.c              |    1 +
 arch/powerpc/platforms/86xx/Kconfig                |   20 +-
 arch/powerpc/platforms/86xx/Makefile               |    2 +
 arch/powerpc/platforms/86xx/gef_gpio.c             |   36 +-
 arch/powerpc/platforms/86xx/gef_ppc9a.c            |  224 +++
 arch/powerpc/platforms/86xx/gef_sbc310.c           |  235 +++
 arch/powerpc/platforms/86xx/gef_sbc610.c           |    1 +
 arch/powerpc/platforms/86xx/mpc8610_hpcd.c         |    1 +
 arch/powerpc/platforms/86xx/mpc86xx_hpcn.c         |    1 +
 arch/powerpc/platforms/86xx/sbc8641d.c             |    1 +
 arch/powerpc/platforms/Kconfig                     |   39 +-
 arch/powerpc/platforms/Kconfig.cputype             |   22 +-
 arch/powerpc/platforms/Makefile                    |    1 +
 arch/powerpc/platforms/amigaone/Kconfig            |   18 +
 arch/powerpc/platforms/amigaone/Makefile           |    1 +
 arch/powerpc/platforms/amigaone/setup.c            |  170 ++
 arch/powerpc/platforms/cell/Kconfig                |   33 +-
 arch/powerpc/platforms/cell/Makefile               |    2 +-
 arch/powerpc/platforms/cell/io-workarounds.c       |    4 +-
 arch/powerpc/platforms/cell/iommu.c                |    9 +-
 arch/powerpc/platforms/cell/qpace_setup.c          |   15 +-
 arch/powerpc/platforms/cell/spu_base.c             |    2 +-
 arch/powerpc/platforms/cell/spu_fault.c            |   48 +-
 arch/powerpc/platforms/cell/spufs/context.c        |    4 +
 arch/powerpc/platforms/cell/spufs/file.c           |   20 +-
 arch/powerpc/platforms/cell/spufs/inode.c          |    5 +-
 arch/powerpc/platforms/cell/spufs/run.c            |    3 +
 arch/powerpc/platforms/cell/spufs/spufs.h          |    8 +-
 arch/powerpc/platforms/chrp/Kconfig                |    2 +-
 arch/powerpc/platforms/chrp/pegasos_eth.c          |   72 +-
 arch/powerpc/platforms/embedded6xx/Kconfig         |    2 +-
 arch/powerpc/platforms/iseries/Kconfig             |    2 +-
 arch/powerpc/platforms/iseries/irq.c               |    2 +-
 arch/powerpc/platforms/iseries/setup.c             |    2 +-
 arch/powerpc/platforms/maple/Kconfig               |    2 +-
 arch/powerpc/platforms/pasemi/Kconfig              |    2 +-
 arch/powerpc/platforms/powermac/Kconfig            |    2 +-
 arch/powerpc/platforms/powermac/cpufreq_64.c       |    5 +-
 arch/powerpc/platforms/powermac/pic.h              |    2 +-
 arch/powerpc/platforms/powermac/setup.c            |    3 +
 arch/powerpc/platforms/prep/Kconfig                |    2 +-
 arch/powerpc/platforms/ps3/Kconfig                 |    2 +-
 arch/powerpc/platforms/ps3/mm.c                    |    4 +-
 arch/powerpc/platforms/pseries/Kconfig             |   17 +-
 arch/powerpc/platforms/pseries/Makefile            |    3 +-
 arch/powerpc/platforms/pseries/dtl.c               |  278 +++
 arch/powerpc/platforms/pseries/eeh_driver.c        |   68 +-
 arch/powerpc/platforms/pseries/msi.c               |  248 +++-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |    2 -
 arch/powerpc/platforms/pseries/plpar_wrappers.h    |   10 +
 arch/powerpc/platforms/pseries/reconfig.c          |    6 +-
 arch/powerpc/sysdev/cpm2.c                         |    4 +-
 arch/powerpc/sysdev/cpm_common.c                   |    2 +-
 arch/powerpc/sysdev/fsl_pci.c                      |  244 +++-
 arch/powerpc/sysdev/fsl_soc.c                      |    4 +
 arch/powerpc/sysdev/ipic.c                         |    6 +-
 arch/powerpc/sysdev/msi_bitmap.c                   |    6 +-
 arch/powerpc/sysdev/pmi.c                          |    2 +-
 arch/powerpc/sysdev/ppc4xx_pci.c                   |    2 +
 arch/x86/include/asm/ftrace.h                      |   25 -
 arch/x86/kernel/dumpstack.c                        |    1 +
 arch/x86/kernel/ftrace.c                           |   75 +-
 drivers/i2c/busses/i2c-mpc.c                       |    9 +-
 drivers/macintosh/therm_adt746x.c                  |    4 +-
 drivers/net/fec_mpc52xx.c                          |    6 +-
 drivers/ps3/ps3av.c                                |   16 +-
 drivers/serial/cpm_uart/cpm_uart_core.c            |   14 +-
 drivers/serial/mpc52xx_uart.c                      |   40 +-
 drivers/spi/xilinx_spi.c                           |    9 +-
 drivers/watchdog/Kconfig                           |    2 +-
 include/linux/ftrace.h                             |   24 +
 include/linux/pci_ids.h                            |    8 +
 kernel/trace/trace_functions_graph.c               |   75 +
 lib/lmb.c                                          |   42 +-
 285 files changed, 20157 insertions(+), 4688 deletions(-)
 create mode 100644 Documentation/powerpc/dts-bindings/fsl/esdhc.txt
 create mode 100644 arch/powerpc/boot/cuboot-amigaone.c
 create mode 100644 arch/powerpc/boot/dts/amigaone.dts
 create mode 100644 arch/powerpc/boot/dts/digsy_mtc.dts
 create mode 100644 arch/powerpc/boot/dts/gef_ppc9a.dts
 create mode 100644 arch/powerpc/boot/dts/gef_sbc310.dts
 create mode 100644 arch/powerpc/boot/dts/media5200.dts
 create mode 100644 arch/powerpc/boot/dts/mpc8572ds_36b.dts
 create mode 100644 arch/powerpc/boot/dts/pcm032.dts
 create mode 100644 arch/powerpc/boot/dts/redwood.dts
 create mode 100644 arch/powerpc/boot/dts/socrates.dts
 create mode 100644 arch/powerpc/configs/44x/redwood_defconfig
 create mode 100644 arch/powerpc/configs/85xx/socrates_defconfig
 create mode 100644 arch/powerpc/configs/86xx/gef_ppc9a_defconfig
 create mode 100644 arch/powerpc/configs/86xx/gef_sbc310_defconfig
 create mode 100644 arch/powerpc/configs/amigaone_defconfig
 create mode 100644 arch/powerpc/include/asm/dbell.h
 rename arch/powerpc/include/asm/{mmu-fsl-booke.h => mmu-book3e.h} (53%)
 delete mode 100644 arch/powerpc/include/asm/pgtable-4k.h
 create mode 100644 arch/powerpc/include/asm/pgtable-ppc64-4k.h
 create mode 100644 arch/powerpc/include/asm/pgtable-ppc64-64k.h
 create mode 100644 arch/powerpc/include/asm/ppc-opcode.h
 create mode 100644 arch/powerpc/include/asm/pte-40x.h
 create mode 100644 arch/powerpc/include/asm/pte-44x.h
 create mode 100644 arch/powerpc/include/asm/pte-8xx.h
 create mode 100644 arch/powerpc/include/asm/pte-common.h
 create mode 100644 arch/powerpc/include/asm/pte-fsl-booke.h
 create mode 100644 arch/powerpc/include/asm/pte-hash32.h
 create mode 100644 arch/powerpc/include/asm/pte-hash64-4k.h
 rename arch/powerpc/include/asm/{pgtable-64k.h => pte-hash64-64k.h} (73%)
 create mode 100644 arch/powerpc/include/asm/pte-hash64.h
 create mode 100644 arch/powerpc/kernel/cpu_setup_fsl_booke.S
 create mode 100644 arch/powerpc/kernel/dbell.c
 rename arch/powerpc/mm/{mmap.c => mmap_64.c} (65%)
 create mode 100644 arch/powerpc/platforms/52xx/media5200.c
 create mode 100644 arch/powerpc/platforms/52xx/mpc52xx_gpt.c
 create mode 100644 arch/powerpc/platforms/85xx/socrates.c
 create mode 100644 arch/powerpc/platforms/85xx/socrates_fpga_pic.c
 create mode 100644 arch/powerpc/platforms/85xx/socrates_fpga_pic.h
 create mode 100644 arch/powerpc/platforms/86xx/gef_ppc9a.c
 create mode 100644 arch/powerpc/platforms/86xx/gef_sbc310.c
 create mode 100644 arch/powerpc/platforms/amigaone/Kconfig
 create mode 100644 arch/powerpc/platforms/amigaone/Makefile
 create mode 100644 arch/powerpc/platforms/amigaone/setup.c
 create mode 100644 arch/powerpc/platforms/pseries/dtl.c


