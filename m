Return-Path: <linux-kernel-owner+w=401wt.eu-S1757805AbZEWWHS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757805AbZEWWHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 18:07:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755322AbZEWWHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 18:07:07 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49227 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754598AbZEWWHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 18:07:05 -0400
Date: Sat, 23 May 2009 15:07:03 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.30-rc7
Message-ID: <alpine.LFD.2.01.0905231453180.3555@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ok, so 90% of the patch is the addition of one new driver, at around 9000 
lines for the the Cisco PCI-Express FCoE HBA SCSI driver.

If you ignore that (and you should - unless you happen to have such 
hardware and have been pining for the driver to be merged for a long 
time), the rest is really mostly a collection of small fixes. Several 
regressions fixed, lots of small cleanup.

Nothing huge stands out. The diffstat shows the new driver clearly, and 
some of the cifs fixes aren't totally trivial (and the reiserfs xattr 
changes show up), but most of it really is one-liners.

So go wild. I suspect I'll do an -rc8, but we're definitely getting closer 
to release-time - it would be good to get as much testing as possible, and 
it should generally be pretty safe to try this all out.

Thanks,

		Linus

---
Abhijeet Joglekar (1):
      [SCSI] fnic: Add new Cisco PCI-Express FCoE HBA

Adam Radford (2):
      [SCSI] 3w-9xxx: scsi_dma_unmap fix
      [SCSI] 3w-xxxx: scsi_dma_unmap fix

Adam Williamson (1):
      ALSA: hda - fix audio on HP TX25xx series notebooks

Ajit Khaparde (1):
      be2net: add two new pci device ids to pci device table

Alan Cox (1):
      piix: The Sony TZ90 needs the cable type hardcoding

Alan Jenkins (2):
      eeepc-laptop: fix wlan rfkill state change during init
      eeepc-laptop: Work around rfkill firmware bug

Alessandro Rubini (1):
      [ARM] 5519/1: amba probe: pass "struct amba_id *" instead of void *

Andreas Mohr (1):
      ALSA: Kill truncate warning by shortening Sigmatel-specific AC97 control name

Andrew Randrianasulu (1):
      MIPS: IP32: Fix hang on shutdown in power button interrupt handler.

Andrew Vasquez (1):
      [SCSI] fc-transport: Close state transition-window during rport deletion.

Bartlomiej Zolnierkiewicz (5):
      ide: fix 40-wire cable detection for TSST SH-S202* ATAPI devices (v2)
      ide: fix OOPS during ide-cd error recovery
      ide: fix printk() levels in ide_dump_ata[pi]_error()
      ide: improve failed opcode reporting
      ide: report timeouts in ide_busy_sleep()

Ben Dooks (5):
      [ARM] nwfpe: Add decleration for ExtendedCPDO
      [ARM] nwfpe: fix 'floatx80_is_nan' sparse warning
      [ARM] S3C24XX: Fix unused code warning in arch/arm/plat-s3c24xx/dma.c
      [ARM] S3C2410: mach-bast.c registering i2c data too early
      [ARM] S3C: Do not set clk->owner field if unset

Benjamin Herrenschmidt (2):
      powerpc: Explicit alignment for .data.cacheline_aligned
      drm: Round size of SHM maps to PAGE_SIZE

Bjorn Helgaas (1):
      PM: check sysdev_suspend(PMSG_FREEZE) return value

Breno Leitao (1):
      icom: fix rmmod crash

Chris Friesen (1):
      ipconfig: handle case of delayed DHCP server

Christian Hohnstaedt (1):
      crypto: ixp4xx - check firmware for crypto support

Corentin Chary (2):
      asus-laptop: fix input keycode
      eeepc-laptop: unregister_rfkill_notifier on failure

Corey Minyard (1):
      ipmi: fix ipmi_si modprobe hang

Darren Salt (1):
      eeepc-laptop: report brightness control events via the input layer

David Rientjes (2):
      slub: enforce MAX_ORDER
      slub: add Documentation/ABI/testing/sysfs-kernel-slab

David Woodhouse (1):
      Fix oops on close of hot-unplugged FTDI serial converter

Edward Goggin (1):
      [SCSI] initialize max_target_blocked in scsi_alloc_target

Eric Dumazet (2):
      sch_teql: should not dereference skb after ndo_start_xmit()
      pkt_sched: gen_estimator: use 64 bit intermediate counters for bps

Eric Moore (1):
      [SCSI] mpt2sas: fix driver version inconsistency

Eric Paris (1):
      TPM: get_event_name stack corruption

Frank Filz (1):
      nfs: Fix NFS v4 client handling of MAY_EXEC in nfs_permission.

Frans Pop (1):
      ipv4: make default for INET_LRO consistent with help text

Gabriel Paubert (1):
      mv643xx_eth: fix PPC DMA breakage

Geoff Levand (1):
      powerpc/ps3: Update ps3_defconfig

GeunSik Lim (1):
      tracing: Append prompt in /debug/tracing/README file

Greg Ungerer (1):
      MIPS: 64-bit: Fix system lockup.

Grigori Goronzy (1):
      eeepc-laptop: support for super hybrid engine (SHE)

Harald Welte (1):
      via82cxxx: Add VIA VX855 PCI Device ID

Hartley Sweeten (1):
      [ARM] 5509/1: ep93xx: clkdev enable UARTS

Herbert Xu (2):
      crypto: api - Fix algorithm module auto-loading
      crypto: padlock - Revert aes-all alias to aes

Hugh Dickins (1):
      hugh: update email address

Ian Campbell (2):
      xen/blkfront: allow xenbus state transition to Closing->Closed  when not Connected
      xen/blkfront: fix warning when deleting gendisk on unplug/shutdown

Ilpo Järvinen (1):
      tcp: fix MSG_PEEK race check

Inaky Perez-Gonzalez (1):
      wimax/i2400m: fix device crash: fix optimization in _roq_queue_update_ws

Ingo Molnar (1):
      lockdep: increase MAX_LOCKDEP_ENTRIES and MAX_LOCKDEP_CHAINS

Jan Beulich (1):
      x86: fix percpu_{to,from}_op()

Jarkko Nikula (2):
      ARM: OMAP2: Fix tusb6010 init error and compilation warning
      ARM: OMAP2: Fix SPI driver failure on 2420 when running multi-omap config

Jeff Layton (1):
      cifs: fix pointer initialization and checks in cifs_follow_symlink (try #4)

Jeff Mahoney (3):
      reiserfs: clean up ifdefs
      reiserfs: deal with NULL xattr root w/ xattrs disabled
      reiserfs: fixup perms when xattrs are disabled

Jeremy Fitzhardinge (1):
      x86: Fix performance regression caused by paravirt_ops on native kernels

Kalle Jokiniemi (1):
      ARM: OMAP3: Fix HW SAVEANDRESTORE shift define

Len Brown (8):
      ACPICA: use acpi.* modparam namespace
      ACPI: video: DMI workaround another broken Acer BIOS enabling display brightness
      ACPI: power: update error message
      ACPI: suspend: don't let device _PS3 failure prevent suspend
      ACPI: suspend: restore BM_RLD on resume
      ACPI, i915: build fix
      ACPI: idle: fix init-time TSC check regression
      ACPI: Idle C-states disabled by max_cstate should not disable the TSC

Lin Ming (1):
      ACPI: resume: re-enable SCI-enable workaround

Linus Torvalds (3):
      Fix caller information for warn_slowpath_null
      Avoid ICE in get_random_int() with gcc-3.4.5
      Linux 2.6.30-rc7

Magnus Damm (2):
      sh: ap325 camera without i2c driver fix
      video: stop sh_mobile_lcdcfb only if started

Marek Szyprowski (2):
      [ARM] S3C64XX: GPIO include cleanup
      [ARM] S3C64XX: fix GPIO debug

Mark Brown (1):
      mfd: Keep a cache of WM8350 volatile values

Masami Hiramatsu (1):
      x86, 32-bit: fix kernel_trap_sp()

Mel Gorman (2):
      powerpc: Do not assert pte_locked for hugepage PTE entries
      [ARM] Double check memmap is actually valid with a memmap has unexpected holes V2

Michael Ellerman (2):
      powerpc/ftrace: Use pr_devel() in ftrace.c
      powerpc/maple: Add a quirk to disable MSI for IPR on Bimini

Michal Simek (2):
      microblaze: Update Microblaze defconfig
      microblaze: Fix kind-of-intr checking against number of interrupts

Michel Dänzer (1):
      drm: Copy back ioctl data to userspace regardless of return code.

Mike Frysinger (1):
      regulator: da903x: add missing __devexit_p()

Nelson Castillo (1):
      mfd: pcf50633: fix unsafe disable_irq()

Nick Piggin (2):
      mm: SLUB fix reclaim_state
      mm: SLOB fix reclaim_state

Nico Schottelius (1):
      Fix scripts/setlocalversion with tagged git commit

Paul Walmsley (1):
      ARM: OMAP: GPIO de-bounce clocks don't affect module idle state

Pavel Emelyanov (1):
      netpoll: don't dereference NULL dev from np

Pavel Roskin (1):
      [ARM] mach-l7200: fix spelling of SYS_CLOCK_OFF

Peter Korsgaard (1):
      mtd_dataflash: unbreak erase support

Rabin Vincent (2):
      [ARM] 5518/1: versatile: don't put clock lookups in __initdata
      [ARM] 5517/1: integrator: don't put clock lookups in __initdata

Rafael J. Wysocki (1):
      PCI PM: Fix initialization and kexec breakage for some devices

Ralf Baechle (4):
      NET: Meth: Fix unsafe mix of irq and non-irq spinlocks.
      MIPS: IP22: Fix hang in power button interrupt handler
      MIPS: IP32: Fix build error due to uninitialized variable.
      MIPS: IP32: Remove unnecessary if not even harmful volatile keywords.

Randy Dunlap (1):
      xen: use header for EXPORT_SYMBOL_GPL

Ricardo Martins (1):
      [ARM] 5513/1: Eurotech VIPER SBC: fix compilation error

Roel Kluin (2):
      asm-generic: fix local_add_unless macro
      cdrom: beyond ARRAY_SIZE of viocd_diskinfo

Ron (1):
      sched: Fix fallback sched_clock()'s offset when using jiffies

Russell King (3):
      [ARM] smp: fix cpumask usage in ARM SMP code
      [ARM] realview: remove useless smp_cross_call_done()
      [ARM] realview: fix broadcast tick support

Ryusuke Konishi (1):
      nilfs2: fix memory leak in nilfs_ioctl_clean_segments

Sam Ravnborg (1):
      x86: Fix false positive section mismatch warnings in the apic code

Sergei Shtylyov (1):
      icside: register second channel of version 6 PCB

Steffen Klassert (1):
      crypto: eseqiv - Fix IV generation for sync algorithms

Stephen Hemminger (3):
      bridge: relay bridge multicast pkgs if !STP
      bridge: fix initial packet flood if !STP
      bonding: fix link down handling in 802.3ad mode

Steve French (2):
      [CIFS] fix posix open regression
      [CIFS] Avoid open on possible directories since Samba now rejects them

Steven Rostedt (2):
      x86/function-graph: fix constraint for recording old return value
      powerpc/ftrace: Fix constraint to be early clobber

Takashi Iwai (1):
      ALSA: pcsp - fix printk format warning again

Tejun Heo (1):
      ide-tape: remove back-to-back REQUEST_SENSE detection

Thomas Chenault (1):
      net: fix skb_seq_read returning wrong offset/length for page frag data

Thomas Gleixner (1):
      futex: setup writeable mapping for futex ops which modify user space data

Tomi Valkeinen (1):
      ARM: OMAP: Fix printing of reserved memory for frambuffer

Tony Lindgren (2):
      ARM: OMAP2/3: Add name for musb clocks
      ARM: OMAP2/3: Change omapfb to use clkdev for dispc and rfbi, v2

Toshiyuki Okajima (1):
      page-writeback: fix the calculation of the oldest_jif in wb_kupdate()

Vikram Pandita (1):
      ARM: OMAP3: Fix number of GPIO lines for 34xx

Vladimir Zajac (1):
      thermal: fix off-by-1 error in trip point trigger condition

Wang Tinggong (1):
      Doc: fixed descriptions on /proc/sys/net/core/* and /proc/sys/net/unix/*

Wu Zhangjin (1):
      MIPS: Fix sparse warning in incompatiable argument type of clear_user.

Yevgeny Petrilin (1):
      mlx4_en: Fix not deleted napi structures

Yinghai Lu (2):
      x86: mtrr: Fix high_width computation when phys-addr is >= 44bit
      [SCSI] ses: fix problems caused by empty SES provided name

Zhang Rui (3):
      ACPI video: dmi check for broken _BQC on Acer Aspire 5720
      ACPI processor: introduce module parameter processor.ignore_tpc
      ACPI processor: reset the throttling state once it's invalid

peter fuerst (1):
      MIPS: IP28: Change to build with -mr10k-cache-barrier=store

roel kluin (1):
      Neterion: *FIFO1_DMA_ERR set twice, should 2nd be *FIFO2_DMA_ERR?
