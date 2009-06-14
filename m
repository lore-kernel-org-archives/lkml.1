Return-Path: <linux-kernel-owner+w=401wt.eu-S1763512AbZFNTV7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763512AbZFNTV7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jun 2009 15:21:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762614AbZFNTVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Jun 2009 15:21:51 -0400
Received: from cantor.suse.de ([195.135.220.2]:42427 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760904AbZFNTVu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jun 2009 15:21:50 -0400
Date: Sun, 14 Jun 2009 21:21:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial patches
Message-ID: <alpine.LNX.2.00.0906121822220.7457@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="168427776-1224489319-1244823765=:7457"
Content-ID: <alpine.LNX.2.00.0906121827230.7457@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--168427776-1224489319-1244823765=:7457
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LNX.2.00.0906121827231.7457@wotan.suse.de>

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive accumulated trivial fixes all over the tree. Overwhelming majority
are fixes of typos in code comments and simple documentation updates.

Thanks.

 .gitignore                                         |    2 +-
 Documentation/CodingStyle                          |    4 ++--
 Documentation/DMA-API.txt                          |    4 ++--
 Documentation/RCU/rculist_nulls.txt                |    2 +-
 Documentation/SM501.txt                            |    2 +-
 Documentation/SubmittingPatches                    |    8 ++++----
 Documentation/block/deadline-iosched.txt           |    2 +-
 Documentation/braille-console.txt                  |    2 +-
 Documentation/dell_rbu.txt                         |    4 ++--
 Documentation/driver-model/devres.txt              |    2 +-
 Documentation/edac.txt                             |    8 ++++----
 Documentation/fb/sh7760fb.txt                      |    2 +-
 .../filesystems/autofs4-mount-control.txt          |    2 +-
 Documentation/filesystems/caching/netfs-api.txt    |    2 +-
 Documentation/filesystems/ext4.txt                 |    6 +++---
 Documentation/filesystems/fiemap.txt               |    2 +-
 Documentation/filesystems/nfs-rdma.txt             |    2 +-
 Documentation/filesystems/proc.txt                 |    4 ++--
 Documentation/filesystems/sysfs-pci.txt            |    2 +-
 Documentation/filesystems/vfat.txt                 |    8 ++++----
 Documentation/gpio.txt                             |    2 +-
 Documentation/kdump/kdump.txt                      |    4 ++--
 Documentation/kernel-parameters.txt                |    4 ++--
 Documentation/kobject.txt                          |    2 +-
 Documentation/laptops/acer-wmi.txt                 |    2 +-
 Documentation/laptops/sony-laptop.txt              |    2 +-
 Documentation/laptops/thinkpad-acpi.txt            |    2 +-
 Documentation/local_ops.txt                        |    2 +-
 Documentation/memory-hotplug.txt                   |    8 ++++----
 Documentation/mn10300/ABI.txt                      |    2 +-
 Documentation/mtd/nand_ecc.txt                     |   12 ++++++------
 Documentation/networking/bonding.txt               |    6 +++---
 Documentation/networking/can.txt                   |    2 +-
 Documentation/networking/dm9000.txt                |    2 +-
 Documentation/networking/l2tp.txt                  |    2 +-
 Documentation/networking/netdevices.txt            |    2 +-
 Documentation/networking/phonet.txt                |    2 +-
 Documentation/networking/regulatory.txt            |    2 +-
 Documentation/power/regulator/consumer.txt         |    2 +-
 Documentation/power/regulator/overview.txt         |    2 +-
 Documentation/power/s2ram.txt                      |    2 +-
 Documentation/power/userland-swsusp.txt            |    2 +-
 Documentation/powerpc/booting-without-of.txt       |    4 ++--
 Documentation/powerpc/dts-bindings/fsl/board.txt   |    2 +-
 .../powerpc/dts-bindings/fsl/cpm_qe/cpm.txt        |    2 +-
 .../powerpc/dts-bindings/fsl/cpm_qe/gpio.txt       |    2 +-
 Documentation/powerpc/dts-bindings/fsl/msi-pic.txt |    2 +-
 Documentation/powerpc/dts-bindings/fsl/pmc.txt     |    4 ++--
 Documentation/powerpc/qe_firmware.txt              |    2 +-
 Documentation/rbtree.txt                           |   10 +++++-----
 Documentation/s390/Debugging390.txt                |    4 ++--
 Documentation/scheduler/sched-nice-design.txt      |    2 +-
 Documentation/scsi/aic79xx.txt                     |    2 +-
 Documentation/scsi/ncr53c8xx.txt                   |    4 ++--
 Documentation/scsi/sym53c8xx_2.txt                 |    2 +-
 Documentation/sound/alsa/ALSA-Configuration.txt    |    2 +-
 Documentation/sound/alsa/HD-Audio.txt              |    2 +-
 Documentation/sound/alsa/hda_codec.txt             |    2 +-
 Documentation/sysctl/vm.txt                        |    4 ++--
 Documentation/timers/hpet.txt                      |    2 +-
 Documentation/timers/timer_stats.txt               |    2 +-
 Documentation/trace/ftrace.txt                     |    2 +-
 Documentation/trace/kmemtrace.txt                  |    2 +-
 Documentation/usb/WUSB-Design-overview.txt         |    8 ++++----
 Documentation/usb/anchors.txt                      |    4 ++--
 Documentation/usb/callbacks.txt                    |    2 +-
 Documentation/video4linux/cx18.txt                 |    2 +-
 MAINTAINERS                                        |    2 +-
 arch/arm/mach-sa1100/jornada720_ssp.c              |    4 ++--
 arch/blackfin/Kconfig                              |    2 +-
 arch/powerpc/mm/slb.c                              |    2 +-
 arch/s390/kernel/head.S                            |    2 +-
 drivers/ata/libata-acpi.c                          |    4 ++--
 drivers/ata/libata-eh.c                            |    2 +-
 drivers/base/bus.c                                 |    2 +-
 drivers/block/Kconfig                              |    2 +-
 drivers/char/Kconfig                               |    2 +-
 drivers/char/amiserial.c                           |    2 +-
 drivers/connector/Kconfig                          |    2 +-
 drivers/crypto/Kconfig                             |    6 +++---
 drivers/edac/e752x_edac.c                          |    2 +-
 drivers/ide/Kconfig                                |    2 +-
 drivers/ide/ide-atapi.c                            |    2 +-
 drivers/input/misc/Kconfig                         |    2 +-
 drivers/isdn/divert/isdn_divert.c                  |    2 +-
 drivers/isdn/mISDN/dsp_core.c                      |    2 +-
 drivers/media/dvb/dvb-usb/Kconfig                  |    2 +-
 drivers/media/video/hdpvr/hdpvr-video.c            |    2 +-
 drivers/message/fusion/lsi/mpi_history.txt         |    6 +++---
 drivers/mtd/Kconfig                                |    3 ++-
 drivers/mtd/devices/Kconfig                        |    2 +-
 drivers/mtd/nand/Kconfig                           |    4 ++--
 drivers/net/Kconfig                                |    4 ++--
 drivers/net/appletalk/ltpc.c                       |    2 +-
 drivers/net/b44.h                                  |    2 +-
 drivers/net/e100.c                                 |    2 +-
 drivers/net/e1000e/e1000.h                         |    2 +-
 drivers/net/ehea/ehea.h                            |    2 +-
 drivers/net/igbvf/igbvf.h                          |    2 +-
 drivers/net/ipg.h                                  |    2 +-
 drivers/net/mlx4/en_netdev.c                       |    2 +-
 drivers/net/niu.h                                  |    4 ++--
 drivers/net/qlge/qlge_main.c                       |    2 +-
 drivers/net/qlge/qlge_mpi.c                        |    6 +++---
 drivers/net/skfp/h/smt.h                           |    2 +-
 drivers/net/tokenring/3c359.c                      |    2 +-
 drivers/net/tokenring/lanstreamer.c                |    2 +-
 drivers/net/tokenring/olympic.c                    |    2 +-
 drivers/net/ucc_geth_ethtool.c                     |    2 +-
 drivers/net/usb/usbnet.c                           |    2 +-
 drivers/net/wireless/Kconfig                       |    2 +-
 drivers/net/wireless/hostap/Kconfig                |    8 ++++----
 drivers/net/wireless/iwlwifi/Kconfig               |    4 ++--
 drivers/net/wireless/rndis_wlan.c                  |    2 +-
 drivers/net/wireless/rt2x00/Kconfig                |   14 +++++++-------
 drivers/net/wireless/rt2x00/rt2x00lib.h            |    2 +-
 drivers/net/wireless/wavelan_cs.c                  |    2 +-
 drivers/pci/hotplug/sgi_hotplug.c                  |    4 ++--
 drivers/s390/net/Kconfig                           |   14 +++++++-------
 drivers/s390/scsi/zfcp_fc.c                        |    2 +-
 drivers/scsi/dpt/osd_util.h                        |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c                      |    4 ++--
 drivers/scsi/megaraid.h                            |    2 +-
 drivers/scsi/megaraid/mbox_defs.h                  |    2 +-
 drivers/serial/Kconfig                             |    2 +-
 drivers/staging/go7007/go7007.txt                  |    4 ++--
 drivers/staging/panel/lcd-panel-cgram.txt          |    2 +-
 drivers/staging/rt2860/common/mlme.c               |    2 +-
 drivers/staging/rt2870/common/mlme.c               |    2 +-
 drivers/staging/rt3070/common/mlme.c               |    2 +-
 drivers/staging/wlan-ng/hfa384x_usb.c              |    2 +-
 drivers/usb/serial/io_ti.c                         |    2 +-
 drivers/w1/Kconfig                                 |    2 +-
 drivers/w1/masters/Kconfig                         |    6 +++---
 drivers/watchdog/Kconfig                           |    2 +-
 drivers/watchdog/iop_wdt.c                         |    2 +-
 fs/bio.c                                           |    4 ++--
 fs/compat.c                                        |    2 +-
 fs/compat_ioctl.c                                  |    2 +-
 fs/ext2/ext2.h                                     |    2 +-
 fs/inode.c                                         |    2 +-
 include/linux/ultrasound.h                         |    2 +-
 kernel/power/poweroff.c                            |    2 +-
 kernel/rtmutex.c                                   |    2 +-
 net/ipv6/Kconfig                                   |    2 +-
 net/ipv6/addrconf.c                                |    2 +-
 net/netfilter/Kconfig                              |    4 ++--
 net/netfilter/nf_conntrack_acct.c                  |    2 +-
 sound/oss/msnd.c                                   |    2 +-
 sound/pci/aw2/aw2-saa7146.c                        |    2 +-
 sound/pci/sis7019.h                                |    4 ++--
 sound/pci/vx222/vx222_ops.c                        |    2 +-
 sound/usb/usbmixer.c                               |    2 +-
 153 files changed, 229 insertions(+), 228 deletions(-)

Alessio Igor Bogani (1):
      trivial: input/misc: Fix typo in Kconfig

Alex Chiang (1):
      trivial: fix grammo in bus_for_each_dev() kerneldoc

Ali Gholami Rudi (1):
      trivial: ext2: fix a typo in comment in ext2.h

Chris Sanford (1):
      trivial: unnecessary (void*) cast removal in sound/oss/msnd.c

GeunSik Lim (1):
      trivial: ftrace:fix description of trace directory

Jean Delvare (1):
      trivial: fix ETIMEOUT -> ETIMEDOUT typos

Manish Katiyar (1):
      trivial: kernel/power/poweroff.c: whitespace fix

Markus Heidelberg (1):
      trivial: remove the trivial patch monkey's name from SubmittingPatches

Martin Olsson (3):
      trivial: Fix paramater/parameter typo in dmesg and source comments
      trivial: fix typos s/paramter/parameter/ and s/excute/execute/ in documentation and source comments.
      trivial: fix typo milisecond/millisecond for documentation and source comments.

Masanori Kobayasi (1):
      trivial: Documentation/dell_rbu.txt: fix typos

Masatake YAMATO (1):
      trivial: Fix a typo in comment of addrconf_dad_start()

Matt Kraai (1):
      trivial: Remove the hyphen from git commands

Matt LaPlante (1):
      trivial: Miscellaneous documentation typo fixes

Nikanth Karthikesan (2):
      trivial: fix comment typo in fs/compat.c
      trivial: fix typo in bio_alloc kernel doc

Németh Márton (1):
      trivial: usb: fix missing space typo in doc

Paulius Zaleckas (1):
      trivial: mtd: fix Kconfig comment about 'armflash'

Pavel Machek (3):
      trivial: Fix Pavel's address in MAINTAINERS
      trivial: SubmittingPatches: fix typo
      trivial: Kconfig: .ko is normally not included in module names

Peter Huewe (1):
      trivial: pci hotplug: adding __init/__exit macros to sgi_hotplug

Sankar P (1):
      trivial: spelling fix in ppc code comments

Thadeu Lima de Souza Cascardo (3):
      trivial: typo (en|dis|avail|remove)bale -> (en|dis|avail|remove)able
      Trivial: fix typo s/balence/balance/
      trivial: fix typo compatiable/compatiability has extra 'a'.

Viral Mehta (1):
      trivial: remove extra space

Wang Tinggong (1):
      trivial: rbtree.txt: fix rb_entry() parameters in sample code

Wolfram Sang (1):
      trivial: fs/inode: Fix typo in file_update_time nanodoc

figo.zhang (1):
      trivial: Documentation/rbtree.txt: cleanup kerneldoc of rbtree.txt
--168427776-1224489319-1244823765=:7457--
