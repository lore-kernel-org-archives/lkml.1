Return-Path: <linux-kernel-owner+w=401wt.eu-S1760843AbZFJDrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760843AbZFJDrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 23:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755461AbZFJDgk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 23:36:40 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51428 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757693AbZFJDgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 23:36:36 -0400
Date: Tue, 9 Jun 2009 20:36:36 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
X-X-Sender: torvalds@localhost.localdomain
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Linux 2.6.30
Message-ID: <alpine.LFD.2.01.0906092010030.6847@localhost.localdomain>
User-Agent: Alpine 2.01 (LFD 1184 2008-12-16)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


As mentioned last week, -rc8 was the last -rc, and there really isn't any 
point in delaying the real release any more.

I'm sure we've missed something, and I know we have some regressions 
pending. At the same time, we do need the coverage of a eral release, and 
on the whole it looks pretty good. We've fixed a few regressions in the 
last few days, and there's always 2.6.30.x.

The appended shortlog from 2.6.29-rc8 is not very interesting, but it's 
about as good as it gets. Not a lot of changes (just 72 non-merges, 
according to git rev-list), and most of those are pretty small and 
trivial. We're talking mostly one-liners, with just a couple of them 
standing out (in fact, just mainly the DPMS handling cleanup in 
drm_crtc_helper.c)

As to the whole set of changes since 2.6.29, the best place to look is 
probably just 

	http://kernelnewbies.org/Linux_2_6_30

as usual. One thing that doesn't seem to be mentioned there is that we're 
hopefully now done with the suspend/resume irq re-architecting, and have 
switched to a new world order. Although I suspect lots of details will 
still change, of course.

And as usual, I'll wait a day or two before really opening the merge 
window. I want people to actually test this one rather than immediately 
sending me "please pull" requests. Deal?

		Linus

---
Adam Jackson (1):
      drm: ignore EDID with really tiny modes.

Al Viro (1):
      ext3/4 with synchronous writes gets wedged by Postfix

Alan Cox (3):
      ivtv: Fix PCI DMA direction
      [libata] pata_ali: Use IGN_SIMPLEX
      pata_netcell: Fix typo

Alessandro Rubini (1):
      [ARM] 5543/1: arm: serial amba: add missing declaration in serial.h

Anand Gadiyar (1):
      omap_hsmmc: Trivial fix for a typo in comment

Avi Kivity (2):
      KVM: Explicity initialize cpus_hardware_enabled
      kvm: fix kvm reboot crash when MAXSMP is used

Ben Nizette (1):
      mmc/omap: Use disable_irq_nosync() from within irq handlers.

Ben Skeggs (1):
      drm: don't associate _DRM_DRIVER maps with a master

Chris Mason (1):
      Btrfs: Fix oops and use after free during space balancing

Dave Airlie (2):
      drm: fix irq naming for kms drivers.
      drm/radeon: fix ring free alignment calculations

Dave Jones (1):
      [CPUFREQ] powernow-k8: check space_id of _PCT registers to be FFH

Dave Liu (1):
      sdhci-of: Fix the wrong accessor to HOSTVER register

Eric Anholt (1):
      drm/i915: Remove a bad BUG_ON in the fence management code.

Eric Dumazet (1):
      r8169: fix crash when large packets are received

Eric Lammerts (1):
      fix oops when using console=ttymxcN with N > 0

FUJITA Tomonori (1):
      bsg: setting rq->bio to NULL

Hugh Dickins (1):
      integrity: fix IMA inode leak

Ian Kent (1):
      autofs4: remove hashed check in validate_wait()

James Bottomley (1):
      pata_legacy: wait for async probing

Jan Kara (1):
      jbd: fix race in buffer processing in commit code

Jaswinder Singh Rajput (2):
      drm/i915: intel_lvds.c fix section mismatch
      MIPS: ioctl.h: Fix headers_check warnings

Jonathan Cameron (1):
      [ARM] pxa/imote2: fix UCAM sensor board ADC model number

Keith Packard (3):
      drm: add newlines to text sysfs files
      drm: set permissions on edid file to 0444
      drm: Hook up DPMS property handling in drm_crtc.c. Add drm_helper_connector_dpms.

Kevin Hilman (1):
      mtd: davinci nand: update clock naming

Kumar Gala (1):
      sdhci-of: Add fsl,esdhc as a valid compatible to bind against

Linus Torvalds (3):
      Revert "drm: don't associate _DRM_DRIVER maps with a master"
      async: Fix lack of boot-time console due to insufficient synchronization
      Linux 2.6.30

Martin Fuzzey (3):
      [ARM] 5534/1: kmalloc must return a cache line aligned buffer
      mxcmmc : Reset the SDHC hardware if software timeout occurs.
      mxcmmc: Fix missing return value checking in DMA setup code.

Matthieu CASTET (1):
      SSB: BCM47xx: Export ssb_watchdog_timer_set

Mike Frysinger (2):
      kbuild: fix detection of CONFIG_FRAME_WARN=0
      shm: fix unused warnings on nommu

Minoru Usui (1):
      cls_cgroup: Fix oops when user send improperly 'tc filter add' request

NeilBrown (3):
      md/raid5: use conf->raid_disks in preference to mddev->raid_disk
      md/raid5 - avoid deadlocks in get_active_stripe during reshape
      md/raid5: fix bug in reshape code when chunk_size decreases.

Nicolas Pitre (3):
      mvsdio: allow automatic loading when modular
      mvsdio: ignore high speed timing requests from the core
      mvsdio: fix config failure with some high speed SDHC cards

Oleg Nesterov (2):
      ptrace: tracehook_report_clone: fix false positives
      ptrace: revert "ptrace_detach: the wrong wakeup breaks the ERESTARTxxx logic"

Peter Botha (1):
      char: mxser, fix ISA board lookup

Philipp Zabel (1):
      [ARM] pxa: fix pxa27x_udc default pullup GPIO

Rabin Vincent (1):
      mx[23]: don't put clock lookups in __initdata

Ralf Baechle (2):
      MIPS: Sibyte: Honor CONFIG_CMDLINE
      MIPS: Outline udelay and fix a few issues.

Russell King (1):
      [ARM] ARMv7 errata: only apply fixes when running on applicable CPU

Rusty Russell (1):
      lguest: fix 'unhandled trap 13' with CONFIG_CC_STACKPROTECTOR

Salman Qazi (1):
      drivers/char/mem.c: avoid OOM lockup during large reads from /dev/zero

Sascha Hauer (1):
      mxcmmc: decrease minimum frequency to make MMC cards work

Sergei Shtylyov (3):
      pata_efar: fix PIO2 underclocking
      pdc202xx_old: fix 'pdc20246_dma_ops'
      pdc202xx_old: fix resetproc() method

Tejun Heo (1):
      ahci: add warning messages for hp laptops with broken suspend

Theodore Ts'o (1):
      Fix nobh_truncate_page() to not pass stack garbage to get_block()

Ville Syrjala (1):
      ata_piix: Add HP Compaq nc6000 to the broken poweroff list

Yan Zheng (1):
      Btrfs: set device->total_disk_bytes when adding new device

Yinghai Lu (3):
      x86/pci: fix mmconfig detection with 32bit near 4g
      cpumask: introduce zalloc_cpumask_var
      cpumask: alloc zeroed cpumask for static cpumask_var_ts

Yoichi Yuasa (2):
      MIPS: Kconfig: Remove "Support for" from Cavium system type
      MIPS: Cobalt: PCI bus is always required to obtain the board ID

Yu Zhao (1):
      PCI: use fixed-up device class when configuring device
