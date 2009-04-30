Return-Path: <linux-kernel-owner+w=401wt.eu-S1754325AbZD3FLd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325AbZD3FLd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 01:11:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752029AbZD3FLI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 01:11:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181AbZD3FLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 01:11:03 -0400
Date: Wed, 29 Apr 2009 22:10:20 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.30-rc4
Message-ID: <alpine.LFD.2.00.0904292200580.3395@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Lots of random small changes. And one big revert - say "Goodbye" to Tuz, 
and "Hello again" to Tux.

For people who prefer the tazmanian devil, you can revert the revert with 
"git revert 3d4f16348b77efbf81b7fa186a18a0eb815b6b84" and you'll get your 
Tuz back.

Other than that? Pretty random. ARM, m68k, Microblaze, Powerpc updates. 
ACPi and i915. DVB and network drivers. PCI and USB. btrfs and ecryptfs. 
Networking and sound. All over the map, in other words. 

			Linus

---
Adrian Bunk (1):
      net: Fix LL_MAX_HEADER for CONFIG_TR_MODULE

Adrian McMenamin (1):
      maple: input: fix up maple mouse driver

Alan Cox (3):
      ax25: proc uid file misses header
      cafe_nand: Fix warning
      radio_si470x: Fix free memory corruption

Alan Stern (2):
      USB: serial: fix lifetime and locking problems
      USB: g_file_storage: fix use-after-free bug when closing files

Alexander Beregalov (3):
      powerpc: Make macintosh/mediabay driver depend on CONFIG_BLOCK
      USB: musb: fix build when !CONFIG_PM
      pktcdvd.h should include mempool.h

Almer S. Tigelaar (4):
      sony-laptop: Duplicate SNC 127 Event Fix
      sony-laptop: SNC 127 Initialization Fix
      sony-laptop: SNC input event 38 fix
      ACPI: EC: Fix ACPI EC resume non-query interrupt message

Andreas Herrmann (1):
      x86: hpet: fix periodic mode programming on AMD 81xx

Andreas Schwab (1):
      powerpc/32: Don't clobber personality flags on exec

Andy Walls (1):
      V4L/DVB (11494): cx18: Send correct input routing value to external audio multiplexers

Anton Blanchard (1):
      ipv4: Limit size of route cache hash table

Anton Vorontsov (2):
      powerpc/5200: Bring the legacy fsl_spi_platform_data hooks back
      fsl_rio: Pass the proper device to dma mapping routines

Avi Kivity (1):
      KVM: MMU: Fix off-by-one calculating large page count

Ayaz Abdulla (1):
      forcedeth: tx timeout fix

Bartlomiej Zolnierkiewicz (5):
      powerpc: Fix modular build of ide-pmac when mediabay is built in
      mediabay: fix build for CONFIG_BLOCK=n
      palm_bk3710: palm_bk3710_udmatimings[] CodingStyle fixup
      MAINTAINERS: update IDE entry
      mg_disk: fix CONFIG_LBD=y warning

Ben Hutchings (1):
      net: Fix GRO for multiple page fragments

Bjorn Helgaas (6):
      ACPI: button: whitespace changes
      ACPI: button: remove unnecessary null pointer checks
      ACPI: button: use Linux style for getting driver_data
      ACPI: button: cache hid/name/class pointers
      ACPI: button: remove button->device pointer
      ACPI: button: remove control method/fixed hardware distinctions

Bruno Prémont (1):
      ide: Stop disks on reboot for laptop which cuts power

Chien Tung (8):
      RDMA/nes: Fix compiler warning at nes_verbs.c:1955
      RDMA/nes: Modify thermo mitigation to flip SerDes1 ref clk to internal
      RDMA/nes: Correct CDR loop filter setting for port 1
      RDMA/nes: Enable repause timer for port 1
      RDMA/nes: Set trace length to 1 inch for SFP_D
      RDMA/nes: Fix fw_ver in /sys
      RDMA/nes: Fix unused variable compile warning when INFINIBAND_NES_DEBUG=n
      RDMA/nes: Update iw_nes version

Chris Ball (1):
      Btrfs: When shrinking, only update disk size on success

Chris Mason (7):
      Btrfs: fix fallocate deadlock on inode extent lock
      Btrfs: fix deadlocks and stalls on dead root removal
      Btrfs: remove #if 0 code
      Btrfs: ratelimit IO error printks
      Btrfs: remove unused btrfs_bit_radix slab
      Btrfs: fix acl caching
      Btrfs: look for acls during btrfs_read_locked_inode

Chris Wright (1):
      drm/i915: fix up error path leak in i915_cmdbuffer

Christian Borntraeger (1):
      virtio-rng: Remove false BUG for spurious callbacks

Christian Lamparter (7):
      p54: replace MAC80211_LEDS with P54_LEDS in p54.h
      p54spi: fix locking warning in p54spi_op_tx
      ar9170: add Cace Airpcap NX usb_id
      p54usb: add Telsey 802.11g USB2.0 Adapter
      ar9170usb: add ZyXEL NWD271N
      p54: deactivate broken powersave function
      ar9170usb: fix hang on resume

Christoph Hellwig (4):
      Btrfs: simplify makefile
      Btrfs: don't export symbols
      Btrfs: kill btrfs_cache_create
      quota: remove obsolete comments in fs/quota/Makefile

Christopher Pascoe (1):
      V4L/DVB (11626): cx23885: Two fixes for DViCO FusionHDTV DVB-T Dual Express

Chuck Ebbert (1):
      ext4: really print the find_group_flex fallback warning only once

Chuck Short (1):
      USB: Unusual Device support for Gold MP3 Player Energy

Coly Li (2):
      uv_time: add parameter to uv_read_rtc()
      microblaze: add parameter to microblaze_read()

Dan Carpenter (4):
      ext2: missing unlock in ext2_quota_write()
      unreachable code in drms_uA_update()
      V4L/DVB (11515): drivers/media/video/saa5249.c: fix use-after-free and leak
      V4L/DVB (11516): drivers/media/video/saa5246a.c: fix use-after-free

Dan Streetman (1):
      USB: ehci-sched.c: EHCI SITD scheduling bugfix

Dan Williams (1):
      airo: queue SIOCSIWAUTH-requested auth mode change for next commit

Daniel Mack (1):
      ALSA: snd-usb-caiaq: fix reported elapsed periods

Daniel T Chen (1):
      ALSA: Atiixp: Add SSID for mute_led quirk (unknown HP model)

David Brownell (4):
      [ARM] 5457/1: mach-imx gpio buildfix
      palm_bk3710: UDMA performance fix
      palm_bk3710: those registers/bitfields don't exist
      USB: gadget: omap_udc uses platform_driver_probe()

David Howells (5):
      MN10300: Update the ASB2303 defconfig
      ROMFS: romfs_lookup() shouldn't be doing a partial name comparison
      ROMFS: Advance destination buffer pointer when reading from a blockdev
      FRV: Wire up new syscalls
      FRV: Stop gcc from generating uninitialised variable warnings after BUG()

David Lopo (1):
      USB: Gadget: MIPS CI13xxx UDC bugfixes

David S. Miller (3):
      sparc64: Update defconfig.
      sparc32: Update defconfig.
      sparc: Fix bus type probing for ESP and LE devices.

Dean Anderson (1):
      V4L/DVB (11570): patch: s2255drv: fix race condition on set mode

Devin Heitmueller (1):
      V4L/DVB (11652): au0828: fix kernel oops regression on USB disconnect.

Diego Liziero (1):
      drivers/regulator: fix when type is different from REGULATOR_VOLTAGE or REGULATOR_CURRENT

Divy Le Ray (4):
      cxgb3: fix link fault handling
      cxgb3: fix workqueue flush issues
      cxgb3: Fix potential msi-x vector leak
      cxgb3: Fix EEH final recovery attempt

Dmitry Eremin-Solenikov (1):
      [ARM] 5458/1: pcmcia: pxa2xx-sharpsl: check if we do have Scoop config

Don Wood (1):
      RDMA/nes: Fix bugs in nes_reg_phys_mr()

Elina Pasheva (1):
      USB: serial: sierra driver bug fix for composite interface

Eric Anholt (1):
      drm/i915: Don't let an oops get triggered from irq_emit without dma init.

Eric Dumazet (2):
      netfilter: nf_log regression fix
      net: Avoid extra wakeups of threads blocked in wait_for_packet()

Eric Miao (1):
      [ARM] pxa/magician: remove un-necessary #include of pxa-regs.h and hardware.h

Erik Waling (2):
      macb: Handle Retry Limit Exceeded errors
      macb: process the RX ring regardless of interrupt status

FUJITA Tomonori (1):
      bio: fix memcpy corruption in bio_copy_user_iov()

Faisal Latif (5):
      RDMA/nes: Do not set apbvt entry for loopback
      RDMA/nes: Check for sequence number wrap-around
      RDMA/nes: Increase rexmit timeout interval
      RDMA/nes: Fix hang issues for large cluster dynamic connections
      RDMA/nes: Fix error path in nes_accept()

Frank Munzert (1):
      [S390] Use tape_generic_offline directly.

Fred Isaman (1):
      lib: find_last_bit.o needed by a module only, move it from lib to obj

Geert Uytterhoeven (4):
      scsi: a4000 - Correct driver unregistration in case of failure
      m68k,m68knommu: Wire up preadv and pwritev
      m68k: Update defconfigs for 2.6.30-rc3
      m68k: arch/m68k/kernel/sun3-head.S needs <linux/init.h>

Geoff Levand (4):
      powerpc/ps3: Fix CONFIG_PS3_FLASH=n build warning
      maintainers: Fix PS3 patterns
      powerpc/pasemi: Fix build error on UP
      powerpc/ps3: Fix build error on UP

Gerald Schaefer (1):
      [S390] appldata: avoid deadlock with appldata_mem

Gerrit Renker (1):
      mac80211: Fragmentation threshold (typo)

Grant Likely (2):
      powerpc/5200: Add FLASH nodes to lite5200 device tree
      powerpc/5200: defconfig updates

Greg Ungerer (9):
      m68knommu: fix missing .data.cacheline_aligned section
      m68knommu: remove unused kernel stats offsets
      m68knommu: fix DMA support for ColdFire
      m68knommu: update the defconfig for the ColdFire 5208evb board
      m68knommu: add a defconfig for the ColdFire M5272C3 board
      m68knommu: update the default config for the ColdFire 5249EVB.
      m68knommu: update the default config for the ColdFire 5257EVB board
      m68knommu: update the default config for the ColdFire 5307C3 board
      m68knommu: update the default config for the ColdFire 5407C3 board

Guennadi Liakhovetski (2):
      [ARM] pxa/pcm990: start external GPIOs immediately after built-in ones
      V4L/DVB (11561a): move media after i2c

H. Peter Anvin (1):
      x86, kbuild: make "make install" not depend on vmlinux

Hannes Reinecke (1):
      block: fix intermittent dm timeout based oops

Heiko Carstens (2):
      [S390] ipl: fix compile breakage
      [S390] omit frame pointers on s390 when possible

Heiko Schocher (1):
      ucc_geth.c: Fix upsmr setting in RMII mode

Helge Deller (1):
      ide-cd: fix kernel crash on hppa regression

Hendrik Brueckner (4):
      af_iucv: fix oops in iucv_sock_recvmsg() for MSG_PEEK flag
      af_iucv: Reject incoming msgs if RECV_SHUTDOWN is set
      af_iucv: Test additional sk states in iucv_sock_shutdown
      af_iucv: Fix race when queuing incoming iucv messages

Henrique de Moraes Holschuh (5):
      thinkpad-acpi: silence hotkey enable warning for module parameter
      thinkpad-acpi: fix LED blinking through timer trigger
      thinkpad-acpi: fix use of MODULE_AUTHOR
      thinkpad-acpi: simplify module autoloading
      thinkpad-acpi: bump up version to 0.23

Herbert Xu (3):
      gro: Fix use after free in tcp_gro_receive
      tun: Only free a netdev when all tun descriptors are closed
      tun: Fix sk_sleep races when attaching/detaching

Herton Ronaldo Krzesinski (1):
      rt2x00: prevent double kfree when failing to register hardware

Ilpo Järvinen (2):
      tcp: fix mid-wq adjustment helper
      powerpc: Fix of_node_put() exit path in of_irq_map_one()

Ingo Molnar (1):
      locking: clarify kernel-taint warning message

Ivo van Doorn (2):
      rt2x00: Add rt73usb USB IDs
      rt2x00: Don't free register information on suspend

Jack Morgenstein (1):
      IB/mthca: Fix timeout for INIT_HCA and a few other commands

Jack Steiner (3):
      x86/uv: fix init of memory-less nodes
      x86/uv: fix init of cpu-less nodes
      x86/uv: fix for no memory at paddr 0

Jamie Lentin (1):
      at76c50x-usb: Add device ID for OQO model 01+

Jan Engelhardt (1):
      netfilter: xt_recent: fix stack overread in compat code

Jan Kiszka (2):
      KVM: Fix overlapping check for memory slots
      KVM: Unregister cpufreq notifier on unload

Jarek Poplawski (1):
      net: sch_netem: Fix an inconsistency in ingress netem timestamps.

Jarkko Nikula (2):
      ASoC: OMAP: Update contact addresses
      USB: musb: Remove my email address from few musb related drivers

Jaroslav Kysela (2):
      [ALSA] ac97_codec: increase timeout for analog subsections
      [ALSA] intel8x0: another attempt to fix ac97_clock measure routine

Jaswinder Singh Rajput (1):
      x86: mm/numa_32.c calculate_numa_remap_pages should use __init

Jay Sternberg (1):
      iwlwifi: fix EEPROM validation mask to include OTP only devices

Jay Vosburgh (1):
      vlan: update vlan carrier state for admin up/down

Jean Delvare (4):
      ALSA: AOA: Convert onyx and tas codecs to new-style i2c drivers
      ALSA: keywest: Convert to new-style i2c driver
      net/netrom: Fix socket locking
      V4L/DVB (11568): cx18: Fix the handling of i2c bus registration error

Jeff Moyer (2):
      cfq-iosched: make seek_mean converge more quickly
      cfq-iosched: use the default seek distance when there aren't enough seek samples

Jens Axboe (4):
      block: make blk_abort_queue() ignore non-request based devices
      cfq-iosched: clear ->prio_trees[] on cfqd alloc
      cfq-iosched: fix bug with aliased request and cooperation detection
      cfq-iosched: cache prio_tree root in cfqq->p_root

Jerome Marchand (1):
      block: simplify I/O stat accounting

Jes Sorensen (1):
      KVM: ia64: fix locking order entering guest

Jesse Barnes (1):
      drm/i915: allow tiled front buffers on 965+

Jesse Brandeburg (2):
      e1000e: fix bug in restart queue logic
      e1000: fix transmit routine exit bug

Jianjun kong (1):
      8139too: fix HW initial flow

Joe Perches (3):
      MAINTAINERS - Add section NETWORKING DRIVERS
      MAINTAINERS - Update NETWORKING W: url and standardize T: git url
      iwl3945-base.c: Add missing space to debug print

Joel Becker (2):
      Btrfs: Fix a trivial warning using max() of u64 vs ULL.
      Btrfs: Fix a bunch of printk() warnings.

Joerg Albert (1):
      mwl8k: fix module re-insertion bug

Joerg Roedel (1):
      KVM: x86: release time_page on vcpu destruction

Johan Hedberg (1):
      Bluetooth: Fix removing of RFCOMM DLC timer with DEFER_SETUP

Johannes Berg (11):
      mac80211: correct wext transmit power handler
      fix iwl3945 registration regression
      ar9170: fix struct layout on arm
      mac80211: avoid crashing when no scan sdata
      cfg80211: copy hold when replacing BSS
      cfg80211: do not replace BSS structs
      mac80211: validate TIM IE length
      mac80211: fix basic rate bitmap calculation
      atmel: fix netdev ops conversion
      mac80211: fix alignment calculation bug
      USB: pass mem_flags to dma_alloc_coherent

Jonathan Corbet (1):
      Delete slow-work timers properly

Josef Bacik (1):
      Btrfs: try to keep a healthy ratio of metadata vs data block groups

Josh Boyer (1):
      maintainers: Fix PowerPC 4xx git tree

Jouni Malinen (1):
      nl80211: Make nl80211_send_mlme_event() atomic

Kailang Yang (2):
      ALSA: hda - Fix alc662_init_verbs
      ALSA: hda - Add quirks for Realtek codecs

Kalle Valo (1):
      mac80211: fix beacon loss detection after scan

Karsten Keil (1):
      Add reference to CAPI 2.0 standard

Karsten Wiese (2):
      ALSA: us122l: Fix signedness in comparisions
      ALSA: us122l: add snd_us122l_free()

Keith Packard (1):
      drm/i915: fix transition to I915_TILING_NONE

Ken Kawasaki (1):
      pcnet_cs: add cis(firmware) of the Allied Telesis LA-PCM

Kumar Gala (6):
      powerpc/85xx: Updated generic mpc85xx_defconfig
      powerpc/85xx: Enabled a bunch of FSL specific drivers/options
      powerpc/85xx: Added SMP defconfig
      powerpc/85xx: Remove defconfigs that mpc85xx_{smp_}defconfig cover
      Revert "powerpc: Add support for early tlbilx opcode"
      powerpc: ppc32 needs elf_read_implies_exec()

Laszlo Attila Toth (1):
      netfilter: Kconfig: TProxy doesn't depend on NF_CONNTRACK

Len Brown (8):
      ACPI: Disable _GTS and _BFS support by default
      ACPI: add /sys/firmware/acpi/interrupts/sci_not counter
      ACPI: idle: mark_tsc_unstable() at init-time, not run-time
      ACPI: delete obsolete "bus master activity" proc field
      ACPI/hpet: prevent boot hang when hpet=force used on ICH-4M
      ACPI: prevent processor.max_cstate=0 boot crash
      Revert "ACPICA: delete check for AML access to port 0x81-83"
      x86, hpet: Stop soliciting hpet=force users on ICH4M

Lin Ming (1):
      I/O port protection: update for windows compatibility.

Linus Torvalds (2):
      Revert "linux.conf.au 2009: Tuz"
      Linux 2.6.30-rc4

Luis R. Rodriguez (1):
      cfg80211: fix NULL pointer deference in reg_device_remove()

Marc Dionne (1):
      CacheFiles: Fix the documentation to use the correct credential pointer names

Marcel Holtmann (4):
      Bluetooth: Fallback from eSCO to SCO on unspecified error
      Bluetooth: Add workaround for wrong HCI event in eSCO setup
      Bluetooth: Add different pairing timeout for Legacy Pairing
      Bluetooth: Fix connection establishment with low security requirement

Marcelo Tosatti (1):
      KVM: MMU: disable global page optimization

Marcin Slusarz (1):
      net: fix "compatibility" typos

Marek Vasut (1):
      [ARM] pxa/palm27x: General fix for Palm27x aSoC driver

Mark A. Greer (1):
      USB: musb: Prevent multiple includes of musb.h

Mark Brown (5):
      [ARM] pxa: merge AC97 platform data structures
      ASoC: Fix offset of freqmode in WM8580 PLL configuration
      ASoC: Fix WM8580 volume update handling for large register changes
      ASoC: s3c-i2s-v2 needs to declare a license for modular builds
      regulator: Fix default constraints for fixed voltage regulators

Martin Fuzzey (1):
      USB: pwc : do not pass stack allocated buffers to USB core.

Martin Schwidefsky (2):
      [S390] /proc/stat idle field for idle cpus
      [S390] update default configuration.

Martyn Welch (1):
      powerpc/86xx: Add device_type entry to soc for ppc9a

Masakazu Mokuno (1):
      net/ps3: Fix wireless AP connect error handling

Matt Carlson (1):
      tg3: Fix SEEPROM accesses

Matt Kraai (1):
      RDMA/nes: Remove root_256()'s unused pbl_count_256 parameter

Matthew Garrett (5):
      drm/i915: Register ACPI video even when not modesetting
      drm/i915: Unregister ACPI video driver when exiting
      drm/i915: Enable ASLE if present
      thermal: Fix polling frequency for systems without passive cooling
      ACPI, i915: Register ACPI video even when not modesetting

Matthew Wilcox (1):
      x86/PCI: Move set_pci_bus_resources_arch_default into arch/x86

Matthias Kaehlcke (1):
      USB: ci13xxx_udc: fix build error

Mattia Dongili (2):
      sony-laptop: fix bogus error message display on resume
      sony-laptop: always try to unblock rfkill on load

Mauro Carvalho Chehab (1):
      V4L/DVB (11494a): cx231xx Kconfig fixes

Michael Buesch (4):
      b43: Poison RX buffers
      b43: Refresh RX poison on buffer recycling
      b43: Do radio lock assertion in software
      mac80211: quiet beacon loss messages

Michael Ellerman (2):
      powerpc: Fix crash on CPU hotplug
      powerpc/cell: Select PCI for IBM_CELL_BLADE AND CELLEB

Michael K. Johnson (1):
      x86: more than 8 32-bit CPUs requires X86_BIGSMP

Michal Simek (16):
      microblaze: Remove unneded per cpu SYSCALL_SAVE variable
      microblaze: Remove while(1) loop from show_regs function
      microblaze: Remove uncache shadow condition
      microblaze: Rename kernel_mode to pt_mode in pt_regs
      microblaze: Move task_pt_regs up
      microblaze: Remove sparse error in traps.c
      microblaze: Add missing declaration for die and _exception func
      microblaze: Add missing preadv and pwritev syscalls
      microblaze: Move start_thread to process.c
      microblaze: Remove redundant variable
      microblaze: Correspond CONFIG...PCMP in Makefile/Kconfig
      microblaze: Fix USR1/2 pvr printing message
      microblaze: Do not use PVR configuration for broken MB version
      microblaze: Do not check use_dcache
      microblaze: Add STATE_SAVE_ARG_SPACE for noMMU kernel too
      microblaze: Use CFLAGS_KERNEL instead of CFLAGS

Mikael Pettersson (1):
      [ARM] 5456/1: add sys_preadv and sys_pwritev

Mike Rapoport (2):
      net: Fix typo in net_device_ops description.
      regulator/virtual: fix strings compare predicates

Miroslaw Walukiewicz (1):
      RDMA/nes: Fix resource issues in nes_create_cq() and nes_destroy_cq()

Nicolas Dichtel (1):
      xfrm: wrong hash value for temporary SA

Nicolas Morey-Chaisemartin (1):
      mlx4_core: Fix memory leak in mlx4_enable_msi_x()

Nicolas Pitre (1):
      [ARM] 5460/1: Orion: reduce namespace pollution

Niels de Vos (1):
      serial: remove contact data

Oleg Nesterov (3):
      do_execve() must not clear fs->in_exec if it was set by another thread
      check_unsafe_exec: s/lock_task_sighand/rcu_read_lock/
      ptrace: ptrace_attach: fix the usage of ->cred_exec_mutex

Oliver Hartkopp (1):
      can: Network Drop Monitor: Make use of consume_skb() in af_can.c

Oliver Neukum (3):
      pegasus: Handle disconnect error code correctly.
      USB: removal of tty->low_latency hack dating back to the old serial code
      USB: correct error handling in cdc-wdm

PJ Waskiewicz (2):
      ixgbe: Fix DCB traffic class mapping for 82599
      ixgbe: Fix the DCB PFC thresholds for 82599

Pablo Neira Ayuso (4):
      netfilter: ctnetlink: report error if event message allocation fails
      netfilter: nfnetlink: return ENOMEM if we fail to create netlink socket
      netfilter: ctnetlink: fix gcc warning during compilation
      netfilter: nf_ct_dccp: add missing role attributes for DCCP

Pallipadi, Venkatesh (2):
      x86, irq: Remove IRQ_DISABLED check in process context IRQ move
      x86, acpi_cpufreq: Fix the NULL pointer dereference in get_measured_perf

Patrick McHardy (4):
      netfilter: nf_conntrack: fix crash when unloading helpers
      netfilter: nf_nat: add support for persistent mappings
      vlan/macvlan: fix NULL pointer dereferences in ethtool handlers
      netfilter: nf_ct_dccp/udplite: fix protocol registration error

Paul Moore (1):
      netlabel: Always remove the correct address selector

Paul Mundt (1):
      sh: Fix up unsigned syscall_nr in SH-5 pt_regs.

Paul Walmsley (1):
      regulator core: fix double-free in regulator_register() error path

Pavel Roskin (2):
      ath9k: fix access to a freed skb in ath_rx_tasklet()
      orinoco: correct timeout logic in __orinoco_hw_set_tkip_key()

Peter Zijlstra (1):
      lockdep: more robust lockdep_map init sequence

Philip Rakity (1):
      libertas: don't leak skb on receive error

Philipp Zabel (2):
      ASoC: pxa-ssp: Don't use SSCR0_SerClkDiv and SSCR0_SCR
      regulator/bq24022: fix bug in is_enabled function

Rafael J. Wysocki (1):
      PM/Hibernate: Fix waiting for image device to appear on resume

Rami Rosen (1):
      mwl8: fix build warning.

Randy Dunlap (3):
      docbooks: add/fix PCI kernel-doc
      ecryptfs: fix printk format warning
      regulator: fix header file missing kernel-doc

Reinette Chatre (4):
      iwl3945: use cancel_delayed_work_sync to cancel rfkill_poll
      mac80211: do not print WARN if config interface
      iwlwifi: add debugging for TX path
      iwlwifi: DMA fixes

Richard Retanubun (1):
      m68knommu: Fixed GPIO pin initialization for CONFIG_M5271 FEC.

Robert Jarzmik (2):
      [ARM] pxa/mioa701: use GPIO95 as AC97 reset line
      USB: otg: Fix bug on remove path without transceiver

Robert P. J. Day (1):
      MAC80211: Remove unused MAC80211_VERBOSE_SPECT_MGMT_DEBUG.

Roel Kluin (1):
      microblaze: iowrite upon timeout

Roger Quadros (1):
      Bluetooth: Ensure that HCI sysfs add/del is preempt safe

Roland Dreier (1):
      mlx4_en: Fix cleanup if workqueue create in mlx4_en_add() fails

Russell King - ARM Linux (1):
      ASoC: Fix warning in wm9705

Rusty Russell (2):
      x86: fix boot crash in NMI watchdog with CONFIG_CPUMASK_OFFSTACK=y and flat APIC
      x86: avoid theoretical spurious NMI backtraces with CONFIG_CPUMASK_OFFSTACK=y

Sage Weil (1):
      umem: fix request_queue lock warning

Sascha Hauer (1):
      V4L/DVB (11612): mx3_camera: Fix compilation with CONFIG_PM

Stefan Roese (2):
      powerpc/of-device-tree: Factor MTD physmap bindings out of booting-without-of
      powerpc/device-tree: Document MTD nodes with multiple "reg" tuples

Stephen Hemminger (2):
      veth: prevent oops caused by netdev destructor
      netfilter: revised locking for x_tables

Stephen Rothwell (1):
      powerpc: fix for long standing bug noticed by gcc 4.4.0

Steve Wise (2):
      RDMA/cxgb3: Adjust ORD/IRD (if needed) for peer2peer connections
      RDMA/cxgb3: Don't zero QP attrs when moving to IDLE

Steven Rostedt (1):
      lockdep, x86: account for irqs enabled in paranoid_exit

Steven Whitehouse (3):
      bitops: Add __ffs64 bitop
      GFS2: Fix bug in block allocation
      GFS2: Ensure that the inode goal block settings are updated

Subrata Modak (1):
      ALSA: Fix Trivial Warnining in sound/pci/cmipci.c

Suresh Siddha (1):
      x86-64: fix FPU corruption with signals and preemption

Takashi Iwai (3):
      ALSA: hda - Add quirk for Packard Bell RS65
      ASoC: remove non-existing referece to CONFIG_SND_SOC_CODEC_WM8991
      ALSA: hda - Fix init verbs of AD1884A mobile model

Tejun Heo (8):
      scatterlist: make sure sg_miter_next() doesn't return 0 sized mappings
      block: fix SG_IO vector request data length handling
      block: fix queue bounce limit setting
      bio: fix bio_kmalloc()
      bio: use bio_kmalloc() in copy/map functions
      block: include empty disks in /proc/diskstats
      mg_disk: fix locking
      hd: fix locking

Thadeu Lima de Souza Cascardo (1):
      e100: do not go D3 in shutdown unless system is powering off

Theodore Ts'o (7):
      jbd2: use SWRITE_SYNC_PLUG when writing synchronous revoke records
      jbd: use SWRITE_SYNC_PLUG when writing synchronous revoke records
      ext4: Make the extent validity check more paranoid
      ext4: Fix potential inode allocation soft lockup in Orlov allocator
      ext4: Fix softlockup caused by illegal i_file_acl value in on-disk inode
      ext4: Ignore i_file_acl_high unless EXT4_FEATURE_INCOMPAT_64BIT is present
      ext4: Do not try to validate extents on special files

Thomas Renninger (4):
      acpi-cpufreq: Cleanup: Use printk_once
      acpi-cpufreq: style-only: add parens to math expression
      acpi-cpufreq: Do not let get_measured perf depend on internal variable
      PCI quirk: disable MSI on VIA VT3364 chipsets

Tilman Schmidt (2):
      update Documentation/isdn/00-INDEX
      Documentation/isdn/INTERFACE.CAPI

Tim Abbott (20):
      Add new HEAD_TEXT_SECTION macro.
      xtensa: convert to use __HEAD and HEAD_TEXT macros.
      alpha: convert to use __HEAD and HEAD_TEXT macros.
      frv: convert frv to use __HEAD and HEAD_TEXT macros.
      m32r: convert to use __HEAD and HEAD_TEXT macros.
      m68k: convert to use __HEAD and HEAD_TEXT macros.
      mn10300: convert to use __HEAD and HEAD_TEXT macros.
      powerpc: convert to use __HEAD and HEAD_TEXT macros.
      s390: convert to use __HEAD and HEAD_TEXT macros.
      sh: convert to use __HEAD and HEAD_TEXT macros.
      sparc: convert to use __HEAD and HEAD_TEXT macros.
      FRV: Remove unused header asm/init.h.
      FRV: Use __INIT macro instead of .text.init.
      arm: Use __INIT macro instead of .text.init.
      powerpc: Use TEXT_TEXT macro in linker script.
      powerpc: Use __REF macro instead of old .text.init.refok.
      sh: Use __INIT macro instead of .text.init.
      sparc: cleanup references to deprecated .text.init* sections.
      Remove unused support code for refok sections.
      powerpc: Revert switch to TEXT_TEXT in linker script

Timur Tabi (1):
      powerpc: don't disable SATA interrupts on Freescale MPC8610 HPCD

Tony Breeds (1):
      ixgbe: Be explict with what we are !'ing in ixgbe_sfp_config_module_task()

Tony Cook (2):
      USB: mos7840: add new device id
      USB: fix mos7840 problem with minor numbers

Tyler Hicks (8):
      eCryptfs: Copy lower inode attrs before dentry instantiation
      eCryptfs: NULL pointer dereference in ecryptfs_send_miscdev()
      eCryptfs: Print FNEK sig properly in /proc/mounts
      eCryptfs: Fix data corruption when using ecryptfs_passthrough
      eCryptfs: Remove ecryptfs_unlink_sigs warnings
      eCryptfs: Lock lower directory inode mutex during lookup
      eCryptfs: Larger buffer for encrypted symlink targets
      eCryptfs: Fix min function comparison warning

Ursula Braun (1):
      af_iucv: consider state IUCV_CLOSING when closing a socket

Valentine Barshak (1):
      powerpc/44x: Correct memory size calculation for denali-based boards

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in getting rx status for frames pending in reorder buffer

Waskiewicz Jr, Peter P (1):
      ixgbe: Fix WoL functionality for 82599 KX4 devices

Weidong Han (1):
      docs, x86: add nox2apic back to kernel-parameters.txt

Wu Fengguang (1):
      drm/i915: fix unpaired i915 device mutex on entervt failure.

Yevgeny Petrilin (7):
      mlx4_en: Fix error handling while activating RX rings
      mlx4_en: Fix a race at restart task
      mlx4_en: Assign dummy event handler for TX queue
      mlx4_en: use NETIF_F_IP_CSUM | NETIF_F_IPV6_CSUM for tx csum at initialization
      mlx4_en: Move to SW counters for total bytes and packets
      mlx4_en: Fix cleanup flow on cq activation
      mlx4_en: Handle page allocation failure during receive

Yinghai Lu (6):
      x86/irq: mark NUMA_MIGRATE_IRQ_DESC broken
      x86/PCI: don't call e820_all_mapped with -1 in the mmconfig case
      x86/PCI: set_pci_bus_resources_arch_default cleanups
      PCI: cleanup debug output resources
      x86/PCI: don't bother with root quirks if _CRS is used
      x86: check boundary in setup_node_bootmem()

Yoshihiro Shimoda (1):
      sh: sh7785lcr: fix defconfig for 29-bit mode

Yossi Etigin (1):
      IPoIB: Disable NAPI while CQ is being drained

Yu Zhao (1):
      PCI: only save/restore existent registers in the PCIe capability

Zhang Rui (3):
      ACPI: Revert conflicting workaround for BIOS w/ mangled PRT entries
      ACPI video: handle indexed _BQC correctly
      ACPI video: fix an error when the brightness levels on AC and on Battery are same

Zhenyu Wang (1):
      drm/i915: add support for G41 chipset

hummerbliss@gmail.com (1):
      netfilter: bridge: allow fragmentation of VLAN packets traversing a bridge
