Return-Path: <linux-kernel-owner+w=401wt.eu-S1758349AbYAPEiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758349AbYAPEiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 23:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754436AbYAPEh5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 23:37:57 -0500
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41289 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753832AbYAPEhy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 23:37:54 -0500
Date: Tue, 15 Jan 2008 20:37:48 -0800 (PST)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.24-rc8
Message-ID: <alpine.LFD.1.00.0801152027150.2806@woody.linux-foundation.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I do hate doing -rc's for so long, but I hate releasing when not feeling 
it's simmered enough even more. And the changes since -rc7 are bigger than 
the changes between -rc6 and -rc7 were (partly probably because people 
were still on vacation between -rc6 and -rc7, so we had something of a 
small trickle come in afterwards).

That said, the changes here really aren't that big, and the shortlog is 
fairly boring. So I'm pretty sure this is the last -rc, and the final 
2.6.24 will probably be out next weekend or so. But in the meantime, let's 
give this a final shakedown, and see if we can fix any last regressions 
still.

(I also get the feeling that more people are already working on 2.6.25 
features, so it's not like delaying 2.6.24 will help past some point 
anyway, but let's give it a few more days).

Anyway: drivers, networking, some arch updates, and ACPI. A fair number of 
really small commits. I honestly can't really improve on the appended 
shortlog - there isn't any over-arching theme, except for "lots of small 
boring fixes". 

Which is as it should be, of course.

			Linus

---
Adrian Bunk (3):
      [NET]: Fix netx-eth.c compilation.
      scsi/qla2xxx/qla_os.c section fix
      OSS msnd: fix array overflows

Akinobu Mita (1):
      xip: fix get_zeroed_page with __GFP_HIGHMEM

Al Viro (4):
      xircom_cb endianness fixes
      de4x5 fixes
      endianness noise in tulip_core
      libata fixes for sparse-found problems

Alan Cox (5):
      pl2303: Fix mode switching regression
      libata-sff: PCI IRQ handling fix
      pata_pdc202xx_old: Further fixups
      ACPI : Not register gsi for PCI IDE controller in legacy mode
      libata: correct handling of TSS DVD

Alexey Starikovskiy (2):
      ACPI: EC: Enable boot EC before bus_scan
      ACPI: Make sysfs interface in ACPI power optional.

Amos Waterland (1):
      [IPV4] ipconfig: Fix regression in ip command line processing

Andrew Lutomirski (1):
      mac80211: return an error when SIWRATE doesn't match any rate

Andrew Morton (2):
      [libata] pata_bf54x: checkpatch fixes
      [libata] core checkpatch fix

Andy Wingo (1):
      macintosh: fix fabrication of caplock key events

Anton Vorontsov (1):
      fs_enet: check for phydev existence in the ethtool handlers

Atsushi Nemoto (2):
      [MIPS] Move inclusing of kernel/time/Kconfig menu to appropriate place
      [MIPS] Replace 40c7869b693b18412491fdcff64682215b739f9e kludge

Auke Kok (1):
      [NET] Intel ethernet drivers: update MAINTAINERS

Aurelien Jarno (1):
      [MIPS] Kconfig fixes for BCM47XX platform

Benjamin Herrenschmidt (1):
      [POWERPC] Workaround for iommu page alignment

Bernhard Walle (1):
      x86: fix RTC_AIE with CONFIG_HPET_EMULATE_RTC

Björn Steinbrink (1):
      [FORCEDETH]: Fix reversing the MAC address on suspend.

Bob Moore (1):
      ACPICA: fix acpi_serialize hang regression

Brian Haley (1):
      [IPV6]: IPV6_MULTICAST_IF setting is ignored on link-local connect()

Brice Goglin (1):
      [LRO] Fix lro_mgr->features checks

Carmelo Amoroso (1):
      sh: Fix argument page dcache flushing regression.

Chas Williams (1):
      [ATM]: [nicstar] delay irq setup until card is configured

Christoph Hellwig (1):
      [XFS] fix unaligned access in readdir

Christoph Lameter (1):
      quicklists: Only consider memory that can be used with GFP_KERNEL

Dan Williams (1):
      md: fix data corruption when a degraded raid5 array is reshaped

Dave Dillow (1):
      IB/srp: Release transport before removing host

Dave Young (1):
      [BLUETOOTH]: rfcomm tty BUG_ON() code fix

David Brownell (1):
      spi_bitbang: always grab lock with irqs blocked

David S. Miller (12):
      [NIU]: Missing ->last_rx update.
      [NIU]: Fix potentially stuck TCP socket send queues.
      [NIU]: Update driver version and release date.
      [NET]: Do not grab device reference when scheduling a NAPI poll.
      [NET]: Add NAPI_STATE_DISABLE.
      [NET]: Do not check netif_running() and carrier state in ->poll()
      [NETXEN]: Fix ->poll() done logic.
      [NET]: Fix drivers to handle napi_disable() disabling interrupts.
      [NET]: Stop polling when napi_disable() is pending.
      [NET]: Make ->poll() breakout consistent in Intel ethernet drivers.
      [SPARC]: Make gettimeofday() monotonic again.
      [SPARC64]: Fix build with SPARSEMEM_VMEMMAP disabled.

David Smith (1):
      TPM: fix suspend and resume failure

Dhananjay Phadke (1):
      netxen: fix byte-swapping in tx and rx

Dmitri Vorobiev (1):
      [MIPS] Malta: Fix software reset on big endian

Dmitry Baryshkov (1):
      Input: Handle EV_PWR type of input caps in input_set_capability.

Dotan Barak (1):
      IB/mlx4: Fix value of pkey_index in QP1 completions

Emil Medve (1):
      Fixed a small typo in the loopback driver

Eric Dumazet (6):
      [IPV4] ROUTE: ip_rt_dump() is unecessary slow
      [XFRM]: xfrm_algo_clone() allocates too much memory
      [SOCK]: Adds a rcu_dereference() in sk_filter
      [IPV4] ROUTE: fix rcu_dereference() uses in /proc/net/rt_cache
      [DECNET] ROUTE: fix rcu_dereference() uses in /proc/net/decnet_cache
      [TOKENRING]: rif_timer not initialized properly

Eric Sandeen (1):
      hfs: handle more on-disk corruptions without oopsing

Evgeniy Polyakov (1):
      w1: decrement slave counter only in ->release() callback

FD Cami (1):
      Update kernel parameter document for libata DMA mode setting knobs.

FUJITA Tomonori (1):
      [SCSI] qla1280: fix 32 bit segment code

Francois Romieu (1):
      r8169: fix missing loop variable increment

George Kibardin (1):
      ide: fix cable detection for SATA bridges

Gregor Jasny (1):
      V4L/DVB (6944a): Fix Regression VIDIOCGMBUF ioctl hangs on bttv driver

Gwendal Grignou (1):
      sata_sil24: prevent hba lockup when pass-through ATA commands are used

Hans Verkuil (2):
      V4L/DVB (6916): ivtv: udelay has to be changed *after* the eeprom was read, not before
      V4L/DVB (6999): ivtv: stick to udelay=10 after all

Herbert Xu (3):
      [IPV4] raw: Strengthen check on validity of iph->ihl
      [ATM]: Check IP header validity in mpc_send_packet
      [CRYPTO] padlock: Fix alignment fault in aes_crypt_copy

Ingo Molnar (2):
      block: fix blktrace timestamps
      x86: fix boot crash on HIGHMEM4G && SPARSEMEM

Ivan Kokshaysky (1):
      gameport: don't export functions that are static inline

Ivo van Doorn (2):
      rt2x00: Corectly initialize rt2500usb MAC
      rt2x00: Put 802.11 data on 4 byte boundary

Jan Altenberg (1):
      [ARM] 4691/1: add missing i2c_board_info struct for at91rm9200

Jan Engelhardt (1):
      [NETFILTER]: xt_helper: Do not bypass RCU

Jarek Poplawski (2):
      [AX25] af_ax25: Possible circular locking.
      [VLAN]: nested VLAN: fix lockdep's recursive locking warning

Jean Delvare (4):
      dmi-id: fix for __you_cannot_kmalloc_that_much failure
      snd_mixer_oss_build_input(): fix for __you_cannot_kmalloc_that_much failure with gcc-3.2
      i2c: Driver IDs are optional
      i2c-sibyte: Fix an error path

Jeff Garzik (1):
      IDE: terminate ACPI DMI list

Jens Axboe (2):
      loop: fix bad bio_alloc() nr_iovec request
      blktrace: kill the unneeded initcall

Jens Osterkamp (1):
      spidernet MAINTAINERship update

Jeremy Kerr (2):
      ps3fb: prevent use after free of fb_info
      ps3fb: fix deadlock on kexec()

Jesper Nilsson (4):
      CRIS: define __ARCH_WANT_SYS_RT_SIGSUSPEND in unistd.h for CRIS
      CRIS v10: correct do_signal to fix oops and clean up signal handling in general
      CRIS v10: kernel/time.c needs to include linux/vmstat.h to compile
      CRIS v10: driver for ds1302 needs to include cris-specific i2c.h

Joe Perches (1):
      i2c: Spelling fixes

Ken Chen (1):
      hugetlbfs: fix quota leak

Ken'ichi Ohmichi (1):
      vmcoreinfo: add the array length of "free_list" for filtering free pages

Kristoffer Ericson (2):
      Input: jornada680_kbd - fix default keymap
      Input: improve Kconfig help entries for HP Jornada devices

Krzysztof Helt (2):
      3c509: PnP resource management fix
      s3c2410fb: fix incorrect argument type in resume function

Len Brown (3):
      increase PNP_MAX_PORT to 40 from 24
      PM: ACPI and APM must not be enabled at the same time
      pnpacpi: print resource shortage message only once

Li Zefan (1):
      [CONNECTOR]: Don't touch queue dev after decrement of ref count.

Linus Torvalds (5):
      Revert "hda_intel suspend latency: shorten codec read"
      Use access mode instead of open flags to determine needed permissions
      Revert "writeback: introduce writeback_control.more_io to indicate more io"
      Fix ARM profiling/instrumentation configuration
      Linux 2.6.24-rc8

Massimo Cirillo (1):
      cache invalidation error for buffered write

Matheos Worku (1):
      [NIU]: Fix slowpath interrupt handling.

Mathieu Desnoyers (1):
      Fix Blackfin HARDWARE_PM support

Mattias Nissler (1):
      rt2x00: Allow rt61 to catch up after a missing tx report

Michael Buesch (2):
      b43: Fix rxheader channel parsing
      ssb: Fix probing of PCI cores if PCI and PCIE core is available

Michael Halcrow (1):
      eCryptfs: fix dentry handling on create error, unlink, and inode destroy

Michael Neuling (1):
      [POWERPC] Fix CPU hotplug when using the SLB shadow buffer

Mike Frysinger (1):
      x86: asm-x86/msr.h: pull in linux/types.h

Mirko Lindner (1):
      [NIU]: Support for Marvell PHY

NeilBrown (1):
      knfsd: Allow NFSv2/3 WRITE calls to succeed when krb5i etc is used.

Nicolas Ferre (1):
      MAINTAINERS: email update and add missing entry

OGAWA Hirofumi (1):
      fat: optimize fat_count_free_clusters()

Ohad Ben-Cohen (1):
      [BLUETOOTH]: Always send explicit hci_ll wake-up acks.

Olaf Hering (1):
      [POWERPC] efika: add phy-handle property for fec_mpc52xx

Oleg Nesterov (1):
      fix the "remove task_ppid_nr_ns" commit

Ondrej Zary (1):
      libata and starting/stopping ATAPI floppy devices

Patrick McHardy (2):
      [MACVLAN]: Prevent nesting macvlan devices
      [NETFILTER]: bridge: fix double POST_ROUTING invocation

Paul Mackerras (1):
      [POWERPC] Fix boot failure on POWER6

Paul Moore (1):
      [NET]: Clone the sk_buff 'iif' field in __skb_clone()

Paul Mundt (1):
      sh: Force __access_ok() to obey address space limit.

Pavel Emelyanov (1):
      [NEIGH]: Fix race between neigh_parms_release and neightbl_fill_parms

Ralf Baechle (2):
      [MIPS] Fix CONFIG_BOOT_RAW.
      [MIPS] Cacheops.h: Fix typo.

Randy Dunlap (4):
      V4L/DVB (7001): av7110: fix section mismatch
      cciss: section mismatch
      advansys: fix section mismatch warning
      uvesafb: fix section mismatch warnings

Richard Purdie (3):
      Input: spitzkbd - fix suspend key handling
      Input: pass EV_PWR events to event handlers
      [ARM] 4735/1: Unbreak pxa25x suspend/resume

Rod Whitby (1):
      pata_ixp4xx_cf: fix compilation introduced by ata_port_desc() conversion

Roland McGrath (4):
      core dump: real_parent ppid
      acct: real_parent ppid
      show_task: real_parent
      remove task_ppid_nr_ns

Russ Dill (3):
      [NET]: kaweth was forgotten in msec switchover of usb_start_wait_urb
      [NET]: mcs7830 passes msecs instead of jiffies to usb_control_msg
      [usb netdev] asix: fix regression

Russell King (2):
      [ARM] pxa: silence warnings from cpu_is_xxx() macros
      [ARM] vfp: fix fuitod/fsitod instructions

Rusty Russell (2):
      Don't blatt first element of prv in sg_chain()
      modules: de-mutex more symbol lookup paths in the module code

Sean Hefty (1):
      MAINTAINERS: Update Sean Hefty's email address

Sebastian Siewior (1):
      KEYS: fix macro

Sergei Shtylyov (2):
      [MIPS] Alchemy: Fix use of __init code bug exposed by modpost warning
      trm290: do hook dma_host_{on,off} methods (take 2)

Shaohua Li (1):
      ide: workaround suspend bug for ACPI IDE

Stephen Hemminger (4):
      [TULIP]: NAPI full quantum bug.
      ip1000: menu location change
      sky2: large memory workaround.
      sky2: remove check for PCI wakeup setting from BIOS

Steven Rostedt (1):
      Kick CPUS that might be sleeping in cpus_idle_wait

Tejun Heo (8):
      sata_qstor: use hardreset instead of softreset
      libata-pmp: 4726 hates SRST
      libata-pmp: propagate timeout to host link
      libata: don't normalize UNKNOWN to NONE after reset
      ata_piix: ignore ATA_DMA_ERR on vmware ich4
      sata_sil24: fix stupid typo
      sata_sil24: freeze on non-dev errors reported via CERR
      libata: relocate sdev->manage_start_stop configuration

Thomas Bogendoerfer (7):
      [MIPS] Fix IP32 breakage
      [MIPS] Assume R4000/R4400 newer than 3.0 don't have the mfc0 count bug
      Fix crash with FLAT_MEMORY and ARCH_PFN_OFFSET != 0
      [METH]: Fix MAC address handling.
      [MIPS] Wrong CONFIG option prevents setup of DMA zone.
      [MIPS] Cobalt: Fix ethernet interrupts for RaQ1
      [MIPS] Cobalt: Qube1 has no serial port so don't use it

Thomas Gleixner (2):
      x86: fix do_fork_idle section mismatch
      futex: Prevent stale futex owner when interrupted/timeout

Tony Lindgren (1):
      i2c-omap: Fix NULL pointer dereferencing

Tony Luck (1):
      [IA64] Fix unaligned handler for floating point instructions with base update

Trond Myklebust (1):
      NFSv4: Give the lock stateid its own sequence queue

Venki Pallipadi (1):
      ACPI: Reintroduce run time configurable max_cstate for !CPU_IDLE case

Vitaly Wool (1):
      [MIPS] pnx8xxx: move to clocksource

Vlad Yasevich (3):
      [SCTP]: Fix the name of the authentication event.
      [SCTP]: Correctly handle AUTH parameters in unexpected INIT
      [SCTP]: Add back the code that accounted for FORWARD_TSN parameter in INIT.

WANG Cong (1):
      [MIPS] Lasat: Fix built in separate object directory.

Yasuyuki Kozakai (1):
      [NETFILTER]: ip6t_eui64: Fixes calculation of Universal/Local bit

Zhao Yakui (1):
      ACPI: apply quirk_ich6_lpc_acpi to more ICH8 and ICH9

dhananjay@netxen.com (4):
      netxen: update MAINTAINERS
      netxen: update driver version
      netxen: stop second phy correctly
      netxen: optimize tx handling

maximilian attems (2):
      [IRDA]: irda_create() nuke user triggable printk
      [AX25]: Kill user triggable printks.
