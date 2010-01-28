Return-Path: <linux-kernel-owner+w=401wt.eu-S1756253Ab0A1Xh5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756253Ab0A1Xh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:37:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753919Ab0A1Xh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:37:56 -0500
Received: from kroah.org ([198.145.64.141]:46832 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0A1Xhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:37:55 -0500
Date: Thu, 28 Jan 2010 15:35:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       torvalds@linux-foundation.org, stable@kernel.org
Cc: lwn@lwn.net
Subject: Linux 2.6.32.7
Message-ID: <20100128233558.GA18110@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm announcing the release of the 2.6.32.7 kernel.  All users of the
2.6.32 kernel series are very strongly encouraged to upgrade.

This release is brought to you by the very appreciated efforts of the
Debian, Gentoo, and Novell kernel teams, who spent a lot of time to
flush out patches that were in their trees to me for inclusion.  Special
thanks goes to Ben Hutchings for doing a lot of this work.

The updated 2.6.32.y git tree can be found at:
        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.32.y.git
and can be browsed at the normal kernel.org git web browser:
        http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.32.y.git;a=summary

thanks,

greg k-h

------------

 Documentation/DocBook/Makefile              |   21 +-
 Documentation/video4linux/CARDLIST.saa7134  |    1 
 Makefile                                    |    2 
 arch/arm/mach-davinci/dm646x.c              |    9 -
 arch/powerpc/sysdev/fsl_pci.c               |   14 +
 arch/s390/kvm/intercept.c                   |    4 
 arch/x86/kernel/cpu/intel.c                 |    1 
 arch/x86/kernel/cpuid.c                     |    2 
 arch/x86/kernel/msr.c                       |    2 
 arch/x86/kernel/tsc.c                       |    1 
 arch/x86/kvm/lapic.c                        |   11 -
 arch/x86/kvm/mmu.c                          |    6 
 arch/x86/kvm/paging_tmpl.h                  |    4 
 arch/x86/kvm/x86.c                          |    6 
 drivers/acpi/processor_idle.c               |   21 +-
 drivers/ata/ahci.c                          |   20 ++
 drivers/ata/ata_piix.c                      |    6 
 drivers/base/devtmpfs.c                     |    3 
 drivers/firmware/dmi_scan.c                 |   15 +
 drivers/hid/usbhid/hid-core.c               |    3 
 drivers/hid/usbhid/hid-quirks.c             |    2 
 drivers/hwmon/fschmd.c                      |    7 
 drivers/infiniband/ulp/ipoib/ipoib_main.c   |    1 
 drivers/input/mouse/alps.c                  |  252 +++++++++++++++++++++++++---
 drivers/input/mouse/alps.h                  |    1 
 drivers/input/serio/i8042-x86ia64io.h       |  158 +++++++++--------
 drivers/md/md.c                             |    2 
 drivers/media/dvb/siano/smsusb.c            |   10 +
 drivers/media/video/saa7134/saa7134-cards.c |   31 +++
 drivers/media/video/saa7134/saa7134-dvb.c   |    1 
 drivers/media/video/saa7134/saa7134.h       |    1 
 drivers/media/video/uvc/uvc_ctrl.c          |    2 
 drivers/mtd/ubi/upd.c                       |    1 
 drivers/mtd/ubi/vtbl.c                      |    1 
 drivers/net/atl1c/atl1c.h                   |    6 
 drivers/net/atl1c/atl1c_main.c              |   72 +++-----
 drivers/net/atl1e/atl1e_main.c              |   36 ----
 drivers/net/benet/be.h                      |   15 +
 drivers/net/benet/be_main.c                 |    2 
 drivers/net/qlge/qlge_main.c                |   30 +--
 drivers/net/qlge/qlge_mpi.c                 |    3 
 drivers/net/sfc/tx.c                        |    4 
 drivers/net/wireless/ath/ar9170/usb.c       |    4 
 drivers/net/wireless/iwlwifi/iwl-5000.c     |    4 
 drivers/pci/pcie/aer/aer_inject.c           |    8 
 drivers/pci/setup-bus.c                     |   11 -
 drivers/s390/cio/device.c                   |   11 -
 drivers/s390/cio/device_fsm.c               |   25 --
 drivers/s390/net/netiucv.c                  |    4 
 drivers/scsi/device_handler/scsi_dh.c       |   11 -
 drivers/scsi/fcoe/fcoe.c                    |   15 +
 drivers/scsi/libfc/fc_disc.c                |    2 
 drivers/scsi/libfc/fc_elsct.c               |    4 
 drivers/scsi/libfc/fc_fcp.c                 |   35 ++-
 drivers/scsi/libfc/fc_lport.c               |   33 ++-
 drivers/scsi/libfc/fc_rport.c               |   82 ++++++---
 drivers/scsi/lpfc/lpfc_init.c               |   16 +
 drivers/scsi/mpt2sas/mpi/mpi2_cnfg.h        |    8 
 drivers/scsi/mpt2sas/mpt2sas_scsih.c        |   18 ++
 drivers/scsi/scsi_devinfo.c                 |    9 -
 drivers/scsi/scsi_transport_fc.c            |   68 ++++---
 drivers/scsi/scsi_transport_iscsi.c         |    9 -
 drivers/usb/serial/ftdi_sio.c               |   14 +
 drivers/usb/serial/ftdi_sio.h               |   14 +
 drivers/usb/serial/mos7840.c                |   24 ++
 drivers/watchdog/iTCO_wdt.c                 |  115 ++++++++----
 fs/fcntl.c                                  |    6 
 fs/nfs/super.c                              |    2 
 fs/nfsd/nfs4acl.c                           |    2 
 fs/partitions/efi.c                         |   30 ++-
 fs/partitions/efi.h                         |    8 
 fs/super.c                                  |    3 
 include/acpi/platform/aclinux.h             |    2 
 include/linux/clocksource.h                 |    2 
 include/linux/hid.h                         |    1 
 include/linux/pci_ids.h                     |   14 +
 include/linux/time.h                        |    1 
 include/scsi/fc_frame.h                     |    3 
 include/scsi/libfc.h                        |    1 
 init/calibrate.c                            |   24 +-
 ipc/msg.c                                   |    1 
 ipc/sem.c                                   |    1 
 ipc/shm.c                                   |    1 
 kernel/cpu.c                                |    5 
 kernel/sched.c                              |   34 ++-
 kernel/sched_fair.c                         |   16 +
 kernel/time/clockevents.c                   |    5 
 kernel/time/clocksource.c                   |   44 ++++
 kernel/time/tick-sched.c                    |   52 ++++-
 kernel/time/timekeeping.c                   |   11 +
 net/mac80211/cfg.c                          |    3 
 net/netfilter/xt_conntrack.c                |   61 +-----
 net/wireless/sme.c                          |    1 
 sound/pci/hda/hda_intel.c                   |    3 
 sound/pci/hda/patch_intelhdmi.c             |    2 
 sound/pci/hda/patch_realtek.c               |   10 -
 sound/pci/ice1712/juli.c                    |   32 +++
 sound/soc/codecs/wm8903.c                   |    3 
 virt/kvm/eventfd.c                          |   15 +
 virt/kvm/irq_comm.c                         |   12 +
 100 files changed, 1182 insertions(+), 563 deletions(-)

Abhijeet Joglekar (1):
      libfc: remote port gets stuck in restart state without really restarting

Abhijeet Kolekar (1):
      cfg80211: fix channel setting for wext

Ajit Khaparde (2):
      be2net: Add support for next generation of BladeEngine device.
      be2net: Add the new PCI IDs to PCI_DEVICE_TABLE.

Aleksey Kunitskiy (1):
      ALSA: ice1724 - Patch for suspend/resume for ESI Juli@

Alex Williamson (1):
      PCI: Always set prefetchable base/limit upper32 registers

Artem Bityutskiy (1):
      UBI: fix memory leak in update path

Avi Kivity (1):
      KVM: Fix race between APIC TMR and IRR

Bartlomiej Zolnierkiewicz (1):
      ata_piix: fix MWDMA handling on PIIX3

Ben Hutchings (3):
      powerpc/fsl: Add PCI device ids for new QoirQ chips
      V4L/DVB (13680a): DocBook/media: copy images after building HTML
      V4L/DVB (13680b): DocBook/media: create links for included sources

Benoit Papillault (1):
      mac80211: check that ieee80211_set_power_mgmt only handles STA interfaces.

Chandra Seetharaman (1):
      scsi_dh: create sysfs file, dh_state for all SCSI disk devices

Chris Leech (1):
      libfc: fix memory corruption caused by double frees and bad error handling

Christian Borntraeger (1):
      KVM: S390: fix potential array overrun in intercept handling

Christian Ehrhardt (1):
      sched: Fix missing sched tunable recalculation on cpu add/remove

Chuck Lever (1):
      NFS: Revert default r/wsize behavior

Cliff Brake (2):
      USB: mos7840: add device IDs for B&B electronics devices
      USB: ftdi_sio: add USB device ID's for B&B Electronics line

Danny Wood (1):
      V4L/DVB (13168): Add support for Asus Europa Hybrid DVB-T card (SAA7134 SubVendor ID: 0x1043 Device ID: 0x4847)

David J. Wilder (1):
      IPoIB: Clear ipoib_neigh.dgid in ipoib_neigh_alloc()

Dmitry Torokhov (3):
      DMI: allow omitting ident strings in DMI tables
      Input: i8042 - remove identification strings from DMI tables
      Input: i8042 - add Gigabyte M1022M to the noloop list

Elliott Sales de Andrade (1):
      Input: i8042 - add Dritek quirk for Acer Aspire 5610.

Florian Westphal (1):
      netfilter: xtables: fix conntrack match v1 ipt-save output

Frank Filz (1):
      nfsd: Fix sort_pacl in fs/nfsd/nf4acl.c to actually sort groups

Greg Kroah-Hartman (2):
      fnctl: f_modown should call write_lock_irqsave/restore
      Linux 2.6.32.7

Guennadi Liakhovetski (1):
      ASoC: fix a memory-leak in wm8903

H Hartley Sweeten (1):
      clockevents: Add missing include to pacify sparse

Hans de Goede (1):
      hwmon: (fschmd) Fix a memleak on multiple opens of /dev/watchdog

Heiko Carstens (1):
      driver-core: fix devtmpfs crash on s390

Hemant Pedanekar (1):
      davinci: dm646x: Add support for 3.x silicon revision

Imre Kaloz (1):
      iTCO_wdt: add PCI ID for the Intel EP80579 (Tolapai) SoC

Jie Yang (2):
      atl1c:use common_task instead of reset_task and link_chg_task
      atl1e:disable NETIF_F_TSO6 for hardware limit

Jiri Kosina (1):
      HID: fixup quirk for NCR devices

Jiri Slaby (1):
      KVM: fix lock imbalance in kvm_*_irq_source_id()

Joe Eykholt (4):
      libfc: fix typo in retry check on received PRLI
      libfc: lport: fix minor documentation errors
      libfc: don't WARN_ON in lport_timeout for RESET state
      libfc: fix free of fc_rport_priv with timer pending

Jon Hunter (1):
      nohz: Prevent clocksource wrapping during idle

Karel Zak (2):
      partitions: read whole sector with EFI GPT header
      partitions: use sector size for EFI GPT

Kashyap, Desai (1):
      mpt2sas: New device SAS2208 support is added

Kay Sievers (2):
      Driver-Core: devtmpfs - set root directory mode to 0755
      vfs: get_sb_single() - do not pass options twice

Laurent Pinchart (1):
      V4L/DVB (13826): uvcvideo: Fix controls blacklisting

Len Brown (1):
      ACPI: enable C2 and Turbo-mode on Nehalem notebooks on A/C

Marcelo Tosatti (2):
      KVM: MMU: bail out pagewalk on kvm_read_guest error
      KVM: only clear irq_source_id if irqchip is present

Michael Krufky (1):
      V4L/DVB (13569): smsusb: add autodetection support for five additional Hauppauge USB IDs

Michael Reed (2):
      scsi_transport_fc: remove invalid BUG_ON
      lpfc: fix hang on SGI ia64 platform

Michael S. Tsirkin (1):
      KVM: only allow one gsi per fd

Mike Christie (2):
      iscsi class: modify handling of replacement timeout
      fcoe: initialize return value in fcoe_destroy

Mike Travis (1):
      timers, init: Limit the number of per cpu calibration bootup messages

Neil Turton (1):
      sfc: Fix DMA mapping cleanup in case of an error in TSO

NeilBrown (1):
      md: fix small irregularity with start_ro module parameter

Pallipadi, Venkatesh (1):
      x86: Reenable TSC sync check at boot, even with NONSTOP_TSC

Peter Horton (1):
      UBI: initialise update marker

Peter Oberparleiter (2):
      cio: fix double free in case of probe failure
      cio: dont panic in non-fatal conditions

Ron Mercer (5):
      qlge: Remove explicit setting of PCI Dev CTL reg.
      qlge: Set PCIE max read request size.
      qlge: Don't fail open when port is not initialized.
      qlge: Add handler for DCBX firmware event.
      qlge: Bonding fix for mode 6.

Russ Anderson (1):
      x86, msr/cpuid: Pass the number of minors when unregistering MSR and CPUID drivers.

Rusty Russell (1):
      sched: Fix isolcpus boot option

Sebastian Kapfer (1):
      Input: ALPS - add interleaved protocol support (Dell E6x00 series)

Serge E. Hallyn (1):
      ipc ns: fix memory leak (idr)

Seth Heasley (2):
      iTCO_wdt: Add support for Intel Ibex Peak
      iTCO_wdt: Add Intel Cougar Point and PCH DeviceIDs

Shaohua Li (1):
      ahci: disable SNotification capability for ich8

Sheng Yang (1):
      KVM: x86: Fix host_mapping_level()

Song Youquan (1):
      PCI: AER: fix aer inject result in kernel oops

Stefan Ringel (1):
      ALSA: hda - Add PCI IDs for Nvidia G2xx-series

Takahiro Yasui (1):
      scsi_devinfo: update Hitachi entries (v2)

Takashi Iwai (3):
      ALSA: hda - Fix quirk for Maxdata obook4-1
      ALSA: hda - Add missing Line-Out and PCM switches as slave
      ALSA: hda - Fix HP T5735 automute

Thomas Klute (1):
      ar9170: Add support for D-Link DWA 160 A2

Ursula Braun (1):
      netiucv: displayed TX bytes value much too high

Vasu Dev (1):
      fcoe, libfc: fix an libfc issue with queue ramp down in libfc

Wei Yongjun (2):
      KVM: x86: Fix probable memory leak of vcpu->arch.mce_banks
      KVM: x86: Fix leak of free lapic date in kvm_arch_vcpu_init()

Wey-Yi Guy (1):
      iwlwifi: Fix throughput stall issue in HT mode for 5000

Wim Van Sebroeck (1):
      iTCO_wdt.c - cleanup chipset documentation

Wu Fengguang (1):
      ALSA: hda - select IbexPeak handler for Calpella

Xiaotian Feng (2):
      clockevent: Don't remove broadcast device when cpu is dead
      ACPI: don't cond_resched if irq is disabled

Yi Zou (6):
      libfc: fix ddp in fc_fcp for 0 xid
      fcoe: remove redundant checking of netdev->netdev_ops
      libfc: Fix wrong scsi return status under FC_DATA_UNDRUN
      libfc: Fix frags in frame exceeding SKB_MAX_FRAGS in fc_fcp_send_data
      fcoe: Fix checking san mac address
      fcoe: Fix getting san mac for VLAN interface

