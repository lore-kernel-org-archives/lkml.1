Return-Path: <linux-kernel-owner+w=401wt.eu-S1759377AbXFQDeR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759377AbXFQDeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 23:34:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758629AbXFQDeF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 23:34:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:32909 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755056AbXFQDeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 23:34:01 -0400
Date: Sat, 16 Jun 2007 20:33:52 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: And now for something _totally_ different: Linux v2.6.22-rc5
Message-ID: <alpine.LFD.0.98.0706162013420.14121@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463790079-1636944895-1182051232=:14121"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463790079-1636944895-1182051232=:14121
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: 8BIT


In a stunning turn of events, I've actually been able to make another -rc 
release despite all the discussion (*cough*flaming*cough*) about other 
issues, and we now have a brand-spanking-new Linux 2.6.22-rc5 release 
out there!

As usual, you get *five* kernels for the price of one! You can get the 
tar-ball, the patches, or the git tree. And the tar-balls and patches come 
not just in the old gzipped format, you can have them bzip2'd too! So you 
have an incredible selection of kernels to choose from, fresh from the 
oven!

By a happy turn of events, we have even succeeded in solving a number of 
annoying regressions! Special thanks go to Tejun Heo, who worked night and 
day, and finally reproduced and fixed the odd suspend/resume problems in 
the ATA layer that got introduced by some previous cleanups.

But that's not all! We have other regressions fixed, and we have a bonus 
round of random architecture fixes, and an extra-bonus round of Blackfin 
updates.

[ Ok, so I can't really call the Blackfin fixes for regressions, but let's 
  face it, it's not like anybody is actually going to care. So doing the 
  Blackfin merge at this point may not be strictly proper -rc policy, but 
  hey, it's a new architecture. It certainly won't cause any more 
  regressions, if only because there's not a whole lot to regress there.

  The same largely goes for the libertas wireless driver ;^/ ]

On a more serious note, I have to admit that I'm a bit unhappy with the 
pure *volume* of changes this late in the game. I was really wanting to 
stop some of the merges, but while not all of it really fixed regressions, 
there really are a lot of bugfixes in there.

Yeah, the *bulk* of the patch is things like PA-RISC, Blackfin and the
libertas driver, but I really *really* wish people would also more 
obviously be working on the regression list.

On that note - I doubly appreciate the people who *did* work on 
regressions. Thanks, guys,

		Linus
---
Adam Litke (1):
      hugetlb: fix get_policy for stacked shared memory files

Adrian Bunk (1):
      [RXRPC] net/rxrpc/ar-connection.c: fix NULL dereference

Akinobu Mita (2):
      [CIFS] fix mempool destroy done in wrong order in cifs error path
      [NETFILTER]: nf_conntrack_amanda: fix textsearch_prepare() error check

Alan Cox (3):
      MAINTAINERS: corrections
      libata-core/sff: Fix multiple assumptions about DMA
      libata: Correct abuse of language

Alan Stern (2):
      USB: Fix up bogus bInterval values in endpoint descriptors
      OHCI: Fix machine check in ohci_hub_status_data

Albert Lee (6):
      libata: print device model and firmware revision for ATAPI devices
      libata passthru: update protocol numbers
      libata passthru: support PIO multi commands
      libata passthru: map UDMA protocols
      libata passthru: always enforce correct DEV bit
      libata passthru: update cached device paramters

Alexandr Andreev (1):
      parisc: sync compat getdents

Alexey Dobriyan (3):
      parisc: make command_line[] static
      parisc: convert /proc/gsc/pcxl_dma to seq_file
      fuse: ->fs_flags fixlet

Alexey Kuznetsov (1):
      pi-futex: fix exit races and locking problems

Andrea Righi (1):
      [AVR32] ratelimit segfault reporting rate

Andrew Morton (3):
      V4L/DVB (5699): Cinergyt2: fix file release handler
      document Acked-by:
      x86_64: oops_begin() fix

Andrew Victor (3):
      [ARM] 4418/1: AT91: Number of programmable clocks differs
      [ARM] 4419/1: AT91: SAM9 USB clocks check for suspending
      [ARM] 4421/1: AT91: Value of _KEY fields.

Andy Whitcroft (4):
      checkpatch.pl: should be executable
      update checkpatch.pl to version 0.03
      update feature-removal-schedule.txt to include deprecated functions
      update checkpatch.pl to version 0.04

Antonino Daplas (3):
      [VIDEO] ffb: The pseudo_palette is only 16 elements long
      [VIDEO] sunxvr2500fb: Fix pseudo_palette array size
      [VIDEO] sunxvr500fb: Fix pseudo_palette array size

Arnd Bergmann (2):
      [POWERPC] spufs: Refuse to load the module when not running on cell
      [POWERPC] Fix pci_setup_phb_io_dynamic for pci_iomap

Atsushi Nemoto (5):
      [MIPS] Drop __ARCH_WANT_SYS_FADVISE64
      [MIPS] Fix some system calls with long long arguments
      [MIPS] Fix warning by moving do_default_vi into CONFIG_CPU_MIPSR2_SRS
      [MIPS] Wire up utimensat, signalfd, timerfd, eventfd
      [MIPS] Fix IP27 build

Aubrey Li (2):
      Blackfin arch: DMA code minor naming convention fix
      Blackfin arch: try to split up functions like this into smaller units according to LKML review

Aurelien Jarno (1):
      [PARISC] Disable LWS debugging

Avi Kivity (1):
      KVM: Prevent guest fpu state from leaking into the host

Badari Pulavarty (1):
      Restore shmid as inode# to fix /proc/pid/maps ABI breakage

Bartlomiej Zolnierkiewicz (4):
      serverworks: remove crappy code
      serverworks: fix CSB6 tuning logic
      it821x: RAID mode fixes
      ide-scsi: fix OOPS in idescsi_expiry()

Ben Collins (1):
      USB: UNUSUAL_DEV: Sync up some reported devices from Ubuntu

Ben Dooks (4):
      [ARM] 4442/1: OSIRIS: Fix CPLD register definitions
      [ARM] 4443/1: OSIRIS: Add watchdog device to machine devices
      [ARM] 4444/2: OSIRIS: CPLD suspend fix
      [ARM] 4445/1: ANUBIS: Fix CPLD registers

Benjamin Herrenschmidt (1):
      Rework ptep_set_access_flags and fix sun4c

Bill Gatliff (1):
      [ARM] 4422/1: Fix default value handling in gpio_direction_output (PXA)

Björn Steinbrink (3):
      i386: fix NMI watchdog not reserving its MSRs
      i386: use the right wrapper to disable the NMI watchdog
      perfctr-watchdog: fix interchanged parameters to release_{evntsel,perfctr}_nmi

Bob Picco (1):
      fix sysrq-m oops

Brian King (2):
      ibmveth: Fix h_free_logical_lan error on pool resize
      ibmveth: Automatically enable larger rx buffer pools for larger mtu

Brice Goglin (3):
      myri10ge: limit the number of recoveries
      myri10ge: report when the link partner is running in Myrinet mode
      myri10ge: update driver version

Bryan Wu (3):
      RAMFS NOMMU: missed POSIX UID/GID inode attribute checking
      Blackfin arch: fixup Blackfin MAINTIANERS team member list
      Blackfin SPI driver: fix bug SPI DMA incomplete transmission

Catalin Marinas (1):
      [ARM] 4392/2: Do not corrupt the SP register in compressed/head.S

Chris Ball (1):
      libertas: wakeup both mesh and normal wakeup when getting out of scan

Chris Dearman (6):
      [MIPS] Remove duplicate fpu enable hazard code.
      [MIPS] Always install the DSP exception handler.
      [MIPS] SMTC: Fix build error caused by nonsense code.
      [MIPS] Malta: Fix for SOCitSC based Maltas
      [MIPS] Separate performance counter interrupts
      [MIPS] Fix builds where MSC01E_xxx is undefined.

Chris Zankel (8):
      [XTENSA] fix bit operations in bitops.h
      [XTENSA] Spelling fixes in arch/xtensa
      [XTENSA] fix sources using deprecated assembler directive
      [XTENSA] Remove multi-exported symbols from xtensa_ksyms.c
      [XTENSA] Use generic 64-bit division
      [XTENSA] clean-up header files
      [XTENSA] Move common sections into bss sections
      [XTENSA] Remove non-rt signal handling

Christoph Hellwig (5):
      [POWERPC] spufs: Hook up spufs_release_mem
      [POWERPC] spufs: Synchronize pte invalidation vs ps close
      [POWERPC] spufs scheduler: Fix wakeup races
      [POWERPC] scc_sio: Fix link failure
      [POWERPC] spufs: Don't yield nosched context

Christoph Lameter (4):
      slab: fix alien cache handling
      SLUB: return ZERO_SIZE_PTR for kmalloc(0)
      SLUB slab validation: Alloc while interrupts are disabled must use GFP_ATOMIC
      SLUB: minimum alignment fixes

Dan Williams (26):
      libertas: call SET_NETDEV_DEV from common code
      libertas: replace 'macaddress' with 'bssid'
      libertas: correctly unregister mesh netdev on error
      libertas: don't tear down netdev in libertas_activate_card
      libertas: make scan result handling more flexible
      libertas: fix 'keep previous scan' behavior
      libertas: move channel changing into association framework
      libertas: make association paths consistent
      libertas: use MAC_FMT and MAC_ARG where appropriate
      libertas: use compare_ether_addr() rather than memcmp() where appropriate
      libertas: fix debug enter/leave prints for libertas_execute_next_command
      libertas: correctly balance locking in libertas_process_rx_command
      libertas: correct error report paths for wlan_fwt_list_ioctl
      libertas: fix deadlock SIOCGIWSCAN handler
      libertas: fix default adhoc channel
      libertas: honor specific channel requests during association
      libertas: send SIOCGIWSCAN event after partial scans too
      libertas: debug print spacing fixes in assoc.c
      libertas: add more verbose debugging to libertas_cmd_80211_authenticate
      libertas: Make WPA work through supplicant handshake
      libertas: sparse fixes
      libertas: tweak association debug output
      libertas: remove structure WLAN_802_11_SSID and libertas_escape_essid
      libertas: remove WPA_SUPPLICANT structure
      libertas: reduce SSID and BSSID mixed-case abuse
      libertas: actually send mesh frames to mesh netdev

Dave Airlie (1):
      drm: fix radeon setparam on 32/64 bit systems.

Dave Jones (1):
      typo in via-velocity.c

David Brownell (4):
      update Documentation/driver-model/platform.txt
      USB: usb gadgets avoid le{16,32}_to_cpup()
      [AVR32] gpio_*_cansleep() fix
      spi doc updates

David Lamparter (1):
      cfg80211: fix signed macaddress in sysfs

David Miller (2):
      [SPARC64]: Fix service channel hypervisor function names.
      [SPARC64]: Provide mmu statistics via sysfs.

David S. Miller (18):
      [SPARC64]: Move topology init code into new file, sysfs.c
      [SPARC64]: Export basic cpu properties via sysfs.
      [SPARC64]: Proper multi-core scheduling support.
      [SPARC64]: Make core and sibling groups equal on UltraSPARC-IV.
      [SPARC64]: Fix {mc,smt}_capable().
      [SPARC64]: Fill in gaps in non-PCI dma_*() NOP implementation.
      [ATA]: Back out bogus (SPARC64 && !PCI) Kconfig depends.
      [TCP] tcp_probe: Attach printf attribute properly to printl().
      [UDP]: Revert 2-pass hashing changes.
      [SPARC64]: Fix 2 bugs in PCI Sabre bus scanning.
      [SPARC64]: Fix SBUS IRQ regression caused by PCI-E driver.
      [SPARC64]: Handle PCI bridges without 'ranges' property.
      [TCP]: Disable TSO if MD5SIG is enabled.
      [SPARC64]: Wire up cookie based sun4v interrupt registry.
      [SPARC64]: Fix IO/MEM space sizing for PCI.
      [SPARC64]: Really fix parport.
      [SPARC64]: Fix args to sun4v_ldc_revoke().
      [TCP]: Set initial_ssthresh default to zero in Cubic and BIC.

David Woodhouse (7):
      libertas: fix character set in README
      libertas: first pass at fixing up endianness issues
      libertas: More endianness fixes.
      libertas: more endianness fixes, in tx.c this time
      libertas: don't byte-swap firmware version number. It's a byte array.
      libertas: fix big-endian associate command.
      fix radeon setparam on 32/64 systems, harder.

Denis Cheng (1):
      [NET]: Merge dst_discard_in and dst_discard_out.

Dmitry Mishin (1):
      [NETFILTER]: ip_tables: fix compat related crash

Dmitry Torokhov (3):
      Input: i8042 - add ASUS P65UP5 to the noloop list
      Input: i8042 - add ULI EV4873 to noloop list
      Input: move input-polldev to drivers/input

Eli Cohen (1):
      mlx4_core: Fix CQ context layout

Eric Dumazet (1):
      [TCP]: Use LIMIT_NETDEBUG in tcp_retransmit_timer().

Eric Sandeen (1):
      sysfs: store sysfs inode nrs in s_ino to avoid readdir oopses

Eric W. Biederman (1):
      shm: fix the filename of hugetlb sysv shared memory

G. Liakhovetski (2):
      [IrDA]: Fix Rx/Tx path race.
      [IrDA]: f-timer reloading when sending rejected frames.

Grant Grundler (2):
      [PARISC] remove remnants of parisc-specific softirq code
      [PARISC] remove global_ack_eiem

Greg Kroah-Hartman (1):
      kobject: use the proper printk level for kobject error

Greg Ungerer (2):
      m68knommu: fix ColdFire timer off by 1
      nommu: report correct errno in message

Haavard Skinnemoen (2):
      [AVR32] STK1000: Set SPI_MODE_3 in the ltv350qv board info
      [AVR32] Define ARCH_KMALLOC_MINALIGN to L1_CACHE_BYTES

Hans Verkuil (6):
      V4L/DVB (5675): Move big PIO accesses from the interrupt handler to a workhandler
      V4L/DVB (5730): Remove unused V4L2_CAP_VIDEO_OUTPUT_POS
      V4L/DVB (5732): Add ivtv CROPCAP support and fix ivtv S_CROP for video output.
      V4L/DVB (5736): Add V4L2_FBUF_CAP/FLAG_LOCAL/GLOBAL_INV_ALPHA
      V4L/DVB (5673): Fix audio stuttering for saa711x/ivtv when in radio mode.
      V4L/DVB (5751): Ivtv: fix ia64 printk format warnings.

Helge Deller (10):
      [PARISC] fix lasi_82596 build
      [PARISC] fix section mismatch in parport_gsc
      [PARISC] fix section mismatch in parisc STI video drivers
      [PARISC] fix section mismatch in ccio-dma
      [PARISC] fix section mismatches in arch/parisc/kernel
      [PARISC] fix section mismatch in parisc eisa driver
      [PARISC] fix section mismatch in superio serial drivers
      [PARISC] Wire up utimensat/signalfd/timerfd/eventfd syscalls
      [PARISC] fix "ENTRY" macro redefinition
      [PARISC] fix section mismatch in smp.c

Herbert Xu (6):
      [IPV4]: Only panic if inetdev_init fails for loopback
      [IPV4]: Convert IPv4 devconf to an array
      [IPV4]: Add default config support after inetdev_init
      [IPV4]: Restore old behaviour of default config values
      [IPV4]: Do not remove idev when addresses are cleared
      [IPV6] addrconf: Fix IPv6 on tuntap tunnels

Holger Schurig (23):
      libertas: rename wlan_association_worker
      libertas: a debug output was missing a newline
      libertas: fix removal of all debugfs files
      libertas: remove __FILE__ from debug output
      libertas: remove unused/superfluous definitions of DEV_NAME_LEN
      libertas: move vendor & product id's into if_usb.c
      libertas: make libertas_wlan_data_rates static
      libertas: exclude non-used code when PROC_DEBUG is not set
      libertas: make debug configurable
      libertas: tune debug code
      libertas: single out mesh code
      libertas: change debug output of libertas_interrupt()
      libertas: get rid of libertas_sbi_get_priv()
      libertas: fix SSID output
      libertas: changed some occurences of kmalloc() + memset(&a,0,sz) to kzalloc()
      libertas: move reset_device() code main.c to if_usb.c
      libertas: split wlan_add_card()
      libertas: indirect all hardware access via hw_XXXX functions
      libertas: move contents of fw.h to decl.h
      libertas: split module into two (libertas.ko and usb8xxx.ko)
      libertas: fix RESET logic at unload time
      libertas: let DRV_NAME be overridable
      libertas: remove unused variables in wlan_dev_t

Hugh Dickins (3):
      splice: __generic_file_splice_read: fix i_size_read() length checks
      mount -t tmpfs -o mpol=: check nodes online
      i386 mm: use pte_update() in ptep_test_and_clear_dirty()

Ilpo Järvinen (4):
      [TCP]: Fix left_out setting during FRTO
      [TCP]: Add missing break to TCP option parsing code
      [TCP]: Congestion control API RTT sampling fix
      [TCP]: Fix logic breakage due to DSACK separation

Ivo van Doorn (1):
      [RFKILL]: Make rfkill->name const

Jack Morgenstein (2):
      mlx4_core: Don't set MTT address in dMPT entries with PA set
      IB/mlx4: Fix zeroing of rnr_retry value in ib_modify_qp()

Jan Kara (1):
      udf: fix possible leakage of blocks

Javier Cardona (2):
      libertas: fixed transmission flow control on the mesh interface
      libertas: added transmission failures to mesh statistics

Jean-Christian de Rivaz (1):
      Blackfin SMC91X ethernet supporting driver: SMC91C111 LEDs are note drived in the kernel like in uboot

Jeff Dike (4):
      uml: fix kernel stack size on x86_64
      uml: get declaration of simple_strtoul
      uml: remove PAGE_SIZE from libc code
      uml: kill x86_64 STACK_TOP_MAX

Jeff Garzik (1):
      Revert "[netdrvr e100] experiment with doing RX in a similar manner to eepro100"

Jeff Mahoney (1):
      reiserfs: mailing list has moved

Jens Axboe (8):
      splice: move inode size check into generic_file_splice_read()
      splice: remove do_splice_direct() symbol export
      pipe: move pipe_inode_info structure decleration up before it's used
      splice: move balance_dirty_pages_ratelimited() outside of splice actor
      splice: __generic_file_splice_read: fix read/truncate race
      splice: adjust balance_dirty_pages_ratelimited() call
      splice: fix leak of pages on short splice to pipe
      splice: only check do_wakeup in splice_to_pipe() for a real pipe

Jeremy Kerr (1):
      [POWERPC] spufs: Fix gang destroy leaks

Jiri Slaby (4):
      ide: generic IDE PCI driver, add another device exception
      Char: stallion, don't fail with less than max panels
      Char: stallion, alloc tty before pci devices init
      Char: stallion, proper fail return values

Johannes Berg (1):
      mac80211: fix debugfs tx power reduction output

Joy Latten (1):
      xfrm: Add security check before flushing SAD/SPD

Kay Sievers (2):
      Driver core: keep PHYSDEV for old struct class_device
      USB: set default y for CONFIG_USB_DEVICE_CLASS

Ken Chen (1):
      loop: preallocate eight loop devices

Kim Phillips (1):
      phylib: add RGMII-ID mode to the Marvell m88e1111 PHY to fix broken ucc_geth

Konstantin Sharlaimov (1):
      [PPP_MPPE]: Fix "osize too small" check.

Kyle McMartin (11):
      [PARISC] Move #undef to end of syscall table
      [PARISC] Wire up kexec_load syscall
      [PARISC] Let PA-8900 processors boot
      [PARISC] kobject is embedded in subsys, not kset
      [PARISC] Build fixes for power.c
      [PARISC] fix trivial spelling nit in asm/linkage.h
      [PARISC] fix null ptr deref in unwind.c
      [PARISC] fix "reduce size of task_struct on 64-bit machines" fallout
      [PARISC] be more defensive in process.c::get_wchan
      [PARISC] Fix bug when syscall nr is __NR_Linux_syscalls
      [PARISC] Fix kernel panic in check_ivt

Lee Trager (1):
      ide: HPA detect from resume

Linus Torvalds (1):
      Linux 2.6.22-rc5

Luis Carlos (1):
      libertas: convert libertas_mpp into anycast_mask

Luis Carlos Cobo (4):
      libertas: fixed incorrect assigment of fcs errors to frag errors
      libertas: add URB debug info
      libertas: fixed kernel oops on module/card removal
      libertas: updated mesh commands for 5.220.9.p11

Luis Carlos Cobo Rus (8):
      libertas: version bump (321p0) and cmds update for new fw (5.220.10.p0)
      libertas: cleanup of fwt_list_route processing
      libertas: updated readme file
      libertas: make mac address configuration work with mesh interface too
      libertas: split wext for eth and msh
      libertas: support for mesh autostart on firmware 5.220.11
      libertas: pull current channel from firmware on mesh autostart
      libertas: deauthenticate from AP in channel switch

Maciej W. Rozycki (1):
      [MIPS] Fix KMODE for the R3000

Marc Pignat (1):
      mmc-atmel: remove linux/mmc/protocol.h dependencies

Marcelo Tosatti (5):
      libertas: scan two channels per scan command
      libertas: remove deprecated pm_register and associated code
      libertas: fix scanning from associate path
      libertas: fix error handling of card initialization
      libertas: fix oops on rmmod

Mark Fasheh (1):
      ocfs2: Fix invalid assertion during write on 64k pages

Markus Rechberger (1):
      firmware: remove orphaned Email

Matt Mackall (1):
      random: fix output buffer folding

Mattias Nissler (1):
      mac80211: Don't stop tx queue on master device while scanning.

Mauro Carvalho Chehab (2):
      V4L/DVB (5702): Fix Kconfig items to avoid linkedition errors
      V4L/DVB (5761): Fix broken b2c2 dependency on non x86 architectures

Michael Chan (5):
      [BNX2]: Fix netdev watchdog on 5708.
      [BNX2]: Add missing wait in bnx2_init_5709_context().
      [BNX2]: Enable DMA on 5709.
      [BNX2]: Fix occasional counter corruption on 5708.
      [BNX2]: Update version and reldate.

Michael Hennerich (3):
      Blackfin arch: As Mike pointed out range goes form m..MAX_BLACKFIN_GPIO -1
      Blackfin arch: add missing gpio.h header to fix compiling in some pm configurations
      Blackfin arch: fix bug can not wakeup from sleep via push buttons

Mike Accetta (1):
      md: fix bug in error handling during raid1 repair

Mike Frysinger (19):
      Blackfin arch: remove defconfig file
      Blackfin arch: mark our memory init functions with __init so they get freed after init
      Blackfin arch: implement a basic /proc/sram file for L1 allocation visibility
      Blackfin arch: scrub old console defines
      Blackfin arch: update defconfigs
      Blackfin arch: unify differences between our diff head.S files -- no functional changes
      Blackfin arch: move more of our startup code to .init so it can be freed once we are up and running
      Blackfin arch: add proper ENDPROC()
      Blackfin arch: fix spelling typo in output
      Blackfin arch: add support for Alon Bar-Lev's dynamic kernel command-line
      Blackfin arch: make sure we initialize our L1 Data B section properly based on the linked kernel
      Blackfin arch: redo our linker script a bit
      Blackfin arch: move HI/LO macros into blackfin.h and punt the rest of macros.h as it includes VDSP macros we never use
      Blackfin serial driver: hook up our UARTs STP bit with userspaces CMSPAR
      Blackfin serial driver: ignore framing and parity errors
      Blackfin serial driver: actually implement the break_ctl() function
      Blackfin serial driver: decouple PARODD and CMSPAR checking from PARENB
      Blackfin RTC drivers: update MAINTAINERS information
      Blackfin SPI driver: tweak spi cleanup function to match newer kernel changes

Miklos Szeredi (1):
      [AF_UNIX]: Fix stream recvmsg() race.

Milind Arun Choudhary (2):
      [PARISC] ROUND_UP macro cleanup in arch/parisc
      [PARISC] ROUNDUP macro cleanup in drivers/parisc

Milton Miller (1):
      [POWERPC] Fix console output getting dropped on platforms without udbg_putc

Mithlesh Thukral (3):
      NetXen: Fix ping issue after reboot on Blades with 3.4.19 firmware
      NetXen: Fix compile failure seen on PPC architecture
      NetXen: Fix link status messages

NeilBrown (1):
      md: fix two raid10 bugs

Oliver Endriss (1):
      V4L/DVB (5716): Tda10086,tda826x: fix tuning, STR/SNR values

Olof Johansson (2):
      [POWERPC] pasemi: Fix iommu + 64K PAGE_SIZE bug
      libata: fix probe time irq printouts

Ondrej Zary (1):
      Input: usbtouchscreen - fix fallout caused by move from drivers/usb

Patrick McHardy (4):
      [TCP]: Honour sk_bound_dev_if in tcp_v4_send_ack
      [NETLINK]: Mark netlink policies const
      [RTNETLINK]: ifindex 0 does not exist
      [NET_SCHED]: Fix filter double free

Patrick McHarrdy (1):
      [NETFILTER]: nf_conntrack: fix helper module unload races

Paul Fulghum (1):
      tty: restore locked ioctl file op

Paul Jackson (1):
      cpuset: zero malloc - fix for old cpusets

Paul Mackerras (2):
      [POWERPC] Fix building of COFF zImages
      [POWERPC] Fix per-cpu allocation on oldworld SMP powermacs

Paul Moore (2):
      [NetLabel]: consolidate the struct socket/sock handling to just struct sock
      [CIPSO]: Fix several unaligned kernel accesses in the CIPSO engine.

Paul Mundt (7):
      sh: Fix in_nmi symbol build error.
      sh: microdev: Fix compile warnings.
      sh: Fix SH4-202 clock fwk set_rate() mismatch.
      sh: voyagergx: Fix build warnings.
      sh: ioremap() through PMB needs asm/mmu.h.
      sh: Fix se73180 platform device registration.
      mm: Fix memory/cpu hotplug section mismatch and oops.

Peer Chen (3):
      Add the PATA controller device ID to pci_ids.h for MCP73/MCP77.
      ide: Add the MCP73/77 support to PATA driver
      ahci: Add MCP73/MCP77 support to AHCI driver

Pete Zaitcev (1):
      usblp: Don't let suspend to kill ->used

Peter Zijlstra (1):
      frv: build fix

Pierre Ossman (3):
      mmc: fix broken if clause
      mmc: don't call switch on old cards
      mmc: get back read-only switch function

Rafael J. Wysocki (2):
      Resume from RAM on HPC nx6325 broken
      swsusp: Fix userland interface

Ragner Magalhaes (1):
      mmc-omap: fix sd response type 6 vs. 1

Ralf Baechle (9):
      [MIPS] Atlas, Malta, SEAD: Remove scroll from interrupt handler.
      [MIPS] Remove prototype for deleted function qemu_handle_int
      [MIPS] SMTC: Don't set and restore irqregs ptr from self_ipi.
      [MIPS] Atlas: Fix build.
      [MIPS] SMTC: Fix warning.
      [MIPS] SMTC: Don't continue in set_vi_srs_handler on detected bad arguments.
      [MIPS] SMTC: The MT ASE requires to initialize c0_pagemask and c0_wired.
      [MIPS] Fix modpost warnings by making start_secondary __cpuinit
      [MIPS] Fix smp barriers in test_and_{change,clear,set}_bit

Randy Dunlap (4):
      isdn/diva: fix section mismatch
      checkpatch: produce fewer lines of output
      hexdump: more output formatting
      toshiba_acpi: fix section mismatch in allyesconfig

Ratnadeep Joshi (1):
      Documentation/atomic_ops.txt typo fix

Robert P. J. Day (4):
      [MIPS] Fix some minor typoes in arch/mips/Kconfig.
      au1xmmc: Replace C code with call to ARRAY_SIZE() macro.
      [SPARC64]: Include <linux/rwsem.h> instead of <asm/rwsem.h>.
      Protect <linux/console_struct.h> from multiple inclusion

Robin Getz (1):
      Blackfin arch: all symbols were offset by 4k, since we didn't have the __text label.

Roland Dreier (5):
      mlx4_core: Initialize ctx_list and ctx_lock earlier
      mlx4_core: Free catastrophic error MSI-X interrupt with correct dev_id
      IB/mthca, mlx4_core: Fix typo in comment
      mlx4_core: Check firmware command interface revision
      IB/mlx4: Make sure RQ allocation is always valid

Roland McGrath (1):
      Restrict clearing TIF_SIGPENDING

Roy Huang (1):
      Blackfin arch:  fix bug ad1836 fails to build properly for BF533-EZKIT

Russell King (5):
      [ARM] Solve buggy smp_processor_id() usage
      [ARM] Fix 4417/1: Serial: Fix AMBA drivers locking
      [ARM] pxa: fix pxa27x keyboard driver
      V4L/DVB (5700): Saa7111: fix picture settings cache bug
      [ARM] VFP: fix section mismatch error

Sam Ravnborg (3):
      [VIDEO]: Fix section mismatch warning in promcon.
      net: fix typo in drivers/net/usb/Kconfig
      kbuild: fix sh64 section mismatch problems

Sean Hefty (1):
      RDMA/cma: Fix initialization of next_port

Sebastian Siewior (2):
      [POWERPC] spufs: Free mm if spufs_fill_dir() failed
      [POWERPC] spufs: Fix error handling in spufs_fill_dir()

Sergei Shtylyov (2):
      [MIPS] EMMA2RH: remove dead KGDB code
      hpt366: disallow Ultra133 for HPT374

Simon Arlott (5):
      [PARISC] spelling fixes: arch/parisc/
      USB: cxacru: add Documentation file
      USB: cxacru: create sysfs attributes in atm_start instead of bind
      USB: cxacru: ignore error trying to start ADSL in atm_start
      Blackfin arch: spelling fixes

Stephen Hemminger (1):
      Driver core: kill unused code

Stephen Rothwell (2):
      Xtensa: use asm-generic/fcntl.h
      Move three functions that are only needed for CONFIG_MEMORY_HOTPLUG

Steve French (5):
      [CIFS] Fix oops on failed cifs mount (in kthread_stop)
      [CIFS] typo in previous patch
      [CIFS] whitespace cleanup
      [CIFS] whitespace cleanup part 2
      [CIFS] CIFS should honour umask

Steven Rostedt (1):
      enable interrupts in user path of page fault.

Stuart Yoder (2):
      [POWERPC] Fix typo in booting-without-of-txt section numbering
      [POWERPC] Add table of contents to booting-without-of.txt

Tejun Heo (8):
      sata_promise: use TF interface for polling NODATA commands
      libata: disable NCQ for HITACHI HTS541680J9SA00/SB21C7EP
      libata: fix hw_sata_spd_limit initialization
      libata: force PIO on IOMEGA ZIP 250 ATAPI
      libata: limit post SRST nsect/lbal wait to ~100ms
      sysfs: fix condition check in sysfs_drop_dentry()
      sysfs: fix race condition around sd->s_dentry, take#2
      block: always requeue !fs requests at the front

Thierry Merle (1):
      V4L/DVB (5720): Usbvision: fix urb allocation and submits

Thomas Bogendoerfer (3):
      [MIPS] RM300: Fix MMIO problems by marking the PCI INT ACK region busy
      [MIPS] Fix VGA corruption on RM300C
      [MIPS] Make dma_map_sg handle sg elements which are longer than one page

Thomas Gleixner (2):
      rt-mutex: fix stale return value
      rt-mutex: fix chain walk early wakeup bug

Thomas Graf (1):
      [NET]: Avoid duplicate netlink notification when changing link state

Thomas Klein (1):
      ehea: Fixed possible kernel panic on VLAN packet recv

Thomas Renninger (1):
      [POWERPC] cbe_cpufreq: Limit frequency via cpufreq notifier chain

Tiger Yang (1):
      ocfs2: Fix masklog breakage

Vlad Yasevich (6):
      [SCTP]: Correctly set daddr for IPv6 sockets during peeloff
      [SCTP]: Allow unspecified port in sctp_bindx()
      [SCTP] Fix leak in sctp_getsockopt_local_addrs when copy_to_user fails
      [SCTP] Update pmtu handling to be similar to tcp
      [SCTP] Flag a pmtu change request
      [SCTP] Don't disable PMTU discovery when mtu is small

Wang Zhenyu (8):
      [AGPGART] intel_agp: cleanup intel private data
      [AGPGART] intel_agp: use table for device probe
      [AGPGART] intel_agp: add support for 965GME/GLE
      [AGPGART] intel_agp: add support for 945GME
      [AGPGART] intel_agp: Add support for G33, Q33 and Q35 chipsets
      i915: add new pciids for 945GME, 965GME/GLE
      drm/i915:  Add support for the G33, Q33, and Q35 chipsets.
      [AGPGART] intel_agp: fix device probe

Yehuda Sadeh Weinraub (1):
      [CIFS] Missing flag on negprot needed for some servers to force packet signing

Yoann Padioleau (1):
      potential parse error in ifdef part 3

Yoichi Yuasa (1):
      remove unused variable in pata_isapnp

---1463790079-1636944895-1182051232=:14121--
