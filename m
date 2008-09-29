Return-Path: <linux-kernel-owner+w=401wt.eu-S1753794AbYI2XJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753794AbYI2XJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 19:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751786AbYI2XJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 19:09:15 -0400
Received: from mail.lang.hm ([64.81.33.126]:33487 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbYI2XJO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 19:09:14 -0400
Date: Mon, 29 Sep 2008 16:09:59 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.27-rc8
In-Reply-To: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
Message-ID: <alpine.DEB.1.10.0809291609090.8559@asgard.lang.hm>
References: <alpine.LFD.2.00.0809291527460.3389@nehalem.linux-foundation.org>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Sep 2008, Linus Torvalds wrote:

> So yet another week, another -rc. This one should be the last one: we're
> certainly not running out of regressions, but at the same time, at some
> point I just have to pick some point, and on the whole the regressions
> don't look _too_ scary. And -rc8 obviously does fix more of them.

unless there is news that I missed, the E1000 bricking bug is still out 
there. that is a particularly nasty one.

David Lang

> Most of the changes since -rc7 are pretty small, and there aren't even a
> whole lot of them. The shortlog (appended) is just a couple of pages, and
> the diffstat is even smaller, but since the dirstat is a dense overview,
> I'll just put that here instead:
>
>   4.6% arch/m32r/kernel/
>   5.7% arch/m32r/
>   9.5% arch/mips/pci/
>  10.4% arch/mips/
>   4.2% arch/x86/kernel/
>   4.4% arch/x86/
>  26.0% arch/
>   3.5% drivers/usb/storage/
>  10.4% drivers/usb/
>   3.6% drivers/watchdog/
>  23.8% drivers/
>  11.5% fs/xfs/
>  13.5% fs/
>   3.7% kernel/
>   9.8% net/9p/
>  10.6% net/
>   5.4% scripts/kconfig/
>   5.9% scripts/
>   7.4% sound/soc/codecs/
>   8.4% sound/soc/
>  10.1% sound/
>
> and it's actually more spread out than usual. Arch and drivers are just
> half of the patch even when combined.
>
> Give it a try,
>
> 		Linus
>
> ---
> Adrian Bunk (5):
>      m32r: remove the unused NOHIGHMEM option
>      m32r: don't offer CONFIG_ISA
>      m32r: export empty_zero_page
>      m32r: export __ndelay
>      m32r/kernel/: cleanups
>
> Adrian Hunter (2):
>      UBIFS: TNC / GC race fixes
>      UBIFS: remove incorrect assert
>
> Akinobu Mita (2):
>      [WATCHDOG] ibmasr: remove unnecessary spin_unlock()
>      ibmasr: remove unnecessary spin_unlock()
>
> Alan Cox (1):
>      pcmcia: Fix broken abuse of dev->driver_data
>
> Alan Stern (2):
>      USB: unusual_devs addition for RockChip MP3 player
>      USB: revert recovery from transient errors
>
> Alex Chiang (1):
>      [IA64] Ski simulator doesn't need check_sal_cache_flush
>
> Alexander Beregalov (1):
>      UBIFS: fix printk format warnings
>
> Alexander Duyck (1):
>      netdev: simple_tx_hash shouldn't hash inside fragments
>
> Andrea Righi (1):
>      x86, oprofile: BUG scheduling while atomic
>
> Andreas Bombe (1):
>      usb-serial: Add Siemens EF81 to PL-2303 hack triggers
>
> Andreas Herrmann (1):
>      x86: c1e_idle: don't mark TSC unstable if CPU has invariant TSC
>
> Andrew Morton (2):
>      Documentation/sysctl/kernel.txt: fix softlockup_thresh description
>      USB: drivers/usb/musb/: disable it on SuperH
>
> Andrew Vasquez (1):
>      [SCSI] qla2xxx: Defer enablement of RISC interrupts until ISP initialization completes.
>
> Anti Sullin (1):
>      atmel_serial: update the powersave handler to match serial core
>
> Atsuo Igarashi (1):
>      kgdb: could not write to the last of valid memory with kgdb
>
> Aurelien Jarno (2):
>      [MIPS] BCM47xx: Fix build error due to missing PCI functions
>      [SSB] Initialise dma_mask for SSB_BUSTYPE_SSB devices
>
> Balbir Singh (1):
>      mm owner: fix race between swapoff and exit
>
> Ben Dooks (1):
>      [WATCHDOG] wdt285: fix sparse warnings
>
> Boaz Harrosh (2):
>      [SCSI] qlogicpti: fix sg list traversal error in continuation entries
>      scsi: fix fall out of sg-chaining patch in qlogicpti
>
> Borislav Petkov (1):
>      ide-tape: fix vendor strings
>
> Bruno Randolf (2):
>      [MIPS] au1000: Fix gpio direction
>      [MIPS] au1000: Make sure GPIO value is zero or one
>
> Chris Adams (1):
>      usb serial: ti_usb_3410_5052 obviously broken by firmware changes
>
> Craig Shelley (1):
>      USB: SERIAL CP2101 add device IDs
>
> Daisuke Nishimura (1):
>      memcg: check under limit at shrink_usage
>
> David Almaroad (1):
>      usb: unusual devs patch for Nokia 5310 Music Xpress
>
> David Brownell (3):
>      USB: ehci: fix some ehci hangs and crashes
>      usb gadget: fix omap_udc DMA regression
>      USB: fix EHCI periodic transfers
>
> David Howells (3):
>      MN10300: Move asm-arm/cnt32_to_63.h to include/linux/
>      MN10300: Make sched_clock() report time since boot
>      ARM: Delete ARM's own cnt32_to_63.h
>
> David S. Miller (2):
>      sparc64: Fix disappearing PCI devices on e3500.
>      sparc64: Fix missing devices due to PCI bridge test in of_create_pci_dev().
>
> Eric Van Hensbergen (1):
>      9p: fix put_data error handling
>
> Felipe Balbi (1):
>      usb: musb: fix include path
>
> Filip Joelsson (1):
>      USB: Fixing Nokia 3310c in storage mode
>
> Gaetan Carlier (1):
>      usb: ftdi_sio: add support for Domintell devices
>
> Geoff Levand (1):
>      USB: fix hcd interrupt disabling
>
> Greg Kroah-Hartman (1):
>      PCI: fix compiler warnings in pci_get_subsys()
>
> Haavard Skinnemoen (1):
>      ALSA: ASoC: Fix at32-pcm build breakage with PM enabled
>
> Henrik Rydberg (1):
>      Input: bcm5974 - switch back to normal mode when closing
>
> Ingo Molnar (1):
>      timers: fix build error in !oneshot case
>
> Jack Tan (1):
>      [MIPS] Fixe the definition of PTRS_PER_PGD
>
> James Bottomley (1):
>      [SCSI] Fix hang with split requests
>
> Jaroslav Kysela (1):
>      USB: ftdi_sio: Add 0x5050/0x0900 USB IDs (Papouch Quido USB 4/4)
>
> Jason Wessel (4):
>      kgdb, x86, arm, mips, powerpc: ignore user space single stepping
>      kgdb, x86_64: gdb serial has BX and DX reversed
>      kgdb, x86_64: fix PS CS SS registers in gdb serial
>      kgdboc,tty: Fix tty polling search to use name correctly
>
> Jay Lan (1):
>      [IA64] kexec fails on systems with blocks of uncached memory
>
> Jean Delvare (2):
>      i2c: Fix mailing lists in two MAINTAINERS entries
>      ALSA: ASoC: Fix another cs4270 error path
>
> Jeremy Katz (1):
>      x86: disable apm on the olpc
>
> Joerg Roedel (2):
>      AMD IOMMU: set iommu sunc flag after command queuing
>      AMD IOMMU: protect completion wait loop with iommu lock
>
> Jonathan Steel (1):
>      kexec: fix segmentation fault in kimage_add_entry
>
> Julia Lawall (1):
>      9p: introduce missing kfree
>
> Julien Brunel (1):
>      9p: use an IS_ERR test rather than a NULL test
>
> Kevin Lloyd (3):
>      USB Storage: Sierra: Non-configurable TRU-Install
>      USB Serial: Sierra: Device addition & version rev
>      USB Serial: Sierra: Add MC8785 VID/PID
>
> Kirill A. Shutemov (1):
>      smb.h: do not include linux/time.h in userspace
>
> Kristoffer Ericson (1):
>      Input: jornada720_ts - fix build error ( LONG() usage )
>
> Lachlan McIlroy (2):
>      [XFS] Fix extent list corruption in xfs_iext_irec_compact_full().
>      [XFS] Remove xfs_iext_irec_compact_full()
>
> Liam Girdwood (1):
>      ALSA: ASoC: maintainers - update email address for Liam Girdwood
>
> Linus Torvalds (2):
>      Fix NULL pointer dereference in proc_sys_compare
>      Linux 2.6.27-rc8
>
> Luis R. Rodriguez (1):
>      ath9k: disable MIB interrupts to fix interrupt storm
>
> Marc Dionne (1):
>      x86: prevent stale state of c1e_mask across CPU offline/online, fix
>
> Marcel Holtmann (3):
>      [Bluetooth] Fix I/O errors on MacBooks with Broadcom chips
>      [Bluetooth] Fix wrong URB handling of btusb driver
>      [Bluetooth] Fix USB disconnect handling of btusb driver
>
> Marin Mitov (1):
>      Documentation/DMA-mapping.txt: update for pci_dma_mapping_error() changes
>
> Michael Kerrisk (1):
>      sys_paccept: disable paccept() until API design is resolved
>
> M?rton N?meth (1):
>      cdrom: update ioctl documentation
>
> Nick Piggin (1):
>      mm: tiny-shmem fix lock ordering: mmap_sem vs i_mutex
>
> Oliver Neukum (1):
>      USB: update of Documentation/usb/anchors.txt
>
> Otavio Salvador (1):
>      USB: serial: add ZTE CDMA Tech id to option driver
>
> Peter Korsgaard (1):
>      USB: fsl_usb2_udc: fix VDBG() format string
>
> Rakib Mullick (1):
>      sched: fix init_hrtick() section mismatch warning
>
> Ralf Baechle (2):
>      [MIPS] IP27: Switch to dynamic interrupt routing avoding panic on error.
>      Swarm: Fix crash due to missing initialization
>
> Randy Dunlap (1):
>      kernel-doc: allow structs whose members are all private
>
> Ravikiran G Thirumalai (1):
>      x86: fix 27-rc crash on vsmp due to paravirt during module load
>
> Richard Nauber (1):
>      USB: Fix the Nokia 6300 storage-mode.
>
> Roland Dreier (1):
>      IPoIB: Fix crash when path record fails after path flush
>
> Sebastian Siewior (1):
>      UBIFS: create the name of the background thread in every case
>
> Senthil Balasubramanian (2):
>      ath9k: connectivity is lost after Group rekeying is done
>      ath9k: Fix IRQ nobody cared issue with ath9k
>
> Sitsofe Wheeler (1):
>      PCI: Fix pcie_aspm=force
>
> Sven Wegener (1):
>      i2c-dev: Return correct error code on class_create() failure
>
> Takashi Iwai (2):
>      ALSA: fix locking in snd_pcm_open*() and snd_rawmidi_open*()
>      ALSA: remove unneeded power_mutex lock in snd_pcm_drop
>
> Tejun Heo (7):
>      9p: implement proper trans module refcounting and unregistration
>      9p-trans_fd: fix trans_fd::p9_conn_destroy()
>      9p-trans_fd: clean up p9_conn_create()
>      9p-trans_fd: don't do fs segment mangling in p9_fd_poll()
>      9p-trans_fd: fix and clean up module init/exit paths
>      ide: note that IDE generic may prevent other drivers from attaching
>      sata_nv: reinstate nv_hardreset() for non generic controllers
>
> Thomas Gleixner (6):
>      clockevents: prevent cpu online to interfere with nohz
>      x86: prevent stale state of c1e_mask across CPU offline/online
>      clockevents: prevent stale tick_next_period for onlining CPUs
>      clockevents: check broadcast device not tick device
>      clockevents: prevent mode mismatch on cpu online
>      x86: prevent C-states hang on AMD C1E enabled machines
>
> Timur Tabi (1):
>      ALSA: make the CS4270 driver a new-style I2C driver
>
> Tony Murray (1):
>      USB: Correct Sierra Wireless USB EVDO Modem Device ID
>
> Uwe Kleine-K?nig (1):
>      i2c-powermac: Fix section for probe and remove functions
>
> Wim Van Sebroeck (1):
>      [WATCHDOG] unlocked_ioctl changes
>
> Yasuyuki Kozakai (1):
>      netfilter: ip6t_{hbh,dst}: Rejects not-strict mode on rule insertion
>
> born.into.silence@gmail.com (1):
>      wireless: zd1211rw: add device ID fix wifi dongle "trust nw-3100"
>
> zippel@linux-m68k.org (2):
>      kconfig: fix silentoldconfig
>      kconfig: readd lost change count
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
