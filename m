Return-Path: <linux-kernel-owner+w=401wt.eu-S1753733AbYK2J0w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753733AbYK2J0w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2008 04:26:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751047AbYK2J0m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Nov 2008 04:26:42 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:44536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbYK2J01 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2008 04:26:27 -0500
Date: Sat, 29 Nov 2008 10:26:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Jirka Pirko <jirka@pirko.cz>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] get rid of some "may be used uninitialized" compiler
	warnings
Message-ID: <20081129092601.GA26691@elte.hu>
References: <20081129003347.2295622f@jirka.pirko.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081129003347.2295622f@jirka.pirko.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Jirka Pirko <jirka@pirko.cz> wrote:

> Just used uninitialized_var() macro when it's appropriate. I checked 
> that warning is meaningless in all these cases.
> 
> Signed-off-by: Jirka Pirko <jirka@pirko.cz>
> ---
>  arch/x86/kernel/cpu/mtrr/main.c |    2 +-
>  drivers/ata/sata_via.c          |    2 +-
>  drivers/net/niu.c               |    4 ++--
>  drivers/video/aty/aty128fb.c    |    2 +-
>  kernel/cpuset.c                 |    2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)

that's not an adequate detail of analysis.

For a full range of warning fixes and a per commit explanation of exactly 
why a warning should be annotated (or the underlying bug be fixed), see 
the commits in the tree below.

	Ingo

===============>
The latest auto-warnings-next git tree can be found at:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git auto-warnings-next


David Howells (5):
      warnings: fix xfs posix acl
      warnings: disable i2o on 64bit
      werror: modtable warnings
      werror: config option
      werror: config, rework

Ingo Molnar (192):
      include/asm-generic/bug.h - fix warning in net/sched/sch_generic.c
      include/asm-generic/bug.h - fix warning in mm/bootmem.c
      fix warning in fs/dcache.c
      fix warning in drivers/hwmon/adt7473.c
      fix warning in net/rfkill/rfkill.c
      fix warning in kernel/power/snapshot.c
      fix warning in kernel/audit.c
      fix warning in net/packet/af_packet.c
      fix warning in mm/mempolicy.c
      fix warning in arch/x86/kernel/genx2apic_uv_x.c
      fix warning in security/selinux/netnode.c
      fix warning in drivers/hwmon/i5k_amb.c
      fix warning in drivers/ata/pata_atiixp.c
      fix warning in net/sunrpc/svcauth_unix.c
      fix warning in fs/udf/truncate.c
      fix warning in drivers/memstick/core/mspro_block.c
      fix warning in drivers/net/sky2.c
      fix warning in fs/nfs/client.c
      fix warning in block/cfq-iosched.c
      fix warning in sound/soc/codecs/wm8903.c
      x86: fix default_spin_lock_flags() prototype
      drivers/ide/pci/hpt366.c: remove unused variable
      drivers/net/wireless/b43/phy_g.c: type check debug printouts
      drivers/video/cirrusfb.c: remove unused variables
      fs/afs/dir.c: fix uninitialized variable use
      net/netlabel/netlabel_addrlist.c: add type checking to audit_log_format()
      include/linux/fs.h: improve type checking of __mandatory_lock()
      [vfs] fs.h: fops_get()/fops_put(): use pointer comparison
      net/mac80211/rc80211_minstrel_debugfs.c: fix return type
      sound/soc/codecs/tlv320aic23.c: remove unused variable
      fix warning in drivers/isdn/hardware/eicon/message.c
      fix warning in drivers/pci/search.c
      fix warning in fs/compat_binfmt_elf.c
      fix warning in kernel/power/main.c
      fix warning in drivers/watchdog/i6300esb.c
      fix warning in drivers/isdn/sc/init.c
      fix warning in drivers/input/touchscreen/htcpen.c
      fix warning in drivers/infiniband/hw/amso1100/c2_vq.c
      fix warning in drivers/isdn/icn/icn.c
      fix warning in drivers/mca/mca-legacy.c
      fix warning in drivers/isdn/sc/shmem.c
      fix warning in drivers/scsi/g_NCR5380.c
      fix warning in drivers/net/3c523.c
      fix warning in drivers/net/depca.c
      fix warning in drivers/isdn/sc/ioctl.c
      fix warning in drivers/isdn/sc/timer.c
      fix warning in drivers/scsi/dtc.c
      fix warning in drivers/mfd/ucb1400_core.c
      fix warning in drivers/watchdog/w83697ug_wdt.c
      fix warning in drivers/net/wireless/iwlwifi/iwl-scan.c
      fix warning in drivers/media/dvb/dvb-usb/anysee.c
      fix warning in net/netfilter/nf_conntrack_proto_tcp.c
      fix warning in fs/coda/sysctl.c
      fix warning in drivers/video/aty/atyfb_base.c
      fix warning in drivers/video/aty/atyfb_base.c, #2
      include/linux/init.h: fix warning in drivers/crypto/hifn_795x.c
      fix warning in drivers/net/atlx/atl2.c
      fix warning in arch/x86/kernel/scx200_32.c
      fix warning in drivers/char/rocket.c
      werror: enable more widely
      werror: fix rename of config option
      warnings, kbuild: allow scripts to override -Werror warnings
      werror: depends on !ENABLE_WARN_DEPRECATED && !ENABLE_MUST_CHECK
      fix warning in net/netfilter/ipvs/ip_vs_ctl.c
      fix warning in net/netfilter/nf_conntrack_proto_sctp.c
      fix warning in drivers/isdn/i4l/isdn_common.c
      fix warning in arch/x86/kernel/cpu/intel_cacheinfo.c
      fix warning in drivers/scsi/advansys.c
      fix warning in sound/pci/hda/patch_sigmatel.c
      fix warning in drivers/net/wireless/ray_cs.c
      fix warning in kernel/profile.c
      fix warning in drivers/message/fusion/mptbase.c
      fix warning in ipc/ipc_sysctl.c
      fix warning in drivers/char/rtc.c
      fix warning in drivers/video/matrox/matroxfb_crtc2.c
      fix warning in net/bluetooth/rfcomm/sock.c
      fix warning in net/sunrpc/xprtrdma/verbs.c
      fix warning in sound/pci/cs46xx/cs46xx_lib.c
      fix warnings in drivers/acpi/sbs.c
      fix warning in net/ax25/sysctl_net_ax25.c
      #ifdef complications in drivers/acpi/sleep/main.c
      fix warning in drivers/pci/pci-driver.c
      fix warning in drivers/base/platform.c
      fix warning in arch/x86/kernel/early-quirks.c
      fix warning in drivers/isdn/i4l/isdn_ppp.c
      fix warning in arch/x86/kernel/setup.c
      fix warning in drivers/net/mlx4/mcg.c
      work around warning in fs/xfs/xfs_rtalloc.c
      fix warning in fs/ext4/extents.c
      fix warning in net/dccp/options.c
      work around warning in fs/xfs/xfs_mount.c
      annotate warning in fs/jfs/jfs_dmap.c
      fix warning in drivers/video/sis/sis_main.c
      vfs: turn vfs_lock_file() from macro into inline, on !FILE_LOCKING
      vfs: warning in fs/nfsd/nfsxdr.c
      nfsd: fix unused variable in fs/nfsd/nfsxdr.c
      vfs: warning in fs/nfsd/nfs4state.c
      improve the structure of pnpbios_thread_init()
      fix !CONFIG_PCI related warning in drivers/char/cs5535_gpio.c
      fix warnings in drivers/video/mb862xx/mb862xxfb.c
      fix warning in sound/pci/pcxhr/pcxhr_core.c
      fix warning in sound/pci/pcxhr/pcxhr_mixer.c
      warning in sound/pci/pcxhr/pcxhr.c
      fix warning in drivers/acpi/toshiba_acpi.c
      fix warning in drivers/char/ipmi/ipmi_msghandler.c
      fix warning in drivers/char/isicom.c
      warning in fs/eventpoll.c
      crypto: fix error flow of crypto/testmgr.c:test_comp()
      werror: fix warning in drivers/misc/fujitsu-laptop.c
      sched, cpusets: fix warning in kernel/cpuset.c
      fix warning in mm/swapfile.c
      markers: fix warning in kernel/marker.c
      fix warning in block/bsg.c
      fix warning in drivers/acpi/executer/exprep.c
      fix warning in drivers/ata/libata-core.c
      fix warning in drivers/ata/libata-scsi.c
      fix uninitialized memory use in drivers/atm/ambassador.c
      fix warning in drivers/atm/horizon.c
      fix warning in drivers/block/DAC960.c
      fix warning in drivers/isdn/capi/capidrv.c
      fix warning in drivers/md/dm-raid1.c
      fix warning in drivers/media/common/tuners/mxl5007t.c
      fix warning in drivers/media/dvb/frontends/drx397xD.c
      fix warnings in drivers/media/dvb/ttusb-dec/ttusb_dec.c
      fix warning in drivers/media/video/cx18/cx18-mailbox.c
      fix drivers/media/video/usbvideo/quickcam_messenger.c
      fix warning in drivers/media/video/usbvision/usbvision-i2c.c
      fix warning in drivers/misc/sgi-gru/grufault.c
      fix warning in drivers/net/cassini.c
      fix error path in drivers/net/mlx4/en_rx.c
      fix warning in drivers/net/wireless/ath9k/rc.c
      fix warning in drivers/net/wireless/b43/main.c
      fix warning in drivers/net/wireless/iwlwifi/iwl-3945.c
      fix warning in fs/locks.c
      x86: fix warning in arch/x86/pci/amd_bus.c
      fix warning in drivers/ata/sata_via.c
      fix warning in drivers/net/sis900.c
      remove unused code from drivers/rtc/rtc-ds1390.c
      fix warnings in fs/befs/linuxvfs.c
      fix warning in fs/cifs/cifssmb.c
      fix warning in fs/configfs/symlink.c
      fix warning in fs/dlm/netlink.c
      fix warning in net/dsa/mv88e6060.c
      fix warning in net/dsa/mv88e6xxx.c
      fix warning in net/ipv6/ip6_flowlabel.c
      fix warning in net/netfilter/nf_conntrack_ftp.c
      fix warning in drivers/scsi/lpfc/lpfc_els.c
      fix warning in drivers/scsi/megaraid/megaraid_mm.c
      fix warning in drivers/usb/serial/io_edgeport.c
      fix warning in drivers/uwb/i1480/i1480-est.c
      fix warning in drivers/uwb/whc-rc.c
      fix warnings in drivers/uwb/wlp/messages.c
      fix warnings in drivers/video/sis/init301.c
      fix warning in drivers/watchdog/w83697ug_wdt.c
      fix warning in fs/cifs/readdir.c
      fix warnings in fs/ecryptfs/keystore.c
      fix warnings in fs/fat/namei_vfat.c
      fix warning in net/sched/sch_hfsc.c
      fix warning in net/sunrpc/xprtrdma/svc_rdma_transport.c
      fix warning in drivers/net/qla3xxx.c
      fix warning in drivers/scsi/qla4xxx/ql4_mbx.c
      fix warning in drivers/usb/serial/keyspan.c
      fix warnings in drivers/usb/serial/keyspan_pda.c
      fix warning in fs/ocfs2/aops.c
      fix warnings in fs/omfs/file.c
      fix warning in fs/ocfs2/ioctl.c
      fix warning in drivers/net/niu.c
      fix warnings in drivers/net/niu.c
      fix warning in drivers/net/s2io.c
      fix warning in drivers/usb/serial/mos7720.c
      fix assignment in fs/reiserfs/do_balan.c
      fix warning in drivers/scsi/advansys.c
      fix warning in fs/ocfs2/cluster/heartbeat.c
      fix warning in fs/ocfs2/stack_user.c
      fix warnings in fs/reiserfs/lbalance.c
      fix warning in fs/ocfs2/slot_map.c
      fix type unsafe pointer use in drivers/pci/hotplug/cpqphp_core.c
      fix warning in drivers/mtd/devices/phram.c
      fix warning in drivers/scsi/ncr53c8xx.c
      fix warning in sound/isa/sb/sb8.c
      fix warning in drivers/net/wan/z85230.c
      fix warning in drivers/isdn/hardware/eicon/maintidi.c
      fix warning in drivers/isdn/hysdn/hysdn_net.c
      fix warning in drivers/mtd/devices/mtd_dataflash.c
      fix warning in sound/pci/via82xx_modem.c
      fix warning in sound/pci/via82xx.c
      fix warning in sound/pci/vx222/vx222.c
      Revert "ACPI suspend: fix build warning when CONFIG_ACPI_SLEEP=n"
      fix warnings in drivers/net/wireless/zd1201.c
      fix warning in drivers/usb/atm/ueagle-atm.c
      fix warning in drivers/usb/serial/io_edgeport.c
      fix warning in arch/x86/boot/video-mode.c


 Makefile                                          |    4 +
 arch/x86/boot/video-mode.c                        |    2 +-
 arch/x86/kernel/cpu/intel_cacheinfo.c             |    6 +-
 arch/x86/kernel/early-quirks.c                    |    2 +
 arch/x86/kernel/genx2apic_uv_x.c                  |    5 +-
 arch/x86/kernel/paravirt-spinlocks.c              |    3 +-
 arch/x86/kernel/scx200_32.c                       |    6 +-
 arch/x86/kernel/setup.c                           |    2 +
 arch/x86/pci/amd_bus.c                            |    4 +-
 block/bsg.c                                       |    2 +-
 block/cfq-iosched.c                               |    1 +
 crypto/testmgr.c                                  |    2 +-
 drivers/acpi/executer/exprep.c                    |    2 +-
 drivers/acpi/sbs.c                                |    7 ++
 drivers/acpi/sleep/main.c                         |   12 +-
 drivers/acpi/toshiba_acpi.c                       |    4 +-
 drivers/ata/libata-core.c                         |    2 +-
 drivers/ata/libata-scsi.c                         |    2 +-
 drivers/ata/pata_atiixp.c                         |    2 +-
 drivers/ata/sata_via.c                            |    2 +-
 drivers/atm/ambassador.c                          |    2 +-
 drivers/atm/horizon.c                             |    2 +-
 drivers/base/platform.c                           |   10 +-
 drivers/block/DAC960.c                            |    3 +-
 drivers/char/ip2/ip2main.c                        |    2 +-
 drivers/char/ipmi/ipmi_msghandler.c               |    6 +-
 drivers/char/isicom.c                             |    2 +-
 drivers/char/rocket.c                             |   12 ++-
 drivers/char/rtc.c                                |    4 +
 drivers/char/specialix.c                          |    2 +-
 drivers/hwmon/adt7473.c                           |    2 +
 drivers/hwmon/i5k_amb.c                           |    2 +-
 drivers/infiniband/hw/amso1100/c2_vq.c            |    7 +-
 drivers/input/touchscreen/htcpen.c                |    7 +-
 drivers/isdn/capi/capidrv.c                       |    4 +-
 drivers/isdn/hardware/eicon/maintidi.c            |    2 +-
 drivers/isdn/hardware/eicon/message.c             |   34 ++++---
 drivers/isdn/hisax/config.c                       |    2 +-
 drivers/isdn/hysdn/hysdn_net.c                    |    4 +-
 drivers/isdn/i4l/isdn_common.c                    |    2 +
 drivers/isdn/i4l/isdn_ppp.c                       |    2 +
 drivers/isdn/icn/icn.c                            |    2 +-
 drivers/isdn/sc/card.h                            |    2 +-
 drivers/isdn/sc/init.c                            |   38 ++++----
 drivers/isdn/sc/scioc.h                           |    2 +-
 drivers/isdn/sc/shmem.c                           |    2 +-
 drivers/isdn/sc/timer.c                           |    2 +-
 drivers/md/dm-raid1.c                             |    2 +-
 drivers/media/common/tuners/mxl5007t.c            |    2 +-
 drivers/media/dvb/dvb-usb/anysee.c                |    2 +-
 drivers/media/dvb/frontends/drx397xD.c            |    2 +-
 drivers/media/dvb/ttusb-dec/ttusb_dec.c           |    4 +-
 drivers/media/video/cx18/cx18-mailbox.c           |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c |    2 +-
 drivers/media/video/usbvision/usbvision-i2c.c     |    2 +-
 drivers/media/video/zoran/zoran_card.c            |    2 +-
 drivers/memstick/core/mspro_block.c               |    1 +
 drivers/message/fusion/mptbase.c                  |    2 +
 drivers/message/i2o/Kconfig                       |    4 +-
 drivers/misc/fujitsu-laptop.c                     |    2 +-
 drivers/misc/sgi-gru/grufault.c                   |    4 +-
 drivers/mtd/devices/mtd_dataflash.c               |    2 +-
 drivers/mtd/devices/phram.c                       |    2 +-
 drivers/net/3c523.c                               |    4 +-
 drivers/net/atlx/atl2.c                           |    2 -
 drivers/net/cassini.c                             |    2 +-
 drivers/net/depca.c                               |    7 +-
 drivers/net/mlx4/en_rx.c                          |    3 +-
 drivers/net/mlx4/mcg.c                            |    2 +-
 drivers/net/niu.c                                 |    6 +-
 drivers/net/qla3xxx.c                             |    2 +-
 drivers/net/s2io.c                                |    2 +-
 drivers/net/sis900.c                              |    2 +-
 drivers/net/sky2.c                                |    2 +-
 drivers/net/wan/z85230.c                          |    2 +-
 drivers/net/wireless/ath9k/rc.c                   |    2 +-
 drivers/net/wireless/b43/b43.h                    |    3 +-
 drivers/net/wireless/b43/main.c                   |    2 +-
 drivers/net/wireless/iwlwifi/iwl-3945.c           |    2 +-
 drivers/net/wireless/iwlwifi/iwl-debug.h          |    6 +-
 drivers/net/wireless/iwlwifi/iwl-led.c            |    2 -
 drivers/net/wireless/ray_cs.c                     |    2 +
 drivers/net/wireless/zd1201.c                     |    3 +
 drivers/pci/hotplug/cpqphp.h                      |    2 +-
 drivers/pci/pci-driver.c                          |    9 +-
 drivers/pci/search.c                              |    6 +-
 drivers/pnp/pnpbios/core.c                        |    8 +-
 drivers/rtc/rtc-ds1390.c                          |   14 ---
 drivers/scsi/advansys.c                           |   10 ++-
 drivers/scsi/dpt_i2o.c                            |    2 +-
 drivers/scsi/dtc.c                                |   30 ------
 drivers/scsi/fdomain.c                            |    2 +-
 drivers/scsi/g_NCR5380.c                          |   12 ---
 drivers/scsi/initio.c                             |    2 +-
 drivers/scsi/lpfc/lpfc_els.c                      |    3 +-
 drivers/scsi/megaraid/megaraid_mm.c               |    2 +-
 drivers/scsi/ncr53c8xx.c                          |    2 +-
 drivers/scsi/qla4xxx/ql4_mbx.c                    |    2 +-
 drivers/telephony/ixj.c                           |    2 +-
 drivers/usb/atm/ueagle-atm.c                      |    2 +-
 drivers/usb/serial/io_edgeport.c                  |    4 +-
 drivers/usb/serial/keyspan.c                      |    2 +-
 drivers/usb/serial/keyspan_pda.c                  |    6 +-
 drivers/usb/serial/mos7720.c                      |    2 +-
 drivers/uwb/i1480/i1480-est.c                     |    2 +-
 drivers/uwb/whc-rc.c                              |    2 +-
 drivers/uwb/wlp/messages.c                        |    2 +-
 drivers/video/aty/atyfb_base.c                    |    5 +-
 drivers/video/matrox/matroxfb_crtc2.c             |    4 +-
 drivers/video/mb862xx/mb862xxfb.c                 |    4 +
 drivers/video/sis/init301.c                       |    2 +-
 drivers/video/sis/sis_main.c                      |    2 +
 drivers/watchdog/alim1535_wdt.c                   |    2 +-
 drivers/watchdog/alim7101_wdt.c                   |    2 +-
 drivers/watchdog/i6300esb.c                       |   14 ---
 drivers/watchdog/w83697ug_wdt.c                   |   19 +++-
 fs/afs/dir.c                                      |    2 +-
 fs/befs/linuxvfs.c                                |    6 +-
 fs/cifs/cifssmb.c                                 |    2 +-
 fs/cifs/readdir.c                                 |    4 +-
 fs/coda/Makefile                                  |    4 +-
 fs/coda/coda_int.h                                |    5 +
 fs/coda/sysctl.c                                  |    8 +-
 fs/compat_binfmt_elf.c                            |    6 +-
 fs/configfs/symlink.c                             |    2 +-
 fs/dcache.c                                       |    2 +
 fs/dlm/netlink.c                                  |    2 +-
 fs/ecryptfs/keystore.c                            |    4 +-
 fs/eventpoll.c                                    |    2 +-
 fs/ext4/extents.c                                 |    1 +
 fs/fat/namei_vfat.c                               |    4 +-
 fs/jfs/jfs_dmap.c                                 |    2 +-
 fs/locks.c                                        |    2 +-
 fs/nfs/client.c                                   |    1 +
 fs/ocfs2/aops.c                                   |    2 +-
 fs/ocfs2/cluster/heartbeat.c                      |    4 +-
 fs/ocfs2/ioctl.c                                  |    2 +-
 fs/ocfs2/slot_map.c                               |    2 +-
 fs/ocfs2/stack_user.c                             |    2 +-
 fs/omfs/file.c                                    |    4 +-
 fs/reiserfs/do_balan.c                            |    5 +-
 fs/reiserfs/lbalance.c                            |   10 +-
 fs/udf/truncate.c                                 |    4 +-
 fs/xfs/linux-2.6/xfs_xattr.c                      |   14 ---
 fs/xfs/xfs_acl.c                                  |   13 +++
 fs/xfs/xfs_acl.h                                  |    2 +
 fs/xfs/xfs_mount.c                                |    2 +
 fs/xfs/xfs_rtalloc.c                              |    2 +-
 include/asm-generic/bug.h                         |    7 +-
 include/linux/audit.h                             |    5 +-
 include/linux/coda_linux.h                        |    4 -
 include/linux/fs.h                                |   24 ++++-
 include/linux/init.h                              |   18 ++--
 include/linux/mca-legacy.h                        |    2 +-
 include/linux/module.h                            |   28 +++++-
 include/linux/pci.h                               |    5 +-
 include/linux/ucb1400.h                           |    4 +-
 include/net/netfilter/nf_conntrack_l4proto.h      |    2 +-
 ipc/ipc_sysctl.c                                  |    4 +-
 kernel/cpuset.c                                   |    2 +-
 kernel/marker.c                                   |    2 +-
 kernel/power/main.c                               |   30 ++++---
 kernel/power/snapshot.c                           |    8 +-
 kernel/profile.c                                  |  106 +++++++++++----------
 lib/Kconfig.debug                                 |   15 +++-
 mm/bootmem.c                                      |    2 +
 mm/mempolicy.c                                    |    2 +-
 mm/swapfile.c                                     |    2 +-
 net/ax25/sysctl_net_ax25.c                        |    2 +
 net/bluetooth/rfcomm/sock.c                       |    2 +
 net/dccp/options.c                                |    2 +-
 net/dsa/mv88e6060.c                               |    2 +-
 net/dsa/mv88e6xxx.c                               |    2 +-
 net/ipv6/ip6_flowlabel.c                          |    2 +-
 net/netfilter/ipvs/ip_vs_ctl.c                    |    1 +
 net/netfilter/nf_conntrack_ftp.c                  |    3 +-
 net/netfilter/nf_conntrack_proto_sctp.c           |    3 +
 net/packet/af_packet.c                            |    2 +-
 net/rfkill/rfkill.c                               |    1 +
 net/sched/sch_hfsc.c                              |    2 +-
 net/sunrpc/svcauth_unix.c                         |    3 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c          |    2 +-
 net/sunrpc/xprtrdma/verbs.c                       |    2 +
 security/selinux/netnode.c                        |    1 +
 sound/isa/sb/sb8.c                                |    2 +-
 sound/oss/ad1848.c                                |    2 +-
 sound/pci/cs46xx/cs46xx_lib.c                     |    5 +-
 sound/pci/hda/patch_sigmatel.c                    |    4 +-
 sound/pci/pcxhr/pcxhr.c                           |    8 +-
 sound/pci/pcxhr/pcxhr_core.c                      |    2 +-
 sound/pci/pcxhr/pcxhr_mixer.c                     |    3 +-
 sound/pci/via82xx.c                               |    2 +-
 sound/pci/via82xx_modem.c                         |    2 +-
 sound/pci/vx222/vx222.c                           |    2 +-
 sound/soc/codecs/tlv320aic23.c                    |    2 -
 sound/soc/codecs/wm8903.c                         |    4 +-
 196 files changed, 545 insertions(+), 436 deletions(-)

diff --git a/Makefile b/Makefile
index 7b1f238..2839a99 100644
--- a/Makefile
+++ b/Makefile
@@ -540,6 +540,10 @@ ifdef CONFIG_FUNCTION_TRACER
 KBUILD_CFLAGS	+= -pg
 endif
 
+ifndef CONFIG_ALLOW_WARNINGS
+KBUILD_CFLAGS	+= -Werror ${WERROR}
+endif
+
 # We trigger additional mismatches with less inlining
 ifdef CONFIG_DEBUG_SECTION_MISMATCH
 KBUILD_CFLAGS += $(call cc-option, -fno-inline-functions-called-once)
diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
index 748e8d0..0cdb52c 100644
--- a/arch/x86/boot/video-mode.c
+++ b/arch/x86/boot/video-mode.c
@@ -147,7 +147,7 @@ static void vga_recalc_vertical(void)
 int set_mode(u16 mode)
 {
 	int rv;
-	u16 real_mode;
+	u16 uninitialized_var(real_mode);
 
 	/* Very special mode numbers... */
 	if (mode == VIDEO_CURRENT_MODE)
diff --git a/arch/x86/kernel/cpu/intel_cacheinfo.c b/arch/x86/kernel/cpu/intel_cacheinfo.c
index 3f46afb..d3c6e2b 100644
--- a/arch/x86/kernel/cpu/intel_cacheinfo.c
+++ b/arch/x86/kernel/cpu/intel_cacheinfo.c
@@ -135,7 +135,7 @@ struct _cpuid4_info {
 	cpumask_t shared_cpu_map;	/* future?: only cpus/node is needed */
 };
 
-#ifdef CONFIG_PCI
+#if defined(CONFIG_PCI) && defined(CONFIG_SYSFS)
 static struct pci_device_id k8_nb_id[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1103) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_AMD, 0x1203) },
@@ -475,6 +475,8 @@ unsigned int __cpuinit init_intel_cacheinfo(struct cpuinfo_x86 *c)
 	return l2;
 }
 
+#ifdef CONFIG_SYSFS
+
 /* pointer to _cpuid4_info array (for each cache leaf) */
 static DEFINE_PER_CPU(struct _cpuid4_info *, cpuid4_info);
 #define CPUID4_INFO_IDX(x, y)	(&((per_cpu(cpuid4_info, x))[y]))
@@ -578,8 +580,6 @@ out:
 	return retval;
 }
 
-#ifdef CONFIG_SYSFS
-
 #include <linux/kobject.h>
 #include <linux/sysfs.h>
 
diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
index 1b894b7..602633a 100644
--- a/arch/x86/kernel/early-quirks.c
+++ b/arch/x86/kernel/early-quirks.c
@@ -96,6 +96,7 @@ static void __init nvidia_bugs(int num, int slot, int func)
 }
 
 #if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
+#if defined(CONFIG_ACPI) && defined(CONFIG_X86_IO_APIC)
 static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 {
 	u32 d;
@@ -113,6 +114,7 @@ static u32 __init ati_ixp4x0_rev(int num, int slot, int func)
 	d &= 0xff;
 	return d;
 }
+#endif
 
 static void __init ati_bugs(int num, int slot, int func)
 {
diff --git a/arch/x86/kernel/genx2apic_uv_x.c b/arch/x86/kernel/genx2apic_uv_x.c
index 2c7dbdb..03a7548 100644
--- a/arch/x86/kernel/genx2apic_uv_x.c
+++ b/arch/x86/kernel/genx2apic_uv_x.c
@@ -241,7 +241,8 @@ static __init int boot_pnode_to_blade(int pnode)
 	for (blade = 0; blade < uv_num_possible_blades(); blade++)
 		if (pnode == uv_blade_info[blade].pnode)
 			return blade;
-	BUG();
+
+	panic("x2apic_uv: bad pnode!");
 }
 
 struct redir_addr {
@@ -272,7 +273,7 @@ static __init void get_lowmem_redirect(unsigned long *base, unsigned long *size)
 			return;
 		}
 	}
-	BUG();
+	panic("get_lowmem_redirect: no match!");
 }
 
 static __init void map_low_mmrs(void)
diff --git a/arch/x86/kernel/paravirt-spinlocks.c b/arch/x86/kernel/paravirt-spinlocks.c
index 0e9f198..95777b0 100644
--- a/arch/x86/kernel/paravirt-spinlocks.c
+++ b/arch/x86/kernel/paravirt-spinlocks.c
@@ -7,7 +7,8 @@
 
 #include <asm/paravirt.h>
 
-static void default_spin_lock_flags(struct raw_spinlock *lock, unsigned long flags)
+static inline void
+default_spin_lock_flags(raw_spinlock_t *lock, unsigned long flags)
 {
 	__raw_spin_lock(lock);
 }
diff --git a/arch/x86/kernel/scx200_32.c b/arch/x86/kernel/scx200_32.c
index 7e004ac..1b6e3d1 100644
--- a/arch/x86/kernel/scx200_32.c
+++ b/arch/x86/kernel/scx200_32.c
@@ -78,8 +78,10 @@ static int __devinit scx200_probe(struct pci_dev *pdev, const struct pci_device_
 		if (scx200_cb_probe(SCx200_CB_BASE_FIXED)) {
 			scx200_cb_base = SCx200_CB_BASE_FIXED;
 		} else {
-			pci_read_config_dword(pdev, SCx200_CBA_SCRATCH, &base);
-			if (scx200_cb_probe(base)) {
+			int err;
+
+			err = pci_read_config_dword(pdev, SCx200_CBA_SCRATCH, &base);
+			if (!err && scx200_cb_probe(base)) {
 				scx200_cb_base = base;
 			} else {
 				printk(KERN_WARNING NAME ": Configuration Block not found\n");
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 9d5674f..cc0c2c0 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -738,6 +738,7 @@ void start_periodic_check_for_corruption(void)
 }
 #endif
 
+#ifdef CONFIG_X86_RESERVE_LOW_64K
 static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 {
 	printk(KERN_NOTICE
@@ -749,6 +750,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 
 	return 0;
 }
+#endif
 
 /* List of systems that have known low memory corruption BIOS problems */
 static struct dmi_system_id __initdata bad_bios_dmi_table[] = {
diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 22e0576..f27eada 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -277,8 +277,8 @@ static int __init early_fill_mp_bus_info(void)
 {
 	int i;
 	int j;
-	unsigned bus;
-	unsigned slot;
+	unsigned uninitialized_var(bus);
+	unsigned uninitialized_var(slot);
 	int found;
 	int node;
 	int link;
diff --git a/block/bsg.c b/block/bsg.c
index e8bd247..3fbf295 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -246,7 +246,7 @@ bsg_map_hdr(struct bsg_device *bd, struct sg_io_v4 *hdr, fmode_t has_write_perm)
 {
 	struct request_queue *q = bd->queue;
 	struct request *rq, *next_rq = NULL;
-	int ret, rw;
+	int ret, uninitialized_var(rw);
 	unsigned int dxfer_len;
 	void *dxferp = NULL;
 
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 6a062ee..c409dd9 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1505,6 +1505,7 @@ cfq_async_queue_prio(struct cfq_data *cfqd, int ioprio_class, int ioprio)
 		return &cfqd->async_idle_cfqq;
 	default:
 		BUG();
+		return NULL;
 	}
 }
 
diff --git a/crypto/testmgr.c b/crypto/testmgr.c
index b828c6c..0cf0ae3 100644
--- a/crypto/testmgr.c
+++ b/crypto/testmgr.c
@@ -853,7 +853,7 @@ static int test_comp(struct crypto_comp *tfm, struct comp_testvec *ctemplate,
 	}
 
 	for (i = 0; i < dtcount; i++) {
-		int ilen, ret, dlen = COMP_BUF_SIZE;
+		int ilen, dlen = COMP_BUF_SIZE;
 
 		memset(result, 0, sizeof (result));
 
diff --git a/drivers/acpi/executer/exprep.c b/drivers/acpi/executer/exprep.c
index 5d438c3..dc23e24 100644
--- a/drivers/acpi/executer/exprep.c
+++ b/drivers/acpi/executer/exprep.c
@@ -319,7 +319,7 @@ acpi_ex_prep_common_field_object(union acpi_operand_object *obj_desc,
 				 u32 field_bit_position, u32 field_bit_length)
 {
 	u32 access_bit_width;
-	u32 byte_alignment;
+	u32 uninitialized_var(byte_alignment);
 	u32 nearest_byte_address;
 
 	ACPI_FUNCTION_TRACE(ex_prep_common_field_object);
diff --git a/drivers/acpi/sbs.c b/drivers/acpi/sbs.c
index 6050ce4..4ac05cc 100644
--- a/drivers/acpi/sbs.c
+++ b/drivers/acpi/sbs.c
@@ -389,6 +389,8 @@ static int acpi_battery_get_state(struct acpi_battery *battery)
 	return result;
 }
 
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
+
 static int acpi_battery_get_alarm(struct acpi_battery *battery)
 {
 	return acpi_smbus_read(battery->sbs->hc, SMBUS_READ_WORD,
@@ -425,6 +427,8 @@ static int acpi_battery_set_alarm(struct acpi_battery *battery)
 	return ret;
 }
 
+#endif
+
 static int acpi_ac_get_present(struct acpi_sbs *sbs)
 {
 	int result;
@@ -816,7 +820,10 @@ static int acpi_battery_add(struct acpi_sbs *sbs, int id)
 
 static void acpi_battery_remove(struct acpi_sbs *sbs, int id)
 {
+#if defined(CONFIG_ACPI_SYSFS_POWER) || defined(CONFIG_ACPI_PROCFS_POWER)
 	struct acpi_battery *battery = &sbs->battery[id];
+#endif
+
 #ifdef CONFIG_ACPI_SYSFS_POWER
 	if (battery->bat.dev) {
 		if (battery->have_sysfs_alarm)
diff --git a/drivers/acpi/sleep/main.c b/drivers/acpi/sleep/main.c
index 80c0868..c6d0a47 100644
--- a/drivers/acpi/sleep/main.c
+++ b/drivers/acpi/sleep/main.c
@@ -24,6 +24,7 @@
 #include "sleep.h"
 
 u8 sleep_states[ACPI_S_STATE_COUNT];
+static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 
 static void acpi_sleep_tts_switch(u32 acpi_state)
 {
@@ -77,7 +78,6 @@ static int acpi_sleep_prepare(u32 acpi_state)
 }
 
 #ifdef CONFIG_ACPI_SLEEP
-static u32 acpi_target_sleep_state = ACPI_STATE_S0;
 /*
  * ACPI 1.0 wants us to execute _PTS before suspending devices, so we allow the
  * user to request that behavior by using the 'acpi_old_suspend_ordering'
@@ -93,7 +93,7 @@ void __init acpi_old_suspend_ordering(void)
 /**
  *	acpi_pm_disable_gpes - Disable the GPEs.
  */
-static int acpi_pm_disable_gpes(void)
+static inline int acpi_pm_disable_gpes(void)
 {
 	acpi_hw_disable_all_gpes();
 	return 0;
@@ -105,7 +105,7 @@ static int acpi_pm_disable_gpes(void)
  *	If necessary, set the firmware waking vector and do arch-specific
  *	nastiness to get the wakeup code to the waking vector.
  */
-static int __acpi_pm_prepare(void)
+static inline int __acpi_pm_prepare(void)
 {
 	int error = acpi_sleep_prepare(acpi_target_sleep_state);
 
@@ -118,7 +118,7 @@ static int __acpi_pm_prepare(void)
  *	acpi_pm_prepare - Prepare the platform to enter the target sleep
  *		state and disable the GPEs.
  */
-static int acpi_pm_prepare(void)
+static inline int acpi_pm_prepare(void)
 {
 	int error = __acpi_pm_prepare();
 
@@ -133,7 +133,7 @@ static int acpi_pm_prepare(void)
  *	This is called after we wake back up (or if entering the sleep state
  *	failed).
  */
-static void acpi_pm_finish(void)
+static inline void acpi_pm_finish(void)
 {
 	u32 acpi_state = acpi_target_sleep_state;
 
@@ -154,7 +154,7 @@ static void acpi_pm_finish(void)
 /**
  *	acpi_pm_end - Finish up suspend sequence.
  */
-static void acpi_pm_end(void)
+static inline void acpi_pm_end(void)
 {
 	/*
 	 * This is necessary in case acpi_pm_finish() is not called during a
diff --git a/drivers/acpi/toshiba_acpi.c b/drivers/acpi/toshiba_acpi.c
index 66aac06..7db6b48 100644
--- a/drivers/acpi/toshiba_acpi.c
+++ b/drivers/acpi/toshiba_acpi.c
@@ -729,8 +729,8 @@ static int __init toshiba_acpi_init(void)
 {
 	acpi_status status = AE_OK;
 	u32 hci_result;
-	bool bt_present;
-	bool bt_on;
+	bool uninitialized_var(bt_present);
+	bool uninitialized_var(bt_on);
 	bool radio_on;
 	int ret = 0;
 
diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index 4214bfb..0530350 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1411,7 +1411,7 @@ static int ata_hpa_resize(struct ata_device *dev)
 	struct ata_eh_context *ehc = &dev->link->eh_context;
 	int print_info = ehc->i.flags & ATA_EHI_PRINTINFO;
 	u64 sectors = ata_id_n_sectors(dev->id);
-	u64 native_sectors;
+	u64 uninitialized_var(native_sectors);
 	int rc;
 
 	/* do we need to do it? */
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 47c7afc..0b7ff0f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3223,7 +3223,7 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 	int tries = 5;
 	struct ata_device *last_failed_dev = NULL;
 	struct ata_link *link;
-	struct ata_device *dev;
+	struct ata_device *uninitialized_var(dev);
 
 	if (ap->flags & ATA_FLAG_DISABLED)
 		return;
diff --git a/drivers/ata/pata_atiixp.c b/drivers/ata/pata_atiixp.c
index 0e2cde8..b474093 100644
--- a/drivers/ata/pata_atiixp.c
+++ b/drivers/ata/pata_atiixp.c
@@ -155,7 +155,7 @@ static void atiixp_set_dmamode(struct ata_port *ap, struct ata_device *adev)
 		wanted_pio = 3;
 	else if (adev->dma_mode == XFER_MW_DMA_0)
 		wanted_pio = 0;
-	else BUG();
+	else panic("atiixp_set_dmamode: unknown DMA mode!");
 
 	if (adev->pio_mode != wanted_pio)
 		atiixp_set_pio_timing(ap, adev, wanted_pio);
diff --git a/drivers/ata/sata_via.c b/drivers/ata/sata_via.c
index c18935f..01df26b 100644
--- a/drivers/ata/sata_via.c
+++ b/drivers/ata/sata_via.c
@@ -564,7 +564,7 @@ static int svia_init_one(struct pci_dev *pdev, const struct pci_device_id *ent)
 	static int printed_version;
 	unsigned int i;
 	int rc;
-	struct ata_host *host;
+	struct ata_host *uninitialized_var(host);
 	int board_id = (int) ent->driver_data;
 	const unsigned *bar_sizes;
 
diff --git a/drivers/atm/ambassador.c b/drivers/atm/ambassador.c
index 703364b..2a2a400 100644
--- a/drivers/atm/ambassador.c
+++ b/drivers/atm/ambassador.c
@@ -2097,7 +2097,7 @@ static int __devinit amb_init (amb_dev * dev)
 {
   loader_block lb;
   
-  u32 version;
+  u32 version = -1;
   
   if (amb_reset (dev, 1)) {
     PRINTK (KERN_ERR, "card reset failed!");
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index 6154123..a918382 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -2131,7 +2131,7 @@ static int atm_pcr_check (struct atm_trafprm * tp, unsigned int pcr) {
 static int hrz_open (struct atm_vcc *atm_vcc)
 {
   int error;
-  u16 channel;
+  u16 uninitialized_var(channel);
   
   struct atm_qos * qos;
   struct atm_trafprm * txtp;
diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index dfcbfe5..e0bcd6b 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -614,7 +614,8 @@ static int platform_match(struct device *dev, struct device_driver *drv)
 
 #ifdef CONFIG_PM_SLEEP
 
-static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
+static inline int
+platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 {
 	int ret = 0;
 
@@ -624,7 +625,8 @@ static int platform_legacy_suspend(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
-static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
+static inline int
+platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -637,7 +639,7 @@ static int platform_legacy_suspend_late(struct device *dev, pm_message_t mesg)
 	return ret;
 }
 
-static int platform_legacy_resume_early(struct device *dev)
+static inline int platform_legacy_resume_early(struct device *dev)
 {
 	struct platform_driver *drv = to_platform_driver(dev->driver);
 	struct platform_device *pdev;
@@ -650,7 +652,7 @@ static int platform_legacy_resume_early(struct device *dev)
 	return ret;
 }
 
-static int platform_legacy_resume(struct device *dev)
+static inline int platform_legacy_resume(struct device *dev)
 {
 	int ret = 0;
 
diff --git a/drivers/block/DAC960.c b/drivers/block/DAC960.c
index f6a337c..2c97e74 100644
--- a/drivers/block/DAC960.c
+++ b/drivers/block/DAC960.c
@@ -6646,7 +6646,8 @@ static long DAC960_gam_ioctl(struct file *file, unsigned int Request,
 	  (DAC960_ControllerInfo_T __user *) Argument;
 	DAC960_ControllerInfo_T ControllerInfo;
 	DAC960_Controller_T *Controller;
-	int ControllerNumber;
+	int uninitialized_var(ControllerNumber);
+
 	if (UserSpaceControllerInfo == NULL)
 		ErrorCode = -EINVAL;
 	else ErrorCode = get_user(ControllerNumber,
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index 70e0ebc..9cf4ff2 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -3202,4 +3202,4 @@ static struct pci_device_id ip2main_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, ip2main_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ip2main_pci_tbl);
diff --git a/drivers/char/ipmi/ipmi_msghandler.c b/drivers/char/ipmi/ipmi_msghandler.c
index 7a88dfd..5e1ab2c 100644
--- a/drivers/char/ipmi/ipmi_msghandler.c
+++ b/drivers/char/ipmi/ipmi_msghandler.c
@@ -1796,7 +1796,8 @@ int ipmi_request_settime(ipmi_user_t      user,
 			 int              retries,
 			 unsigned int     retry_time_ms)
 {
-	unsigned char saddr, lun;
+	unsigned char uninitialized_var(saddr),
+		      uninitialized_var(lun);
 	int           rv;
 
 	if (!user)
@@ -1828,7 +1829,8 @@ int ipmi_request_supply_msgs(ipmi_user_t          user,
 			     struct ipmi_recv_msg *supplied_recv,
 			     int                  priority)
 {
-	unsigned char saddr, lun;
+	unsigned char uninitialized_var(saddr),
+		      uninitialized_var(lun);
 	int           rv;
 
 	if (!user)
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 04e4549..53f58a0 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1696,7 +1696,7 @@ static unsigned int card_count;
 static int __devinit isicom_probe(struct pci_dev *pdev,
 	const struct pci_device_id *ent)
 {
-	unsigned int signature, index;
+	unsigned int uninitialized_var(signature), index;
 	int retval = -EPERM;
 	struct isi_board *board = NULL;
 
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index 584d791..6d15b00 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -149,12 +149,14 @@ static Word_t aiop_intr_bits[AIOP_CTL_SIZE] = {
 	AIOP_INTR_BIT_3
 };
 
+#ifdef CONFIG_PCI
 static Word_t upci_aiop_intr_bits[AIOP_CTL_SIZE] = {
 	UPCI_AIOP_INTR_BIT_0,
 	UPCI_AIOP_INTR_BIT_1,
 	UPCI_AIOP_INTR_BIT_2,
 	UPCI_AIOP_INTR_BIT_3
 };
+#endif
 
 static Byte_t RData[RDATASIZE] = {
 	0x00, 0x09, 0xf6, 0x82,
@@ -226,7 +228,6 @@ static unsigned long nextLineNumber;
 static int __init init_ISA(int i);
 static void rp_wait_until_sent(struct tty_struct *tty, int timeout);
 static void rp_flush_buffer(struct tty_struct *tty);
-static void rmSpeakerReset(CONTROLLER_T * CtlP, unsigned long model);
 static unsigned char GetLineNumber(int ctrl, int aiop, int ch);
 static unsigned char SetLineNumber(int ctrl, int aiop, int ch);
 static void rp_start(struct tty_struct *tty);
@@ -240,11 +241,14 @@ static void sDisInterrupts(CHANNEL_T * ChP, Word_t Flags);
 static void sModemReset(CONTROLLER_T * CtlP, int chan, int on);
 static void sPCIModemReset(CONTROLLER_T * CtlP, int chan, int on);
 static int sWriteTxPrioByte(CHANNEL_T * ChP, Byte_t Data);
+#ifdef CONFIG_PCI
+static void rmSpeakerReset(CONTROLLER_T * CtlP, unsigned long model);
 static int sPCIInitController(CONTROLLER_T * CtlP, int CtlNum,
 			      ByteIO_t * AiopIOList, int AiopIOListSize,
 			      WordIO_t ConfigIO, int IRQNum, Byte_t Frequency,
 			      int PeriodicOnly, int altChanRingIndicator,
 			      int UPCIRingInd);
+#endif
 static int sInitController(CONTROLLER_T * CtlP, int CtlNum, ByteIO_t MudbacIO,
 			   ByteIO_t * AiopIOList, int AiopIOListSize,
 			   int IRQNum, Byte_t Frequency, int PeriodicOnly);
@@ -1874,7 +1878,7 @@ static struct pci_device_id __devinitdata rocket_pci_ids[] = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_RP, PCI_ANY_ID) },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, rocket_pci_ids);
+MODULE_STATIC_DEVICE_TABLE(pci, rocket_pci_ids);
 
 /*
  *  Called when a PCI card is found.  Retrieves and stores model information,
@@ -2651,6 +2655,7 @@ static int sInitController(CONTROLLER_T * CtlP, int CtlNum, ByteIO_t MudbacIO,
 		return (CtlP->NumAiop);
 }
 
+#ifdef CONFIG_PCI
 /***************************************************************************
 Function: sPCIInitController
 Purpose:  Initialization of controller global registers and controller
@@ -2770,6 +2775,7 @@ static int sPCIInitController(CONTROLLER_T * CtlP, int CtlNum,
 	else
 		return (CtlP->NumAiop);
 }
+#endif /* CONFIG_PCI */
 
 /***************************************************************************
 Function: sReadAiopID
@@ -3260,6 +3266,7 @@ static void sPCIModemReset(CONTROLLER_T * CtlP, int chan, int on)
 	sOutB(addr + chan, 0);	/* apply or remove reset */
 }
 
+#ifdef CONFIG_PCI
 /*  Resets the speaker controller on RocketModem II and III devices */
 static void rmSpeakerReset(CONTROLLER_T * CtlP, unsigned long model)
 {
@@ -3278,6 +3285,7 @@ static void rmSpeakerReset(CONTROLLER_T * CtlP, unsigned long model)
 		sOutB(addr, 0);
 	}
 }
+#endif /* CONFIG_PCI */
 
 /*  Returns the line number given the controller (board), aiop and channel number */
 static unsigned char GetLineNumber(int ctrl, int aiop, int ch)
diff --git a/drivers/char/rtc.c b/drivers/char/rtc.c
index 20d6efb..5ade9b6 100644
--- a/drivers/char/rtc.c
+++ b/drivers/char/rtc.c
@@ -188,7 +188,9 @@ static int rtc_proc_open(struct inode *inode, struct file *file);
  * timer (but you would need to have an awful timing before you'd trip on it)
  */
 static unsigned long rtc_status;	/* bitmapped status byte.	*/
+#if defined(RTC_IRQ) || defined(CONFIG_PROC_FS)
 static unsigned long rtc_freq;		/* Current periodic IRQ rate	*/
+#endif
 static unsigned long rtc_irq_data;	/* our output to the world	*/
 static unsigned long rtc_max_user_freq = 64; /* > this, need CAP_SYS_RESOURCE */
 
@@ -1083,7 +1085,9 @@ no_irq:
 #endif
 
 #if defined(__alpha__) || defined(__mips__)
+#ifdef CONFIG_PROC_FS
 	rtc_freq = HZ;
+#endif
 
 	/* Each operating system on an Alpha uses its own epoch.
 	   Let's try to guess which one we are using now. */
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index a16b94f..f2770a1 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -2359,7 +2359,7 @@ static struct pci_device_id specialx_pci_tbl[] __devinitdata = {
 	{ PCI_DEVICE(PCI_VENDOR_ID_SPECIALIX, PCI_DEVICE_ID_SPECIALIX_IO8) },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, specialx_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, specialx_pci_tbl);
 
 module_init(specialix_init_module);
 module_exit(specialix_exit_module);
diff --git a/drivers/hwmon/adt7473.c b/drivers/hwmon/adt7473.c
index 18aa308..bc1698a 100644
--- a/drivers/hwmon/adt7473.c
+++ b/drivers/hwmon/adt7473.c
@@ -850,6 +850,8 @@ static ssize_t show_pwm_auto_temp(struct device *dev,
 	}
 	/* shouldn't ever get here */
 	BUG();
+
+	return 0;
 }
 
 static ssize_t set_pwm_auto_temp(struct device *dev,
diff --git a/drivers/hwmon/i5k_amb.c b/drivers/hwmon/i5k_amb.c
index 2ede938..5e1db7b 100644
--- a/drivers/hwmon/i5k_amb.c
+++ b/drivers/hwmon/i5k_amb.c
@@ -480,7 +480,7 @@ static unsigned long i5k_channel_pci_id(struct i5k_amb_data *data,
 	case PCI_DEVICE_ID_INTEL_5400_ERR:
 		return PCI_DEVICE_ID_INTEL_5400_FBD0 + channel;
 	default:
-		BUG();
+		panic("i5k_channel_pci_id: unknown chipset!");
 	}
 }
 
diff --git a/drivers/infiniband/hw/amso1100/c2_vq.c b/drivers/infiniband/hw/amso1100/c2_vq.c
index 9ce7819..dc5c225 100644
--- a/drivers/infiniband/hw/amso1100/c2_vq.c
+++ b/drivers/infiniband/hw/amso1100/c2_vq.c
@@ -107,7 +107,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
 	r = kmalloc(sizeof(struct c2_vq_req), GFP_KERNEL);
 	if (r) {
 		init_waitqueue_head(&r->wait_object);
-		r->reply_msg = (u64) NULL;
+		r->reply_msg = (u64) (long) NULL;
 		r->event = 0;
 		r->cm_id = NULL;
 		r->qp = NULL;
@@ -123,7 +123,7 @@ struct c2_vq_req *vq_req_alloc(struct c2_dev *c2dev)
  */
 void vq_req_free(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
-	r->reply_msg = (u64) NULL;
+	r->reply_msg = (u64) (long) NULL;
 	if (atomic_dec_and_test(&r->refcnt)) {
 		kfree(r);
 	}
@@ -151,7 +151,7 @@ void vq_req_get(struct c2_dev *c2dev, struct c2_vq_req *r)
 void vq_req_put(struct c2_dev *c2dev, struct c2_vq_req *r)
 {
 	if (atomic_dec_and_test(&r->refcnt)) {
-		if (r->reply_msg != (u64) NULL)
+		if (r->reply_msg != (u64) (long) NULL)
 			vq_repbuf_free(c2dev,
 				       (void *) (unsigned long) r->reply_msg);
 		kfree(r);
@@ -258,3 +258,4 @@ void vq_repbuf_free(struct c2_dev *c2dev, void *reply)
 {
 	kmem_cache_free(c2dev->host_msg_cache, reply);
 }
+
diff --git a/drivers/input/touchscreen/htcpen.c b/drivers/input/touchscreen/htcpen.c
index 62811de..1aff4e7 100644
--- a/drivers/input/touchscreen/htcpen.c
+++ b/drivers/input/touchscreen/htcpen.c
@@ -47,12 +47,6 @@ static int invert_y;
 module_param(invert_y, bool, 0644);
 MODULE_PARM_DESC(invert_y, "If set, Y axis is inverted");
 
-static struct pnp_device_id pnp_ids[] = {
-	{ .id = "PNP0cc0" },
-	{ .id = "" }
-};
-MODULE_DEVICE_TABLE(pnp, pnp_ids);
-
 static irqreturn_t htcpen_interrupt(int irq, void *handle)
 {
 	struct input_dev *htcpen_dev = handle;
@@ -253,3 +247,4 @@ static void __exit htcpen_isa_exit(void)
 
 module_init(htcpen_isa_init);
 module_exit(htcpen_isa_exit);
+
diff --git a/drivers/isdn/capi/capidrv.c b/drivers/isdn/capi/capidrv.c
index d5b4cc3..ef01784 100644
--- a/drivers/isdn/capi/capidrv.c
+++ b/drivers/isdn/capi/capidrv.c
@@ -1551,8 +1551,8 @@ static int decodeFVteln(char *teln, unsigned long *bmaskp, int *activep)
 
 static int FVteln2capi20(char *teln, u8 AdditionalInfo[1+2+2+31])
 {
-	unsigned long bmask;
-	int active;
+	unsigned long uninitialized_var(bmask);
+	int uninitialized_var(active);
 	int rc, i;
    
 	rc = decodeFVteln(teln, &bmask, &active);
diff --git a/drivers/isdn/hardware/eicon/maintidi.c b/drivers/isdn/hardware/eicon/maintidi.c
index 23960cb..ac88242 100644
--- a/drivers/isdn/hardware/eicon/maintidi.c
+++ b/drivers/isdn/hardware/eicon/maintidi.c
@@ -959,7 +959,7 @@ static int process_idi_event (diva_strace_context_t* pLib,
 	}
 	if (!strncmp("State\\Layer2 No1", path, pVar->path_length)) {
 		char* tmp = &pLib->lines[0].pInterface->Layer2[0];
-    dword l2_state;
+    dword uninitialized_var(l2_state);
     diva_strace_read_uint (pVar, &l2_state);
 
 		switch (l2_state) {
diff --git a/drivers/isdn/hardware/eicon/message.c b/drivers/isdn/hardware/eicon/message.c
index 599fed8..1afbcca 100644
--- a/drivers/isdn/hardware/eicon/message.c
+++ b/drivers/isdn/hardware/eicon/message.c
@@ -2682,7 +2682,7 @@ byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plc
           if (!(fax_control_bits & T30_CONTROL_BIT_MORE_DOCUMENTS)
            || (fax_feature_bits & T30_FEATURE_BIT_MORE_DOCUMENTS))
           {
-            len = (byte)(&(((T30_INFO *) 0)->universal_6));
+            len = (byte)(offsetof(T30_INFO, universal_6));
             fax_info_change = false;
             if (ncpi->length >= 4)
             {
@@ -2744,7 +2744,7 @@ byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plc
                     for (i = 0; i < w; i++)
                       ((T30_INFO   *)(plci->fax_connect_info_buffer))->station_id[i] = fax_parms[4].info[1+i];
                     ((T30_INFO   *)(plci->fax_connect_info_buffer))->head_line_len = 0;
-                    len = (byte)(((T30_INFO *) 0)->station_id + 20);
+                    len = (byte)(offsetof(T30_INFO, station_id) + 20);
                     w = fax_parms[5].length;
                     if (w > 20)
                       w = 20;
@@ -2778,7 +2778,7 @@ byte connect_b3_req(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plc
                 }
                 else
                 {
-                  len = (byte)(&(((T30_INFO *) 0)->universal_6));
+                  len = (byte)(offsetof(T30_INFO, universal_6));
                 }
                 fax_info_change = true;
 
@@ -2881,7 +2881,7 @@ byte connect_b3_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * plc
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_ENABLE_NSF)
     && (plci->nsf_control_bits & T30_NSF_CONTROL_BIT_NEGOTIATE_RESP))
    {
-            len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+            len = (byte)(offsetof(T30_INFO, station_id) + 20);
             if (plci->fax_connect_info_length < len)
             {
               ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -3780,7 +3780,7 @@ byte manufacturer_res(dword Id, word Number, DIVA_CAPI_ADAPTER   * a, PLCI   * p
       break;
     }
     ncpi = &m_parms[1];
-    len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+    len = (byte)(offsetof(T30_INFO, station_id) + 20);
     if (plci->fax_connect_info_length < len)
     {
       ((T30_INFO *)(plci->fax_connect_info_buffer))->station_id_len = 0;
@@ -6481,7 +6481,7 @@ void nl_ind(PLCI   * plci)
   word info = 0;
   word fax_feature_bits;
   byte fax_send_edata_ack;
-  static byte v120_header_buffer[2 + 3];
+  static byte v120_header_buffer[2 + 3] __attribute__ ((aligned(8)));
   static word fax_info[] = {
     0,                     /* T30_SUCCESS                        */
     _FAX_NO_CONNECTION,    /* T30_ERR_NO_DIS_RECEIVED            */
@@ -6820,7 +6820,7 @@ void nl_ind(PLCI   * plci)
         if ((plci->requested_options_conn | plci->requested_options | a->requested_options_table[plci->appl->Id-1])
           & ((1L << PRIVATE_FAX_SUB_SEP_PWD) | (1L << PRIVATE_FAX_NONSTANDARD)))
         {
-          i = ((word)(((T30_INFO *) 0)->station_id + 20)) + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
+          i = ((word)(offsetof(T30_INFO, station_id) + 20)) + ((T30_INFO   *)plci->NL.RBuffer->P)->head_line_len;
           while (i < plci->NL.RBuffer->length)
             plci->ncpi_buffer[++len] = plci->NL.RBuffer->P[i++];
         }
@@ -7212,7 +7212,7 @@ void nl_ind(PLCI   * plci)
     {
       plci->RData[1].P = plci->RData[0].P;
       plci->RData[1].PLength = plci->RData[0].PLength;
-      plci->RData[0].P = v120_header_buffer + (-((int) v120_header_buffer) & 3);
+      plci->RData[0].P = v120_header_buffer;
       if ((plci->NL.RBuffer->P[0] & V120_HEADER_EXTEND_BIT) || (plci->NL.RLength == 1))
         plci->RData[0].PLength = 1;
       else
@@ -8390,6 +8390,7 @@ word add_b23(PLCI   * plci, API_PARSE * bp)
       /* copy head line to NLC */
       if(b3_config_parms[3].length)
       {
+        byte *head_line = (void *) ((T30_INFO *)&nlc[1] + 1);
 
         pos = (byte)(fax_head_line_time (&(((T30_INFO *)&nlc[1])->station_id[20])));
         if (pos != 0)
@@ -8398,17 +8399,17 @@ word add_b23(PLCI   * plci, API_PARSE * bp)
             pos = 0;
           else
           {
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-            ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+            head_line[pos++] = ' ';
+            head_line[pos++] = ' ';
             len = (byte)b3_config_parms[2].length;
             if (len > 20)
               len = 20;
             if (CAPI_MAX_DATE_TIME_LENGTH + 2 + len + 2 + b3_config_parms[3].length <= CAPI_MAX_HEAD_LINE_SPACE)
             {
               for (i = 0; i < len; i++)
-                ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
-              ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ' ';
+                head_line[pos++] = ((byte   *)b3_config_parms[2].info)[1+i];
+              head_line[pos++] = ' ';
+              head_line[pos++] = ' ';
             }
           }
         }
@@ -8419,7 +8420,7 @@ word add_b23(PLCI   * plci, API_PARSE * bp)
         ((T30_INFO *)&nlc[1])->head_line_len = (byte)(pos + len);
         nlc[0] += (byte)(pos + len);
         for (i = 0; i < len; i++)
-          ((T30_INFO *)&nlc[1])->station_id[20 + pos++] = ((byte   *)b3_config_parms[3].info)[1+i];
+          head_line[pos++] = ((byte   *)b3_config_parms[3].info)[1+i];
         }
       else
         ((T30_INFO *)&nlc[1])->head_line_len = 0;
@@ -8448,7 +8449,7 @@ word add_b23(PLCI   * plci, API_PARSE * bp)
             fax_control_bits |= T30_CONTROL_BIT_ACCEPT_SEL_POLLING;
           }
             len = nlc[0];
-          pos = ((byte)(((T30_INFO *) 0)->station_id + 20));
+          pos = (byte)(offsetof(T30_INFO, station_id) + 20);
    if (pos < plci->fax_connect_info_length)
    {
      for (i = 1 + plci->fax_connect_info_buffer[pos]; i != 0; i--)
@@ -8500,7 +8501,7 @@ word add_b23(PLCI   * plci, API_PARSE * bp)
       }
 
       PUT_WORD(&(((T30_INFO *)&nlc[1])->control_bits_low), fax_control_bits);
-      len = ((byte)(((T30_INFO *) 0)->station_id + 20));
+      len = (byte)(offsetof(T30_INFO, station_id) + 20);
       for (i = 0; i < len; i++)
         plci->fax_connect_info_buffer[i] = nlc[1+i];
       ((T30_INFO   *) plci->fax_connect_info_buffer)->head_line_len = 0;
@@ -15043,3 +15044,4 @@ static void diva_free_dma_descriptor (PLCI   *plci, int nr) {
 }
 
 /*------------------------------------------------------------------*/
+
diff --git a/drivers/isdn/hisax/config.c b/drivers/isdn/hisax/config.c
index 84d75a3..63932c5 100644
--- a/drivers/isdn/hisax/config.c
+++ b/drivers/isdn/hisax/config.c
@@ -1970,7 +1970,7 @@ static struct pci_device_id hisax_pci_tbl[] __devinitdata = {
 	{ }				/* Terminating entry */
 };
 
-MODULE_DEVICE_TABLE(pci, hisax_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, hisax_pci_tbl);
 #endif /* CONFIG_PCI */
 
 module_init(HiSax_init);
diff --git a/drivers/isdn/hysdn/hysdn_net.c b/drivers/isdn/hysdn/hysdn_net.c
index cfa8fa5..07a59db 100644
--- a/drivers/isdn/hysdn/hysdn_net.c
+++ b/drivers/isdn/hysdn/hysdn_net.c
@@ -83,12 +83,12 @@ net_open(struct net_device *dev)
 
 	/* Fill in the MAC-level header (if not already set) */
 	if (!card->mac_addr[0]) {
-		for (i = 0; i < ETH_ALEN - sizeof(unsigned long); i++)
+		for (i = 0; i < ETH_ALEN - sizeof(unsigned int); i++)
 			dev->dev_addr[i] = 0xfc;
 		if ((in_dev = dev->ip_ptr) != NULL) {
 			struct in_ifaddr *ifa = in_dev->ifa_list;
 			if (ifa != NULL)
-				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(unsigned long)), &ifa->ifa_local, sizeof(unsigned long));
+				memcpy(dev->dev_addr + (ETH_ALEN - sizeof(unsigned int)), &ifa->ifa_local, sizeof(unsigned int));
 		}
 	} else
 		memcpy(dev->dev_addr, card->mac_addr, ETH_ALEN);
diff --git a/drivers/isdn/i4l/isdn_common.c b/drivers/isdn/i4l/isdn_common.c
index 7188c59..0421604 100644
--- a/drivers/isdn/i4l/isdn_common.c
+++ b/drivers/isdn/i4l/isdn_common.c
@@ -1280,7 +1280,9 @@ isdn_ioctl(struct inode *inode, struct file *file, uint cmd, ulong arg)
 	int ret;
 	int i;
 	char __user *p;
+#ifdef CONFIG_NETDEVICES
 	char *s;
+#endif
 	union iocpar {
 		char name[10];
 		char bname[22];
diff --git a/drivers/isdn/i4l/isdn_ppp.c b/drivers/isdn/i4l/isdn_ppp.c
index 77c280e..c179360 100644
--- a/drivers/isdn/i4l/isdn_ppp.c
+++ b/drivers/isdn/i4l/isdn_ppp.c
@@ -431,6 +431,7 @@ set_arg(void __user *b, void *val,int len)
 	return 0;
 }
 
+#ifdef CONFIG_IPPP_FILTER
 static int get_filter(void __user *arg, struct sock_filter **p)
 {
 	struct sock_fprog uprog;
@@ -465,6 +466,7 @@ static int get_filter(void __user *arg, struct sock_filter **p)
 	*p = code;
 	return uprog.len;
 }
+#endif
 
 /*
  * ippp device ioctl
diff --git a/drivers/isdn/icn/icn.c b/drivers/isdn/icn/icn.c
index bf7997a..2d95a80 100644
--- a/drivers/isdn/icn/icn.c
+++ b/drivers/isdn/icn/icn.c
@@ -717,7 +717,7 @@ icn_sendbuf(int channel, int ack, struct sk_buff *skb, icn_card * card)
 			return 0;
 		if (card->sndcount[channel] > ICN_MAX_SQUEUE)
 			return 0;
-		#warning TODO test headroom or use skb->nb to flag ACK
+		/* TODO test headroom or use skb->nb to flag ACK: */
 		nskb = skb_clone(skb, GFP_ATOMIC);
 		if (nskb) {
 			/* Push ACK flag as one
diff --git a/drivers/isdn/sc/card.h b/drivers/isdn/sc/card.h
index 0120bcf..2b99000 100644
--- a/drivers/isdn/sc/card.h
+++ b/drivers/isdn/sc/card.h
@@ -82,7 +82,7 @@ typedef struct {
 	int ioport[MAX_IO_REGS];	/* Index to I/O ports */
 	int shmem_pgport;		/* port for the exp mem page reg. */
 	int shmem_magic;		/* adapter magic number */
-	unsigned int rambase;		/* Shared RAM base address */
+	u8 __iomem *rambase;		/* Shared RAM base address */
 	unsigned int ramsize;		/* Size of shared memory */
 	RspMessage async_msg;		/* Async response message */
 	int want_async_messages;	/* Snoop the Q ? */
diff --git a/drivers/isdn/sc/init.c b/drivers/isdn/sc/init.c
index dd0acd0..afc950a 100644
--- a/drivers/isdn/sc/init.c
+++ b/drivers/isdn/sc/init.c
@@ -27,7 +27,7 @@ static const char *boardname[] = { "DataCommute/BRI", "DataCommute/PRI", "TeleCo
 /* insmod set parameters */
 static unsigned int io[] = {0,0,0,0};
 static unsigned char irq[] = {0,0,0,0};
-static unsigned long ram[] = {0,0,0,0};
+static u8 __iomem * ram[] = {0,0,0,0};
 static int do_reset = 0;
 
 module_param_array(io, int, NULL, 0);
@@ -35,7 +35,7 @@ module_param_array(irq, int, NULL, 0);
 module_param_array(ram, int, NULL, 0);
 module_param(do_reset, bool, 0);
 
-static int identify_board(unsigned long, unsigned int);
+static int identify_board(u8 __iomem *rambase, unsigned int iobase);
 
 static int __init sc_init(void)
 {
@@ -153,7 +153,7 @@ static int __init sc_init(void)
 			outb(0xFF, io[b] + RESET_OFFSET);
 			msleep_interruptible(10000);
 		}
-		pr_debug("RAM Base for board %d is 0x%lx, %s probe\n", b,
+		pr_debug("RAM Base for board %d is %p, %s probe\n", b,
 			ram[b], ram[b] == 0 ? "will" : "won't");
 
 		if(ram[b]) {
@@ -162,10 +162,10 @@ static int __init sc_init(void)
 			 * Just look for a signature and ID the
 			 * board model
 			 */
-			if(request_region(ram[b], SRAM_PAGESIZE, "sc test")) {
-				pr_debug("request_region for RAM base 0x%lx succeeded\n", ram[b]);
+			if (request_region((unsigned long)ram[b], SRAM_PAGESIZE, "sc test")) {
+				pr_debug("request_region for RAM base %p succeeded\n", ram[b]);
 			 	model = identify_board(ram[b], io[b]);
-				release_region(ram[b], SRAM_PAGESIZE);
+				release_region((unsigned long)ram[b], SRAM_PAGESIZE);
 			}
 		}
 		else {
@@ -177,12 +177,12 @@ static int __init sc_init(void)
 				pr_debug("Checking RAM address 0x%x...\n", i);
 				if(request_region(i, SRAM_PAGESIZE, "sc test")) {
 					pr_debug("  request_region succeeded\n");
-					model = identify_board(i, io[b]);
+					model = identify_board((u8 __iomem *)i, io[b]);
 					release_region(i, SRAM_PAGESIZE);
 					if (model >= 0) {
 						pr_debug("  Identified a %s\n",
 							boardname[model]);
-						ram[b] = i;
+						ram[b] = (u8 __iomem *)i;
 						break;
 					}
 					pr_debug("  Unidentifed or inaccessible\n");
@@ -199,7 +199,7 @@ static int __init sc_init(void)
 			 * Nope, there was no place in RAM for the
 			 * board, or it couldn't be identified
 			 */
-			 pr_debug("Failed to find an adapter at 0x%lx\n", ram[b]);
+			 pr_debug("Failed to find an adapter at %p\n", ram[b]);
 			 continue;
 		}
 
@@ -222,7 +222,7 @@ static int __init sc_init(void)
 			features = BRI_FEATURES;
 			break;
 		}
-		switch(ram[b] >> 12 & 0x0F) {
+		switch((unsigned long)ram[b] >> 12 & 0x0F) {
 		case 0x0:
 			pr_debug("RAM Page register set to EXP_PAGE0\n");
 			pgport = EXP_PAGE0;
@@ -358,10 +358,10 @@ static int __init sc_init(void)
 		pr_debug("Requesting I/O Port %#x\n",
 				sc_adapter[cinst]->ioport[IRQ_SELECT]);
 		sc_adapter[cinst]->rambase = ram[b];
-		request_region(sc_adapter[cinst]->rambase, SRAM_PAGESIZE,
-				interface->id);
+		request_region((unsigned long)sc_adapter[cinst]->rambase,
+				SRAM_PAGESIZE, interface->id);
 
-		pr_info("  %s (%d) - %s %d channels IRQ %d, I/O Base 0x%x, RAM Base 0x%lx\n", 
+		pr_info("  %s (%d) - %s %d channels IRQ %d, I/O Base 0x%x, RAM Base %p\n", 
 			sc_adapter[cinst]->devicename,
 			sc_adapter[cinst]->driverId,
 			boardname[model], channels, irq[b], io[b], ram[b]);
@@ -400,7 +400,7 @@ static void __exit sc_exit(void)
 		/*
 		 * Release shared RAM
 		 */
-		release_region(sc_adapter[i]->rambase, SRAM_PAGESIZE);
+		release_region((unsigned long)sc_adapter[i]->rambase, SRAM_PAGESIZE);
 
 		/*
 		 * Release the IRQ
@@ -434,7 +434,7 @@ static void __exit sc_exit(void)
 	pr_info("SpellCaster ISA ISDN Adapter Driver Unloaded.\n");
 }
 
-static int identify_board(unsigned long rambase, unsigned int iobase)
+static int identify_board(u8 __iomem *rambase, unsigned int iobase)
 {
 	unsigned int pgport;
 	unsigned long sig;
@@ -444,15 +444,15 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 	HWConfig_pl hwci;
 	int x;
 
-	pr_debug("Attempting to identify adapter @ 0x%lx io 0x%x\n",
+	pr_debug("Attempting to identify adapter @ %p io 0x%x\n",
 		rambase, iobase);
 
 	/*
 	 * Enable the base pointer
 	 */
-	outb(rambase >> 12, iobase + 0x2c00);
+	outb((unsigned long)rambase >> 12, iobase + 0x2c00);
 
-	switch(rambase >> 12 & 0x0F) {
+	switch((unsigned long)rambase >> 12 & 0x0F) {
 	case 0x0:
 		pgport = iobase + PG0_OFFSET;
 		pr_debug("Page Register offset is 0x%x\n", PG0_OFFSET);
@@ -473,7 +473,7 @@ static int identify_board(unsigned long rambase, unsigned int iobase)
 		pr_debug("Page Register offset is 0x%x\n", PG3_OFFSET);
 		break;
 	default:
-		pr_debug("Invalid rambase 0x%lx\n", rambase);
+		pr_debug("Invalid rambase %p\n", rambase);
 		return -1;
 	}
 
diff --git a/drivers/isdn/sc/scioc.h b/drivers/isdn/sc/scioc.h
index dfb107a..8de38db 100644
--- a/drivers/isdn/sc/scioc.h
+++ b/drivers/isdn/sc/scioc.h
@@ -86,7 +86,7 @@ typedef struct {
 	char load_ver[11];
 	char proc_ver[11];
 	int iobase;
-	long rambase;
+	u8 __iomem *rambase;
 	char irq;
 	long ramsize;
 	char interface;
diff --git a/drivers/isdn/sc/shmem.c b/drivers/isdn/sc/shmem.c
index 712220c..fc5b114 100644
--- a/drivers/isdn/sc/shmem.c
+++ b/drivers/isdn/sc/shmem.c
@@ -54,7 +54,7 @@ void memcpy_toshmem(int card, void *dest, const void *src, size_t n)
 	spin_unlock_irqrestore(&sc_adapter[card]->lock, flags);
 	pr_debug("%s: set page to %#x\n",sc_adapter[card]->devicename,
 		((sc_adapter[card]->shmem_magic + ch * SRAM_PAGESIZE)>>14)|0x80);
-	pr_debug("%s: copying %d bytes from %#lx to %#lx\n",
+	pr_debug("%s: copying %d bytes from %#lx to %p\n",
 		sc_adapter[card]->devicename, n,
 		(unsigned long) src,
 		sc_adapter[card]->rambase + ((unsigned long) dest %0x4000));
diff --git a/drivers/isdn/sc/timer.c b/drivers/isdn/sc/timer.c
index 91fbe0d..7b04315 100644
--- a/drivers/isdn/sc/timer.c
+++ b/drivers/isdn/sc/timer.c
@@ -27,7 +27,7 @@
 static void setup_ports(int card)
 {
 
-	outb((sc_adapter[card]->rambase >> 12), sc_adapter[card]->ioport[EXP_BASE]);
+	outb(((long)sc_adapter[card]->rambase >> 12), sc_adapter[card]->ioport[EXP_BASE]);
 
 	/* And the IRQ */
 	outb((sc_adapter[card]->interrupt | 0x80),
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index ec43f9f..8998814 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -933,7 +933,7 @@ static int parse_features(struct mirror_set *ms, unsigned argc, char **argv,
 static int mirror_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	int r;
-	unsigned int nr_mirrors, m, args_used;
+	unsigned int nr_mirrors, m, uninitialized_var(args_used);
 	struct mirror_set *ms;
 	struct dm_dirty_log *dl;
 
diff --git a/drivers/media/common/tuners/mxl5007t.c b/drivers/media/common/tuners/mxl5007t.c
index 64379f2..f6330ee 100644
--- a/drivers/media/common/tuners/mxl5007t.c
+++ b/drivers/media/common/tuners/mxl5007t.c
@@ -657,7 +657,7 @@ static int mxl5007t_get_status(struct dvb_frontend *fe, u32 *status)
 {
 	struct mxl5007t_state *state = fe->tuner_priv;
 	int rf_locked, ref_locked;
-	s32 rf_input_level;
+	s32 uninitialized_var(rf_input_level);
 	int ret;
 
 	if (fe->ops.i2c_gate_ctrl)
diff --git a/drivers/media/dvb/dvb-usb/anysee.c b/drivers/media/dvb/dvb-usb/anysee.c
index cd2edbc..f0f8ef1 100644
--- a/drivers/media/dvb/dvb-usb/anysee.c
+++ b/drivers/media/dvb/dvb-usb/anysee.c
@@ -153,7 +153,7 @@ static int anysee_master_xfer(struct i2c_adapter *adap, struct i2c_msg *msg,
 	int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
-	int ret, inc, i = 0;
+	int ret = -EINVAL, inc, i = 0;
 
 	if (mutex_lock_interruptible(&d->i2c_mutex) < 0)
 		return -EAGAIN;
diff --git a/drivers/media/dvb/frontends/drx397xD.c b/drivers/media/dvb/frontends/drx397xD.c
index b9ca5c8..a8d0a43 100644
--- a/drivers/media/dvb/frontends/drx397xD.c
+++ b/drivers/media/dvb/frontends/drx397xD.c
@@ -646,7 +646,7 @@ static int drx_tune(struct drx397xD_state *s,
 	u32 edi = 0, ebx = 0, ebp = 0, edx = 0;
 	u16 v20 = 0, v1E = 0, v16 = 0, v14 = 0, v12 = 0, v10 = 0, v0E = 0;
 
-	int rc, df_tuner;
+	int rc, uninitialized_var(df_tuner);
 	int a, b, c, d;
 	pr_debug("%s %d\n", __func__, s->config.d60);
 
diff --git a/drivers/media/dvb/ttusb-dec/ttusb_dec.c b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
index ab33fec..3b5646b 100644
--- a/drivers/media/dvb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/dvb/ttusb-dec/ttusb_dec.c
@@ -1377,7 +1377,9 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
 static int ttusb_dec_init_stb(struct ttusb_dec *dec)
 {
 	int result;
-	unsigned int mode, model, version;
+	unsigned int uninitialized_var(mode),
+		     uninitialized_var(model),
+		     uninitialized_var(version);
 
 	dprintk("%s\n", __func__);
 
diff --git a/drivers/media/video/cx18/cx18-mailbox.c b/drivers/media/video/cx18/cx18-mailbox.c
index acff7df..5c847be 100644
--- a/drivers/media/video/cx18/cx18-mailbox.c
+++ b/drivers/media/video/cx18/cx18-mailbox.c
@@ -184,7 +184,7 @@ long cx18_mb_ack(struct cx18 *cx, const struct cx18_mailbox *mb)
 static int cx18_api_call(struct cx18 *cx, u32 cmd, int args, u32 data[])
 {
 	const struct cx18_api_info *info = find_api_info(cmd);
-	u32 state = 0, irq = 0, req, oldreq, err;
+	u32 state = 0, irq = 0, uninitialized_var(req), oldreq, err;
 	struct cx18_mailbox __iomem *mb;
 	wait_queue_head_t *waitq;
 	int timeout = 100;
diff --git a/drivers/media/video/usbvideo/quickcam_messenger.c b/drivers/media/video/usbvideo/quickcam_messenger.c
index 4459b8a..606402a 100644
--- a/drivers/media/video/usbvideo/quickcam_messenger.c
+++ b/drivers/media/video/usbvideo/quickcam_messenger.c
@@ -447,7 +447,7 @@ static int qcm_sensor_init(struct uvd *uvd)
 	CHECK_RET(ret, qcm_stv_setw(uvd->dev, 0x15c1,
 				cpu_to_le16(ISOC_PACKET_SIZE)));
 	CHECK_RET(ret, qcm_stv_setb(uvd->dev, 0x15c3, 0x08));
-	CHECK_RET(ret, ret = qcm_stv_setb(uvd->dev, 0x143f, 0x01));
+	CHECK_RET(ret, qcm_stv_setb(uvd->dev, 0x143f, 0x01));
 
 	CHECK_RET(ret, qcm_stv_setb(uvd->dev, STV_ISO_ENABLE, 0x00));
 
diff --git a/drivers/media/video/usbvision/usbvision-i2c.c b/drivers/media/video/usbvision/usbvision-i2c.c
index 9907b9a..b07c39e 100644
--- a/drivers/media/video/usbvision/usbvision-i2c.c
+++ b/drivers/media/video/usbvision/usbvision-i2c.c
@@ -157,7 +157,7 @@ usbvision_i2c_xfer(struct i2c_adapter *i2c_adap, struct i2c_msg msgs[], int num)
 	struct i2c_msg *pmsg;
 	struct usb_usbvision *usbvision;
 	int i, ret;
-	unsigned char addr;
+	unsigned char uninitialized_var(addr);
 
 	usbvision = (struct usb_usbvision *)i2c_get_adapdata(i2c_adap);
 
diff --git a/drivers/media/video/zoran/zoran_card.c b/drivers/media/video/zoran/zoran_card.c
index fa5f2f8..acfb060 100644
--- a/drivers/media/video/zoran/zoran_card.c
+++ b/drivers/media/video/zoran/zoran_card.c
@@ -158,7 +158,7 @@ static struct pci_device_id zr36067_pci_tbl[] = {
 	 PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{0}
 };
-MODULE_DEVICE_TABLE(pci, zr36067_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, zr36067_pci_tbl);
 
 int zoran_num;			/* number of Buzs in use */
 struct zoran *zoran[BUZ_MAX];
diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/mspro_block.c
index 7911151..324ecf0 100644
--- a/drivers/memstick/core/mspro_block.c
+++ b/drivers/memstick/core/mspro_block.c
@@ -652,6 +652,7 @@ has_int_reg:
 
 	default:
 		BUG();
+		return -EINVAL;
 	}
 }
 
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index d6a0074..12dad3d 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -103,7 +103,9 @@ static int mfcounter = 0;
  *  Public data...
  */
 
+#ifdef CONFIG_PROC_FS
 static struct proc_dir_entry *mpt_proc_root_dir;
+#endif
 
 #define WHOINIT_UNKNOWN		0xAA
 
diff --git a/drivers/message/i2o/Kconfig b/drivers/message/i2o/Kconfig
index 5afa0e3..c102225 100644
--- a/drivers/message/i2o/Kconfig
+++ b/drivers/message/i2o/Kconfig
@@ -54,7 +54,7 @@ config I2O_EXT_ADAPTEC_DMA64
 
 config I2O_CONFIG
 	tristate "I2O Configuration support"
-	depends on VIRT_TO_BUS
+	depends on VIRT_TO_BUS && (BROKEN || !64BIT)
 	---help---
 	  Say Y for support of the configuration interface for the I2O adapters.
 	  If you have a RAID controller from Adaptec and you want to use the
@@ -66,6 +66,8 @@ config I2O_CONFIG
 	  Note: If you want to use the new API you have to download the
 	  i2o_config patch from http://i2o.shadowconnect.com/
 
+	  Note: This is broken on 64-bit architectures.
+
 config I2O_CONFIG_OLD_IOCTL
 	bool "Enable ioctls (OBSOLETE)"
 	depends on I2O_CONFIG
diff --git a/drivers/misc/fujitsu-laptop.c b/drivers/misc/fujitsu-laptop.c
index a7dd3e9..cc4797c 100644
--- a/drivers/misc/fujitsu-laptop.c
+++ b/drivers/misc/fujitsu-laptop.c
@@ -1123,4 +1123,4 @@ static struct pnp_device_id pnp_ids[] = {
 	{.id = ""}
 };
 
-MODULE_DEVICE_TABLE(pnp, pnp_ids);
+MODULE_STATIC_DEVICE_TABLE(pnp, pnp_ids);
diff --git a/drivers/misc/sgi-gru/grufault.c b/drivers/misc/sgi-gru/grufault.c
index 8c389d6..6b52fa1 100644
--- a/drivers/misc/sgi-gru/grufault.c
+++ b/drivers/misc/sgi-gru/grufault.c
@@ -278,8 +278,8 @@ static int gru_try_dropin(struct gru_thread_state *gts,
 {
 	struct mm_struct *mm = gts->ts_mm;
 	struct vm_area_struct *vma;
-	int pageshift, asid, write, ret;
-	unsigned long paddr, gpa, vaddr;
+	int uninitialized_var(pageshift), asid, write, ret;
+	unsigned long uninitialized_var(paddr), gpa, vaddr;
 
 	/*
 	 * NOTE: The GRU contains magic hardware that eliminates races between
diff --git a/drivers/mtd/devices/mtd_dataflash.c b/drivers/mtd/devices/mtd_dataflash.c
index 6dd9aff..118e671 100644
--- a/drivers/mtd/devices/mtd_dataflash.c
+++ b/drivers/mtd/devices/mtd_dataflash.c
@@ -673,7 +673,7 @@ add_dataflash_otp(struct spi_device *spi, char *name,
 	dev_set_drvdata(&spi->dev, priv);
 
 	if (mtd_has_partitions()) {
-		struct mtd_partition	*parts;
+		struct mtd_partition	*uninitialized_var(parts);
 		int			nr_parts = 0;
 
 #ifdef CONFIG_MTD_CMDLINE_PARTS
diff --git a/drivers/mtd/devices/phram.c b/drivers/mtd/devices/phram.c
index 088fbb7..2068a90 100644
--- a/drivers/mtd/devices/phram.c
+++ b/drivers/mtd/devices/phram.c
@@ -235,7 +235,7 @@ static int phram_setup(const char *val, struct kernel_param *kp)
 {
 	char buf[64+12+12], *str = buf;
 	char *token[3];
-	char *name;
+	char *uninitialized_var(name);
 	uint32_t start;
 	uint32_t len;
 	int i, ret;
diff --git a/drivers/net/3c523.c b/drivers/net/3c523.c
index e2ce41d..7b9d427 100644
--- a/drivers/net/3c523.c
+++ b/drivers/net/3c523.c
@@ -578,13 +578,13 @@ err_out:
 	return retval;
 }
 
+#ifdef MODULE
 static void cleanup_card(struct net_device *dev)
 {
 	mca_set_adapter_procfn(((struct priv *) (dev->priv))->slot, NULL, NULL);
 	release_region(dev->base_addr, ELMC_IO_EXTENT);
 }
-
-#ifndef MODULE
+#else
 struct net_device * __init elmc_probe(int unit)
 {
 	struct net_device *dev = alloc_etherdev(sizeof(struct priv));
diff --git a/drivers/net/atlx/atl2.c b/drivers/net/atlx/atl2.c
index 8571e8c..e02bd7e 100644
--- a/drivers/net/atlx/atl2.c
+++ b/drivers/net/atlx/atl2.c
@@ -644,7 +644,6 @@ static int atl2_request_irq(struct atl2_adapter *adapter)
 	int flags, err = 0;
 
 	flags = IRQF_SHARED;
-#ifdef CONFIG_PCI_MSI
 	adapter->have_msi = true;
 	err = pci_enable_msi(adapter->pdev);
 	if (err)
@@ -652,7 +651,6 @@ static int atl2_request_irq(struct atl2_adapter *adapter)
 
 	if (adapter->have_msi)
 		flags &= ~IRQF_SHARED;
-#endif
 
 	return request_irq(adapter->pdev->irq, &atl2_intr, flags, netdev->name,
 		netdev);
diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
index 86909cf..e083e1c 100644
--- a/drivers/net/cassini.c
+++ b/drivers/net/cassini.c
@@ -2347,7 +2347,7 @@ static int cas_rx_ringN(struct cas *cp, int ring, int budget)
 	drops = 0;
 	while (1) {
 		struct cas_rx_comp *rxc = rxcs + entry;
-		struct sk_buff *skb;
+		struct sk_buff *uninitialized_var(skb);
 		int type, len;
 		u64 words[4];
 		int i, dring;
diff --git a/drivers/net/depca.c b/drivers/net/depca.c
index ace39ec..f00bd64 100644
--- a/drivers/net/depca.c
+++ b/drivers/net/depca.c
@@ -1558,6 +1558,7 @@ static int __init depca_isa_probe (struct platform_device *device)
 #ifdef CONFIG_EISA
 static int __init depca_eisa_probe (struct device *device)
 {
+	enum depca_type adapter = unknown;
 	struct eisa_device *edev;
 	struct net_device *dev;
 	struct depca_private *lp;
@@ -1576,7 +1577,11 @@ static int __init depca_eisa_probe (struct device *device)
 	 * the EISA configuration structures (yet... :-), just rely on
 	 * the ISA probing to sort it out... */
 
-	depca_shmem_probe (&mem_start);
+	adapter = depca_shmem_probe (&mem_start);
+	if (adapter == unknown) {
+		status = -ENODEV;
+		goto out_free;
+	}
 
 	dev->base_addr = ioaddr;
 	dev->irq = irq;
diff --git a/drivers/net/mlx4/en_rx.c b/drivers/net/mlx4/en_rx.c
index 6232227..aed7739 100644
--- a/drivers/net/mlx4/en_rx.c
+++ b/drivers/net/mlx4/en_rx.c
@@ -443,7 +443,8 @@ int mlx4_en_activate_rx_rings(struct mlx4_en_priv *priv)
 		/* Fill Rx buffers */
 		ring->full = 0;
 	}
-	if (mlx4_en_fill_rx_buffers(priv))
+	err = mlx4_en_fill_rx_buffers(priv);
+	if (err)
 		goto err_buffers;
 
 	for (ring_ind = 0; ring_ind < priv->rx_ring_num; ring_ind++) {
diff --git a/drivers/net/mlx4/mcg.c b/drivers/net/mlx4/mcg.c
index 592c01a..224ef0f 100644
--- a/drivers/net/mlx4/mcg.c
+++ b/drivers/net/mlx4/mcg.c
@@ -215,7 +215,7 @@ int mlx4_multicast_attach(struct mlx4_dev *dev, struct mlx4_qp *qp, u8 gid[16],
 
 	if (block_mcast_loopback)
 		mgm->qp[members_count++] = cpu_to_be32((qp->qpn & MGM_QPN_MASK) |
-						       (1 << MGM_BLCK_LB_BIT));
+						       (1U << MGM_BLCK_LB_BIT));
 	else
 		mgm->qp[members_count++] = cpu_to_be32(qp->qpn & MGM_QPN_MASK);
 
diff --git a/drivers/net/niu.c b/drivers/net/niu.c
index 1b6f548..7e25142 100644
--- a/drivers/net/niu.c
+++ b/drivers/net/niu.c
@@ -448,7 +448,7 @@ static int serdes_init_niu_1g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u16 pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	u32 tx_cfg, rx_cfg;
 	unsigned long i;
 	int err;
@@ -547,7 +547,7 @@ static int serdes_init_niu_10g_serdes(struct niu *np)
 	struct niu_link_config *lp = &np->link_config;
 	u32 tx_cfg, rx_cfg, pll_cfg, pll_sts;
 	int max_retry = 100;
-	u64 sig, mask, val;
+	u64 uninitialized_var(sig), mask, val;
 	unsigned long i;
 	int err;
 
@@ -738,7 +738,7 @@ static int esr_write_glue0(struct niu *np, unsigned long chan, u32 val)
 
 static int esr_reset(struct niu *np)
 {
-	u32 reset;
+	u32 uninitialized_var(reset);
 	int err;
 
 	err = mdio_write(np, np->port, NIU_ESR_DEV_ADDR,
diff --git a/drivers/net/qla3xxx.c b/drivers/net/qla3xxx.c
index 508452c..3ae623e 100644
--- a/drivers/net/qla3xxx.c
+++ b/drivers/net/qla3xxx.c
@@ -3909,7 +3909,7 @@ static int __devinit ql3xxx_probe(struct pci_dev *pdev,
 	struct net_device *ndev = NULL;
 	struct ql3_adapter *qdev = NULL;
 	static int cards_found = 0;
-	int pci_using_dac, err;
+	int uninitialized_var(pci_using_dac), err;
 
 	err = pci_enable_device(pdev);
 	if (err) {
diff --git a/drivers/net/s2io.c b/drivers/net/s2io.c
index 6a1375f..a150575 100644
--- a/drivers/net/s2io.c
+++ b/drivers/net/s2io.c
@@ -7366,7 +7366,7 @@ static int rx_osm_handler(struct ring_info *ring_data, struct RxD_t * rxdp)
 	int ring_no = ring_data->ring_no;
 	u16 l3_csum, l4_csum;
 	unsigned long long err = rxdp->Control_1 & RXD_T_CODE;
-	struct lro *lro;
+	struct lro *uninitialized_var(lro);
 	u8 err_mask;
 
 	skb->dev = dev;
diff --git a/drivers/net/sis900.c b/drivers/net/sis900.c
index fa3a460..8be433e 100644
--- a/drivers/net/sis900.c
+++ b/drivers/net/sis900.c
@@ -1277,7 +1277,7 @@ static void sis900_timer(unsigned long data)
 	u16 status;
 
 	if (!sis_priv->autong_complete){
-		int speed, duplex = 0;
+		int uninitialized_var(speed), duplex = 0;
 
 		sis900_read_mode(net_dev, &speed, &duplex);
 		if (duplex){
diff --git a/drivers/net/sky2.c b/drivers/net/sky2.c
index 3813d15..85fdacc 100644
--- a/drivers/net/sky2.c
+++ b/drivers/net/sky2.c
@@ -2748,7 +2748,7 @@ static u32 sky2_mhz(const struct sky2_hw *hw)
 		return 156;
 
 	default:
-		BUG();
+		panic("sky2_mhz: unknown chip id!");
 	}
 }
 
diff --git a/drivers/net/wan/z85230.c b/drivers/net/wan/z85230.c
index 5bf7e01..d7bf53a 100644
--- a/drivers/net/wan/z85230.c
+++ b/drivers/net/wan/z85230.c
@@ -710,7 +710,7 @@ EXPORT_SYMBOL(z8530_nop);
 irqreturn_t z8530_interrupt(int irq, void *dev_id)
 {
 	struct z8530_dev *dev=dev_id;
-	u8 intr;
+	u8 uninitialized_var(intr);
 	static volatile int locker=0;
 	int work=0;
 	struct z8530_irqhandler *irqs;
diff --git a/drivers/net/wireless/ath9k/rc.c b/drivers/net/wireless/ath9k/rc.c
index cca2fc5..27b35d3 100644
--- a/drivers/net/wireless/ath9k/rc.c
+++ b/drivers/net/wireless/ath9k/rc.c
@@ -1030,7 +1030,7 @@ static u8 ath_rc_rate_getidx(struct ath_softc *sc,
 			     u16 min_rate)
 {
 	u32 j;
-	u8 nextindex;
+	u8 uninitialized_var(nextindex);
 	struct ath_tx_ratectrl *rate_ctrl =
 		(struct ath_tx_ratectrl *)(ath_rc_priv);
 
diff --git a/drivers/net/wireless/b43/b43.h b/drivers/net/wireless/b43/b43.h
index 427b820..ac55b62 100644
--- a/drivers/net/wireless/b43/b43.h
+++ b/drivers/net/wireless/b43/b43.h
@@ -853,7 +853,8 @@ void b43warn(struct b43_wl *wl, const char *fmt, ...)
 void b43dbg(struct b43_wl *wl, const char *fmt, ...)
     __attribute__ ((format(printf, 2, 3)));
 #else /* DEBUG */
-# define b43dbg(wl, fmt...) do { /* nothing */ } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+b43dbg(struct b43_wl *wl, const char *fmt, ...) { }
 #endif /* DEBUG */
 
 /* A WARN_ON variant that vanishes when b43 debugging is disabled.
diff --git a/drivers/net/wireless/b43/main.c b/drivers/net/wireless/b43/main.c
index 14c44df..bd70b27 100644
--- a/drivers/net/wireless/b43/main.c
+++ b/drivers/net/wireless/b43/main.c
@@ -3255,7 +3255,7 @@ static int b43_switch_band(struct b43_wl *wl, struct ieee80211_channel *chan)
 	struct b43_wldev *down_dev;
 	struct b43_wldev *d;
 	int err;
-	bool gmode;
+	bool uninitialized_var(gmode);
 	int prev_status;
 
 	/* Find a device and PHY which supports the band. */
diff --git a/drivers/net/wireless/iwlwifi/iwl-3945.c b/drivers/net/wireless/iwlwifi/iwl-3945.c
index 7ca5627..e9e0b1a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945.c
+++ b/drivers/net/wireless/iwlwifi/iwl-3945.c
@@ -2179,7 +2179,7 @@ int iwl3945_txpower_set_from_eeprom(struct iwl3945_priv *priv)
 		/* set tx power value for all OFDM rates */
 		for (rate_index = 0; rate_index < IWL_OFDM_RATES;
 		     rate_index++) {
-			s32 power_idx;
+			s32 uninitialized_var(power_idx);
 			int rc;
 
 			/* use channel group's clip-power table,
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index e548d67..ddc1fbf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -68,8 +68,10 @@ void iwl_dbgfs_unregister(struct iwl_priv *priv);
 #endif
 
 #else
-#define IWL_DEBUG(level, fmt, args...)
-#define IWL_DEBUG_LIMIT(level, fmt, args...)
+static inline void __attribute__ ((format(printf, 2, 3)))
+IWL_DEBUG(int level, const char *fmt, ...) { }
+static inline void __attribute__ ((format(printf, 2, 3)))
+IWL_DEBUG_LIMIT(int level, const char *fmt, ...) { }
 #endif				/* CONFIG_IWLWIFI_DEBUG */
 
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 4eee1b1..f4f0664 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -43,7 +43,6 @@
 #include "iwl-io.h"
 #include "iwl-helpers.h"
 
-#ifdef CONFIG_IWLWIFI_DEBUG
 static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_TX),
 	__stringify(IWL_LED_TRG_RX),
@@ -51,7 +50,6 @@ static const char *led_type_str[] = {
 	__stringify(IWL_LED_TRG_RADIO),
 	NULL
 };
-#endif /* CONFIG_IWLWIFI_DEBUG */
 
 
 static const struct {
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 1404a57..c23a811 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -294,7 +294,9 @@ static char hop_pattern_length[] = { 1,
 	     JAPAN_TEST_HOP_MOD
 };
 
+#ifdef CONFIG_PROC_FS
 static char rcsid[] = "Raylink/WebGear wireless LAN - Corey <Thomas corey@world.std.com>";
+#endif
 
 /*=============================================================================
     ray_attach() creates an "instance" of the driver, allocating
diff --git a/drivers/net/wireless/zd1201.c b/drivers/net/wireless/zd1201.c
index b16ec6e..39c016e 100644
--- a/drivers/net/wireless/zd1201.c
+++ b/drivers/net/wireless/zd1201.c
@@ -595,6 +595,9 @@ static inline int zd1201_getconfig16(struct zd1201 *zd, int rid, short *val)
 	int err;
 	__le16 zdval;
 
+	/* initialize */
+	*val = 0;
+
 	err = zd1201_getconfig(zd, rid, &zdval, sizeof(__le16));
 	if (err)
 		return err;
diff --git a/drivers/pci/hotplug/cpqphp.h b/drivers/pci/hotplug/cpqphp.h
index afaf8f6..390a9ba 100644
--- a/drivers/pci/hotplug/cpqphp.h
+++ b/drivers/pci/hotplug/cpqphp.h
@@ -449,7 +449,7 @@ extern u8 cpqhp_disk_irq;
 
 /* inline functions */
 
-static inline char *slot_name(struct slot *slot)
+static inline const char *slot_name(struct slot *slot)
 {
 	return hotplug_slot_name(slot->hotplug_slot);
 }
diff --git a/drivers/pci/pci-driver.c b/drivers/pci/pci-driver.c
index b4cdd69..b6e291a 100644
--- a/drivers/pci/pci-driver.c
+++ b/drivers/pci/pci-driver.c
@@ -337,7 +337,7 @@ static int pci_default_pm_resume(struct pci_dev *pci_dev)
 	return retval;
 }
 
-static int pci_legacy_suspend(struct device *dev, pm_message_t state)
+static inline int pci_legacy_suspend(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -352,7 +352,8 @@ static int pci_legacy_suspend(struct device *dev, pm_message_t state)
 	return i;
 }
 
-static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
+static inline int
+pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 {
 	struct pci_dev * pci_dev = to_pci_dev(dev);
 	struct pci_driver * drv = pci_dev->driver;
@@ -365,7 +366,7 @@ static int pci_legacy_suspend_late(struct device *dev, pm_message_t state)
 	return i;
 }
 
-static int pci_legacy_resume(struct device *dev)
+static inline int pci_legacy_resume(struct device *dev)
 {
 	int error;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
@@ -378,7 +379,7 @@ static int pci_legacy_resume(struct device *dev)
 	return error;
 }
 
-static int pci_legacy_resume_early(struct device *dev)
+static inline int pci_legacy_resume_early(struct device *dev)
 {
 	int error = 0;
 	struct pci_dev * pci_dev = to_pci_dev(dev);
diff --git a/drivers/pci/search.c b/drivers/pci/search.c
index 5af8bd5..c07d6c9 100644
--- a/drivers/pci/search.c
+++ b/drivers/pci/search.c
@@ -277,8 +277,12 @@ static struct pci_dev *pci_get_dev_by_id(const struct pci_device_id *id,
 			      match_pci_dev_by_id);
 	if (dev)
 		pdev = to_pci_dev(dev);
+
+	/*
+	 * FIXME: take the cast off, when pci_dev_put() is made const:
+	 */
 	if (from)
-		pci_dev_put(from);
+		pci_dev_put((struct pci_dev *)from);
 	return pdev;
 }
 
diff --git a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
index 996f648..e6dc4c1 100644
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -573,6 +573,8 @@ static int __init pnpbios_init(void)
 
 fs_initcall(pnpbios_init);
 
+#ifdef CONFIG_HOTPLUG
+
 static int __init pnpbios_thread_init(void)
 {
 	struct task_struct *task;
@@ -583,16 +585,18 @@ static int __init pnpbios_thread_init(void)
 #endif
 	if (pnpbios_disabled)
 		return 0;
-#ifdef CONFIG_HOTPLUG
+
 	init_completion(&unload_sem);
 	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
 	if (!IS_ERR(task))
 		unloading = 0;
-#endif
+
 	return 0;
 }
 
 /* Start the kernel thread later: */
 module_init(pnpbios_thread_init);
 
+#endif
+
 EXPORT_SYMBOL(pnpbios_protocol);
diff --git a/drivers/rtc/rtc-ds1390.c b/drivers/rtc/rtc-ds1390.c
index 599e976..8f5c803 100644
--- a/drivers/rtc/rtc-ds1390.c
+++ b/drivers/rtc/rtc-ds1390.c
@@ -42,20 +42,6 @@ struct ds1390 {
 	u8 txrx_buf[9];	/* cmd + 8 registers */
 };
 
-static void ds1390_set_reg(struct device *dev, unsigned char address,
-				unsigned char data)
-{
-	struct spi_device *spi = to_spi_device(dev);
-	struct ds1390 *chip = dev_get_drvdata(dev);
-
-	/* Set MSB to indicate write */
-	chip->txrx_buf[0] = address | 0x80;
-	chip->txrx_buf[1] = data;
-
-	/* do the i/o */
-	spi_write_then_read(spi, chip->txrx_buf, 2, NULL, 0);
-}
-
 static int ds1390_get_reg(struct device *dev, unsigned char address,
 				unsigned char *data)
 {
diff --git a/drivers/scsi/advansys.c b/drivers/scsi/advansys.c
index 218777b..9f84c18 100644
--- a/drivers/scsi/advansys.c
+++ b/drivers/scsi/advansys.c
@@ -68,7 +68,9 @@
  *  7. advansys_info is not safe against multiple simultaneous callers
  *  8. Add module_param to override ISA/VLB ioport array
  */
-#warning this driver is still not properly converted to the DMA API
+#ifdef CONFIG_ALLOW_WARNINGS
+# warning this driver is still not properly converted to the DMA API
+#endif
 
 /* Enable driver /proc statistics. */
 #define ADVANSYS_STATS
@@ -10516,7 +10518,7 @@ AscSendScsiQueue(ASC_DVC_VAR *asc_dvc, ASC_SCSI_Q *scsiq, uchar n_q_required)
 {
 	PortAddr iop_base;
 	uchar free_q_head;
-	uchar next_qp;
+	uchar uninitialized_var(next_qp);
 	uchar tid_no;
 	uchar target_ix;
 	int sta;
@@ -10945,7 +10947,7 @@ static int asc_execute_scsi_cmnd(struct scsi_cmnd *scp)
 		err_code = asc_dvc->err_code;
 	} else {
 		ADV_DVC_VAR *adv_dvc = &boardp->dvc_var.adv_dvc_var;
-		ADV_SCSI_REQ_Q *adv_scsiqp;
+		ADV_SCSI_REQ_Q *uninitialized_var(adv_scsiqp);
 
 		switch (adv_build_req(boardp, scp, &adv_scsiqp)) {
 		case ASC_NOERROR:
@@ -13876,7 +13878,9 @@ static int __devinit advansys_board_found(struct Scsi_Host *shost,
 		free_dma(shost->dma_channel);
  err_free_proc:
 	kfree(boardp->prtbuf);
+#ifdef CONFIG_PROC_FS
  err_unmap:
+#endif
 	if (boardp->ioremap_addr)
 		iounmap(boardp->ioremap_addr);
  err_shost:
diff --git a/drivers/scsi/dpt_i2o.c b/drivers/scsi/dpt_i2o.c
index 6194ed5..3ca7501 100644
--- a/drivers/scsi/dpt_i2o.c
+++ b/drivers/scsi/dpt_i2o.c
@@ -183,7 +183,7 @@ static struct pci_device_id dptids[] = {
 	{ PCI_DPT_VENDOR_ID, PCI_DPT_RAPTOR_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, }
 };
-MODULE_DEVICE_TABLE(pci,dptids);
+MODULE_STATIC_DEVICE_TABLE(pci,dptids);
 
 static int adpt_detect(struct scsi_host_template* sht)
 {
diff --git a/drivers/scsi/dtc.c b/drivers/scsi/dtc.c
index c2677ba..e2a5ded 100644
--- a/drivers/scsi/dtc.c
+++ b/drivers/scsi/dtc.c
@@ -165,36 +165,6 @@ static const struct signature {
 
 #define NO_SIGNATURES ARRAY_SIZE(signatures)
 
-#ifndef MODULE
-/*
- * Function : dtc_setup(char *str, int *ints)
- *
- * Purpose : LILO command line initialization of the overrides array,
- *
- * Inputs : str - unused, ints - array of integer parameters with ints[0]
- *	equal to the number of ints.
- *
- */
-
-static void __init dtc_setup(char *str, int *ints)
-{
-	static int commandline_current = 0;
-	int i;
-	if (ints[0] != 2)
-		printk("dtc_setup: usage dtc=address,irq\n");
-	else if (commandline_current < NO_OVERRIDES) {
-		overrides[commandline_current].address = ints[1];
-		overrides[commandline_current].irq = ints[2];
-		for (i = 0; i < NO_BASES; ++i)
-			if (bases[i].address == ints[1]) {
-				bases[i].noauto = 1;
-				break;
-			}
-		++commandline_current;
-	}
-}
-#endif
-
 /* 
  * Function : int dtc_detect(struct scsi_host_template * tpnt)
  *
diff --git a/drivers/scsi/fdomain.c b/drivers/scsi/fdomain.c
index 56f4e6b..9da634c 100644
--- a/drivers/scsi/fdomain.c
+++ b/drivers/scsi/fdomain.c
@@ -1774,7 +1774,7 @@ static struct pci_device_id fdomain_pci_tbl[] __devinitdata = {
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, fdomain_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, fdomain_pci_tbl);
 #endif
 #define driver_template fdomain_driver_template
 #include "scsi_module.c"
diff --git a/drivers/scsi/g_NCR5380.c b/drivers/scsi/g_NCR5380.c
index 75585a5..3b41abf 100644
--- a/drivers/scsi/g_NCR5380.c
+++ b/drivers/scsi/g_NCR5380.c
@@ -938,18 +938,6 @@ module_param(ncr_53c400a, int, 0);
 module_param(dtc_3181e, int, 0);
 MODULE_LICENSE("GPL");
 
-
-static struct isapnp_device_id id_table[] __devinitdata = {
-	{
-	 ISAPNP_ANY_ID, ISAPNP_ANY_ID,
-	 ISAPNP_VENDOR('D', 'T', 'C'), ISAPNP_FUNCTION(0x436e),
-	 0},
-	{0}
-};
-
-MODULE_DEVICE_TABLE(isapnp, id_table);
-
-
 __setup("ncr5380=", do_NCR5380_setup);
 __setup("ncr53c400=", do_NCR53C400_setup);
 __setup("ncr53c400a=", do_NCR53C400A_setup);
diff --git a/drivers/scsi/initio.c b/drivers/scsi/initio.c
index e3f7397..3d6bbc0 100644
--- a/drivers/scsi/initio.c
+++ b/drivers/scsi/initio.c
@@ -136,7 +136,7 @@ static struct pci_device_id i91u_pci_devices[] = {
 	{ PCI_VENDOR_ID_DOMEX, I920_DEVICE_ID, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0},
 	{ }
 };
-MODULE_DEVICE_TABLE(pci, i91u_pci_devices);
+MODULE_STATIC_DEVICE_TABLE(pci, i91u_pci_devices);
 
 #define DEBUG_INTERRUPT 0
 #define DEBUG_QUEUE     0
diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 630bd28..6ea9805 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3917,7 +3917,8 @@ lpfc_els_rcv_rscn(struct lpfc_vport *vport, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_dmabuf *pcmd;
 	uint32_t *lp, *datap;
 	IOCB_t *icmd;
-	uint32_t payload_len, length, nportid, *cmd;
+	uint32_t payload_len, uninitialized_var(length), nportid,
+		 *uninitialized_var(cmd);
 	int rscn_cnt;
 	int rscn_id = 0, hba_id = 0;
 	int i;
diff --git a/drivers/scsi/megaraid/megaraid_mm.c b/drivers/scsi/megaraid/megaraid_mm.c
index f680561..0c36f54 100644
--- a/drivers/scsi/megaraid/megaraid_mm.c
+++ b/drivers/scsi/megaraid/megaraid_mm.c
@@ -117,7 +117,7 @@ mraid_mm_ioctl(struct inode *inode, struct file *filep, unsigned int cmd,
 	int		rval;
 	mraid_mmadp_t	*adp;
 	uint8_t		old_ioctl;
-	int		drvrcmd_rval;
+	int		uninitialized_var(drvrcmd_rval);
 	void __user *argp = (void __user *)arg;
 
 	/*
diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index 3b7240e..2f976bf 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -8295,7 +8295,7 @@ __setup("ncr53c8xx=", ncr53c8xx_setup);
 struct Scsi_Host * __init ncr_attach(struct scsi_host_template *tpnt,
 					int unit, struct ncr_device *device)
 {
-	struct host_data *host_data;
+	struct host_data *uninitialized_var(host_data);
 	struct ncb *np = NULL;
 	struct Scsi_Host *instance = NULL;
 	u_long flags = 0;
diff --git a/drivers/scsi/qla4xxx/ql4_mbx.c b/drivers/scsi/qla4xxx/ql4_mbx.c
index c577d79..22d9b50 100644
--- a/drivers/scsi/qla4xxx/ql4_mbx.c
+++ b/drivers/scsi/qla4xxx/ql4_mbx.c
@@ -867,7 +867,7 @@ int qla4xxx_send_tgts(struct scsi_qla_host *ha, char *ip, uint16_t port)
 {
 	struct dev_db_entry *fw_ddb_entry;
 	dma_addr_t fw_ddb_entry_dma;
-	uint32_t ddb_index;
+	uint32_t uninitialized_var(ddb_index);
 	int ret_val = QLA_SUCCESS;
 
 
diff --git a/drivers/telephony/ixj.c b/drivers/telephony/ixj.c
index a913efc..b5d7682 100644
--- a/drivers/telephony/ixj.c
+++ b/drivers/telephony/ixj.c
@@ -288,7 +288,7 @@ static struct pci_device_id ixj_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, ixj_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ixj_pci_tbl);
 
 /************************************************************************
 *
diff --git a/drivers/usb/atm/ueagle-atm.c b/drivers/usb/atm/ueagle-atm.c
index b6483dd..7161f16 100644
--- a/drivers/usb/atm/ueagle-atm.c
+++ b/drivers/usb/atm/ueagle-atm.c
@@ -1427,7 +1427,7 @@ static int uea_stat_e1(struct uea_softc *sc)
 static int uea_stat_e4(struct uea_softc *sc)
 {
 	u32 data;
-	u32 tmp_arr[2];
+	u32 tmp_arr[2] = { 0, };
 	int ret;
 
 	uea_enters(INS_TO_USBDEV(sc));
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index e85c8c0..2ff584b 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -293,7 +293,7 @@ static void update_edgeport_E2PROM(struct edgeport_serial *edge_serial)
 	__u16 BootBuildNumber;
 	__u32 Bootaddr;
 	const struct ihex_binrec *rec;
-	const struct firmware *fw;
+	const struct firmware *uninitialized_var(fw);
 	const char *fw_name;
 	int response;
 
@@ -2457,7 +2457,7 @@ static int send_cmd_write_baud_rate(struct edgeport_port *edge_port,
 	unsigned char *cmdBuffer;
 	unsigned char *currCmd;
 	int cmdLen = 0;
-	int divisor;
+	int uninitialized_var(divisor);
 	int status;
 	unsigned char number =
 		edge_port->port->number - edge_port->port->serial->minor;
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index 9878c0f..7b81a15 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -1345,7 +1345,7 @@ static int keyspan_fake_startup(struct usb_serial *serial)
 	int 				response;
 	const struct ihex_binrec 	*record;
 	char				*fw_name;
-	const struct firmware		*fw;
+	const struct firmware		*uninitialized_var(fw);
 
 	dbg("Keyspan startup version %04x product %04x",
 	    le16_to_cpu(serial->dev->descriptor.bcdDevice),
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index bf1ae24..8d57883 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -456,7 +456,7 @@ static int keyspan_pda_tiocmget(struct tty_struct *tty, struct file *file)
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int rc;
-	unsigned char status;
+	unsigned char uninitialized_var(status);
 	int value;
 
 	rc = keyspan_pda_get_modem_info(serial, &status);
@@ -478,7 +478,7 @@ static int keyspan_pda_tiocmset(struct tty_struct *tty, struct file *file,
 	struct usb_serial_port *port = tty->driver_data;
 	struct usb_serial *serial = port->serial;
 	int rc;
-	unsigned char status;
+	unsigned char uninitialized_var(status);
 
 	rc = keyspan_pda_get_modem_info(serial, &status);
 	if (rc < 0)
@@ -726,7 +726,7 @@ static int keyspan_pda_fake_startup(struct usb_serial *serial)
 	int response;
 	const char *fw_name;
 	const struct ihex_binrec *record;
-	const struct firmware *fw;
+	const struct firmware *uninitialized_var(fw);
 
 	/* download the firmware here ... */
 	response = ezusb_set_reset(serial, 1);
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index e772cc0..26c8ae1 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -959,7 +959,7 @@ static int send_cmd_write_baud_rate(struct moschip_port *mos7720_port,
 {
 	struct usb_serial_port *port;
 	struct usb_serial *serial;
-	int divisor;
+	int uninitialized_var(divisor);
 	int status;
 	unsigned char data;
 	unsigned char number;
diff --git a/drivers/uwb/i1480/i1480-est.c b/drivers/uwb/i1480/i1480-est.c
index 7bf8c6f..c062fdb 100644
--- a/drivers/uwb/i1480/i1480-est.c
+++ b/drivers/uwb/i1480/i1480-est.c
@@ -96,4 +96,4 @@ static struct usb_device_id i1480_est_id_table[] = {
 	{ USB_DEVICE(0x8086, 0x0c3b), },
 	{ },
 };
-MODULE_DEVICE_TABLE(usb, i1480_est_id_table);
+MODULE_STATIC_DEVICE_TABLE(usb, i1480_est_id_table);
diff --git a/drivers/uwb/whc-rc.c b/drivers/uwb/whc-rc.c
index 1711dea..69ff6c6 100644
--- a/drivers/uwb/whc-rc.c
+++ b/drivers/uwb/whc-rc.c
@@ -494,7 +494,7 @@ static struct pci_device_id whcrc_id_table[] = {
 	{ PCI_DEVICE_CLASS(PCI_CLASS_WIRELESS_WHCI, ~0) },
 	{ /* empty last entry */ }
 };
-MODULE_DEVICE_TABLE(pci, whcrc_id_table);
+MODULE_STATIC_DEVICE_TABLE(pci, whcrc_id_table);
 
 static struct umc_driver whcrc_driver = {
 	.name   = "whc-rc",
diff --git a/drivers/uwb/wlp/messages.c b/drivers/uwb/wlp/messages.c
index a64cb82..80bfa62 100644
--- a/drivers/uwb/wlp/messages.c
+++ b/drivers/uwb/wlp/messages.c
@@ -988,7 +988,7 @@ int wlp_parse_f0(struct wlp *wlp, struct sk_buff *skb)
 	size_t len = skb->len;
 	size_t used;
 	ssize_t result;
-	struct wlp_nonce enonce, rnonce;
+	struct wlp_nonce uninitialized_var(enonce), uninitialized_var(rnonce);
 	enum wlp_assc_error assc_err;
 	char enonce_buf[WLP_WSS_NONCE_STRSIZE];
 	char rnonce_buf[WLP_WSS_NONCE_STRSIZE];
diff --git a/drivers/video/aty/atyfb_base.c b/drivers/video/aty/atyfb_base.c
index cc6b470..03403d6 100644
--- a/drivers/video/aty/atyfb_base.c
+++ b/drivers/video/aty/atyfb_base.c
@@ -430,7 +430,7 @@ static int __devinit correct_chipset(struct atyfb_par *par)
 	u16 type;
 	u32 chip_id;
 	const char *name;
-	int i;
+	long i;
 
 	for (i = ARRAY_SIZE(aty_chips) - 1; i >= 0; i--)
 		if (par->pci_id == aty_chips[i].pci_id)
@@ -529,8 +529,10 @@ static int __devinit correct_chipset(struct atyfb_par *par)
 	return 0;
 }
 
+#if defined(CONFIG_FB_ATY_GX) || defined(CONFIG_FB_ATY_CT)
 static char ram_dram[] __devinitdata = "DRAM";
 static char ram_resv[] __devinitdata = "RESV";
+#endif
 #ifdef CONFIG_FB_ATY_GX
 static char ram_vram[] __devinitdata = "VRAM";
 #endif /* CONFIG_FB_ATY_GX */
@@ -3850,3 +3852,4 @@ MODULE_PARM_DESC(mode, "Specify resolution as \"<xres>x<yres>[-<bpp>][@<refresh>
 module_param(nomtrr, bool, 0);
 MODULE_PARM_DESC(nomtrr, "bool: disable use of MTRR registers");
 #endif
+
diff --git a/drivers/video/matrox/matroxfb_crtc2.c b/drivers/video/matrox/matroxfb_crtc2.c
index 7ac4c5f..0d26e45 100644
--- a/drivers/video/matrox/matroxfb_crtc2.c
+++ b/drivers/video/matrox/matroxfb_crtc2.c
@@ -262,7 +262,7 @@ static int matroxfb_dh_open(struct fb_info* info, int user) {
 #define m2info (container_of(info, struct matroxfb_dh_fb_info, fbcon))
 	MINFO_FROM(m2info->primary_dev);
 
-	if (MINFO) {
+	if (MINFO != NULL) {
 		int err;
 
 		if (ACCESS_FBINFO(dead)) {
@@ -282,7 +282,7 @@ static int matroxfb_dh_release(struct fb_info* info, int user) {
 	int err = 0;
 	MINFO_FROM(m2info->primary_dev);
 
-	if (MINFO) {
+	if (MINFO != NULL) {
 		err = ACCESS_FBINFO(fbops).fb_release(&ACCESS_FBINFO(fbcon), user);
 	}
 	return err;
diff --git a/drivers/video/mb862xx/mb862xxfb.c b/drivers/video/mb862xx/mb862xxfb.c
index 38718d9..cb7f03d 100644
--- a/drivers/video/mb862xx/mb862xxfb.c
+++ b/drivers/video/mb862xx/mb862xxfb.c
@@ -85,6 +85,8 @@ static inline unsigned int chan_to_field(unsigned int chan,
 	return chan << bf->offset;
 }
 
+#if defined(CONFIG_FB_MB862XX_PCI_GDC) || defined(CONFIG_FB_MB862XX_LIME)
+
 static int mb862xxfb_setcolreg(unsigned regno,
 			       unsigned red, unsigned green, unsigned blue,
 			       unsigned transp, struct fb_info *info)
@@ -458,6 +460,8 @@ static ssize_t mb862xxfb_show_dispregs(struct device *dev,
 
 static DEVICE_ATTR(dispregs, 0444, mb862xxfb_show_dispregs, NULL);
 
+#endif
+
 irqreturn_t mb862xx_intr(int irq, void *dev_id)
 {
 	struct mb862xxfb_par *par = (struct mb862xxfb_par *) dev_id;
diff --git a/drivers/video/sis/init301.c b/drivers/video/sis/init301.c
index da33d80..889973d 100644
--- a/drivers/video/sis/init301.c
+++ b/drivers/video/sis/init301.c
@@ -6691,7 +6691,7 @@ SiS_SetGroup2(struct SiS_Private *SiS_Pr, unsigned short ModeNo, unsigned short
   bool           newtvphase;
   const unsigned char *TimingPoint;
 #ifdef SIS315H
-  unsigned short resindex, CRT2Index;
+  unsigned short uninitialized_var(resindex), uninitialized_var(CRT2Index);
   const struct SiS_Part2PortTbl *CRT2Part2Ptr = NULL;
 
   if(SiS_Pr->SiS_VBInfo & SetCRT2ToLCDA) return;
diff --git a/drivers/video/sis/sis_main.c b/drivers/video/sis/sis_main.c
index 346d645..a8617c3 100644
--- a/drivers/video/sis/sis_main.c
+++ b/drivers/video/sis/sis_main.c
@@ -4175,6 +4175,7 @@ sisfb_find_rom(struct pci_dev *pdev)
 	return myrombase;
 }
 
+#if defined(CONFIG_FB_SIS_300) || defined(CONFIG_FB_SIS_315)
 static void __devinit
 sisfb_post_map_vram(struct sis_video_info *ivideo, unsigned int *mapsize,
 			unsigned int min)
@@ -4197,6 +4198,7 @@ sisfb_post_map_vram(struct sis_video_info *ivideo, unsigned int *mapsize,
 		}
 	}
 }
+#endif
 
 #ifdef CONFIG_FB_SIS_300
 static int __devinit
diff --git a/drivers/watchdog/alim1535_wdt.c b/drivers/watchdog/alim1535_wdt.c
index 2a7690e..8fdcc6f 100644
--- a/drivers/watchdog/alim1535_wdt.c
+++ b/drivers/watchdog/alim1535_wdt.c
@@ -306,7 +306,7 @@ static struct pci_device_id ali_pci_tbl[] = {
 	{ PCI_VENDOR_ID_AL, 0x1535, PCI_ANY_ID, PCI_ANY_ID,},
 	{ 0, },
 };
-MODULE_DEVICE_TABLE(pci, ali_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, ali_pci_tbl);
 
 /*
  *	ali_find_watchdog	-	find a 1535 and 7101
diff --git a/drivers/watchdog/alim7101_wdt.c b/drivers/watchdog/alim7101_wdt.c
index a045ef8..ba4b8ee 100644
--- a/drivers/watchdog/alim7101_wdt.c
+++ b/drivers/watchdog/alim7101_wdt.c
@@ -427,7 +427,7 @@ static struct pci_device_id alim7101_pci_tbl[] __devinitdata = {
 	{ }
 };
 
-MODULE_DEVICE_TABLE(pci, alim7101_pci_tbl);
+MODULE_STATIC_DEVICE_TABLE(pci, alim7101_pci_tbl);
 
 MODULE_AUTHOR("Steve Hill");
 MODULE_DESCRIPTION("ALi M7101 PMU Computer Watchdog Timer driver");
diff --git a/drivers/watchdog/i6300esb.c b/drivers/watchdog/i6300esb.c
index 74f951c..705ede5 100644
--- a/drivers/watchdog/i6300esb.c
+++ b/drivers/watchdog/i6300esb.c
@@ -355,20 +355,6 @@ static struct notifier_block esb_notifier = {
 };
 
 /*
- * Data for PCI driver interface
- *
- * This data only exists for exporting the supported
- * PCI ids via MODULE_DEVICE_TABLE.  We do not actually
- * register a pci_driver, because someone else might one day
- * want to register another driver on the same PCI id.
- */
-static struct pci_device_id esb_pci_tbl[] = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_ESB_9), },
-	{ 0, },                 /* End of list */
-};
-MODULE_DEVICE_TABLE(pci, esb_pci_tbl);
-
-/*
  *      Init & exit routines
  */
 
diff --git a/drivers/watchdog/w83697ug_wdt.c b/drivers/watchdog/w83697ug_wdt.c
index ada8ad8..3488193 100644
--- a/drivers/watchdog/w83697ug_wdt.c
+++ b/drivers/watchdog/w83697ug_wdt.c
@@ -79,7 +79,7 @@ MODULE_PARM_DESC(nowayout,
 							(same as EFER) */
 #define WDT_EFDR (WDT_EFIR+1) /* Extended Function Data Register */
 
-static void w83697ug_select_wd_register(void)
+static int w83697ug_select_wd_register(void)
 {
 	unsigned char c;
 	unsigned char version;
@@ -102,7 +102,7 @@ static void w83697ug_select_wd_register(void)
 
 	} else {
 		printk(KERN_ERR PFX "No W83697UG/UF could be found\n");
-		return;
+		return -EIO;
 	}
 
 	outb_p(0x07, WDT_EFER); /* point to logical device number reg */
@@ -110,6 +110,8 @@ static void w83697ug_select_wd_register(void)
 	outb_p(0x30, WDT_EFER); /* select CR30 */
 	c = inb_p(WDT_EFDR);
 	outb_p(c || 0x01, WDT_EFDR); /* set bit 0 to activate GPIO2 */
+
+	return 0;
 }
 
 static void w83697ug_unselect_wd_register(void)
@@ -117,11 +119,12 @@ static void w83697ug_unselect_wd_register(void)
 	outb_p(0xAA, WDT_EFER); /* Leave extended function mode */
 }
 
-static void w83697ug_init(void)
+static int w83697ug_init(void)
 {
 	unsigned char t;
 
-	w83697ug_select_wd_register();
+	if (w83697ug_select_wd_register())
+		return -EIO;
 
 	outb_p(0xF6, WDT_EFER); /* Select CRF6 */
 	t = inb_p(WDT_EFDR);    /* read CRF6 */
@@ -137,6 +140,8 @@ static void w83697ug_init(void)
 	outb_p(t, WDT_EFDR);    /* Write back to CRF5 */
 
 	w83697ug_unselect_wd_register();
+
+	return 0;
 }
 
 static void wdt_ctrl(int timeout)
@@ -347,7 +352,11 @@ static int __init wdt_init(void)
 		goto out;
 	}
 
-	w83697ug_init();
+	ret = w83697ug_init();
+	if (ret) {
+		printk(KERN_ERR PFX "init failed\n");
+		goto unreg_regions;
+	}
 
 	ret = register_reboot_notifier(&wdt_notifier);
 	if (ret != 0) {
diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 99cf390..6dbfa5d 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -564,7 +564,7 @@ static struct dentry *afs_lookup(struct inode *dir, struct dentry *dentry,
 static int afs_d_revalidate(struct dentry *dentry, struct nameidata *nd)
 {
 	struct afs_vnode *vnode, *dir;
-	struct afs_fid fid;
+	struct afs_fid fid = { 0, };
 	struct dentry *parent;
 	struct key *key;
 	void *dir_version;
diff --git a/fs/befs/linuxvfs.c b/fs/befs/linuxvfs.c
index b6dfee3..2cc135d 100644
--- a/fs/befs/linuxvfs.c
+++ b/fs/befs/linuxvfs.c
@@ -168,7 +168,7 @@ befs_lookup(struct inode *dir, struct dentry *dentry, struct nameidata *nd)
 	befs_off_t offset;
 	int ret;
 	int utfnamelen;
-	char *utfname;
+	char *uninitialized_var(utfname);
 	const char *name = dentry->d_name.name;
 
 	befs_debug(sb, "---> befs_lookup() "
@@ -221,8 +221,8 @@ befs_readdir(struct file *filp, void *dirent, filldir_t filldir)
 	size_t keysize;
 	unsigned char d_type;
 	char keybuf[BEFS_NAME_LEN + 1];
-	char *nlsname;
-	int nlsnamelen;
+	char *uninitialized_var(nlsname);
+	int uninitialized_var(nlsnamelen);
 	const char *dirname = filp->f_path.dentry->d_name.name;
 
 	befs_debug(sb, "---> befs_readdir() "
diff --git a/fs/cifs/cifssmb.c b/fs/cifs/cifssmb.c
index 2af8626..a7d5d43 100644
--- a/fs/cifs/cifssmb.c
+++ b/fs/cifs/cifssmb.c
@@ -3111,7 +3111,7 @@ CIFSSMBGetCIFSACL(const int xid, struct cifsTconInfo *tcon, __u16 fid,
 		__u32 parm_len;
 		__u32 acl_len;
 		struct smb_com_ntransact_rsp *pSMBr;
-		char *pdata;
+		char *uninitialized_var(pdata);
 
 /* validate_nttransact */
 		rc = validate_ntransact(iov[0].iov_base, (char **)&parm,
diff --git a/fs/cifs/readdir.c b/fs/cifs/readdir.c
index 9f51f9b..a9bda27 100644
--- a/fs/cifs/readdir.c
+++ b/fs/cifs/readdir.c
@@ -910,7 +910,7 @@ static int cifs_filldir(char *pfindEntry, struct file *file,
 	ino_t  inum;
 	struct cifs_sb_info *cifs_sb;
 	struct inode *tmp_inode;
-	struct dentry *tmp_dentry;
+	struct dentry *uninitialized_var(tmp_dentry);
 
 	/* get filename and len into qstring */
 	/* get dentry */
@@ -996,7 +996,7 @@ int cifs_readdir(struct file *file, void *direntry, filldir_t filldir)
 	struct cifs_sb_info *cifs_sb;
 	struct cifsTconInfo *pTcon;
 	struct cifsFileInfo *cifsFile = NULL;
-	char *current_entry;
+	char *uninitialized_var(current_entry);
 	int num_to_fill = 0;
 	char *tmp_buf = NULL;
 	char *end_of_smb;
diff --git a/fs/coda/Makefile b/fs/coda/Makefile
index 6c22e61..161433c 100644
--- a/fs/coda/Makefile
+++ b/fs/coda/Makefile
@@ -5,7 +5,9 @@
 obj-$(CONFIG_CODA_FS) += coda.o
 
 coda-objs := psdev.o cache.o cnode.o inode.o dir.o file.o upcall.o \
-	     coda_linux.o symlink.o pioctl.o sysctl.o 
+	     coda_linux.o symlink.o pioctl.o
+
+coda-$(CONFIG_SYSCTL) += sysctl.o
 
 # If you want debugging output, please uncomment the following line.
 
diff --git a/fs/coda/coda_int.h b/fs/coda/coda_int.h
index 8ccd5ed..dcd35eb 100644
--- a/fs/coda/coda_int.h
+++ b/fs/coda/coda_int.h
@@ -12,8 +12,13 @@ void coda_destroy_inodecache(void);
 int coda_init_inodecache(void);
 int coda_fsync(struct file *coda_file, struct dentry *coda_dentry,
 	       int datasync);
+#ifdef CONFIG_SYSCTL
 void coda_sysctl_init(void);
 void coda_sysctl_clean(void);
+#else
+static inline void coda_sysctl_init(void) { }
+static inline void coda_sysctl_clean(void) { }
+#endif
 
 #endif  /*  _CODA_INT_  */
 
diff --git a/fs/coda/sysctl.c b/fs/coda/sysctl.c
index 81b7771..87a3cab 100644
--- a/fs/coda/sysctl.c
+++ b/fs/coda/sysctl.c
@@ -54,18 +54,14 @@ static ctl_table fs_table[] = {
 
 void coda_sysctl_init(void)
 {
-#ifdef CONFIG_SYSCTL
-	if ( !fs_table_header )
+	if (!fs_table_header)
 		fs_table_header = register_sysctl_table(fs_table);
-#endif
 }
 
 void coda_sysctl_clean(void)
 {
-#ifdef CONFIG_SYSCTL
-	if ( fs_table_header ) {
+	if (fs_table_header) {
 		unregister_sysctl_table(fs_table_header);
 		fs_table_header = NULL;
 	}
-#endif
 }
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index 0adced2..0edf303 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -42,6 +42,7 @@
 #define elf_prstatus	compat_elf_prstatus
 #define elf_prpsinfo	compat_elf_prpsinfo
 
+#if defined(USE_ELF_CORE_DUMP) && defined(CONFIG_ELF_CORE)
 /*
  * Compat version of cputime_to_compat_timeval, perhaps this
  * should be an inline in <linux/compat.h>.
@@ -55,8 +56,9 @@ static void cputime_to_compat_timeval(const cputime_t cputime,
 	value->tv_usec = tv.tv_usec;
 }
 
-#undef cputime_to_timeval
-#define cputime_to_timeval cputime_to_compat_timeval
+# undef cputime_to_timeval
+# define cputime_to_timeval cputime_to_compat_timeval
+#endif
 
 
 /*
diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
index 932a92b..99177c4 100644
--- a/fs/configfs/symlink.c
+++ b/fs/configfs/symlink.c
@@ -135,7 +135,7 @@ int configfs_symlink(struct inode *dir, struct dentry *dentry, const char *symna
 	struct path path;
 	struct configfs_dirent *sd;
 	struct config_item *parent_item;
-	struct config_item *target_item;
+	struct config_item *uninitialized_var(target_item);
 	struct config_item_type *type;
 
 	ret = -EPERM;  /* What lack-of-symlink returns */
diff --git a/fs/dcache.c b/fs/dcache.c
index a1d86c7..2e2505f 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -1884,6 +1884,8 @@ out_nolock:
 shouldnt_be_hashed:
 	spin_unlock(&dcache_lock);
 	BUG();
+
+	return NULL;
 }
 
 static int prepend(char **buffer, int *buflen, const char *str, int namelen)
diff --git a/fs/dlm/netlink.c b/fs/dlm/netlink.c
index 18bda83..aa2a577 100644
--- a/fs/dlm/netlink.c
+++ b/fs/dlm/netlink.c
@@ -127,8 +127,8 @@ static void fill_data(struct dlm_lock_data *data, struct dlm_lkb *lkb)
 
 void dlm_timeout_warn(struct dlm_lkb *lkb)
 {
+	struct sk_buff *uninitialized_var(send_skb);
 	struct dlm_lock_data *data;
-	struct sk_buff *send_skb;
 	size_t size;
 	int rv;
 
diff --git a/fs/ecryptfs/keystore.c b/fs/ecryptfs/keystore.c
index 0d713b6..c43b9ba 100644
--- a/fs/ecryptfs/keystore.c
+++ b/fs/ecryptfs/keystore.c
@@ -439,7 +439,7 @@ decrypt_pki_encrypted_session_key(struct ecryptfs_auth_tok *auth_tok,
 	struct ecryptfs_message *msg = NULL;
 	char *auth_tok_sig;
 	char *payload;
-	size_t payload_len;
+	size_t uninitialized_var(payload_len);
 	int rc;
 
 	rc = ecryptfs_get_auth_tok_sig(&auth_tok_sig, auth_tok);
@@ -1331,7 +1331,7 @@ pki_encrypt_session_key(struct ecryptfs_auth_tok *auth_tok,
 {
 	struct ecryptfs_msg_ctx *msg_ctx = NULL;
 	char *payload = NULL;
-	size_t payload_len;
+	size_t uninitialized_var(payload_len);
 	struct ecryptfs_message *msg;
 	int rc;
 
diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index aec5c13..495f417 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -1050,7 +1050,7 @@ retry:
 asmlinkage long sys_epoll_create1(int flags)
 {
 	int error, fd = -1;
-	struct eventpoll *ep;
+	struct eventpoll *uninitialized_var(ep);
 
 	/* Check the EPOLL_* constant for consistency.  */
 	BUILD_BUG_ON(EPOLL_CLOEXEC != O_CLOEXEC);
diff --git a/fs/ext4/extents.c b/fs/ext4/extents.c
index ea2ce3c..9a34682 100644
--- a/fs/ext4/extents.c
+++ b/fs/ext4/extents.c
@@ -1156,6 +1156,7 @@ ext4_ext_search_right(struct inode *inode, struct ext4_ext_path *path,
 		return 0;
 	}
 
+	ix = NULL; /* avoid gcc false positive warning */
 	/* go up and search for index to the right */
 	while (--depth >= 0) {
 		ix = path[depth].p_idx;
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index bf326d4..9c3dcab 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -595,12 +595,12 @@ static int vfat_build_slots(struct inode *dir, const unsigned char *name,
 	struct fat_mount_options *opts = &sbi->options;
 	struct msdos_dir_slot *ps;
 	struct msdos_dir_entry *de;
-	unsigned char cksum, lcase;
+	unsigned char cksum, uninitialized_var(lcase);
 	unsigned char msdos_name[MSDOS_NAME];
 	wchar_t *uname;
 	__le16 time, date;
 	u8 time_cs;
-	int err, ulen, usize, i;
+	int err, uninitialized_var(ulen), usize, i;
 	loff_t offset;
 
 	*nr_slots = 0;
diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
index 2bc7d8a..93fcb6c 100644
--- a/fs/jfs/jfs_dmap.c
+++ b/fs/jfs/jfs_dmap.c
@@ -1618,7 +1618,7 @@ static int dbAllocAny(struct bmap * bmp, s64 nblocks, int l2nb, s64 * results)
  */
 static int dbFindCtl(struct bmap * bmp, int l2nb, int level, s64 * blkno)
 {
-	int rc, leafidx, lev;
+	int rc, uninitialized_var(leafidx), lev;
 	s64 b, lblkno;
 	struct dmapctl *dcp;
 	int budmin;
diff --git a/fs/locks.c b/fs/locks.c
index 09062e3..9b25d70 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1567,7 +1567,7 @@ EXPORT_SYMBOL(flock_lock_file_wait);
 asmlinkage long sys_flock(unsigned int fd, unsigned int cmd)
 {
 	struct file *filp;
-	struct file_lock *lock;
+	struct file_lock *uninitialized_var(lock);
 	int can_sleep, unlock;
 	int error;
 
diff --git a/fs/nfs/client.c b/fs/nfs/client.c
index 7547600..ffc8894 100644
--- a/fs/nfs/client.c
+++ b/fs/nfs/client.c
@@ -248,6 +248,7 @@ static int nfs_sockaddr_match_ipaddr(const struct sockaddr *sa1,
 				(const struct sockaddr_in6 *)sa2);
 	}
 	BUG();
+	return 0;
 }
 
 /*
diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
index c22543b..9bedf3b 100644
--- a/fs/ocfs2/aops.c
+++ b/fs/ocfs2/aops.c
@@ -1662,7 +1662,7 @@ int ocfs2_write_begin_nolock(struct address_space *mapping,
 {
 	int ret, credits = OCFS2_INODE_UPDATE_CREDITS;
 	unsigned int clusters_to_alloc, extents_to_split;
-	struct ocfs2_write_ctxt *wc;
+	struct ocfs2_write_ctxt *uninitialized_var(wc);
 	struct inode *inode = mapping->host;
 	struct ocfs2_super *osb = OCFS2_SB(inode->i_sb);
 	struct ocfs2_dinode *di;
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 6ebaa58..bd35543 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -1026,8 +1026,8 @@ static ssize_t o2hb_region_block_bytes_write(struct o2hb_region *reg,
 					     size_t count)
 {
 	int status;
-	unsigned long block_bytes;
-	unsigned int block_bits;
+	unsigned long uninitialized_var(block_bytes);
+	unsigned int uninitialized_var(block_bits);
 
 	if (reg->hr_bdev)
 		return -EINVAL;
diff --git a/fs/ocfs2/ioctl.c b/fs/ocfs2/ioctl.c
index 9fcd36d..70fb70c 100644
--- a/fs/ocfs2/ioctl.c
+++ b/fs/ocfs2/ioctl.c
@@ -111,7 +111,7 @@ bail:
 long ocfs2_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 {
 	struct inode *inode = filp->f_path.dentry->d_inode;
-	unsigned int flags;
+	unsigned int uninitialized_var(flags);
 	int new_clusters;
 	int status;
 	struct ocfs2_space_resv sr;
diff --git a/fs/ocfs2/slot_map.c b/fs/ocfs2/slot_map.c
index bdda2d8..d22aedb 100644
--- a/fs/ocfs2/slot_map.c
+++ b/fs/ocfs2/slot_map.c
@@ -357,7 +357,7 @@ static int ocfs2_map_slot_buffers(struct ocfs2_super *osb,
 {
 	int status = 0;
 	u64 blkno;
-	unsigned long long blocks, bytes;
+	unsigned long long blocks, uninitialized_var(bytes);
 	unsigned int i;
 	struct buffer_head *bh;
 
diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index faec2d8..55e2cdc 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -804,7 +804,7 @@ static int fs_protocol_compare(struct ocfs2_protocol_version *existing,
 static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 {
 	dlm_lockspace_t *fsdlm;
-	struct ocfs2_live_connection *control;
+	struct ocfs2_live_connection *uninitialized_var(control);
 	int rc = 0;
 
 	BUG_ON(conn == NULL);
diff --git a/fs/omfs/file.c b/fs/omfs/file.c
index 834b233..5715d1c 100644
--- a/fs/omfs/file.c
+++ b/fs/omfs/file.c
@@ -237,14 +237,14 @@ static int omfs_get_block(struct inode *inode, sector_t block,
 	struct buffer_head *bh;
 	sector_t next, offset;
 	int ret;
-	u64 new_block;
+	u64 uninitialized_var(new_block);
 	u32 max_extents;
 	int extent_count;
 	struct omfs_extent *oe;
 	struct omfs_extent_entry *entry;
 	struct omfs_sb_info *sbi = OMFS_SB(inode->i_sb);
 	int max_blocks = bh_result->b_size >> inode->i_blkbits;
-	int remain;
+	int uninitialized_var(remain);
 
 	ret = -EIO;
 	bh = sb_bread(inode->i_sb, clus_to_blk(sbi, inode->i_ino));
diff --git a/fs/reiserfs/do_balan.c b/fs/reiserfs/do_balan.c
index 2f87f5b..4b2c3df 100644
--- a/fs/reiserfs/do_balan.c
+++ b/fs/reiserfs/do_balan.c
@@ -1295,9 +1295,8 @@ static int balance_leaf(struct tree_balance *tb, struct item_head *ih,	/* item h
 
 					RFALSE(ih, "PAP-12210: ih must be 0");
 
-					if (is_direntry_le_ih
-					    (aux_ih =
-					     B_N_PITEM_HEAD(tbS0, item_pos))) {
+					aux_ih = B_N_PITEM_HEAD(tbS0, item_pos);
+					if (is_direntry_le_ih(aux_ih)) {
 						/* we append to directory item */
 
 						int entry_count;
diff --git a/fs/reiserfs/lbalance.c b/fs/reiserfs/lbalance.c
index 6de060a..6398395 100644
--- a/fs/reiserfs/lbalance.c
+++ b/fs/reiserfs/lbalance.c
@@ -389,7 +389,8 @@ static void leaf_item_bottle(struct buffer_info *dest_bi,
 
 	if (last_first == FIRST_TO_LAST) {
 		/* if ( if item in position item_num in buffer SOURCE is directory item ) */
-		if (is_direntry_le_ih(ih = B_N_PITEM_HEAD(src, item_num)))
+		ih = B_N_PITEM_HEAD(src, item_num);
+		if (is_direntry_le_ih(ih))
 			leaf_copy_dir_entries(dest_bi, src, FIRST_TO_LAST,
 					      item_num, 0, cpy_bytes);
 		else {
@@ -417,7 +418,8 @@ static void leaf_item_bottle(struct buffer_info *dest_bi,
 		}
 	} else {
 		/*  if ( if item in position item_num in buffer SOURCE is directory item ) */
-		if (is_direntry_le_ih(ih = B_N_PITEM_HEAD(src, item_num)))
+		ih = B_N_PITEM_HEAD(src, item_num);
+		if (is_direntry_le_ih(ih))
 			leaf_copy_dir_entries(dest_bi, src, LAST_TO_FIRST,
 					      item_num,
 					      I_ENTRY_COUNT(ih) - cpy_bytes,
@@ -774,8 +776,8 @@ void leaf_delete_items(struct buffer_info *cur_bi, int last_first,
 			leaf_delete_items_entirely(cur_bi, first + 1,
 						   del_num - 1);
 
-			if (is_direntry_le_ih
-			    (ih = B_N_PITEM_HEAD(bh, B_NR_ITEMS(bh) - 1)))
+			ih = B_N_PITEM_HEAD(bh, B_NR_ITEMS(bh) - 1);
+			if (is_direntry_le_ih(ih))
 				/* the last item is directory  */
 				/* len = numbers of directory entries in this item */
 				len = ih_entry_count(ih);
diff --git a/fs/udf/truncate.c b/fs/udf/truncate.c
index 65e19b4..08fd88c 100644
--- a/fs/udf/truncate.c
+++ b/fs/udf/truncate.c
@@ -87,7 +87,7 @@ void udf_truncate_tail_extent(struct inode *inode)
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
-		BUG();
+		panic("udf_truncate_tail_extent: unknown alloc type!");
 
 	/* Find the last extent in the file */
 	while ((netype = udf_next_aext(inode, &epos, &eloc, &elen, 1)) != -1) {
@@ -214,7 +214,7 @@ void udf_truncate_extents(struct inode *inode)
 	else if (iinfo->i_alloc_type == ICBTAG_FLAG_AD_LONG)
 		adsize = sizeof(long_ad);
 	else
-		BUG();
+		panic("udf_truncate_extents: unknown alloc type!");
 
 	etype = inode_bmap(inode, first_block, &epos, &eloc, &elen, &offset);
 	byte_offset = (offset << sb->s_blocksize_bits) +
diff --git a/fs/xfs/linux-2.6/xfs_xattr.c b/fs/xfs/linux-2.6/xfs_xattr.c
index 964621f..b7b459c 100644
--- a/fs/xfs/linux-2.6/xfs_xattr.c
+++ b/fs/xfs/linux-2.6/xfs_xattr.c
@@ -30,20 +30,6 @@
 
 
 /*
- * ACL handling.  Should eventually be moved into xfs_acl.c
- */
-
-static int
-xfs_decode_acl(const char *name)
-{
-	if (strcmp(name, "posix_acl_access") == 0)
-		return _ACL_TYPE_ACCESS;
-	else if (strcmp(name, "posix_acl_default") == 0)
-		return _ACL_TYPE_DEFAULT;
-	return -EINVAL;
-}
-
-/*
  * Get system extended attributes which at the moment only
  * includes Posix ACLs.
  */
diff --git a/fs/xfs/xfs_acl.c b/fs/xfs/xfs_acl.c
index b2f639a..d29e58c 100644
--- a/fs/xfs/xfs_acl.c
+++ b/fs/xfs/xfs_acl.c
@@ -51,6 +51,19 @@ kmem_zone_t *xfs_acl_zone;
 
 
 /*
+ * ACL handling.
+ */
+int
+xfs_decode_acl(const char *name)
+{
+	if (strcmp(name, "posix_acl_access") == 0)
+		return _ACL_TYPE_ACCESS;
+	else if (strcmp(name, "posix_acl_default") == 0)
+		return _ACL_TYPE_DEFAULT;
+	return -EINVAL;
+}
+
+/*
  * Test for existence of access ACL attribute as efficiently as possible.
  */
 int
diff --git a/fs/xfs/xfs_acl.h b/fs/xfs/xfs_acl.h
index a4e293b..0d4e8a2 100644
--- a/fs/xfs/xfs_acl.h
+++ b/fs/xfs/xfs_acl.h
@@ -59,6 +59,7 @@ extern struct kmem_zone *xfs_acl_zone;
 		(zone) = kmem_zone_init(sizeof(xfs_acl_t), (name))
 #define xfs_acl_zone_destroy(zone)	kmem_zone_destroy(zone)
 
+extern int xfs_decode_acl(const char *);
 extern int xfs_acl_inherit(struct inode *, mode_t mode, xfs_acl_t *);
 extern int xfs_acl_iaccess(struct xfs_inode *, mode_t, cred_t *);
 extern int xfs_acl_vtoacl(struct inode *, xfs_acl_t *, xfs_acl_t *);
@@ -80,6 +81,7 @@ extern int xfs_acl_vremove(struct inode *, int);
 #define _ACL_FREE(a)		((a)? kmem_zone_free(xfs_acl_zone, (a)):(void)0)
 
 #else
+#define xfs_decode_acl(name)	(-EINVAL)
 #define xfs_acl_zone_init(zone,name)
 #define xfs_acl_zone_destroy(zone)
 #define xfs_acl_vset(v,p,sz,t)	(-EOPNOTSUPP)
diff --git a/fs/xfs/xfs_mount.c b/fs/xfs/xfs_mount.c
index 15f5dd2..684674b 100644
--- a/fs/xfs/xfs_mount.c
+++ b/fs/xfs/xfs_mount.c
@@ -1453,6 +1453,8 @@ xfs_mod_sb(xfs_trans_t *tp, __int64_t fields)
 	/* find modified range */
 
 	f = (xfs_sb_field_t)xfs_lowbit64((__uint64_t)fields);
+	if ((long)f < 0) /* work around gcc warning */
+		return;
 	ASSERT((1LL << f) & XFS_SB_MOD_BITS);
 	first = xfs_sb_info[f].offset;
 
diff --git a/fs/xfs/xfs_rtalloc.c b/fs/xfs/xfs_rtalloc.c
index e2f68de..fe5de08 100644
--- a/fs/xfs/xfs_rtalloc.c
+++ b/fs/xfs/xfs_rtalloc.c
@@ -1872,7 +1872,7 @@ xfs_growfs_rt(
 	xfs_extlen_t	rsumblocks;	/* current number of rt summary blks */
 	xfs_sb_t	*sbp;		/* old superblock */
 	xfs_fsblock_t	sumbno;		/* summary block number */
-	xfs_trans_t	*tp;		/* transaction pointer */
+	xfs_trans_t	*uninitialized_var(tp);	/* transaction pointer */
 
 	sbp = &mp->m_sb;
 	cancelflags = 0;
diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 12c07c1..31acb40 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -79,10 +79,9 @@ extern void warn_slowpath(const char *file, const int line,
 #endif
 
 #ifndef WARN
-#define WARN(condition, format...) ({					\
-	int __ret_warn_on = !!(condition);				\
-	unlikely(__ret_warn_on);					\
-})
+static inline int __attribute__ ((format(printf, 2, 3)))
+__WARN(int condition, const char *fmt, ...) { return condition; }
+#define WARN(condition, format...) __WARN(!!(condition), format)
 #endif
 
 #endif
diff --git a/include/linux/audit.h b/include/linux/audit.h
index 6272a39..9c1f8cc 100644
--- a/include/linux/audit.h
+++ b/include/linux/audit.h
@@ -516,7 +516,7 @@ extern int audit_signals;
 #define audit_inode(n,d) do { ; } while (0)
 #define audit_inode_child(d,i,p) do { ; } while (0)
 #define audit_core_dumps(i) do { ; } while (0)
-#define auditsc_get_stamp(c,t,s) do { BUG(); } while (0)
+#define auditsc_get_stamp(c,t,s) do { BUG(); *(t) = (struct timespec){ 0, }; } while (0)
 #define audit_get_loginuid(t) (-1)
 #define audit_get_sessionid(t) (-1)
 #define audit_log_task_context(b) do { ; } while (0)
@@ -580,7 +580,8 @@ extern int audit_enabled;
 #define audit_log(c,g,t,f,...) do { ; } while (0)
 #define audit_log_start(c,g,t) ({ NULL; })
 #define audit_log_vformat(b,f,a) do { ; } while (0)
-#define audit_log_format(b,f,...) do { ; } while (0)
+static inline void __attribute__ ((format(printf, 2, 3)))
+audit_log_format(struct audit_buffer *ab, const char *fmt, ...) { }
 #define audit_log_end(b) do { ; } while (0)
 #define audit_log_n_hex(a,b,l) do { ; } while (0)
 #define audit_log_n_string(a,c,l) do { ; } while (0)
diff --git a/include/linux/coda_linux.h b/include/linux/coda_linux.h
index dcc228a..ab040b0 100644
--- a/include/linux/coda_linux.h
+++ b/include/linux/coda_linux.h
@@ -51,10 +51,6 @@ void coda_vattr_to_iattr(struct inode *, struct coda_vattr *);
 void coda_iattr_to_vattr(struct iattr *, struct coda_vattr *);
 unsigned short coda_flags_to_cflags(unsigned short);
 
-/* sysctl.h */
-void coda_sysctl_init(void);
-void coda_sysctl_clean(void);
-
 #define CODA_ALLOC(ptr, cast, size) do { \
     if (size < PAGE_SIZE) \
         ptr = kmalloc((unsigned long) size, GFP_KERNEL); \
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0dcdd94..6e8d29e 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1054,13 +1054,25 @@ extern int lock_may_write(struct inode *, loff_t start, unsigned long count);
 #define posix_lock_file_wait(a, b) ({ -ENOLCK; })
 #define posix_unblock_lock(a, b) (-ENOENT)
 #define vfs_test_lock(a, b) ({ 0; })
-#define vfs_lock_file(a, b, c, d) (-ENOLCK)
+static inline int
+vfs_lock_file(struct file *filp, unsigned int cmd,
+	      struct file_lock *fl, struct file_lock *conf)
+{
+	return -ENOLCK;
+}
 #define vfs_cancel_lock(a, b) ({ 0; })
 #define flock_lock_file_wait(a, b) ({ -ENOLCK; })
 #define __break_lease(a, b) ({ 0; })
-#define lease_get_mtime(a, b) ({ })
+static inline void lease_get_mtime(struct inode *inode, struct timespec *time)
+{
+	*time = (struct timespec) { 0, };
+}
 #define generic_setlease(a, b, c) ({ -EINVAL; })
-#define vfs_setlease(a, b, c) ({ -EINVAL; })
+static inline int
+vfs_setlease(struct file *filp, long arg, struct file_lock **lease)
+{
+	return -EINVAL;
+}
 #define lease_modify(a, b) ({ -EINVAL; })
 #define lock_may_read(a, b, c) ({ 1; })
 #define lock_may_write(a, b, c) ({ 1; })
@@ -1581,9 +1593,9 @@ int __put_super_and_need_restart(struct super_block *sb);
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
-	(((fops) && try_module_get((fops)->owner) ? (fops) : NULL))
+	(((fops != NULL) && try_module_get((fops)->owner) ? (fops) : NULL))
 #define fops_put(fops) \
-	do { if (fops) module_put((fops)->owner); } while(0)
+	do { if (fops != NULL) module_put((fops)->owner); } while(0)
 
 extern int register_filesystem(struct file_system_type *);
 extern int unregister_filesystem(struct file_system_type *);
@@ -1659,7 +1671,7 @@ static inline int break_lease(struct inode *inode, unsigned int mode)
 #else /* !CONFIG_FILE_LOCKING */
 #define locks_mandatory_locked(a) ({ 0; })
 #define locks_mandatory_area(a, b, c, d, e) ({ 0; })
-#define __mandatory_lock(a) ({ 0; })
+static inline int __mandatory_lock(struct inode *ino) { return 0; }
 #define mandatory_lock(a) ({ 0; })
 #define locks_verify_locked(a) ({ 0; })
 #define locks_verify_truncate(a, b, c) ({ 0; })
diff --git a/include/linux/init.h b/include/linux/init.h
index 68cb026..39747ae 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -313,16 +313,20 @@ void __init parse_early_param(void);
 #define __initdata_or_module __initdata
 #endif /*CONFIG_MODULES*/
 
-/* Functions marked as __devexit may be discarded at kernel link time, depending
-   on config options.  Newer versions of binutils detect references from
-   retained sections to discarded sections and flag an error.  Pointers to
-   __devexit functions must use __devexit_p(function_name), the wrapper will
-   insert either the function_name or NULL, depending on the config options.
+/*
+ * Functions marked as __devexit may be discarded at kernel link time,
+ * depending on config options.  Newer versions of binutils detect
+ * references from retained sections to discarded sections and flag an
+ * error.
+ *
+ * Pointers to __devexit functions must use __devexit_p(function_name),
+ * the wrapper will insert either the function_name or NULL, depending on
+ * the config options.
  */
 #if defined(MODULE) || defined(CONFIG_HOTPLUG)
-#define __devexit_p(x) x
+# define __devexit_p(x) x
 #else
-#define __devexit_p(x) NULL
+# define __devexit_p(x) ((void *)((long)(x) & 0) /* NULL */)
 #endif
 
 #ifdef MODULE
diff --git a/include/linux/mca-legacy.h b/include/linux/mca-legacy.h
index 7a3aea8..16cc419 100644
--- a/include/linux/mca-legacy.h
+++ b/include/linux/mca-legacy.h
@@ -9,7 +9,7 @@
 
 #include <linux/mca.h>
 
-#warning "MCA legacy - please move your driver to the new sysfs api"
+/* #warning "MCA legacy - please move your driver to the new sysfs api" */
 
 /* MCA_NOTFOUND is an error condition.  The other two indicate
  * motherboard POS registers contain the adapter.  They might be
diff --git a/include/linux/module.h b/include/linux/module.h
index 3bfed01..8a330de 100644
--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -78,18 +78,34 @@ void sort_extable(struct exception_table_entry *start,
 		  struct exception_table_entry *finish);
 void sort_main_extable(void);
 
+/*
+ * Return a pointer to the current module, but only if within a module
+ */
 #ifdef MODULE
-#define MODULE_GENERIC_TABLE(gtype,name)			\
-extern const struct gtype##_id __mod_##gtype##_table		\
-  __attribute__ ((unused, alias(__stringify(name))))
-
 extern struct module __this_module;
 #define THIS_MODULE (&__this_module)
 #else  /* !MODULE */
-#define MODULE_GENERIC_TABLE(gtype,name)
 #define THIS_MODULE ((struct module *)0)
 #endif
 
+/*
+ * Declare a module table
+ * - this suppresses "'name' defined but not used" warnings from the compiler
+ *   as the table may not actually be used by the code within the module
+ */
+#ifdef MODULE
+#define MODULE_GENERIC_TABLE(gtype,name)			\
+extern const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
+#define MODULE_STATIC_GENERIC_TABLE(gtype,name)			\
+extern const struct gtype##_id __mod_##gtype##_table		\
+  __attribute__ ((unused, alias(__stringify(name))))
+#else
+#define MODULE_GENERIC_TABLE(gtype,name)
+#define MODULE_STATIC_GENERIC_TABLE(gtype,name) \
+static __typeof__((name)) name __attribute__((unused));
+#endif
+
 /* Generic info of form tag = "info" */
 #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
 
@@ -139,6 +155,8 @@ extern struct module __this_module;
 
 #define MODULE_DEVICE_TABLE(type,name)		\
   MODULE_GENERIC_TABLE(type##_device,name)
+#define MODULE_STATIC_DEVICE_TABLE(type,name)		\
+  MODULE_STATIC_GENERIC_TABLE(type##_device,name)
 
 /* Version of form [<epoch>:]<version>[-<extra-version>].
    Or for CVS/RCS ID version, everything but the number is stripped.
diff --git a/include/linux/pci.h b/include/linux/pci.h
index feb4657..a9c0aee 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -868,7 +868,10 @@ static inline struct pci_dev *pci_get_class(unsigned int class,
 	return NULL;
 }
 
-#define pci_dev_present(ids)	(0)
+static inline int pci_dev_present(const struct pci_device_id *ids)
+{
+	return 0;
+}
 #define no_pci_devices()	(1)
 #define pci_dev_put(dev)	do { } while (0)
 
diff --git a/include/linux/ucb1400.h b/include/linux/ucb1400.h
index 970473b..6139c96 100644
--- a/include/linux/ucb1400.h
+++ b/include/linux/ucb1400.h
@@ -134,8 +134,8 @@ static inline void ucb1400_adc_enable(struct snd_ac97 *ac97)
 	ucb1400_reg_write(ac97, UCB_ADC_CR, UCB_ADC_ENA);
 }
 
-static unsigned int ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel,
-					int adcsync)
+static inline unsigned int
+ucb1400_adc_read(struct snd_ac97 *ac97, u16 adc_channel, int adcsync)
 {
 	unsigned int val;
 
diff --git a/include/net/netfilter/nf_conntrack_l4proto.h b/include/net/netfilter/nf_conntrack_l4proto.h
index 7f2f43c..debdaf7 100644
--- a/include/net/netfilter/nf_conntrack_l4proto.h
+++ b/include/net/netfilter/nf_conntrack_l4proto.h
@@ -129,7 +129,7 @@ extern const struct nla_policy nf_ct_port_nla_policy[];
 	 && net_ratelimit())
 #endif
 #else
-#define LOG_INVALID(net, proto) 0
+static inline int LOG_INVALID(struct net *net, int proto) { return 0; }
 #endif /* CONFIG_SYSCTL */
 
 #endif /*_NF_CONNTRACK_PROTOCOL_H*/
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 0dfebc5..010850a 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -18,6 +18,7 @@
 #include <linux/msg.h>
 #include "util.h"
 
+#if defined(CONFIG_PROC_FS) || defined(CONFIG_SYSCTL_SYSCALL)
 static void *get_ipc(ctl_table *table)
 {
 	char *which = table->data;
@@ -25,7 +26,9 @@ static void *get_ipc(ctl_table *table)
 	which = (which - (char *)&init_ipc_ns) + (char *)ipc_ns;
 	return which;
 }
+#endif
 
+#ifdef CONFIG_PROC_FS
 /*
  * Routine that is called when the file "auto_msgmni" has successfully been
  * written.
@@ -49,7 +52,6 @@ static void ipc_auto_callback(int val)
 	}
 }
 
-#ifdef CONFIG_PROC_FS
 static int proc_ipc_dointvec(ctl_table *table, int write, struct file *filp,
 	void __user *buffer, size_t *lenp, loff_t *ppos)
 {
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index da7ff61..96c0ba1 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -585,7 +585,7 @@ static int generate_sched_domains(cpumask_t **domains,
 	int i, j, k;		/* indices for partition finding loops */
 	cpumask_t *doms;	/* resulting partition; i.e. sched domains */
 	struct sched_domain_attr *dattr;  /* attributes for custom domains */
-	int ndoms;		/* number of sched domains in result */
+	int ndoms = 0;		/* number of sched domains in result */
 	int nslot;		/* next empty doms[] cpumask_t slot */
 
 	doms = NULL;
diff --git a/kernel/marker.c b/kernel/marker.c
index e9c6b2b..36f7af8 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -430,7 +430,7 @@ static int remove_marker(const char *name)
 {
 	struct hlist_head *head;
 	struct hlist_node *node;
-	struct marker_entry *e;
+	struct marker_entry *uninitialized_var(e);
 	int found = 0;
 	size_t len = strlen(name) + 1;
 	u32 hash = jhash(name, len-1, 0);
diff --git a/kernel/power/main.c b/kernel/power/main.c
index b8f7ce9..eaa122b 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -58,16 +58,6 @@ int pm_notifier_call_chain(unsigned long val)
 #ifdef CONFIG_PM_DEBUG
 int pm_test_level = TEST_NONE;
 
-static int suspend_test(int level)
-{
-	if (pm_test_level == level) {
-		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
-		mdelay(5000);
-		return 1;
-	}
-	return 0;
-}
-
 static const char * const pm_tests[__TEST_AFTER_LAST] = {
 	[TEST_NONE] = "none",
 	[TEST_CORE] = "core",
@@ -126,9 +116,8 @@ static ssize_t pm_test_store(struct kobject *kobj, struct kobj_attribute *attr,
 }
 
 power_attr(pm_test);
-#else /* !CONFIG_PM_DEBUG */
-static inline int suspend_test(int level) { return 0; }
-#endif /* !CONFIG_PM_DEBUG */
+
+#endif /* CONFIG_PM_DEBUG */
 
 #endif /* CONFIG_PM_SLEEP */
 
@@ -136,6 +125,16 @@ static inline int suspend_test(int level) { return 0; }
 
 #ifdef CONFIG_PM_TEST_SUSPEND
 
+static int suspend_test(int level)
+{
+	if (pm_test_level == level) {
+		printk(KERN_INFO "suspend debug: Waiting for 5 seconds.\n");
+		mdelay(5000);
+		return 1;
+	}
+	return 0;
+}
+
 /*
  * We test the system suspend code by setting an RTC wakealarm a short
  * time in the future, then suspending.  Suspending the devices won't
@@ -187,6 +186,11 @@ static void suspend_test_finish(const char *label)
 {
 }
 
+static inline int suspend_test(int level)
+{
+	return 0;
+}
+
 #endif
 
 /* This is just an arbitrary number */
diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 5d2ab83..d36971d 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -476,8 +476,8 @@ static int memory_bm_find_bit(struct memory_bitmap *bm, unsigned long pfn,
 
 static void memory_bm_set_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
-	void *addr;
-	unsigned int bit;
+	unsigned int bit = 0;
+	void *addr = NULL;
 	int error;
 
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
@@ -510,8 +510,8 @@ static void memory_bm_clear_bit(struct memory_bitmap *bm, unsigned long pfn)
 
 static int memory_bm_test_bit(struct memory_bitmap *bm, unsigned long pfn)
 {
-	void *addr;
-	unsigned int bit;
+	unsigned int bit = 0;
+	void *addr = NULL;
 	int error;
 
 	error = memory_bm_find_bit(bm, pfn, &addr, &bit);
diff --git a/kernel/profile.c b/kernel/profile.c
index 5b7d1ac..8733514 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -255,6 +255,7 @@ EXPORT_SYMBOL_GPL(unregister_timer_hook);
  *
  * -- wli
  */
+#ifdef CONFIG_PROC_FS
 static void __profile_flip_buffers(void *unused)
 {
 	int cpu = smp_processor_id();
@@ -300,57 +301,6 @@ static void profile_discard_flip_buffers(void)
 	mutex_unlock(&profile_flip_mutex);
 }
 
-void profile_hits(int type, void *__pc, unsigned int nr_hits)
-{
-	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
-	int i, j, cpu;
-	struct profile_hit *hits;
-
-	if (prof_on != type || !prof_buffer)
-		return;
-	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
-	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
-	secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
-	cpu = get_cpu();
-	hits = per_cpu(cpu_profile_hits, cpu)[per_cpu(cpu_profile_flip, cpu)];
-	if (!hits) {
-		put_cpu();
-		return;
-	}
-	/*
-	 * We buffer the global profiler buffer into a per-CPU
-	 * queue and thus reduce the number of global (and possibly
-	 * NUMA-alien) accesses. The write-queue is self-coalescing:
-	 */
-	local_irq_save(flags);
-	do {
-		for (j = 0; j < PROFILE_GRPSZ; ++j) {
-			if (hits[i + j].pc == pc) {
-				hits[i + j].hits += nr_hits;
-				goto out;
-			} else if (!hits[i + j].hits) {
-				hits[i + j].pc = pc;
-				hits[i + j].hits = nr_hits;
-				goto out;
-			}
-		}
-		i = (i + secondary) & (NR_PROFILE_HIT - 1);
-	} while (i != primary);
-
-	/*
-	 * Add the current hit(s) and flush the write-queue out
-	 * to the global buffer:
-	 */
-	atomic_add(nr_hits, &prof_buffer[pc]);
-	for (i = 0; i < NR_PROFILE_HIT; ++i) {
-		atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
-		hits[i].pc = hits[i].hits = 0;
-	}
-out:
-	local_irq_restore(flags);
-	put_cpu();
-}
-
 static int __devinit profile_cpu_callback(struct notifier_block *info,
 					unsigned long action, void *__cpu)
 {
@@ -407,6 +357,60 @@ out_free:
 	}
 	return NOTIFY_OK;
 }
+#endif /* CONFIG_PROC_FS */
+
+void profile_hits(int type, void *__pc, unsigned int nr_hits)
+{
+	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
+	int i, j, cpu;
+	struct profile_hit *hits;
+
+	if (prof_on != type || !prof_buffer)
+		return;
+	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
+	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
+	secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
+	cpu = get_cpu();
+	hits = per_cpu(cpu_profile_hits, cpu)[per_cpu(cpu_profile_flip, cpu)];
+	if (!hits) {
+		put_cpu();
+		return;
+	}
+	/*
+	 * We buffer the global profiler buffer into a per-CPU
+	 * queue and thus reduce the number of global (and possibly
+	 * NUMA-alien) accesses. The write-queue is self-coalescing:
+	 */
+	local_irq_save(flags);
+	do {
+		for (j = 0; j < PROFILE_GRPSZ; ++j) {
+			if (hits[i + j].pc == pc) {
+				hits[i + j].hits += nr_hits;
+				goto out;
+			} else if (!hits[i + j].hits) {
+				hits[i + j].pc = pc;
+				hits[i + j].hits = nr_hits;
+				goto out;
+			}
+		}
+		i = (i + secondary) & (NR_PROFILE_HIT - 1);
+	} while (i != primary);
+
+	/*
+	 * Add the current hit(s) and flush the write-queue out
+	 * to the global buffer:
+	 */
+	atomic_add(nr_hits, &prof_buffer[pc]);
+	for (i = 0; i < NR_PROFILE_HIT; ++i) {
+		atomic_add(hits[i].hits, &prof_buffer[hits[i].pc]);
+		hits[i].pc = hits[i].hits = 0;
+	}
+out:
+	local_irq_restore(flags);
+	put_cpu();
+}
+
+
 #else /* !CONFIG_SMP */
 #define profile_flip_buffers()		do { } while (0)
 #define profile_discard_flip_buffers()	do { } while (0)
diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
index b0f239e..d0a1e18 100644
--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -9,8 +9,20 @@ config PRINTK_TIME
 	  operations.  This is useful for identifying long delays
 	  in kernel startup.
 
+config ALLOW_WARNINGS
+	bool "Continue building despite compiler warnings"
+	default y
+	help
+	  By disabling this option you will enable -Werror on building C
+	  files. This causes all warnings to abort the compilation, just as
+	  errors do. (It is generally not recommended to disable this option as
+	  the overwhelming majority of warnings is harmless and also gcc puts
+	  out false-positive warnings. It is useful for automated testing
+	  though.)
+
 config ENABLE_WARN_DEPRECATED
 	bool "Enable __deprecated logic"
+	depends on ALLOW_WARNINGS
 	default y
 	help
 	  Enable the __deprecated logic in the kernel build.
@@ -19,12 +31,13 @@ config ENABLE_WARN_DEPRECATED
 
 config ENABLE_MUST_CHECK
 	bool "Enable __must_check logic"
-	default y
+	depends on ALLOW_WARNINGS
 	help
 	  Enable the __must_check logic in the kernel build.  Disable this to
 	  suppress the "warning: ignoring return value of 'foo', declared with
 	  attribute warn_unused_result" messages.
 
+
 config FRAME_WARN
 	int "Warn for stack frames larger than (needs gcc 4.4)"
 	range 0 8192
diff --git a/mm/bootmem.c b/mm/bootmem.c
index ac5a891..4778ce8 100644
--- a/mm/bootmem.c
+++ b/mm/bootmem.c
@@ -318,6 +318,8 @@ static int __init mark_bootmem(unsigned long start, unsigned long end,
 		pos = bdata->node_low_pfn;
 	}
 	BUG();
+
+	return 0;
 }
 
 /**
diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index e9493b1..98b815a 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -1418,7 +1418,7 @@ unsigned slab_node(struct mempolicy *policy)
 	}
 
 	default:
-		BUG();
+		panic("slab_node: bad policy mode!");
 	}
 }
 
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 90cb67a..f7a76cb 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1481,7 +1481,7 @@ asmlinkage long sys_swapon(const char __user * specialfile, int swap_flags)
 	int swap_header_version;
 	unsigned int nr_good_pages = 0;
 	int nr_extents = 0;
-	sector_t span;
+	sector_t uninitialized_var(span);
 	unsigned long maxpages = 1;
 	int swapfilesize;
 	unsigned short *swap_map = NULL;
diff --git a/net/ax25/sysctl_net_ax25.c b/net/ax25/sysctl_net_ax25.c
index f288fc4..735ceef 100644
--- a/net/ax25/sysctl_net_ax25.c
+++ b/net/ax25/sysctl_net_ax25.c
@@ -24,7 +24,9 @@ static int min_idle[1],			max_idle[] = {65535000};
 static int min_n2[] = {1},		max_n2[] = {31};
 static int min_paclen[] = {1},		max_paclen[] = {512};
 static int min_proto[1],		max_proto[] = { AX25_PROTO_MAX };
+#ifdef CONFIG_AX25_DAMA_SLAVE
 static int min_ds_timeout[1],		max_ds_timeout[] = {65535000};
+#endif
 
 static struct ctl_table_header *ax25_table_header;
 
diff --git a/net/bluetooth/rfcomm/sock.c b/net/bluetooth/rfcomm/sock.c
index 8a972b6..bc0d4a7 100644
--- a/net/bluetooth/rfcomm/sock.c
+++ b/net/bluetooth/rfcomm/sock.c
@@ -792,7 +792,9 @@ static int rfcomm_sock_getsockopt(struct socket *sock, int level, int optname, c
 
 static int rfcomm_sock_ioctl(struct socket *sock, unsigned int cmd, unsigned long arg)
 {
+#if defined(CONFIG_BT_RFCOMM_TTY) || defined(CONFIG_BT_RFCOMM_DEBUG)
 	struct sock *sk = sock->sk;
+#endif
 	int err;
 
 	BT_DBG("sk %p cmd %x arg %lx", sk, cmd, arg);
diff --git a/net/dccp/options.c b/net/dccp/options.c
index 0809b63..18dcfb9 100644
--- a/net/dccp/options.c
+++ b/net/dccp/options.c
@@ -64,7 +64,7 @@ int dccp_parse_options(struct sock *sk, struct dccp_request_sock *dreq,
 					(dh->dccph_doff * 4);
 	struct dccp_options_received *opt_recv = &dp->dccps_options_received;
 	unsigned char opt, len;
-	unsigned char *value;
+	unsigned char *uninitialized_var(value);
 	u32 elapsed_time;
 	__be32 opt_val;
 	int rc;
diff --git a/net/dsa/mv88e6060.c b/net/dsa/mv88e6060.c
index 54068ef..bfb4a64 100644
--- a/net/dsa/mv88e6060.c
+++ b/net/dsa/mv88e6060.c
@@ -222,7 +222,7 @@ static void mv88e6060_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int port_status;
+		int uninitialized_var(port_status);
 		int link;
 		int speed;
 		int duplex;
diff --git a/net/dsa/mv88e6xxx.c b/net/dsa/mv88e6xxx.c
index aa6c609..4e4d8b5 100644
--- a/net/dsa/mv88e6xxx.c
+++ b/net/dsa/mv88e6xxx.c
@@ -358,7 +358,7 @@ void mv88e6xxx_poll_link(struct dsa_switch *ds)
 
 	for (i = 0; i < DSA_MAX_PORTS; i++) {
 		struct net_device *dev;
-		int port_status;
+		int uninitialized_var(port_status);
 		int link;
 		int speed;
 		int duplex;
diff --git a/net/ipv6/ip6_flowlabel.c b/net/ipv6/ip6_flowlabel.c
index 37a4e77..62809ec 100644
--- a/net/ipv6/ip6_flowlabel.c
+++ b/net/ipv6/ip6_flowlabel.c
@@ -464,7 +464,7 @@ static inline void fl_link(struct ipv6_pinfo *np, struct ipv6_fl_socklist *sfl,
 
 int ipv6_flowlabel_opt(struct sock *sk, char __user *optval, int optlen)
 {
-	int err;
+	int uninitialized_var(err);
 	struct net *net = sock_net(sk);
 	struct ipv6_pinfo *np = inet6_sk(sk);
 	struct in6_flowlabel_req freq;
diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 0302cf3..7e3a0c7 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2327,6 +2327,7 @@ __ip_vs_get_dest_entries(const struct ip_vs_get_dests *get,
 static inline void
 __ip_vs_get_timeouts(struct ip_vs_timeout_user *u)
 {
+	memset(u, 0, sizeof(*u));
 #ifdef CONFIG_IP_VS_PROTO_TCP
 	u->tcp_timeout =
 		ip_vs_protocol_tcp.timeout_table[IP_VS_TCP_S_ESTABLISHED] / HZ;
diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index 4f71071..af7ad91 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -357,7 +357,7 @@ static int help(struct sk_buff *skb,
 	int ret;
 	u32 seq;
 	int dir = CTINFO2DIR(ctinfo);
-	unsigned int matchlen, matchoff;
+	unsigned int uninitialized_var(matchlen), uninitialized_var(matchoff);
 	struct nf_ct_ftp_master *ct_ftp_info = &nfct_help(ct)->help.ct_ftp_info;
 	struct nf_conntrack_expect *exp;
 	union nf_inet_addr *daddr;
@@ -592,3 +592,4 @@ static int __init nf_conntrack_ftp_init(void)
 
 module_init(nf_conntrack_ftp_init);
 module_exit(nf_conntrack_ftp_fini);
+
diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
index ae8c260..d31ced4 100644
--- a/net/netfilter/nf_conntrack_proto_sctp.c
+++ b/net/netfilter/nf_conntrack_proto_sctp.c
@@ -373,6 +373,9 @@ static int sctp_packet(struct nf_conn *ct,
 	}
 	write_unlock_bh(&sctp_lock);
 
+	if (new_state == SCTP_CONNTRACK_MAX)
+		goto out;
+
 	nf_ct_refresh_acct(ct, ctinfo, skb, sctp_timeouts[new_state]);
 
 	if (old_state == SCTP_CONNTRACK_COOKIE_ECHOED &&
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index c718e7e..1478fb8 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -709,7 +709,7 @@ static int tpacket_rcv(struct sk_buff *skb, struct net_device *dev, struct packe
 		hdrlen = sizeof(*h.h2);
 		break;
 	default:
-		BUG();
+		panic("AF_PACKET: bad tp->version");
 	}
 
 	sll = h.raw + TPACKET_ALIGN(hdrlen);
diff --git a/net/rfkill/rfkill.c b/net/rfkill/rfkill.c
index 25ba3bd..f149b5e 100644
--- a/net/rfkill/rfkill.c
+++ b/net/rfkill/rfkill.c
@@ -389,6 +389,7 @@ static const char *rfkill_get_type_str(enum rfkill_type type)
 		return "wwan";
 	default:
 		BUG();
+		return NULL;
 	}
 }
 
diff --git a/net/sched/sch_hfsc.c b/net/sched/sch_hfsc.c
index c1e77da..b39e3b5 100644
--- a/net/sched/sch_hfsc.c
+++ b/net/sched/sch_hfsc.c
@@ -1574,7 +1574,7 @@ static int
 hfsc_enqueue(struct sk_buff *skb, struct Qdisc *sch)
 {
 	struct hfsc_class *cl;
-	int err;
+	int uninitialized_var(err);
 
 	cl = hfsc_classify(skb, sch, &err);
 	if (cl == NULL) {
diff --git a/net/sunrpc/svcauth_unix.c b/net/sunrpc/svcauth_unix.c
index f24800f..200ed93 100644
--- a/net/sunrpc/svcauth_unix.c
+++ b/net/sunrpc/svcauth_unix.c
@@ -692,7 +692,7 @@ svcauth_unix_set_client(struct svc_rqst *rqstp)
 		sin6 = svc_addr_in6(rqstp);
 		break;
 	default:
-		BUG();
+		panic("svcauth_unix_set_client: bad address family!");
 	}
 
 	rqstp->rq_client = NULL;
@@ -873,3 +873,4 @@ struct auth_ops svcauth_unix = {
 	.set_client	= svcauth_unix_set_client,
 };
 
+
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 6fb493c..636095c 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -827,7 +827,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
-	int dma_mr_acc;
+	int uninitialized_var(dma_mr_acc);
 	int need_dma_mr;
 	int ret;
 	int i;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index a5fef5e..900e595 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -276,7 +276,9 @@ rpcrdma_conn_upcall(struct rdma_cm_id *id, struct rdma_cm_event *event)
 	struct rpcrdma_xprt *xprt = id->context;
 	struct rpcrdma_ia *ia = &xprt->rx_ia;
 	struct rpcrdma_ep *ep = &xprt->rx_ep;
+#ifdef RPC_DEBUG
 	struct sockaddr_in *addr = (struct sockaddr_in *) &ep->rep_remote_addr;
+#endif
 	struct ib_qp_attr attr;
 	struct ib_qp_init_attr iattr;
 	int connstate = 0;
diff --git a/security/selinux/netnode.c b/security/selinux/netnode.c
index 7100072..a307122 100644
--- a/security/selinux/netnode.c
+++ b/security/selinux/netnode.c
@@ -140,6 +140,7 @@ static struct sel_netnode *sel_netnode_find(const void *addr, u16 family)
 		break;
 	default:
 		BUG();
+		return NULL;
 	}
 
 	list_for_each_entry_rcu(node, &sel_netnode_hash[idx].list, list)
diff --git a/sound/isa/sb/sb8.c b/sound/isa/sb/sb8.c
index 667eccc..0961e6a 100644
--- a/sound/isa/sb/sb8.c
+++ b/sound/isa/sb/sb8.c
@@ -101,7 +101,7 @@ static int __devinit snd_sb8_probe(struct device *pdev, unsigned int dev)
 	struct snd_card *card;
 	struct snd_sb8 *acard;
 	struct snd_opl3 *opl3;
-	int err;
+	int uninitialized_var(err);
 
 	card = snd_card_new(index[dev], id[dev], THIS_MODULE,
 			    sizeof(struct snd_sb8));
diff --git a/sound/oss/ad1848.c b/sound/oss/ad1848.c
index 7cf9913..2e586f4 100644
--- a/sound/oss/ad1848.c
+++ b/sound/oss/ad1848.c
@@ -2879,7 +2879,7 @@ static struct isapnp_device_id id_table[] __devinitdata = {
 	{0}
 };
 
-MODULE_DEVICE_TABLE(isapnp, id_table);
+MODULE_STATIC_DEVICE_TABLE(isapnp, id_table);
 
 static struct pnp_dev *activate_dev(char *devname, char *resname, struct pnp_dev *dev)
 {
diff --git a/sound/pci/cs46xx/cs46xx_lib.c b/sound/pci/cs46xx/cs46xx_lib.c
index fb6dc39..8ab07aa 100644
--- a/sound/pci/cs46xx/cs46xx_lib.c
+++ b/sound/pci/cs46xx/cs46xx_lib.c
@@ -3640,7 +3640,10 @@ int snd_cs46xx_resume(struct pci_dev *pci)
 {
 	struct snd_card *card = pci_get_drvdata(pci);
 	struct snd_cs46xx *chip = card->private_data;
-	int i, amp_saved;
+	int amp_saved;
+#ifdef CONFIG_SND_CS46XX_NEW_DSP
+	int i;
+#endif
 
 	pci_set_power_state(pci, PCI_D0);
 	pci_restore_state(pci);
diff --git a/sound/pci/hda/patch_sigmatel.c b/sound/pci/hda/patch_sigmatel.c
index 9563b5b..ec3443a 100644
--- a/sound/pci/hda/patch_sigmatel.c
+++ b/sound/pci/hda/patch_sigmatel.c
@@ -4425,17 +4425,17 @@ static int stac92hd71xx_suspend(struct hda_codec *codec, pm_message_t state)
 
 #endif
 
+#ifdef SND_HDA_NEEDS_RESUME
 static struct hda_codec_ops stac92hd71bxx_patch_ops = {
 	.build_controls = stac92xx_build_controls,
 	.build_pcms = stac92xx_build_pcms,
 	.init = stac92xx_init,
 	.free = stac92xx_free,
 	.unsol_event = stac92xx_unsol_event,
-#ifdef SND_HDA_NEEDS_RESUME
 	.resume = stac92hd71xx_resume,
 	.suspend = stac92hd71xx_suspend,
-#endif
 };
+#endif
 
 static struct hda_input_mux stac92hd71bxx_dmux = {
 	.num_items = 4,
diff --git a/sound/pci/pcxhr/pcxhr.c b/sound/pci/pcxhr/pcxhr.c
index 73de6e9..3a69d9d 100644
--- a/sound/pci/pcxhr/pcxhr.c
+++ b/sound/pci/pcxhr/pcxhr.c
@@ -159,7 +159,7 @@ static int pcxhr_pll_freq_register(unsigned int freq, unsigned int* pllreg,
 static int pcxhr_get_clock_reg(struct pcxhr_mgr *mgr, unsigned int rate,
 			       unsigned int *reg, unsigned int *freq)
 {
-	unsigned int val, realfreq, pllreg;
+	unsigned int val, realfreq, uninitialized_var(pllreg);
 	struct pcxhr_rmh rmh;
 	int err;
 
@@ -218,7 +218,9 @@ static int pcxhr_get_clock_reg(struct pcxhr_mgr *mgr, unsigned int rate,
 
 int pcxhr_set_clock(struct pcxhr_mgr *mgr, unsigned int rate)
 {
-	unsigned int val, realfreq, speed;
+	unsigned int uninitialized_var(val),
+		     uninitialized_var(realfreq),
+		     speed;
 	struct pcxhr_rmh rmh;
 	int err, changed;
 
@@ -511,7 +513,7 @@ static void pcxhr_trigger_tasklet(unsigned long arg)
 {
 	unsigned long flags;
 	int i, j, err;
-	struct pcxhr_pipe *pipe;
+	struct pcxhr_pipe *uninitialized_var(pipe);
 	struct snd_pcxhr *chip;
 	struct pcxhr_mgr *mgr = (struct pcxhr_mgr*)(arg);
 	int capture_mask = 0;
diff --git a/sound/pci/pcxhr/pcxhr_core.c b/sound/pci/pcxhr/pcxhr_core.c
index 7143259..c450446 100644
--- a/sound/pci/pcxhr/pcxhr_core.c
+++ b/sound/pci/pcxhr/pcxhr_core.c
@@ -1084,7 +1084,7 @@ static void pcxhr_update_timer_pos(struct pcxhr_mgr *mgr,
 				   struct pcxhr_stream *stream, int samples_to_add)
 {
 	if (stream->substream && (stream->status == PCXHR_STREAM_STATUS_RUNNING)) {
-		u_int64_t new_sample_count;
+		u_int64_t new_sample_count = 0;
 		int elapsed = 0;
 		int hardware_read = 0;
 		struct snd_pcm_runtime *runtime = stream->substream->runtime;
diff --git a/sound/pci/pcxhr/pcxhr_mixer.c b/sound/pci/pcxhr/pcxhr_mixer.c
index aabc7bc..2b44aaa 100644
--- a/sound/pci/pcxhr/pcxhr_mixer.c
+++ b/sound/pci/pcxhr/pcxhr_mixer.c
@@ -798,7 +798,7 @@ static int pcxhr_iec958_capture_byte(struct snd_pcxhr *chip, int aes_idx, unsign
 static int pcxhr_iec958_get(struct snd_kcontrol *kcontrol, struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_pcxhr *chip = snd_kcontrol_chip(kcontrol);
-	unsigned char aes_bits;
+	unsigned char uninitialized_var(aes_bits);
 	int i, err;
 
 	mutex_lock(&chip->mgr->mixer_mutex);
@@ -1056,3 +1056,4 @@ int pcxhr_create_mixer(struct pcxhr_mgr *mgr)
 
 	return 0;
 }
+
diff --git a/sound/pci/via82xx.c b/sound/pci/via82xx.c
index 1aafe95..7ed453e 100644
--- a/sound/pci/via82xx.c
+++ b/sound/pci/via82xx.c
@@ -2428,7 +2428,7 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct via82xx *chip;
+	struct via82xx *uninitialized_var(chip);
 	int chip_type = 0, card_type;
 	unsigned int i;
 	int err;
diff --git a/sound/pci/via82xx_modem.c b/sound/pci/via82xx_modem.c
index 5bd79d2..4ceb563 100644
--- a/sound/pci/via82xx_modem.c
+++ b/sound/pci/via82xx_modem.c
@@ -1162,7 +1162,7 @@ static int __devinit snd_via82xx_probe(struct pci_dev *pci,
 				       const struct pci_device_id *pci_id)
 {
 	struct snd_card *card;
-	struct via82xx_modem *chip;
+	struct via82xx_modem *uninitialized_var(chip);
 	int chip_type = 0, card_type;
 	unsigned int i;
 	int err;
diff --git a/sound/pci/vx222/vx222.c b/sound/pci/vx222/vx222.c
index acc352f..67bd762 100644
--- a/sound/pci/vx222/vx222.c
+++ b/sound/pci/vx222/vx222.c
@@ -194,7 +194,7 @@ static int __devinit snd_vx222_probe(struct pci_dev *pci,
 	static int dev;
 	struct snd_card *card;
 	struct snd_vx_hardware *hw;
-	struct snd_vx222 *vx;
+	struct snd_vx222 *uninitialized_var(vx);
 	int err;
 
 	if (dev >= SNDRV_CARDS)
diff --git a/sound/soc/codecs/tlv320aic23.c b/sound/soc/codecs/tlv320aic23.c
index 44308da..45395d0 100644
--- a/sound/soc/codecs/tlv320aic23.c
+++ b/sound/soc/codecs/tlv320aic23.c
@@ -421,8 +421,6 @@ static int tlv320aic23_set_dai_fmt(struct snd_soc_dai *codec_dai,
 static int tlv320aic23_set_dai_sysclk(struct snd_soc_dai *codec_dai,
 				      int clk_id, unsigned int freq, int dir)
 {
-	struct snd_soc_codec *codec = codec_dai->codec;
-
 	switch (freq) {
 	case 12000000:
 		return 0;
diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index ce40d78..eb437a9 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -391,7 +391,7 @@ static int wm8903_output_event(struct snd_soc_dapm_widget *w,
 		reg = WM8903_ANALOGUE_LINEOUT_0;
 		break;
 	default:
-		BUG();
+		panic("wm8903_output_event: bad register");
 	}
 
 	switch (w->shift) {
@@ -402,7 +402,7 @@ static int wm8903_output_event(struct snd_soc_dapm_widget *w,
 		shift = 4;
 		break;
 	default:
-		BUG();
+		panic("wm8903_output_event: bad shift");
 	}
 
 	if (event & SND_SOC_DAPM_PRE_PMU) {

