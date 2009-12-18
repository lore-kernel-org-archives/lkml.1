Return-Path: <linux-kernel-owner+w=401wt.eu-S933313AbZLRXAP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933313AbZLRXAP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:00:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933247AbZLRXAN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:00:13 -0500
Received: from kroah.org ([198.145.64.141]:38528 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933101AbZLRXAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:00:11 -0500
Date: Fri, 18 Dec 2009 14:56:56 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.2
Message-ID: <20091218225656.GA19000@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.2 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

I'll also be replying to this message with a copy of the patch between
2.6.32.1 and 2.6.32.2

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/Changes                         |    2 
 Documentation/kernel-parameters.txt           |    2 
 Documentation/video4linux/gspca.txt           |    1 
 MAINTAINERS                                   |    4 
 Makefile                                      |    2 
 arch/arm/mach-pxa/em-x270.c                   |   11 -
 arch/ia64/include/asm/io.h                    |    2 
 arch/ia64/mm/ioremap.c                        |   11 +
 arch/powerpc/kernel/vector.S                  |    2 
 arch/s390/include/asm/kvm.h                   |    3 
 arch/s390/kernel/head64.S                     |    3 
 arch/s390/kvm/kvm-s390.c                      |   25 +-
 arch/s390/kvm/sigp.c                          |    6 
 arch/sparc/Makefile                           |    2 
 arch/sparc/kernel/ldc.c                       |    4 
 arch/sparc/kernel/of_device_64.c              |   14 +
 arch/sparc/lib/mcount.S                       |    5 
 arch/x86/Makefile_32.cpu                      |    7 
 arch/x86/include/asm/irq_vectors.h            |    2 
 arch/x86/include/asm/kvm_emulate.h            |    2 
 arch/x86/include/asm/mce.h                    |    6 
 arch/x86/kernel/acpi/cstate.c                 |    2 
 arch/x86/kernel/amd_iommu.c                   |    8 
 arch/x86/kernel/amd_iommu_init.c              |    2 
 arch/x86/kernel/apic/apic.c                   |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c         |    5 
 arch/x86/kernel/cpu/mcheck/mce.c              |    9 -
 arch/x86/kernel/cpu/mcheck/therm_throt.c      |   29 +++
 arch/x86/kernel/cpu/perfctr-watchdog.c        |    2 
 arch/x86/kernel/pci-calgary_64.c              |   12 -
 arch/x86/kernel/pci-dma.c                     |    2 
 arch/x86/kernel/pci-gart_64.c                 |    2 
 arch/x86/kernel/reboot.c                      |    8 
 arch/x86/kernel/setup.c                       |    3 
 arch/x86/kernel/tlb_uv.c                      |    4 
 arch/x86/kvm/emulate.c                        |    5 
 arch/x86/kvm/x86.c                            |   12 -
 arch/x86/xen/enlighten.c                      |   27 +--
 arch/x86/xen/mmu.c                            |    2 
 arch/x86/xen/smp.c                            |    1 
 arch/x86/xen/suspend.c                        |   17 +
 arch/x86/xen/time.c                           |    7 
 arch/x86/xen/xen-asm_64.S                     |    4 
 arch/x86/xen/xen-ops.h                        |    2 
 drivers/ata/pata_hpt37x.c                     |   32 +--
 drivers/ata/pata_hpt3x2n.c                    |   17 -
 drivers/base/core.c                           |    9 -
 drivers/base/power/runtime.c                  |    2 
 drivers/firewire/ohci.c                       |   12 +
 drivers/gpu/drm/drm_irq.c                     |   34 ++-
 drivers/gpu/drm/i915/i915_drv.h               |    4 
 drivers/gpu/drm/i915/i915_gem.c               |    1 
 drivers/gpu/drm/i915/intel_display.c          |   67 +++++--
 drivers/gpu/drm/i915/intel_dp.c               |    6 
 drivers/gpu/drm/i915/intel_tv.c               |   11 -
 drivers/gpu/drm/radeon/atombios_crtc.c        |    8 
 drivers/gpu/drm/radeon/radeon_atombios.c      |    8 
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c   |    7 
 drivers/gpu/drm/radeon/rs600.c                |   15 +
 drivers/gpu/drm/radeon/rs690.c                |   19 +-
 drivers/ide/slc90e66.c                        |    3 
 drivers/macintosh/therm_adt746x.c             |   13 +
 drivers/macintosh/windfarm_smu_controls.c     |    2 
 drivers/md/bitmap.c                           |   24 ++
 drivers/md/bitmap.h                           |    2 
 drivers/md/dm-crypt.c                         |  170 +++++++++++++------
 drivers/md/dm-exception-store.c               |    3 
 drivers/md/dm-ioctl.c                         |   17 +
 drivers/md/dm-snap.c                          |   12 -
 drivers/md/dm-uevent.c                        |    9 -
 drivers/md/md.c                               |    3 
 drivers/md/md.h                               |    1 
 drivers/media/common/tuners/mxl5007t.c        |    2 
 drivers/media/video/gspca/ov519.c             |    1 
 drivers/mtd/ubi/upd.c                         |   20 +-
 drivers/net/b44.c                             |    3 
 drivers/net/bcm63xx_enet.c                    |   12 +
 drivers/net/wireless/ath/ath5k/eeprom.c       |    3 
 drivers/net/wireless/ath/ath5k/phy.c          |    2 
 drivers/net/wireless/ath/ath9k/ath9k.h        |    3 
 drivers/net/wireless/ath/ath9k/hw.c           |   11 +
 drivers/net/wireless/ath/ath9k/hw.h           |    1 
 drivers/net/wireless/ath/ath9k/mac.c          |    6 
 drivers/net/wireless/ath/ath9k/mac.h          |    1 
 drivers/net/wireless/ath/ath9k/main.c         |    9 -
 drivers/net/wireless/ath/ath9k/xmit.c         |   20 ++
 drivers/net/wireless/b43legacy/rfkill.c       |    7 
 drivers/net/wireless/ipw2x00/ipw2100.c        |   11 +
 drivers/net/wireless/rtl818x/rtl8187.h        |    5 
 drivers/net/wireless/rtl818x/rtl8187_dev.c    |   12 +
 drivers/net/wireless/rtl818x/rtl8187_rfkill.c |    4 
 drivers/pci/dmar.c                            |   67 ++++++-
 drivers/pci/intel-iommu.c                     |   26 ++
 drivers/platform/x86/acerhdf.c                |   63 ++++---
 drivers/platform/x86/asus-laptop.c            |    4 
 drivers/platform/x86/thinkpad_acpi.c          |   36 ----
 drivers/serial/8250.c                         |    8 
 drivers/ssb/sprom.c                           |   20 +-
 drivers/usb/class/usbtmc.c                    |   14 +
 drivers/usb/core/usb.c                        |   31 +--
 drivers/usb/musb/musb_gadget_ep0.c            |    1 
 drivers/usb/serial/option.c                   |   37 ++++
 drivers/usb/storage/transport.c               |   17 +
 drivers/usb/storage/unusual_devs.h            |    7 
 drivers/usb/storage/usb.c                     |   18 +-
 drivers/video/matrox/g450_pll.c               |    3 
 drivers/xen/balloon.c                         |   38 +---
 drivers/xen/events.c                          |    3 
 drivers/xen/manage.c                          |   37 ++--
 drivers/xen/xenbus/xenbus_probe.c             |    6 
 fs/debugfs/inode.c                            |   55 +++---
 fs/devpts/inode.c                             |   16 +
 fs/ext3/inode.c                               |   18 +-
 fs/hfs/catalog.c                              |    4 
 fs/hfs/dir.c                                  |   11 +
 fs/hfs/super.c                                |    7 
 fs/jbd2/journal.c                             |    7 
 fs/jffs2/gc.c                                 |    3 
 fs/nfs/write.c                                |    5 
 include/drm/drmP.h                            |    1 
 include/drm/ttm/ttm_memory.h                  |    1 
 include/linux/hrtimer.h                       |    4 
 include/linux/kvm.h                           |    8 
 include/linux/perf_event.h                    |    2 
 include/linux/usb_usual.h                     |    4 
 include/linux/vmalloc.h                       |    2 
 include/net/tcp.h                             |   10 -
 include/trace/ftrace.h                        |    2 
 kernel/acct.c                                 |    3 
 kernel/futex.c                                |   10 -
 kernel/perf_event.c                           |    6 
 kernel/rcutree.c                              |  227 +++++++++++++++-----------
 kernel/rcutree.h                              |   13 -
 kernel/rcutree_plugin.h                       |    4 
 kernel/sched.c                                |   28 ++-
 kernel/sched_debug.c                          |    4 
 kernel/sched_fair.c                           |   35 +++-
 mm/memcontrol.c                               |    1 
 mm/memory.c                                   |    4 
 mm/mincore.c                                  |   37 ++++
 mm/pagewalk.c                                 |   16 +
 mm/vmalloc.c                                  |    2 
 net/core/dev.c                                |   11 +
 net/core/rtnetlink.c                          |    4 
 net/ipv4/ip_output.c                          |    2 
 net/mac80211/cfg.c                            |    3 
 net/mac80211/ieee80211_i.h                    |    1 
 net/mac80211/mesh.h                           |    5 
 net/mac80211/mesh_hwmp.c                      |    2 
 net/mac80211/rx.c                             |    1 
 net/mac80211/scan.c                           |   32 ++-
 net/mac80211/util.c                           |    2 
 net/netfilter/ipvs/ip_vs_ctl.c                |    4 
 net/sunrpc/auth_gss/auth_gss.c                |    2 
 sound/core/hrtimer.c                          |   15 +
 sound/pci/hda/hda_intel.c                     |    5 
 virt/kvm/irq_comm.c                           |    7 
 157 files changed, 1393 insertions(+), 616 deletions(-)

Alan Cox (1):
      matroxfb: fix problems with display stability

Alan Stern (3):
      USB: usb-storage: fix bug in fill_inquiry
      USB: usb-storage: add BAD_SENSE flag
      Driver core: fix race in dev_driver_string

Alex Deucher (5):
      drm/radeon/kms: Add quirk for HIS X1300 board
      drm/radeon/kms: handle vblanks properly with dpms on
      drm/radeon/kms: fix legacy crtc2 dpms
      drm/radeon/kms: fix vram setup on rs600
      drm/radeon/kms: rs6xx/rs740: clamp vram to aperture size

Alexey Dobriyan (1):
      bsdacct: fix uid/gid misreporting

Amerigo Wang (1):
      hfs: fix a potential buffer overflow

Andi Kleen (1):
      futex: Take mmap_sem for get_user_pages in fault_in_user_writeable

Andre Herms (1):
      USB: usbtmc: repeat usb_bulk_msg until whole message is transfered

Arjan van de Ven (1):
      perf_event: Fix invalid type in ioctl definition

Avi Kivity (1):
      KVM: x86 emulator: limit instructions to 15 bytes

Bartlomiej Zolnierkiewicz (1):
      slc90e66: fix UDMA handling

Benjamin Herrenschmidt (1):
      powerpc: Fix usage of 64-bit instruction in 32-bit altivec code

Bob Copeland (1):
      ath5k: allow setting txpower to 0

Bolko Maass (1):
      powerpc/windfarm: Add detection for second cpu pump

Carsten Otte (2):
      KVM: s390: Fix prefix register checking in arch/s390/kvm/sigp.c
      KVM: s390: Make psw available on all exits, not just a subset

Chris Wilson (2):
      drm/i915: Set the error code after failing to insert new offset into mm ht.
      drm/i915: Avoid NULL dereference with component_only tv_modes

Chris Wright (2):
      intel-iommu: Detect DMAR in hyperspace at probe time.
      intel-iommu: ignore page table validation in pass through mode

Cliff Wickman (2):
      x86: SGI UV: Fix BAU initialization
      x86: Fix duplicated UV BAU interrupt vector

Corentin Chary (1):
      asus-laptop: change light sens default values.

Damian Lukowski (1):
      tcp: Stalling connections: Fix timeout calculation routine

Darrick J. Wong (2):
      x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree
      powerpc/therm_adt746x: Record pwm invert bit at module load time]

Dave Jones (2):
      x86: Add new Intel CPU cache size descriptors
      x86: Fix typo in Intel CPU cache size descriptor

David S. Miller (4):
      sparc64: Don't specify IRQF_SHARED for LDC interrupts.
      sparc64: Fix overly strict range type matching for PCI devices.
      sparc64: Fix stack debugging IRQ stack regression.
      sparc: Set UTS_MACHINE correctly.

David Woodhouse (4):
      jffs2: Fix long-standing bug with symlink garbage collection.
      intel-iommu: Apply BIOS sanity checks for interrupt remapping too.
      intel-iommu: Check for an RMRR which ends before it starts.
      intel-iommu: Fix oops with intel_iommu=igfx_off

Eric W. Biederman (1):
      net: Fix userspace RTM_NEWLINK notifications.

Felix Fietkau (1):
      ath9k: fix tx status reporting

Feng Tang (1):
      hrtimer: Fix /proc/timer_list regression

Florian Fainelli (1):
      bcm63xx_enet: fix compilation failure after get_stats_count removal

Gianluca Guida (1):
      Xen balloon: fix totalram_pages counting.

Glauber Costa (1):
      KVM: x86: include pvclock MSRs in msrs_to_save

Greg Kroah-Hartman (1):
      Linux 2.6.32.2

Hendrik Brueckner (1):
      s390: clear high-order bits of registers after sam64

Henrique de Moraes Holschuh (2):
      thinkpad-acpi: fix default brightness_mode for R50e/R51
      thinkpad-acpi: preserve rfkill state across suspend/resume

Hidetoshi Seto (1):
      x86, mce: don't restart timer if disabled

Hugh Dickins (1):
      mm: sigbus instead of abusing oom

Ian Campbell (9):
      xen: re-register runstate area earlier on resume.
      xen: correctly restore pfn_to_mfn_list_list after resume
      xen: register timer interrupt with IRQF_TIMER
      xen: register runstate on secondary CPUs
      xen: call clock resume notifier on all CPUs
      xen: improve error handling in do_suspend.
      xen: don't leak IRQs over suspend/resume.
      xen: explicitly create/destroy stop_machine workqueues outside suspend/resume region.
      xen: try harder to balloon up under memory pressure.

Ian Jackson (1):
      Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Igor Grinberg (1):
      pxa/em-x270: fix usb hub power up/reset sequence

Jan Beulich (1):
      x86/mce: Set up timer unconditionally

Jan Engelhardt (1):
      netfilter: xtables: document minimal required version

Jan Kara (1):
      ext3: Fix data / filesystem corruption when write fails to copy data

Jaroslav Kysela (1):
      ALSA: hda - Terradici HDA controllers does not support 64-bit mode

Javier Cardona (2):
      mac80211: Fixed bug in mesh portal paths
      mac80211: Revert 'Use correct sign for mesh active path refresh'

Jay Fenlason (1):
      firewire: ohci: handle receive packets with a data length of zero

Jeremy Fitzhardinge (5):
      xen/xenbus: make DEVICE_ATTR()s static
      xen: restore runstate_info even if !have_vcpu_info_placement
      xen: don't call dpm_resume_noirq() with interrupts disabled.
      xen: register runstate info for boot CPU early
      xen: use iret for return from 64b kernel to 32b usermode

Joe Perches (1):
      x86: GART: pci-gart_64.c: Use correct length in strncmp

Joerg Roedel (2):
      x86/amd-iommu: attach devices to pre-allocated domains early
      x86/amd-iommu: un__init iommu_setup_msi

Johannes Berg (2):
      mac80211: fix scan abort sanity checks
      tracing: Fix event format export

John W. Linville (1):
      wireless: correctly report signal value for IEEE80211_HW_SIGNAL_UNSPEC

Julia Lawall (1):
      dm exception store: free tmp_store on persistent flag error

Kirill A. Shutemov (1):
      memcg: fix memory.memsw.usage_in_bytes for root cgroup

Kristian Høgsberg (1):
      perf: Don't free perf_mmap_data until work has been done

Larry Finger (2):
      rtl8187: Fix wrong rfkill switch mask for some models
      b43legacy: avoid PPC fault during resume

Leann Ogasawara (1):
      x86: ASUS P4S800 reboot=bios quirk

Li Peng (1):
      drm/i915: Fix sync to vblank when VGA output is turned off

Luis R. Rodriguez (3):
      ath5k: enable EEPROM checksum check
      ath9k: fix processing of TX PS null data frames
      ath9k: Fix maximum tx fifo settings for single stream devices

Marcelo Tosatti (1):
      KVM: fix irq_source_id size verification

Martin Michlmayr (1):
      drm/ttm: Fix build failure due to missing struct page

Mathieu Desnoyers (1):
      debugfs: fix create mutex racy fops and private data

Michael Buesch (1):
      ssb: Fix range check in sprom write

Mikael Pettersson (1):
      x86, apic: Enable lapic nmi watchdog on AMD Family 11h

Mike Galbraith (4):
      sched: Check for an idle shared cache in select_task_rq_fair()
      sched: Fix affinity logic in select_task_rq_fair()
      sched: Rate-limit newidle
      sched: Fix and clean up rate-limit newidle code

Mikulas Patocka (3):
      dm snapshot: only take lock for statustype info not table
      dm: avoid _hash_lock deadlock
      dm snapshot: cope with chunk size larger than origin

Milan Broz (4):
      dm crypt: move private iv fields to structs
      dm crypt: restructure essiv error path
      dm crypt: separate essiv allocation from initialisation
      dm crypt: make wipe message also wipe essiv key

Naoya Horiguchi (2):
      mm: hugetlb: fix hugepage memory leak in mincore()
      mm: hugetlb: fix hugepage memory leak in walk_page_range()

NeilBrown (1):
      md/bitmap: protect against bitmap removal while being updated.

Patrick McHardy (1):
      ip_fragment: also adjust skb->truesize for packets not owned by a socket

Paul E. McKenney (4):
      rcu: Prepare for synchronization fixes: clean up for non-NO_HZ handling of ->completed counter
      rcu: Fix synchronization for rcu_process_gp_end() uses of ->completed counter
      rcu: Fix note_new_gpnum() uses of ->gpnum
      rcu: Remove inline from forward-referenced functions

Paul Mackerras (1):
      perf_event: Fix incorrect range check on cpu number

Peter Feuerer (1):
      acerhdf: add new BIOS versions

Rafael J. Wysocki (1):
      PM / Runtime: Fix lockdep warning in __pm_runtime_set_status()

Rafal Milecki (1):
      V4L/DVB (13116): gspca - ov519: Webcam 041e:4067 added.

Roel Kluin (2):
      V4L/DVB: Fix test in copy_reg_bits()
      SUNRPC: IS_ERR/PTR_ERR confusion

Russ Dill (1):
      USB: Close usb_find_interface race v3

Sarah Sharp (1):
      USB: xhci: Add correct email and files to MAINTAINERS entry.

Sebastian Andrzej Siewior (1):
      UBI: flush wl before clearing update marker

Sergei Shtylyov (2):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)
      USB: musb_gadget_ep0: fix unhandled endpoint 0 IRQs, again

Simon Horman (1):
      ipvs: zero usvc and udest

Stanislav Brabec (1):
      b44 WOL setup: one-bit-off stack corruption kernel panic fix

Sujith (1):
      ath9k: Fix TX hang poll routine

Sukadev Bhattiprolu (1):
      devpts_get_tty() should validate inode

Takashi Iwai (1):
      ALSA: hrtimer - Fix lock-up

Tejun Heo (2):
      x86: Fix iommu=nodac parameter handling
      vmalloc: conditionalize build of pcpu_get_vm_areas()

Theodore Ts'o (1):
      jbd2: don't wipe the journal on a failed journal checksum

Thomas Gleixner (3):
      x86: Prevent GCC 4.4.x (pentium-mmx et al) function prologue wreckage
      x86: Use -maccumulate-outgoing-args for sane mcount prologues
      x86: Fix bogus warning in apic_noop.apic_write()

Tony Luck (1):
      implement early_io{re,un}map for ia64

Trond Myklebust (1):
      NFS: Fix nfs_migrate_page()

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in computing crc over dynamic IEs in beacon

Vivek Natarajan (1):
      mac80211: Fix dynamic power save for scanning.

Xiao Guangrong (1):
      perf_event: Initialize data.period in perf_swevent_hrtimer()

Yong Wang (1):
      x86: Under BIOS control, restore AP's APIC_LVTTHMR to the BSP value

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

Zhao Yakui (2):
      drm/i915: Add the missing clonemask for display port on Ironlake
      ACPI: Use the ARB_DISABLE for the CPU which model id is less than 0x0f.

Zhenyu Wang (2):
      drm/i915: PineView only has LVDS and CRT ports
      drm/i915: Fix LVDS stability issue on Ironlake

Zhu Yi (1):
      ipw2100: fix rebooting hang with driver loaded

zhao.ming9@zte.com.cn (1):
      USB: option: add pid for ZTE

