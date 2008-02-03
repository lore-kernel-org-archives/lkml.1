Return-Path: <linux-kernel-owner+w=401wt.eu-S1753632AbYBCUSP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632AbYBCUSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 15:18:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbYBCUR7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 15:17:59 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:33568 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751870AbYBCUR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 15:17:56 -0500
Date: Sun, 3 Feb 2008 22:17:54 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org, Jesper Juhl <jesper.juhl@gmail.com>
Subject: please pull from the trivial tree
Message-ID: <20080203201754.GE25971@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git


This tree contains the following:

Adrian Bunk (4):
      remove obsolete contact information from CREDITS
      remove Documentation/smp.txt
      move frv docs one level up
      Jesper Juhl is the new trivial patches maintainer

Andre Haupt (3):
      gameport: remove duplicate include
      bf54x: remove duplicate include
      jonada720: remove duplicate include

Clemens Koller (1):
      Documentation/BUG-HUNTING whitespace cleanup

Denis Cheng (1):
      Documentation: fix type error

Fengguang Wu (1):
      do_invalidatepage() comment typo fix

Frank Lichtenheld (1):
      vga.h: Fix prepocessor warning

Joe Perches (41):
      MAINTAINERS: remove Adam Fritzler, remove his email address in other sources
      MAINTAINERS: update Corey Thomas email address
      arch/arm/: Spelling fixes
      include/asm-arm/: Spelling fixes
      arch/h8300/: Spelling fixes
      arch/m32r/: Spelling fixes
      arch/mips/: Spelling fixes
      include/asm-mips/: Spelling fixes
      arch/parisc/: Spelling fixes
      include/asm-parisc/: Spelling fixes
      arch/um: Spelling fixes
      drivers/acpi/: Spelling fixes
      include/acpi/: Spelling fixes
      drivers/ata/: Spelling fixes
      drivers/block/: Spelling fixes
      drivers/bluetooth/: Spelling fixes
      drivers/char/: Spelling fixes
      drivers/edac/: Spelling fixes
      drivers/firmware/: Spelling fixes
      drivers/input/: Spelling fixes
      drivers/isdn/: Spelling fixes
      drivers/macintosh/: Spelling fixes
      drivers/media/: Spelling fixes
      include/media/: Spelling fixes
      drivers/message/: Spelling fixes
      drivers/mtd/: Spelling fixes
      drivers/nubus/: Spelling fixes
      drivers/parisc/: Spelling fixes
      drivers/pcmcia/: Spelling fixes
      drivers/scsi/: Spelling fixes
      drivers/serial/: Spelling fixes
      drivers/ssb/: Spelling fixes
      drivers/video/: Spelling fixes
      drivers/watchdog/: Spelling fixes
      fs/: Spelling fixes
      include/asm-frv/: Spelling fixes
      include/asm-m68knommu/: Spelling fixes
      include/linux/: Spelling fixes
      include/scsi/: Spelling fixes
      kernel/: Spelling fixes
      lib/: Spelling fixes

Leonardo Chiquitto (1):
      Documentation: missing proc/$PID/stat field

Li Zefan (1):
      time: delete comments that refer to noexistent symbols

Marcin Ślusarz (1):
      asm-*/compat.h: fix typo in comment

Masatake YAMATO (1):
      correct missing a double quote in configfs.txt

Michael Opdenacker (1):
      Documentation: mention email-clients.txt in SubmittingPatches

Michal Piotrowski (1):
      Coding style fix drivers/serial/icom.h

Ohad Ben-Cohen (1):
      fs/binfmt_elf.c: spello fix

Oliver Pinter (4):
      typo fixes in net/sctp/sm_statefuns.c
      typo fix in net/rfkill/rfkill.c
      typo fixes in net/core/net_namespace.c
      Documentation/filesystems/porting fixes

Paulius Zaleckas (1):
      Spelling fixes: lenght->length

Pierre Peiffer (1):
      Remove one useless extern declaration

Randy Dunlap (2):
      dio: fix kernel-doc notation
      doc: use correct debugfs mountpoint

Robert P. J. Day (8):
      Correct explanations of "find_next" bit routines.
      linux/dma-mapping.h: rename macro to prevent multiple inclusion
      Fix a small number of "memeber" typoes.
      Typoes:  "whith" -> "with"
      Documentation:  "decnet=" should read "decnet.addr=".
      Documentation:  Update to refer to correct "rcupdate" module name
      Documentation:  Remove references to dead "st0x" and "tmc8xx" parms.
      Documentation:  Clarify when module debugging actually works.

Tim Pepper (1):
      radix_tree.h trivial comment correction

Uwe Kleine-König (3):
      use the newc archive format as requested by initramfs
      SERIAL_NETX_CONSOLE provides console for NetX, not IMX
      fix typo 'the same the\>'


 CREDITS                                            |    7 +-
 Documentation/00-INDEX                             |    4 +-
 Documentation/BUG-HUNTING                          |   22 +++---
 Documentation/SubmittingPatches                    |   16 +----
 Documentation/arm/Sharp-LH/IOBarrier               |    2 +-
 Documentation/debugging-modules.txt                |    4 +
 Documentation/filesystems/configfs/configfs.txt    |    2 +-
 Documentation/filesystems/porting                  |    6 +-
 Documentation/filesystems/proc.txt                 |    1 +
 .../filesystems/ramfs-rootfs-initramfs.txt         |    2 +-
 Documentation/filesystems/relay.txt                |    2 +-
 Documentation/{fujitsu => }/frv/README.txt         |    0 
 Documentation/{fujitsu => }/frv/atomic-ops.txt     |    0 
 Documentation/{fujitsu => }/frv/booting.txt        |    2 +-
 Documentation/{fujitsu => }/frv/clock.txt          |    0 
 Documentation/{fujitsu => }/frv/configuring.txt    |    0 
 Documentation/{fujitsu => }/frv/features.txt       |    0 
 Documentation/{fujitsu => }/frv/gdbinit            |    0 
 Documentation/{fujitsu => }/frv/gdbstub.txt        |    0 
 Documentation/{fujitsu => }/frv/kernel-ABI.txt     |    0 
 Documentation/{fujitsu => }/frv/mmu-layout.txt     |    0 
 Documentation/initrd.txt                           |    2 +-
 Documentation/kernel-parameters.txt                |   21 +++----
 Documentation/networking/decnet.txt                |    2 +-
 Documentation/smp.txt                              |   22 ------
 MAINTAINERS                                        |   13 +---
 Makefile                                           |    2 +-
 arch/alpha/Kconfig                                 |    4 +-
 arch/arm/Kconfig                                   |    3 +-
 arch/arm/mach-pxa/corgi_ssp.c                      |    2 +-
 arch/arm/mach-sa1100/collie_pm.c                   |    2 +-
 arch/arm/plat-s3c24xx/irq.c                        |    2 +-
 arch/frv/Kconfig                                   |    2 +-
 arch/frv/kernel/entry.S                            |    4 +-
 arch/frv/lib/atomic-ops.S                          |    2 +-
 arch/h8300/platform/h8s/ints.c                     |    2 +-
 arch/ia64/Kconfig                                  |    4 +-
 arch/m32r/Kconfig                                  |    3 +-
 arch/m32r/kernel/ptrace.c                          |    2 +-
 arch/mips/Kconfig                                  |    4 +-
 arch/mips/au1000/mtx-1/board_setup.c               |    2 +-
 arch/mips/kernel/binfmt_elfn32.c                   |    2 +-
 arch/mips/kernel/binfmt_elfo32.c                   |    2 +-
 arch/mips/kernel/kspd.c                            |    2 +-
 arch/mips/kernel/setup.c                           |    4 +-
 arch/mips/kernel/smtc.c                            |    6 +-
 arch/mips/mm/c-r4k.c                               |    2 +-
 arch/mips/sgi-ip27/ip27-hubio.c                    |    2 +-
 arch/parisc/Kconfig                                |    5 +-
 arch/parisc/kernel/cache.c                         |    2 +-
 arch/parisc/kernel/hardware.c                      |    2 +-
 arch/parisc/kernel/signal.c                        |    2 +-
 arch/s390/Kconfig                                  |    4 +-
 arch/sh/Kconfig                                    |    5 +-
 arch/sparc/Kconfig                                 |    5 +-
 arch/sparc/kernel/ioport.c                         |    4 +-
 arch/sparc64/Kconfig                               |    5 +-
 arch/um/sys-x86_64/signal.c                        |    2 +-
 arch/x86/Kconfig                                   |    3 +-
 arch/x86/lib/bitops_32.c                           |    2 +-
 arch/x86/lib/bitops_64.c                           |    2 +-
 drivers/acpi/scan.c                                |    2 +-
 drivers/acpi/utilities/utresrc.c                   |    2 +-
 drivers/ata/ata_piix.c                             |    2 +-
 drivers/ata/libata-core.c                          |    2 +-
 drivers/ata/pata_at32.c                            |    2 +-
 drivers/ata/pata_efar.c                            |    2 +-
 drivers/ata/pata_it8213.c                          |    2 +-
 drivers/ata/pata_sis.c                             |    4 +-
 drivers/block/cciss_scsi.c                         |    4 +-
 drivers/bluetooth/btuart_cs.c                      |    2 +-
 drivers/char/drm/r300_reg.h                        |    2 +-
 drivers/char/drm/via_dma.c                         |    2 +-
 drivers/char/efirtc.c                              |    2 +-
 drivers/char/epca.c                                |    4 +-
 drivers/char/hangcheck-timer.c                     |    2 +-
 drivers/char/hvcs.c                                |    2 +-
 drivers/char/ip2/i2lib.c                           |    2 +-
 drivers/char/ip2/ip2main.c                         |    2 +-
 drivers/char/synclink.c                            |    2 +-
 drivers/char/toshiba.c                             |    2 +-
 drivers/dio/dio-driver.c                           |   70 ++++++++++----------
 drivers/edac/edac_pci.c                            |    2 +-
 drivers/edac/i5000_edac.c                          |    2 +-
 drivers/firmware/edd.c                             |    2 +-
 drivers/ide/ide-timing.h                           |    2 +-
 drivers/input/gameport/gameport.c                  |    1 -
 drivers/input/keyboard/bf54x-keys.c                |    1 -
 drivers/input/keyboard/jornada720_kbd.c            |    1 -
 drivers/input/serio/gscps2.c                       |    2 +-
 drivers/isdn/hardware/eicon/debuglib.c             |    2 +-
 drivers/isdn/hardware/eicon/debuglib.h             |    2 +-
 drivers/isdn/hardware/eicon/di.c                   |    2 +-
 drivers/isdn/hardware/eicon/message.c              |    2 +-
 drivers/isdn/hysdn/hycapi.c                        |    2 +-
 drivers/macintosh/smu.c                            |    4 +-
 drivers/media/common/saa7146_core.c                |    2 +-
 drivers/media/dvb/dvb-core/dvb_net.c               |    2 +-
 drivers/media/video/bt8xx/bttv-cards.c             |    2 +-
 drivers/media/video/indycam.c                      |    2 +-
 drivers/media/video/mt20xx.c                       |    2 +-
 drivers/media/video/pvrusb2/pvrusb2.h              |    2 +-
 drivers/media/video/pwc/pwc-if.c                   |    2 +-
 drivers/media/video/tea6420.c                      |    2 +-
 drivers/media/video/usbvideo/quickcam_messenger.c  |    2 +-
 drivers/media/video/usbvision/usbvision-video.c    |    2 +-
 drivers/media/video/vpx3220.c                      |    2 +-
 drivers/media/video/zoran_card.c                   |    2 +-
 drivers/media/video/zr36050.c                      |    2 +-
 drivers/media/video/zr36060.c                      |    2 +-
 drivers/message/fusion/lsi/mpi_log_sas.h           |    2 +-
 drivers/message/fusion/mptctl.c                    |    8 +-
 drivers/message/fusion/mptscsih.c                  |    2 +-
 drivers/message/i2o/iop.c                          |    2 +-
 drivers/mtd/devices/doc2000.c                      |    2 +-
 drivers/mtd/nand/autcpu12.c                        |    6 +-
 drivers/mtd/nand/bf5xx_nand.c                      |    2 +-
 drivers/mtd/nand/cs553x_nand.c                     |    2 +-
 drivers/mtd/nand/edb7312.c                         |    2 +-
 drivers/mtd/nand/nand_base.c                       |    2 +-
 drivers/mtd/nand/nandsim.c                         |    2 +-
 drivers/mtd/nand/s3c2410.c                         |    2 +-
 drivers/mtd/nand/sharpsl.c                         |    2 +-
 drivers/mtd/nftlmount.c                            |    2 +-
 drivers/net/eexpress.c                             |    2 +-
 drivers/net/irda/ali-ircc.h                        |    4 +-
 drivers/net/irda/nsc-ircc.h                        |    4 +-
 drivers/net/irda/via-ircc.h                        |    4 +-
 drivers/net/lib8390.c                              |    2 +-
 drivers/net/skfp/ess.c                             |    2 +-
 drivers/net/skfp/fplustm.c                         |    2 +-
 drivers/net/skfp/hwmtm.c                           |    2 +-
 drivers/net/tokenring/abyss.c                      |    2 +-
 drivers/net/tokenring/abyss.h                      |    2 +-
 drivers/net/tokenring/madgemc.c                    |    2 +-
 drivers/net/tokenring/madgemc.h                    |    2 +-
 drivers/net/tokenring/proteon.c                    |    2 +-
 drivers/net/tokenring/skisa.c                      |    2 +-
 drivers/net/tokenring/tms380tr.c                   |    2 +-
 drivers/net/tokenring/tms380tr.h                   |    2 +-
 drivers/net/tokenring/tmspci.c                     |    2 +-
 drivers/net/wan/cycx_drv.c                         |    4 +-
 drivers/net/wireless/libertas/scan.c               |    2 +-
 drivers/nubus/nubus.c                              |    2 +-
 drivers/parisc/ccio-dma.c                          |    4 +-
 drivers/parisc/hppb.c                              |    2 +-
 drivers/parport/probe.c                            |    2 +-
 drivers/pcmcia/m32r_pcc.c                          |    2 +-
 drivers/pcmcia/m8xx_pcmcia.c                       |    2 +-
 drivers/scsi/NCR53C9x.h                            |    2 +-
 drivers/scsi/aha1542.c                             |    2 +-
 drivers/scsi/aic7xxx/aic79xx_inline.h              |    2 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c                 |    2 +-
 drivers/scsi/aic7xxx/aic79xx_pci.c                 |    4 +-
 drivers/scsi/aic7xxx/aic7xxx_inline.h              |    2 +-
 drivers/scsi/aic7xxx/aic7xxx_osm.c                 |    2 +-
 drivers/scsi/ipr.c                                 |    2 +-
 drivers/scsi/ips.c                                 |    2 +-
 drivers/scsi/lpfc/lpfc.h                           |    2 +-
 drivers/scsi/lpfc/lpfc_mbox.c                      |    2 +-
 drivers/scsi/megaraid/megaraid_mbox.c              |   10 ++--
 drivers/scsi/qla2xxx/qla_gs.c                      |    2 +-
 drivers/scsi/qla4xxx/ql4_def.h                     |    2 +-
 drivers/scsi/qla4xxx/ql4_init.c                    |    2 +-
 drivers/scsi/scsi_tgt_lib.c                        |    2 +-
 drivers/scsi/scsi_transport_sas.c                  |    2 +-
 drivers/serial/Kconfig                             |    4 +-
 drivers/serial/icom.h                              |    2 +-
 drivers/serial/mux.c                               |    2 +-
 drivers/spi/spi_imx.c                              |    2 +-
 drivers/ssb/b43_pci_bridge.c                       |    2 +-
 drivers/video/aty/radeon_pm.c                      |    2 +-
 drivers/video/cyblafb.c                            |    2 +-
 drivers/video/intelfb/intelfb.h                    |    2 +-
 drivers/video/omap/lcdc.c                          |    2 +-
 drivers/video/sm501fb.c                            |    2 +-
 drivers/watchdog/shwdt.c                           |    2 +-
 fs/befs/btree.c                                    |    2 +-
 fs/befs/datastream.c                               |    2 +-
 fs/binfmt_elf.c                                    |    2 +-
 fs/freevxfs/vxfs_dir.h                             |    2 +-
 fs/freevxfs/vxfs_immed.c                           |    2 +-
 fs/gfs2/recovery.c                                 |    2 +-
 fs/jffs2/readinode.c                               |    2 +-
 fs/jfs/jfs_xtree.c                                 |    2 +-
 fs/ocfs2/alloc.c                                   |    2 +-
 fs/ocfs2/dir.c                                     |    2 +-
 fs/ocfs2/ocfs1_fs_compat.h                         |    2 +-
 fs/ocfs2/suballoc.c                                |    2 +-
 fs/reiserfs/bitmap.c                               |    6 +-
 fs/signalfd.c                                      |    2 +-
 include/acpi/acpixf.h                              |    2 +-
 include/acpi/processor.h                           |    2 +-
 include/asm-arm/arch-ixp4xx/ixp4xx-regs.h          |   34 +++++-----
 include/asm-arm/arch-pxa/pxa-regs.h                |   34 +++++-----
 include/asm-arm/arch-versatile/irqs.h              |    4 +-
 include/asm-arm/hardware/it8152.h                  |    2 +-
 include/asm-arm/mach/udc_pxa2xx.h                  |    2 +-
 include/asm-frv/atomic.h                           |    2 +-
 include/asm-frv/bitops.h                           |    2 +-
 include/asm-frv/cacheflush.h                       |    2 +-
 include/asm-frv/highmem.h                          |    2 +-
 include/asm-frv/mem-layout.h                       |    2 +-
 include/asm-frv/pgtable.h                          |    2 +-
 include/asm-ia64/compat.h                          |    2 +-
 include/asm-m68knommu/bitops.h                     |    2 +-
 include/asm-m68knommu/commproc.h                   |    2 +-
 include/asm-m68knommu/delay.h                      |    2 +-
 include/asm-m68knommu/m5249sim.h                   |    4 +-
 include/asm-m68knommu/m5307sim.h                   |   12 ++--
 include/asm-m68knommu/m5407sim.h                   |   12 ++--
 include/asm-m68knommu/m68360_regs.h                |    2 +-
 include/asm-m68knommu/mcfuart.h                    |    2 +-
 include/asm-mips/compat.h                          |    2 +-
 include/asm-mips/mach-excite/excite_fpga.h         |    2 +-
 include/asm-mips/mach-wrppmc/mach-gt64120.h        |    2 +-
 include/asm-mips/sgi/ip22.h                        |    2 +-
 include/asm-mips/sn/sn0/hubio.h                    |    2 +-
 include/asm-parisc/compat.h                        |    2 +-
 include/asm-parisc/elf.h                           |    2 +-
 include/asm-parisc/linkage.h                       |    2 +-
 include/asm-parisc/vga.h                           |    2 +-
 include/asm-powerpc/compat.h                       |    2 +-
 include/asm-s390/compat.h                          |    2 +-
 include/asm-sparc64/compat.h                       |    2 +-
 include/asm-x86/compat.h                           |    2 +-
 include/asm-x86/mach-voyager/do_timer.h            |    1 -
 include/linux/chio.h                               |    2 +-
 include/linux/cyclades.h                           |    2 +-
 include/linux/cycx_x25.h                           |    2 +-
 include/linux/dma-mapping.h                        |    4 +-
 include/linux/dmaengine.h                          |    2 +-
 include/linux/ethtool.h                            |    2 +-
 include/linux/fs.h                                 |    2 +-
 include/linux/hdreg.h                              |    2 +-
 include/linux/hrtimer.h                            |    1 -
 include/linux/llc.h                                |    4 +-
 include/linux/pm.h                                 |    2 +-
 include/linux/pnp.h                                |    2 +-
 include/linux/radix-tree.h                         |    2 +-
 include/linux/reiserfs_fs_sb.h                     |    2 +-
 include/linux/signalfd.h                           |    2 +-
 include/linux/sm501-regs.h                         |    2 +-
 include/linux/spinlock_api_up.h                    |    2 +-
 include/linux/wireless.h                           |    2 +-
 include/media/rds.h                                |    2 +-
 include/scsi/scsi_transport_fc.h                   |    2 +-
 kernel/exit.c                                      |    2 -
 kernel/posix-timers.c                              |    2 +-
 lib/crc32.c                                        |    2 +-
 lib/zlib_deflate/defutil.h                         |    2 +-
 mm/truncate.c                                      |    2 +-
 net/core/net_namespace.c                           |    4 +-
 net/rfkill/rfkill.c                                |    2 +-
 net/sctp/sm_statefuns.c                            |    4 +-
 255 files changed, 382 insertions(+), 442 deletions(-)


