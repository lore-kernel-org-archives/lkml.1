Return-Path: <linux-kernel-owner+w=401wt.eu-S1758210AbXHMEut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758210AbXHMEut (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2007 00:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751165AbXHMEuk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Aug 2007 00:50:40 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46481 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbXHMEuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2007 00:50:37 -0400
Date: Sun, 12 Aug 2007 21:50:28 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.23-rc3
Message-ID: <alpine.LFD.0.999.0708122143240.30176@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Either people really are calming down, and figuring out that we're in the 
stabilization phase, or it's just that it's the middle of August, and 
most everybody at least in Europe are off on vacation.

Regardless of why, -rc3 is out, and doesn't have the tons of changes that 
-rc2 did. But there's some scheduler updates, sparc64 and powerpc changes, 
and random driver updates (the lpfc SCSI driver kind of stands out in the 
diffstat).

Shortlog appended, I don't know what I can add to it.. Please do give it a 
good testing, unless you're on a beach sunning yourself (and who are we 
kidding: you're pasty white, and sand is hard to get out of the keyboard - 
beaches are overrated).

		Linus

---
Adrian Bunk (9):
      sony-laptop: sony_nc_ids[] can become static.
      ACPI: EC: acpi_ec_remove(): fix use-after-free
      ACPI: sbs: remove dead code
      [2.6 patch] ocfs2_insert_extent(): remove dead code
      remove mm/filemap.c:file_send_actor()
      cris: drivers/cdrom/Kconfig no longer exists
      i386: really stop MCEs during code patching
      ACPI: static
      sched: make global code static

Adrian McMenamin (2):
      pvr2fb: Consolidated cleanup of pvr2fb.c
      pvr2fb: update Documentation/fb/pvr2fb.txt

Al Viro (2):
      take sched_debug.c out of nasal demon territory
      fix oops in __audit_signal_info()

Alan Cox (2):
      remove dubious legal statment from uio-howto
      fix serial buffer memory leak

Alan D. Brunelle (1):
      Fix remap handling by blktrace

Alan Stern (1):
      hex_dump: add missing "const" qualifiers

Alexey Dobriyan (2):
      sched: remove binary sysctls from kernel.sched_domain
      Remove unused struct proc_dir_entry::set

Alexey Starikovskiy (5):
      ACPI: EC: Remove noisy debug printk fron EC driver.
      ACPI: Battery: Synchronize battery operations.
      ACPI: EC: If ECDT is not found, look up EC in DSDT.
      ACPI: EC: Switch from boot_ec as soon as we find its desc in DSDT.
      ACPI EC: remove potential deadlock from EC

Andi Kleen (6):
      x86_64: Don't mark __exitcall as __cold
      x86: Disable CLFLUSH support again
      i386: Make patching more robust, fix paravirt issue
      i386: Use global flag to disable broken local apic timer on AMD CPUs.
      i386: Add warning in Documentation that zero-page is not a stable ABI
      i386: Fix start_kernel warning

Andre Detsch (1):
      [POWERPC] cell: Move SPU affinity init to spu_management_of_ops

Andrew Morton (1):
      mtdchar build fix

Andy Whitcroft (1):
      update checkpatch.pl to version 0.09

Anton Vorontsov (2):
      spi_mpc83xx: in "QE mode", use sysclk/2
      spi_mpc83xx: fix prescale modulus calculation

Antonino A. Daplas (2):
      fbcon: Kill compile warning
      pvr2fb: Fix oops when pseudo_palette is written

Artem Bityutskiy (1):
      hexdump: use const notation

Avi Kivity (1):
      KVM: x86 emulator: fix debug reg mov instructions

Badari Pulavarty (1):
      direct-io: fix error-path crashes

Benjamin Herrenschmidt (2):
      [POWERPC] Fix initialization and usage of dma_mask
      [POWERPC] Fix size check for hugetlbfs

Boaz Harrosh (6):
      [SCSI] aha152x: fix debug mode symbol conflict
      [SCSI] aha152x: use bounce buffer
      [SCSI] aha152x: preliminary fixes and some comments
      [SCSI] aha152x: Clean Reset path
      [SCSI] aha152x: Fix check_condition code-path
      [SCSI] aha152x: use data accessors and !use_sg cleanup

Brian King (1):
      ibmveth: Fix rx pool deactivate oops

Bryan Wu (1):
      Blackfin arch: after removing fs.h from mm.h, fix the broken on Blackfin arch

Christoph Hellwig (1):
      sysace: HDIO_GETGEO has it's own method for ages

Christoph Lameter (2):
      SLUB: Remove checks for MAX_PARTIAL from kmem_cache_shrink
      SLUB: Fix dynamic dma kmalloc cache creation

Chuck Ebbert (2):
      [NETFILTER]: Add xt_statistic.h to the header list for usermode programs
      i386: Fix double fault handler

Cornelia Huck (1):
      [S390] cio: avoid memory leak on error in css_alloc_subchannel().

Dan Williams (2):
      [ARM] 4541/1: iop: defconfig updates
      async_tx: update MAINTAINERS for async_tx and iop-adma

Daniel Drake (2):
      mac80211: missing dev_put in ieee80211_master_start_xmit
      mac80211: don't allow scanning in monitor mode

Daniel Ritz (1):
      drivers/char/pcmcia/cm40x0_cs.c: fix release function call

Dave Airlie (1):
      drm/i915: Fix i965 secured batchbuffer usage

David Brownell (1):
      spidev warning fix

David Howells (2):
      BLOCK: Hide the contents of linux/bio.h if CONFIG_BLOCK=n
      FRV: connect up fallocate

David Miller (1):
      [SCSI] ESP: Revert ESP_BUS_TIMEOUT back down to 250

David S. Miller (4):
      [SPARC]: Centralize find_in_proplist() instead of duplicating N times.
      [SPARC64]: Fix hard-coding of cpu type output in /proc/cpuinfo on sun4v.
      [SPARC64]: Do not assume sun4v chips have load-twin/store-init support.
      [SPARC64]: Fix memory leak when cpu hotplugging.

Domen Puncer (2):
      ucc_geth: fix section mismatch
      phy layer: fix phy_mii_ioctl for autonegotiation

Eugene Teo (1):
      sonypi: fix ids member of struct acpi_driver

FUJITA Tomonori (6):
      [SCSI] zfcp: convert to use the data buffer accessors
      [SCSI] ibmvscsi: remove unnecessary map_sg check
      [SCSI] ibmvscsi: use shost_priv
      [SCSI] bsg: update sg_io_v4 structure
      [SCSI] mptsas: add SMP passthrough support via bsg
      [SCSI] initialize shost_data to zero

Fenghua Yu (1):
      acpi-cpufreq: Fix some x86/x86-64 acpi-cpufreq driver issues

Francois Romieu (1):
      r8169: avoid needless NAPI poll scheduling

Gabriel C (3):
      wbsd: fix section mismatch warnings
      linux-audit list is subscribers-only
      kernel-parameters.txt : watchdog.txt should be wdt.txt

Geert Uytterhoeven (1):
      [POWERPC] PS3: Fix storage probe logic

Geoff Levand (1):
      [POWERPC] PS3: Remove text saying PS3 support is incomplete

Greg Ungerer (2):
      [ARM] 4531/1: remove is_in_rom() protptype
      changing include/asm-generic/pgtable.h for non-mmu

Heiko Carstens (3):
      [S390] qdio: make sure data structures are correctly aligned.
      [S390] remove DEFAULT_MIGRATION_COST
      [S390] vmur: use DECLARE_COMPLETION_ONSTACK to keep lockdep happy

Helge Deller (1):
      stifb: detect cards in double buffer mode more reliably

Henrique de Moraes Holschuh (3):
      ACPI: thinkpad-acpi: fix the module init failure path
      ACPI: thinkpad-acpi: change thinkpad-acpi input default and kconfig help
      ACPI: thinkpad-acpi: fix sysfs paths in documentation

Holger Macht (1):
      ACPI: dock: Send key=value pair instead of plain value

Ingo Molnar (60):
      atl1: use spin_trylock_irqsave()
      sched: batch sleeper bonus
      sched: reorder update_cpu_load(rq) with the ->task_tick() call
      sched: uninline rq_clock()
      sched: schedule() speedup
      sched: clean up delta_mine
      sched: delta_exec accounting fix
      sched: document nice levels
      sched: add [__]update_rq_clock(rq)
      sched: eliminate rq_clock() use
      sched: remove rq_clock()
      sched: eliminate __rq_clock() use
      sched: remove __rq_clock()
      sched: remove 'now' use from assignments
      sched: remove the 'u64 now' parameter from print_cfs_rq()
      sched: remove the 'u64 now' parameter from update_curr()
      sched: remove the 'u64 now' parameter from update_stats_wait_start()
      sched: remove the 'u64 now' parameter from update_stats_enqueue()
      sched: remove the 'u64 now' parameter from __update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_wait_end()
      sched: remove the 'u64 now' parameter from update_stats_curr_start()
      sched: remove the 'u64 now' parameter from update_stats_dequeue()
      sched: remove the 'u64 now' parameter from update_stats_curr_end()
      sched: remove the 'u64 now' parameter from __enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_sleeper()
      sched: remove the 'u64 now' parameter from enqueue_entity()
      sched: remove the 'u64 now' parameter from dequeue_entity()
      sched: remove the 'u64 now' parameter from set_next_entity()
      sched: remove the 'u64 now' parameter from pick_next_entity()
      sched: remove the 'u64 now' parameter from put_prev_entity()
      sched: remove the 'u64 now' parameter from update_curr_rt()
      sched: remove the 'u64 now' parameter from ->enqueue_task()
      sched: remove the 'u64 now' parameter from ->dequeue_task()
      sched: remove the 'u64 now' parameter from ->pick_next_task()
      sched: remove the 'u64 now' parameter from pick_next_task()
      sched: remove the 'u64 now' parameter from ->put_prev_task()
      sched: remove the 'u64 now' parameter from ->task_new()
      sched: remove the 'u64 now' parameter from update_curr_load()
      sched: remove the 'u64 now' parameter from inc_load()
      sched: remove the 'u64 now' parameter from dec_load()
      sched: remove the 'u64 now' parameter from inc_nr_running()
      sched: remove the 'u64 now' parameter from dec_nr_running()
      sched: remove the 'u64 now' parameter from enqueue_task()
      sched: remove the 'u64 now' parameter from dequeue_task()
      sched: remove the 'u64 now' parameter from deactivate_task()
      sched: remove the 'u64 now' local variables
      sched debug: remove the 'u64 now' parameter from print_task()/_rq()
      sched: move the __update_rq_clock() call to scheduler_tick()
      sched: remove __update_rq_clock() call from entity_tick()
      sched: clean up set_curr_task_fair()
      sched: optimize activate_task()
      sched: optimize update_rq_clock() calls in the load-balancer
      sched: make the multiplication table more accurate
      sched: round a bit better
      sched: fix update_stats_enqueue() reniced codepath
      sched: refine negative nice level granularity
      sched: improve rq-clock overflow logic
      sched: fix typo in the FAIR_GROUP_SCHED branch
      sched debug: dont print kernel address in /proc/sched_debug
      sched: fix sleeper bonus

James Bottomley (4):
      [SCSI] libsas: fix build dependencies on libata
      [SCSI] mpt fusion: make logging a global sysfs parameter
      [SCSI] aic7xxx: cap maxsync according to correct card limits
      [SCSI] sd: disentangle barriers in SCSI

James Smart (9):
      [SCSI] lpfc 8.2.2 : Error messages and debugfs updates
      [SCSI] lpfc 8.2.2 : Fix locking around HBA's port_list
      [SCSI] lpfc 8.2.2 : Attribute and Parameter splits for vport and physical port
      [SCSI] lpfc 8.2.2 : Rework the lpfc_printf_log() macro
      [SCSI] lpfc 8.2.2 : Miscellaneous management and logging mods
      [SCSI] lpfc 8.2.2 : Miscellaneous Bug Fixes
      [SCSI] lpfc 8.2.2 : Style cleanups
      [SCSI] lpfc 8.2.2 : Change version number to 8.2.2
      [SCSI] lpfc : scsi command accessor fix for 8.2.2

Jan Altenberg (2):
      ucc_geth: remove get_perm_addr from ucc_geth_ethtool.c
      [ARM] 4542/1: AT91: include atmel_lcdc.h in at91sam926{1,3}_devices.c

Jarek Poplawski (1):
      docs: note about select in kconfig-language.txt

Jay Estabrook (1):
      alpha: -Werror fixes for sys_titan.c

Jeff Garzik (1):
      [SCSI] gdth: remove redundant PCI stuff

Jes Sorensen (1):
      lguest files should explicitly include asm/paravirt.h

Jesper Juhl (5):
      asus_acpi: fix possible double free (found by Coverity)
      [NETFILTER]: ipt_recent: avoid a possible NULL pointer deref in recent_seq_open()
      SLUB: Fix format specifier in Documentation/vm/slabinfo.c
      Clean up duplicate includes in drivers/block/
      Documentation: sysrq, description of 'h' slightly inaccurate

Johannes Berg (1):
      [NET] net/core/utils: fix sparse warning

John W. Linville (1):
      Revert "[PATCH] bcm43xx: Fix deviation from specifications in set_baseband_attenuation"

Josh Triplett (2):
      sched: mark print_cfs_stats static
      RCU: Remove prototype for nonexistent function synchronize_idle()

Kim Phillips (1):
      [POWERPC] Revert "[POWERPC] Add 'mdio' to bus scan id list for platforms with QE UEC"

Lee Schermerhorn (1):
      Fix missing numa_zonelist_order sysctl

Len Brown (8):
      ACPI: add "acpi_no_auto_ssdt" bootparam
      ACPI: EC: fix build warning
      ACPI: thermal: create "thermal.off=1" to disable ACPI thermal support
      ACPI: thermal: expose "thermal.tzp=" to set global polling frequency
      ACPI: thermal: create "thermal.psv=" to override passive trip points
      ACPI: thermal: create "thermal.nocrt" to disable critical actions
      ACPI: thermal: create "thermal.act=" to disable or override active trip point
      ACPI: thermal: add DMI hooks to handle AOpen's broken Award BIOS

Linus Torvalds (3):
      Revert "genirq: temporary fix for level-triggered IRQ resend"
      i386: Fix broken mmiocfg accesses
      Linux 2.6.23-rc3

Mariusz Kozlowski (3):
      drivers/net/ibmveth.c: memset fix
      drivers/block/cciss.c: kmalloc + memset conversion to kzalloc
      drivers/block/cpqarray.c: better error handling and kmalloc + memset conversion to k[cz]alloc

Mark Fasheh (6):
      ocfs2: Restrict inode changes in ocfs2_update_inode_atime()
      ocfs2: use s_maxbytes directly in ocfs2_change_file_space()
      ocfs2: Fix some casting errors related to file writes
      ocfs2: check ia_size limits in setattr
      ocfs2: Fix max offset calculations
      ocfs2: set non-default s_time_gran during mount

Mark Fortescue (2):
      [SCSI] qlogicpti: Some cosmetic changes
      [SPARC32]: Fix build.

Masakazu Mokuno (1):
      remove duplicated ioctl entries in compat_ioctl.c

Matthew Wilcox (1):
      [SCSI] dpt_i2o: convert to SCSI hotplug model

Matthias Kaehlcke (1):
      [SCSI] st: Use mutex instead of semaphore

Mattia Dongili (1):
      sony-laptop: restore the last user requested brightness level on resume.

Meelis Roos (1):
      ACPI: EC: fix run-together printk lines

Melissa Howland (1):
      [S390] monwriter: Serialization bug for multithreaded applications.

Miao Xie (1):
      timer: remove clockevents_unregister_notifier

Michael Buesch (1):
      softmac: Fix deadlock of wx_set_essid with assoc work

Michael Chan (2):
      [TG3]: Fix suspend/resume problem.
      [BNX2]: Fix suspend/resume problem.

Michael Holzheu (5):
      [S390] hypfs: implement show_options
      [S390] vmur: allocate single record buffers instead of one big data buffer
      [S390] vmur: reject open on z/VM reader files with status HOLD
      [S390] vmur: add "top of queue" sanity check for reader open
      [S390] vmur: diag14 only works with buffers below 2GB

Michael Wu (1):
      rtl8187: ensure priv->hwaddr is always valid

Muli Ben-Yehuda (1):
      finish i386 and x86-64 sysdata conversion

Murillo Fernandes Bernardes (1):
      x86_64: Calgary - Fix mis-handled PCI topology

Neil Muller (1):
      sis190 check for ISA bridge on SiS966

Nicolas Ferre (1):
      mmc: at91_mci: remove whitespace at the end of lines

Oleg Nesterov (1):
      sched: run_rebalance_domains: s/SCHED_IDLE/CPU_IDLE/

Pablo Neira Ayuso (1):
      [NETFILTER]: ctnetlink: return EEXIST instead of EINVAL for existing nat'ed conntracks

Patrick McHardy (1):
      [NETFILTER]: nf_nat: add symbolic dependency on IPv4 conntrack

Paul A. Clarke (1):
      matroxfb: rectify jitter (G450/G550)

Paul Mackerras (1):
      [POWERPC] Fix potential duplicate entry in SLB shadow buffer

Paul Moore (1):
      [NetLabel]: add missing rcu_dereference() calls in the LSM domain mapping hash table

Paul Mundt (1):
      net: smc91x: Build fixes for general sh boards.

Pete Zaitcev (1):
      x86_64: vdso.lds in arch/x86_64/vdso/.gitignore

Peter Chubb (1):
      fix compilation with gcc 4.2

Peter Williams (2):
      sched: simplify move_tasks()
      sched: fix bug in balance_tasks()

Petr Vandrovec (1):
      Do not replace whole memcpy in apply alternatives

Pierre Ossman (1):
      mmc: reorganize bounce buffer init

Rafael J. Wysocki (1):
      Hibernation: do not try to mark invalid PFNs as nosave

Richard Henderson (1):
      Fix Alpha O_CLOEXEC definition

Robin Holt (1):
      x86_64: fix HPET init race

Roger So (1):
      r8169: PHY power-on fix

Ronald G. Minnich (1):
      lguest: avoid shared libraries mapped over guest memory

Russell King (2):
      [ARM] pata_icside: fix the FIXMEs
      [ARM] rpc: update defconfig

Rusty Russell (3):
      Enable lguest drivers in Kconfig
      Fix non-TSC guest clocksource lockup
      lguest: Fix Malicious Guest GDT Host Crash

Ryusuke Konishi (2):
      eCryptfs: fix lookup error for special files
      eCryptfs: fix error handling in ecryptfs_init

Salyzyn, Mark (1):
      [SCSI] aacraid: prevent panic on adapter resource failure

Sebastian Siewior (1):
      [CRYPTO] api: fix writting into unallocated memory in setkey_aligned

Seokmann Ju (1):
      [SCSI] qla2xxx: fix panic caused by previous patch

Stephan Berberig (1):
      ACPI: bay: send envp with uevent - fix

Stephen Hemminger (2):
      [TCP]: H-TCP maxRTT estimation at startup
      readahead: docbook fix

Stephen Rothwell (1):
      [POWERPC] Fix more section mismatches in head_64.S

Sunil Mushran (2):
      ocfs2: Fix rename/extend race
      ocfs2: Retry sendpage() if it returns EAGAIN

Thomas Gleixner (3):
      genirq: cleanup mismerge artifact
      genirq: suppress resend of level interrupts
      genirq: mark io_apic level interrupts to avoid resend

Thomas Klein (3):
      ehea: Fix workqueue handling
      ehea: Simplify resource usage check
      ehea: Eliminated some compiler warnings

Thomas Voegtle (1):
      sched: mention CONFIG_SCHED_DEBUG in documentation

Trond Myklebust (8):
      SUNRPC: Fix a race in rpciod_down()
      NFS: Fix put_nfs_open_context
      NFSv4: Fix a locking regression in nfs4_set_mode_locked()
      NFS: Fix NFSv4 open stateid regressions
      NFSv4: Don't call put_rpccred() from an rcu callback
      SUNRPC: Don't call gss_delete_sec_context() from an rcu context
      NFS: Replace flush_scheduled_work with cancel_work_sync() and friends
      SUNRPC: Replace flush_workqueue() with cancel_work_sync() and friends

Ulrich Drepper (1):
      sched: clean up sched_getaffinity()

Ulrich Kunitz (1):
      zd1211rw: fix filter for PSPOLL frames

Venki Pallipadi (1):
      ACPI: fix "Time Problems with 2.6.23-rc1-gf695baf2"

Yasunori Goto (1):
      Memory hotplug document

Zachary Amsden (1):
      x86_64: Early segment setup for VT

Zhu Yi (2):
      mac80211: use do { } while (0) for multi-line macros
      mac80211: Fix sparse error for sta_last_seq_ctrl_read

dean gaudet (1):
      x86: Work around mmio config space quirk on AMD Fam10h

geoffrey.levand@am.sony.com (1):
      [POWERPC] PS3: Update ps3_defconfig
