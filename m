Return-Path: <linux-kernel-owner+w=401wt.eu-S1756486AbZIUOmR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486AbZIUOmR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 10:42:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755865AbZIUOmP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 10:42:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:59685 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756476AbZIUOmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 10:42:13 -0400
Date: Mon, 21 Sep 2009 16:42:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT] trivial tree
Message-ID: <alpine.LNX.2.00.0909211520300.17028@wotan.suse.de>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

could you please pull from 'for-linus' branch of

        git://git.kernel.org/pub/scm/linux/kernel/git/jikos/trivial.git for-linus

to receive accumulated trivial fixes all over the tree. There shouldn't be
any clashes with subsystem trees, as -next merge is currently without any
conflicts.

Thanks!

 Documentation/DocBook/mtdnand.tmpl               |    2 +-
 Documentation/DocBook/scsi.tmpl                  |    2 +-
 Documentation/SubmittingPatches                  |    2 +-
 Documentation/filesystems/nfsroot.txt            |    2 +-
 Documentation/gcov.txt                           |    2 +-
 Documentation/hwmon/hpfall.c                     |  115 +++++++++++++++-------
 Documentation/hwmon/pc87427                      |    2 +-
 Documentation/kernel-parameters.txt              |    2 +-
 Documentation/networking/regulatory.txt          |    2 +-
 Documentation/powerpc/dts-bindings/marvell.txt   |    2 +-
 Documentation/scsi/ChangeLog.megaraid            |    2 +-
 Documentation/scsi/scsi_fc_transport.txt         |    2 +-
 Documentation/sound/alsa/HD-Audio-Models.txt     |    2 +-
 Documentation/sysctl/kernel.txt                  |   30 +++---
 Documentation/trace/events.txt                   |    2 +-
 Documentation/trace/ftrace.txt                   |    2 +-
 MAINTAINERS                                      |    2 +-
 arch/arm/Makefile                                |    2 +-
 arch/arm/mach-at91/board-afeb-9260v1.c           |    2 +-
 arch/arm/mach-at91/board-cam60.c                 |    2 +-
 arch/arm/mach-at91/board-neocore926.c            |    2 +-
 arch/arm/mach-at91/board-qil-a9260.c             |    2 +-
 arch/arm/mach-at91/board-sam9260ek.c             |    2 +-
 arch/arm/mach-at91/board-sam9261ek.c             |    2 +-
 arch/arm/mach-at91/board-sam9263ek.c             |    2 +-
 arch/arm/mach-at91/board-sam9g20ek.c             |    2 +-
 arch/arm/mach-at91/board-sam9rlek.c              |    2 +-
 arch/arm/mach-at91/board-usb-a9260.c             |    2 +-
 arch/arm/mach-at91/board-usb-a9263.c             |    2 +-
 arch/blackfin/mach-bf538/include/mach/defBF539.h |    2 +-
 arch/frv/lib/cache.S                             |    2 +-
 arch/h8300/kernel/timer/tpu.c                    |    1 -
 arch/ia64/ia32/sys_ia32.c                        |    2 +-
 arch/mn10300/include/asm/cacheflush.h            |    4 +-
 arch/powerpc/kernel/udbg_16550.c                 |    2 +-
 arch/powerpc/platforms/powermac/udbg_scc.c       |    2 +-
 arch/s390/hypfs/inode.c                          |    2 +-
 arch/s390/kvm/interrupt.c                        |    2 +-
 arch/sparc/kernel/irq_64.c                       |    2 +-
 arch/um/drivers/net_kern.c                       |    2 +-
 arch/um/include/shared/ptrace_user.h             |    2 +-
 arch/x86/kernel/cpu/amd.c                        |    2 +-
 drivers/ata/pata_hpt37x.c                        |    2 +-
 drivers/block/DAC960.c                           |    8 +-
 drivers/block/swim3.c                            |    2 +-
 drivers/char/agp/uninorth-agp.c                  |    2 +-
 drivers/char/epca.c                              |    2 +-
 drivers/char/ipmi/ipmi_poweroff.c                |    4 +-
 drivers/edac/edac_core.h                         |    2 +-
 drivers/gpio/bt8xxgpio.c                         |    4 +-
 drivers/gpu/drm/i915/intel_dp.c                  |    2 +-
 drivers/gpu/drm/mga/mga_state.c                  |    4 +-
 drivers/gpu/drm/radeon/r300.c                    |    4 +-
 drivers/ide/ide-probe.c                          |    2 +-
 drivers/ide/umc8672.c                            |    4 +-
 drivers/infiniband/hw/ipath/ipath_iba6110.c      |    2 +-
 drivers/input/keyboard/atkbd.c                   |    2 +-
 drivers/isdn/capi/capiutil.c                     |    2 +-
 drivers/isdn/i4l/isdn_common.c                   |    4 +-
 drivers/lguest/page_tables.c                     |    2 +-
 drivers/macintosh/rack-meter.c                   |    2 +-
 drivers/md/md.h                                  |    2 +-
 drivers/media/dvb/siano/smscoreapi.c             |    2 +-
 drivers/media/dvb/siano/smscoreapi.h             |    4 +-
 drivers/media/radio/radio-mr800.c                |    2 +-
 drivers/media/video/cx88/cx88-blackbird.c        |    4 +-
 drivers/media/video/cx88/cx88-dvb.c              |    4 +-
 drivers/media/video/cx88/cx88-mpeg.c             |    4 +-
 drivers/media/video/cx88/cx88-video.c            |    4 +-
 drivers/media/video/gspca/m5602/m5602_core.c     |    2 +-
 drivers/message/fusion/mptbase.c                 |    4 +-
 drivers/mmc/host/mxcmmc.c                        |    2 +-
 drivers/mtd/devices/m25p80.c                     |    4 +-
 drivers/mtd/devices/slram.c                      |    2 +-
 drivers/mtd/ftl.c                                |    2 +-
 drivers/mtd/maps/ixp2000.c                       |    2 +-
 drivers/mtd/nand/cafe_nand.c                     |    4 +-
 drivers/mtd/nand/cmx270_nand.c                   |    4 +-
 drivers/mtd/ubi/eba.c                            |    2 +-
 drivers/mtd/ubi/ubi.h                            |    2 +-
 drivers/net/arcnet/arc-rawmode.c                 |    1 -
 drivers/net/arcnet/capmode.c                     |    1 -
 drivers/net/bnx2x_reg.h                          |    2 +-
 drivers/net/bonding/bond_3ad.c                   |    2 +-
 drivers/net/e1000/e1000_hw.c                     |    2 +-
 drivers/net/gianfar_ethtool.c                    |    2 +-
 drivers/net/ibm_newemac/core.c                   |    8 +-
 drivers/net/igb/igb_main.c                       |    2 +-
 drivers/net/ll_temac_main.c                      |    2 +-
 drivers/net/macb.c                               |    2 +-
 drivers/net/ni52.c                               |    4 +-
 drivers/net/qlge/qlge_main.c                     |    4 +-
 drivers/net/rionet.c                             |    2 +-
 drivers/net/skfp/pcmplc.c                        |    2 +-
 drivers/net/skfp/pmf.c                           |    8 +-
 drivers/net/skge.c                               |    2 +-
 drivers/net/sky2.c                               |    2 +-
 drivers/net/vxge/vxge-config.h                   |    2 +-
 drivers/net/vxge/vxge-main.c                     |    2 +-
 drivers/net/wireless/ath/ath5k/reg.h             |    2 +-
 drivers/net/wireless/atmel.c                     |    2 +-
 drivers/net/wireless/zd1211rw/zd_chip.c          |    2 +-
 drivers/rtc/rtc-omap.c                           |    2 +-
 drivers/s390/block/dasd_eckd.c                   |    2 +-
 drivers/s390/net/netiucv.c                       |    2 +-
 drivers/s390/scsi/zfcp_scsi.c                    |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_core.c              |    2 +-
 drivers/scsi/bnx2i/bnx2i_hwi.c                   |    2 +-
 drivers/scsi/lpfc/lpfc_ct.c                      |    2 +-
 drivers/scsi/megaraid/megaraid_sas.c             |    2 +-
 drivers/scsi/qla4xxx/ql4_os.c                    |    4 +-
 drivers/spi/omap_uwire.c                         |    2 +-
 drivers/spi/spi_s3c24xx.c                        |    2 +-
 drivers/staging/rt2860/rtmp.h                    |    2 +-
 drivers/usb/class/cdc-wdm.c                      |    2 -
 drivers/usb/host/ehci-pci.c                      |    2 +-
 drivers/usb/host/ehci.h                          |    2 +-
 drivers/usb/host/ohci-q.c                        |    2 +-
 drivers/usb/host/xhci.h                          |    2 +-
 drivers/usb/serial/cypress_m8.h                  |    2 +-
 drivers/usb/serial/io_edgeport.c                 |    2 +-
 drivers/usb/serial/kl5kusb105.c                  |    2 +-
 drivers/usb/serial/spcp8x5.c                     |    2 +-
 drivers/usb/wusbcore/wa-hc.h                     |    2 +-
 drivers/uwb/i1480/i1480u-wlp/netdev.c            |    2 +-
 drivers/video/cfbcopyarea.c                      |    2 +-
 drivers/video/imxfb.c                            |    2 +-
 drivers/video/omap/lcd_h3.c                      |    4 +-
 drivers/video/omap/lcd_h4.c                      |    4 +-
 drivers/video/omap/lcd_inn1510.c                 |    4 +-
 drivers/video/omap/lcd_inn1610.c                 |    4 +-
 drivers/video/omap/lcd_osk.c                     |    4 +-
 drivers/video/omap/lcd_palmte.c                  |    4 +-
 drivers/video/omap/lcd_palmtt.c                  |    4 +-
 drivers/video/omap/lcd_palmz71.c                 |    4 +-
 drivers/video/s3c2410fb.c                        |    2 +-
 drivers/xen/balloon.c                            |    2 +-
 fs/autofs/dirhash.c                              |    2 +-
 fs/btrfs/tree-log.c                              |    2 +-
 fs/cifs/cifs_dfs_ref.c                           |    2 +-
 fs/ext4/inode.c                                  |    2 +-
 fs/gfs2/rgrp.c                                   |    2 +-
 fs/nfs/callback_xdr.c                            |    2 +-
 fs/ntfs/layout.h                                 |    2 +-
 fs/ocfs2/quota_global.c                          |    2 +-
 fs/xfs/xfs_fs.h                                  |    2 +-
 include/acpi/actypes.h                           |    2 +-
 include/acpi/platform/acgcc.h                    |    2 +-
 include/linux/capability.h                       |    2 +-
 include/linux/mISDNif.h                          |    2 +-
 include/linux/namei.h                            |    2 +-
 include/linux/usb.h                              |    2 +-
 include/linux/workqueue.h                        |    2 +-
 include/rdma/ib_cm.h                             |    2 +-
 include/scsi/fc/fc_fc2.h                         |    3 +-
 kernel/panic.c                                   |    2 +-
 kernel/trace/Kconfig                             |    2 +-
 kernel/trace/trace_hw_branches.c                 |    2 +-
 kernel/tracepoint.c                              |    2 +-
 lib/zlib_deflate/deflate.c                       |    4 +-
 mm/Kconfig.debug                                 |   12 +-
 net/rxrpc/ar-call.c                              |    2 +-
 net/sched/sch_hfsc.c                             |    2 +-
 net/wireless/wext-compat.c                       |    2 +-
 scripts/basic/fixdep.c                           |    4 +-
 scripts/mod/sumversion.c                         |    2 -
 sound/oss/swarm_cs4297a.c                        |    3 -
 sound/oss/sys_timer.c                            |    3 -
 sound/soc/codecs/wm9081.c                        |    2 +-
 sound/soc/pxa/pxa-ssp.c                          |    2 +-
 sound/soc/s3c24xx/s3c24xx_uda134x.c              |    2 +-
 171 files changed, 301 insertions(+), 268 deletions(-)

Anand Gadiyar (3):
      trivial: OHCI: Fix typo in a comment
      trivial: fix typo "for for" in multiple files
      trivial: fix typo "to to" in multiple files

Christian Thaeter (1):
      trivial: doc: hpfall: reduce risk that hpfall can do harm

Dmitri Vorobiev (1):
      Change "useing" -> "using".

Frans Pop (3):
      trivial: cleanup hpfall example code (checkpatch)
      trivial: doc: hpfall: accept disk device to unload as argument
      trivial: improve help text for mm debug config options

GeunSik Lim (1):
      trivial: change address of the libcap source.

Horst Schirmeier (1):
      trivial: doc: document missing value 2 for randomize-va-space

Joe Perches (1):
      trivial: remove unnecessary semicolons

Krzysztof Halasa (1):
      trivial: fix comment typo in drivers/ata/pata_hpt37x.c

Markus Heidelberg (2):
      trivial: remove references to non-existent include/linux/config.h
      trivial: update the Kernel Janitors' web-page URL

Marton Nemeth (1):
      trivial: fix typo in CONFIG_DEBUG_FS in gcov doc

Michael Brunner (1):
      trivial: SubmittingPatches: Fix reference to renumbered step

Michael Tokarev (1):
      trivial: fix missing printk space in amd_k7_smp_check

Michal Sojka (1):
      trivial: fix typo in tracing documentation

Ori Avtalion (1):
      trivial: fix typo in namei.h comment

Peter Huewe (6):
      trivial: add __init/__exit macros to DAC960.c
      trivial: mtd: add __init/__exit macros to init/exitfunctions
      trivial: media/omap: adding __init/__exit macros to lcd_drivers
      trivial: media/video/cx88: add __init/__exit macros to cx88 drivers
      trivial: add __init macro/ fix of __exit macro location in ipmi_poweroff.c
      trivial: add __init/__exit macros in drivers/gpio/bt8xxgpio.c

Robert P. J. Day (2):
      trivial: Correct print_tainted routine name in comment
      trivial: Remove commented out usage of dead MODULE_PARM() in swarm_cs4297a

Samuel R. C. Vale (1):
      trivial: fix typos in comments s/DGBU/DBGU/

Stephen Hemminger (1):
      trivial: typo in kernel-parameters.txt

Thadeu Lima de Souza Cascardo (1):
      trivial: fix typo s/ketymap/keymap/ in comment

Trevor Keith (1):
      trivial: kbuild: remove extraneous blank line after declaration of usage()

Uwe Kleine-Koenig (3):
      trivial: fix typos "man[ae]g?ment" -> "management"
      trivial: Fix duplicated word "options" in comment
      trivial: fix typo in aic7xxx comment

