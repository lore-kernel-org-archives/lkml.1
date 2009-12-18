Return-Path: <linux-kernel-owner+w=401wt.eu-S933331AbZLRXAe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933331AbZLRXAe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:00:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933320AbZLRXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:00:24 -0500
Received: from kroah.org ([198.145.64.141]:38546 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933247AbZLRXAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:00:15 -0500
Date: Fri, 18 Dec 2009 14:59:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.31.9
Message-ID: <20091218225932.GC19026@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.31.9 kernel.  All users of the
2.6.31 kernel series are very strongly encouraged to upgrade.

The updated 2.6.31.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.31.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.31.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/kernel-parameters.txt         |    2 
 Documentation/video4linux/gspca.txt         |    1 
 Makefile                                    |    2 
 arch/arm/mach-pxa/em-x270.c                 |   11 
 arch/powerpc/kernel/vector.S                |    2 
 arch/s390/include/asm/kvm.h                 |    3 
 arch/s390/kvm/kvm-s390.c                    |   25 +-
 arch/sparc/Makefile                         |    2 
 arch/sparc/kernel/ldc.c                     |    4 
 arch/sparc/kernel/of_device_64.c            |   14 -
 arch/sparc/lib/mcount.S                     |    5 
 arch/sparc/mm/init_64.h                     |    2 
 arch/x86/include/asm/mce.h                  |    6 
 arch/x86/kernel/acpi/cstate.c               |    2 
 arch/x86/kernel/amd_iommu.c                 |    8 
 arch/x86/kernel/amd_iommu_init.c            |    2 
 arch/x86/kernel/cpu/intel_cacheinfo.c       |    5 
 arch/x86/kernel/cpu/mcheck/mce.c            |    3 
 arch/x86/kernel/cpu/mcheck/therm_throt.c    |   29 ++
 arch/x86/kernel/cpu/perfctr-watchdog.c      |    2 
 arch/x86/kernel/pci-calgary_64.c            |   12 
 arch/x86/kernel/pci-dma.c                   |    2 
 arch/x86/kernel/pci-gart_64.c               |    2 
 arch/x86/kernel/reboot.c                    |    8 
 arch/x86/kernel/setup.c                     |    3 
 drivers/ata/pata_hpt37x.c                   |   32 +-
 drivers/ata/pata_hpt3x2n.c                  |   17 -
 drivers/firewire/ohci.c                     |   12 
 drivers/gpu/drm/drm_irq.c                   |   34 ++
 drivers/gpu/drm/i915/i915_drv.h             |    5 
 drivers/gpu/drm/i915/i915_reg.h             |    2 
 drivers/gpu/drm/i915/i915_suspend.c         |    2 
 drivers/gpu/drm/i915/intel_crt.c            |    4 
 drivers/gpu/drm/i915/intel_display.c        |   67 +++--
 drivers/gpu/drm/i915/intel_tv.c             |   11 
 drivers/gpu/drm/radeon/radeon_atombios.c    |    8 
 drivers/gpu/drm/radeon/radeon_legacy_crtc.c |    7 
 drivers/ide/cmd64x.c                        |    6 
 drivers/ide/ide-ioctls.c                    |    2 
 drivers/ide/ide-probe.c                     |    9 
 drivers/ide/slc90e66.c                      |    3 
 drivers/isdn/i4l/isdn_ppp.c                 |  342 ++++++++++++----------------
 drivers/macintosh/therm_adt746x.c           |   13 -
 drivers/md/bitmap.c                         |   24 +
 drivers/md/bitmap.h                         |    2 
 drivers/md/md.c                             |    3 
 drivers/md/md.h                             |    1 
 drivers/media/common/tuners/mxl5007t.c      |    2 
 drivers/media/video/gspca/ov519.c           |    1 
 drivers/net/au1000_eth.c                    |   15 -
 drivers/net/b44.c                           |    6 
 drivers/net/smc91x.c                        |    2 
 drivers/net/smsc9420.c                      |   14 +
 drivers/net/wireless/ath/ath5k/eeprom.c     |    3 
 drivers/net/wireless/ath/ath5k/phy.c        |    2 
 drivers/net/wireless/b43legacy/rfkill.c     |    7 
 drivers/net/wireless/ipw2x00/ipw2100.c      |   11 
 drivers/net/wireless/p54/p54usb.c           |   10 
 drivers/platform/x86/asus-laptop.c          |    4 
 drivers/platform/x86/thinkpad_acpi.c        |   36 --
 drivers/serial/8250.c                       |    8 
 drivers/serial/suncore.c                    |   37 +--
 drivers/serial/suncore.h                    |    5 
 drivers/serial/sunhv.c                      |    2 
 drivers/serial/sunsab.c                     |    9 
 drivers/serial/sunsu.c                      |   36 ++
 drivers/serial/sunzilog.c                   |    8 
 drivers/ssb/sprom.c                         |   20 +
 drivers/usb/class/usbtmc.c                  |   14 -
 drivers/usb/core/usb.c                      |   31 +-
 drivers/usb/musb/musb_gadget_ep0.c          |    1 
 drivers/usb/serial/option.c                 |   37 +++
 drivers/usb/storage/transport.c             |   17 +
 drivers/usb/storage/unusual_devs.h          |    7 
 drivers/usb/storage/usb.c                   |   18 -
 drivers/video/backlight/lcd.c               |    2 
 drivers/video/matrox/g450_pll.c             |    3 
 fs/debugfs/inode.c                          |   55 ++--
 fs/devpts/inode.c                           |   16 +
 fs/ext3/inode.c                             |   18 +
 fs/hfs/catalog.c                            |    4 
 fs/hfs/dir.c                                |   11 
 fs/hfs/super.c                              |    7 
 fs/jbd2/journal.c                           |    7 
 fs/jffs2/gc.c                               |    3 
 include/drm/drmP.h                          |    1 
 include/linux/hrtimer.h                     |    4 
 include/linux/isdn_ppp.h                    |    2 
 include/linux/kvm.h                         |    8 
 include/linux/usb_usual.h                   |    4 
 kernel/acct.c                               |    3 
 kernel/futex.c                              |   10 
 mm/mincore.c                                |   37 +++
 mm/pagewalk.c                               |   16 +
 net/8021q/vlan.c                            |    7 
 net/core/dev.c                              |   22 +
 net/core/rtnetlink.c                        |    4 
 net/core/skbuff.c                           |    3 
 net/ipv4/ip_output.c                        |    2 
 net/mac80211/util.c                         |    2 
 net/netfilter/ipvs/ip_vs_ctl.c              |    4 
 net/sunrpc/auth_gss/auth_gss.c              |    2 
 sound/core/hrtimer.c                        |   15 +
 sound/pci/hda/hda_intel.c                   |    5 
 104 files changed, 898 insertions(+), 505 deletions(-)

Alan Cox (1):
      matroxfb: fix problems with display stability

Alan Stern (2):
      USB: usb-storage: fix bug in fill_inquiry
      USB: usb-storage: add BAD_SENSE flag

Alex Deucher (2):
      drm/radeon/kms: Add quirk for HIS X1300 board
      drm/radeon/kms: fix legacy crtc2 dpms

Alexander Beregalov (1):
      Au1x00: fix crash when trying register_netdev()

Alexey Dobriyan (1):
      bsdacct: fix uid/gid misreporting

Amerigo Wang (1):
      hfs: fix a potential buffer overflow

Andi Kleen (1):
      futex: Take mmap_sem for get_user_pages in fault_in_user_writeable

Andre Herms (1):
      USB: usbtmc: repeat usb_bulk_msg until whole message is transfered

Bartlomiej Zolnierkiewicz (1):
      slc90e66: fix UDMA handling

Benjamin Herrenschmidt (1):
      powerpc: Fix usage of 64-bit instruction in 32-bit altivec code

Bob Copeland (1):
      ath5k: allow setting txpower to 0

Carsten Otte (1):
      KVM: s390: Make psw available on all exits, not just a subset

Chris Wilson (1):
      drm/i915: Avoid NULL dereference with component_only tv_modes

Corentin Chary (1):
      asus-laptop: change light sens default values.

Darrick J. Wong (2):
      x86, Calgary IOMMU quirk: Find nearest matching Calgary while walking up the PCI tree
      powerpc/therm_adt746x: Record pwm invert bit at module load time]

Dave Jones (2):
      x86: Add new Intel CPU cache size descriptors
      x86: Fix typo in Intel CPU cache size descriptor

David S. Miller (14):
      Revert "ide: try to use PIO Mode 0 during probe if possible"
      b44: Fix wedge when using netconsole.
      Revert "isdn: isdn_ppp: Use SKB list facilities instead of home-grown implementation."
      sparc64: Fix definition of VMEMMAP_SIZE.
      sunsab: Do not set sunsab_reg.cons right before registering minors.
      sunsu: Fix detection of SU ports which are RSC console or control.
      serial: suncore: Add 'ignore_line' argument to sunserial_console_match().
      serial: suncore: Fix RSC/LOM handling in sunserial_console_termios().
      sunsu: Pass true 'ignore_line' to console match when RSC or LOM console.
      sunsu: Use sunserial_console_termios() in sunsu_console_setup().
      sparc64: Don't specify IRQF_SHARED for LDC interrupts.
      sparc64: Fix overly strict range type matching for PCI devices.
      sparc64: Fix stack debugging IRQ stack regression.
      sparc: Set UTS_MACHINE correctly.

David Woodhouse (1):
      jffs2: Fix long-standing bug with symlink garbage collection.

Eric Dumazet (2):
      net: Fix the rollback test in dev_change_name()
      vlan: Fix register_vlan_dev() error path

Eric W. Biederman (1):
      net: Fix userspace RTM_NEWLINK notifications.

Feng Tang (1):
      hrtimer: Fix /proc/timer_list regression

Greg Kroah-Hartman (1):
      Linux 2.6.31.9

Hemant Pedanekar (1):
      ide: fix ioctl to pass requested transfer mode to ide_find_dma_mode instead of UDMA6

Henrique de Moraes Holschuh (2):
      thinkpad-acpi: fix default brightness_mode for R50e/R51
      thinkpad-acpi: preserve rfkill state across suspend/resume

Herbert Xu (1):
      gro: Fix illegal merging of trailer trash

Ian Jackson (1):
      Serial: Do not read IIR in serial8250_start_tx when UART_BUG_TXEN

Igor Grinberg (1):
      pxa/em-x270: fix usb hub power up/reset sequence

Jan Beulich (1):
      x86/mce: Set up timer unconditionally

Jan Kara (1):
      ext3: Fix data / filesystem corruption when write fails to copy data

Jaroslav Kysela (1):
      ALSA: hda - Terradici HDA controllers does not support 64-bit mode

Jay Fenlason (1):
      firewire: ohci: handle receive packets with a data length of zero

Jean Delvare (1):
      backlight: lcd - Fix wrong sizeof

Jesse Barnes (1):
      drm/i915: save/restore BLC histogram control reg across suspend/resume

Joe Perches (1):
      x86: GART: pci-gart_64.c: Use correct length in strncmp

Joerg Roedel (2):
      x86/amd-iommu: attach devices to pre-allocated domains early
      x86/amd-iommu: un__init iommu_setup_msi

Larry Finger (2):
      b43legacy: avoid PPC fault during resume
      p54usb: Remove DMA buffer from stack

Leann Ogasawara (1):
      x86: ASUS P4S800 reboot=bios quirk

Li Peng (1):
      drm/i915: Fix sync to vblank when VGA output is turned off

Luis R. Rodriguez (1):
      ath5k: enable EEPROM checksum check

Mathieu Desnoyers (1):
      debugfs: fix create mutex racy fops and private data

Michael Buesch (1):
      ssb: Fix range check in sprom write

Mikael Pettersson (1):
      x86, apic: Enable lapic nmi watchdog on AMD Family 11h

Mikulas Patocka (1):
      ide: Serialize CMD643 and CMD646 to fix a hardware bug with SSD

Naoya Horiguchi (2):
      mm: hugetlb: fix hugepage memory leak in mincore()
      mm: hugetlb: fix hugepage memory leak in walk_page_range()

NeilBrown (1):
      md/bitmap: protect against bitmap removal while being updated.

Patrick McHardy (1):
      ip_fragment: also adjust skb->truesize for packets not owned by a socket

Rafal Milecki (1):
      V4L/DVB (13116): gspca - ov519: Webcam 041e:4067 added.

Roel Kluin (2):
      SUNRPC: IS_ERR/PTR_ERR confusion
      V4L/DVB: Fix test in copy_reg_bits()

Russ Dill (1):
      USB: Close usb_find_interface race v3

Russell King - ARM Linux (1):
      NET: smc91x: Fix irq flags

Sergei Shtylyov (2):
      pata_hpt{37x|3x2n}: fix timing register masks (take 2)
      USB: musb_gadget_ep0: fix unhandled endpoint 0 IRQs, again

Simon Horman (1):
      ipvs: zero usvc and udest

Stanislav Brabec (1):
      b44 WOL setup: one-bit-off stack corruption kernel panic fix

Steve Glendinning (1):
      smsc9420: prevent BUG() if ethtool is called with interface down

Sukadev Bhattiprolu (1):
      devpts_get_tty() should validate inode

Takashi Iwai (1):
      ALSA: hrtimer - Fix lock-up

Tejun Heo (1):
      x86: Fix iommu=nodac parameter handling

Theodore Ts'o (1):
      jbd2: don't wipe the journal on a failed journal checksum

Vasanthakumar Thiagarajan (1):
      mac80211: Fix bug in computing crc over dynamic IEs in beacon

Yong Wang (1):
      x86: Under BIOS control, restore AP's APIC_LVTTHMR to the BSP value

Zhang Le (1):
      USB: option.c: add support for D-Link DWM-162-U5

Zhao Yakui (1):
      ACPI: Use the ARB_DISABLE for the CPU which model id is less than 0x0f.

Zhenyu Wang (3):
      drm/i915: Fix CRT hotplug detect by checking really no channels attached
      drm/i915: Fix LVDS stability issue on Ironlake
      drm/i915: PineView only has LVDS and CRT ports

Zhu Yi (1):
      ipw2100: fix rebooting hang with driver loaded

zhao.ming9@zte.com.cn (1):
      USB: option: add pid for ZTE

