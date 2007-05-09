Return-Path: <linux-kernel-owner+w=401wt.eu-S1756511AbXEIJaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756511AbXEIJaX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 05:30:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754483AbXEIJaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 05:30:10 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:42780 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754694AbXEIJaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 05:30:06 -0400
Date: Wed, 9 May 2007 11:30:05 +0200
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: please pull from the trivial tree
Message-ID: <20070509093005.GA23574@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git


This tree contains the following:

Alexander E. Patrakov (1):
      Remove obsolete fat_cvf help text

Artem Bityutskiy (1):
      trivial: s/i_sem /i_mutex/

David Sterba (1):
      Fix trivial typos in Kconfig* files

Jesper Juhl (1):
      Magic number prefix consistency change to Documentation/magic-number.txt

John Anthony Kazos Jr (5):
      Convert the toplevel files CREDITS and MAINTAINERS to UTF-8.
      documentation: convert the Documentation directory to UTF-8
      general: convert "kernel" subdirectory to UTF-8
      include files: convert "include" subdirectory to UTF-8
      sound: convert "sound" subdirectory to UTF-8

Markus Dahms (1):
      remove broken URLs from net drivers' output

Matt LaPlante (1):
      misc doc and kconfig typos

Michael Opdenacker (1):
      Fix occurrences of "the the "

Márton Németh (1):
      drivers/base/platform.c: fix small typo in doc

Randy Dunlap (2):
      devres: kernel-doc and DocBook
      Fix more "deprecated" spellos.

Robert P. J. Day (6):
      Fix misspellings collected by members of KJ list.
      Fix "deprecated" typoes.
      Correct comments in genrtc.c to refer to correct /proc file.
      Kconfig: A couple of grammatical fixes in arch/i386/Kconfig
      Kconfig: Remove reference to external mqueue library
      Fix minor typoes in kernel/module.c

Ronni Nielsen (1):
      fs/libfs.c: >80 columns line break fix

Simon Arlott (1):
      MAINTAINERS: Add cxacru website/mailing list

Uwe Kleine-König (1):
      fix file specification in comments

WANG Cong (1):
      Style fix in fs/select.c


 CREDITS                                           |   44 +++++++-------
 Documentation/ABI/removed/devfs                   |    2 
 Documentation/DocBook/kernel-api.tmpl             |    4 +
 Documentation/MSI-HOWTO.txt                       |    6 -
 Documentation/arm/Interrupts                      |    2 
 Documentation/arm/Samsung-S3C24XX/H1940.txt       |    4 -
 Documentation/auxdisplay/cfag12864b               |    6 -
 Documentation/binfmt_misc.txt                     |    2 
 Documentation/block/ioprio.txt                    |    8 +-
 Documentation/cpu-freq/cpufreq-stats.txt          |    2 
 Documentation/crypto/api-intro.txt                |    6 -
 Documentation/driver-model/platform.txt           |    4 -
 Documentation/dvb/README.dvb-usb                  |    2 
 Documentation/dvb/contributors.txt                |    2 
 Documentation/fb/aty128fb.txt                     |    4 -
 Documentation/fb/framebuffer.txt                  |   16 ++---
 Documentation/fb/imacfb.txt                       |    2 
 Documentation/fb/sstfb.txt                        |    4 -
 Documentation/filesystems/Locking                 |    6 -
 Documentation/filesystems/hpfs.txt                |    2 
 Documentation/filesystems/ntfs.txt                |    2 
 Documentation/filesystems/proc.txt                |    2 
 Documentation/filesystems/relay.txt               |    2 
 Documentation/filesystems/xip.txt                 |    2 
 Documentation/fujitsu/frv/gdbstub.txt             |    2 
 Documentation/hwmon/adm1026                       |    2 
 Documentation/hwmon/gl518sm                       |    2 
 Documentation/hwmon/lm83                          |    2 
 Documentation/hwmon/sis5595                       |    2 
 Documentation/hwmon/via686a                       |    2 
 Documentation/hwmon/w83792d                       |    2 
 Documentation/i2c/busses/i2c-i810                 |    2 
 Documentation/i2c/busses/i2c-sis96x               |    2 
 Documentation/i2c/busses/i2c-via                  |    2 
 Documentation/i2c/busses/i2c-viapro               |    2 
 Documentation/i2c/i2c-protocol                    |    2 
 Documentation/i2o/README                          |    4 -
 Documentation/input/atarikbd.txt                  |    4 -
 Documentation/input/xpad.txt                      |    6 -
 Documentation/isdn/CREDITS                        |    4 -
 Documentation/isdn/README                         |    2 
 Documentation/isdn/README.icn                     |    4 -
 Documentation/java.txt                            |    2 
 Documentation/kernel-docs.txt                     |    2 
 Documentation/m68k/README.buddha                  |    2 
 Documentation/magic-number.txt                    |    2 
 Documentation/netlabel/introduction.txt           |    2 
 Documentation/networking/6pack.txt                |    2 
 Documentation/networking/NAPI_HOWTO.txt           |    2 
 Documentation/networking/packet_mmap.txt          |    2 
 Documentation/networking/slicecom.hun             |    2 
 Documentation/networking/slicecom.txt             |    4 -
 Documentation/networking/tms380tr.txt             |   42 ++++++-------
 Documentation/networking/udplite.txt              |    2 
 Documentation/networking/wan-router.txt           |    4 -
 Documentation/pci.txt                             |    2 
 Documentation/pcieaer-howto.txt                   |    2 
 Documentation/pnp.txt                             |    2 
 Documentation/power/swsusp.txt                    |    2 
 Documentation/powerpc/booting-without-of.txt      |    4 -
 Documentation/s390/Debugging390.txt               |    2 
 Documentation/scsi/aha152x.txt                    |    2 
 Documentation/scsi/aic7xxx.txt                    |    2 
 Documentation/scsi/aic7xxx_old.txt                |    2 
 Documentation/scsi/ncr53c8xx.txt                  |    2 
 Documentation/scsi/st.txt                         |    2 
 Documentation/scsi/sym53c8xx_2.txt                |    2 
 Documentation/scsi/tmscsim.txt                    |    2 
 Documentation/sonypi.txt                          |    2 
 Documentation/sound/oss/mwave                     |    2 
 Documentation/sysctl/kernel.txt                   |    4 -
 Documentation/usb/CREDITS                         |    2 
 Documentation/usb/usb-serial.txt                  |    6 -
 Documentation/video4linux/README.pvrusb2          |    2 
 Documentation/video4linux/Zoran                   |    2 
 Documentation/video4linux/meye.txt                |    2 
 Documentation/video4linux/ov511.txt               |    4 -
 MAINTAINERS                                       |    6 +
 arch/arm/mach-at91/Kconfig                        |    2 
 arch/arm/mach-omap1/Kconfig                       |    2 
 arch/arm/mach-s3c2410/sleep.S                     |    2 
 arch/arm/plat-s3c24xx/sleep.S                     |    2 
 arch/cris/arch-v32/drivers/Kconfig                |    2 
 arch/h8300/Kconfig.debug                          |    4 -
 arch/i386/Kconfig                                 |    4 -
 arch/i386/Kconfig.cpu                             |    4 -
 arch/i386/kernel/cpu/mcheck/therm_throt.c         |    2 
 arch/ia64/Kconfig                                 |    2 
 arch/m68knommu/Kconfig.debug                      |    2 
 arch/mips/Kconfig                                 |    6 -
 arch/mips/Makefile                                |    2 
 arch/mips/pci/fixup-sb1250.c                      |    4 -
 arch/powerpc/Kconfig.debug                        |    2 
 arch/powerpc/oprofile/op_model_cell.c             |    2 
 arch/powerpc/platforms/8xx/mpc86xads_setup.c      |    2 
 arch/powerpc/platforms/8xx/mpc885ads_setup.c      |    2 
 arch/powerpc/platforms/cell/io-workarounds.c      |    2 
 arch/ppc/platforms/mpc866ads_setup.c              |    2 
 arch/ppc/syslib/ipic.c                            |    2 
 arch/s390/crypto/Kconfig                          |    2 
 arch/sh/boards/se/7751/setup.c                    |    2 
 arch/sh/kernel/cpu/sh3/entry.S                    |    2 
 arch/sh/kernel/cpu/sh4a/clock-sh73180.c           |    2 
 arch/sh/kernel/cpu/sh4a/clock-sh7343.c            |    2 
 arch/sh/kernel/cpu/sh4a/clock-sh7770.c            |    2 
 arch/sh/kernel/cpu/sh4a/clock-sh7780.c            |    2 
 arch/sh/kernel/vsyscall/vsyscall.c                |    2 
 arch/um/include/sysdep-i386/archsetjmp.h          |    2 
 arch/um/include/sysdep-x86_64/archsetjmp.h        |    2 
 arch/v850/kernel/entry.S                          |    2 
 arch/x86_64/kernel/io_apic.c                      |    2 
 arch/xtensa/kernel/pci-dma.c                      |    2 
 block/ll_rw_blk.c                                 |    2 
 crypto/Kconfig                                    |    2 
 drivers/ata/Kconfig                               |    2 
 drivers/base/devres.c                             |   32 +++++-----
 drivers/base/platform.c                           |    2 
 drivers/block/rd.c                                |    2 
 drivers/char/drm/drm_dma.c                        |    2 
 drivers/char/drm/drm_vm.c                         |    2 
 drivers/char/drm/r300_reg.h                       |    2 
 drivers/char/genrtc.c                             |    4 -
 drivers/char/pcmcia/cm4000_cs.c                   |    2 
 drivers/char/tpm/Kconfig                          |    2 
 drivers/char/tty_io.c                             |    8 +-
 drivers/crypto/Kconfig                            |    2 
 drivers/ide/pci/siimage.c                         |    2 
 drivers/ieee1394/nodemgr.c                        |    2 
 drivers/isdn/capi/Kconfig                         |    2 
 drivers/isdn/hardware/eicon/divasync.h            |    2 
 drivers/isdn/hisax/hfc_usb.c                      |    4 -
 drivers/leds/leds-h1940.c                         |    2 
 drivers/macintosh/Kconfig                         |    2 
 drivers/media/dvb/dvb-usb/dvb-usb-remote.c        |    2 
 drivers/media/dvb/frontends/dib7000m.c            |    2 
 drivers/media/dvb/frontends/dib7000p.c            |    2 
 drivers/media/dvb/frontends/tda10021.c            |    2 
 drivers/media/dvb/frontends/ves1x93.c             |    2 
 drivers/media/video/em28xx/em28xx-i2c.c           |    2 
 drivers/media/video/em28xx/em28xx-video.c         |    2 
 drivers/media/video/pwc/philips.txt               |    6 -
 drivers/media/video/usbvideo/vicam.c              |    2 
 drivers/message/fusion/lsi/mpi_history.txt        |    2 
 drivers/message/fusion/mptbase.c                  |    2 
 drivers/mtd/maps/Kconfig                          |    2 
 drivers/mtd/maps/nettel.c                         |    2 
 drivers/mtd/onenand/onenand_base.c                |    2 
 drivers/net/3c509.c                               |    5 -
 drivers/net/3c59x.c                               |    2 
 drivers/net/atp.c                                 |    8 --
 drivers/net/bonding/bond_main.c                   |    2 
 drivers/net/eepro.c                               |    2 
 drivers/net/eepro100.c                            |    2 
 drivers/net/epic100.c                             |   10 +--
 drivers/net/hamradio/Kconfig                      |    2 
 drivers/net/irda/donauboe.h                       |    2 
 drivers/net/ixgb/ixgb_ee.c                        |    2 
 drivers/net/meth.h                                |    2 
 drivers/net/natsemi.c                             |    1 
 drivers/net/ne2k-pci.c                            |    3 
 drivers/net/sundance.c                            |    3 
 drivers/net/tulip/interrupt.c                     |    2 
 drivers/net/tulip/winbond-840.c                   |    2 
 drivers/net/tulip/xircom_cb.c                     |    2 
 drivers/net/typhoon.c                             |    2 
 drivers/net/wireless/airport.c                    |    2 
 drivers/net/wireless/prism54/isl_ioctl.c          |    2 
 drivers/net/wireless/prism54/islpci_dev.c         |    2 
 drivers/net/wireless/wavelan_cs.c                 |    4 -
 drivers/net/wireless/wavelan_cs.p.h               |    2 
 drivers/net/yellowfin.c                           |    1 
 drivers/pci/pci-driver.c                          |    2 
 drivers/rtc/Kconfig                               |    2 
 drivers/s390/char/sclp_rw.c                       |    2 
 drivers/s390/net/qeth_main.c                      |    2 
 drivers/s390/scsi/zfcp_qdio.c                     |    2 
 drivers/sbus/char/bpp.c                           |    2 
 drivers/scsi/aic7xxx/aic79xx_pci.c                |    2 
 drivers/scsi/aic94xx/Makefile                     |    2 
 drivers/scsi/dc395x.c                             |    6 -
 drivers/scsi/scsi_lib.c                           |    2 
 drivers/usb/misc/auerswald.c                      |    2 
 drivers/usb/net/usbnet.h                          |    2 
 drivers/usb/serial/Kconfig                        |    2 
 drivers/usb/serial/aircable.c                     |    4 -
 drivers/usb/serial/io_edgeport.c                  |    4 -
 drivers/video/console/softcursor.c                |    2 
 drivers/video/i810/i810_main.c                    |    2 
 drivers/video/matrox/matroxfb_Ti3026.c            |    2 
 drivers/video/matrox/matroxfb_accel.c             |    2 
 drivers/video/matrox/matroxfb_base.c              |    2 
 drivers/video/matrox/matroxfb_misc.c              |    2 
 drivers/video/skeletonfb.c                        |    2 
 fs/Kconfig                                        |    4 -
 fs/direct-io.c                                    |    2 
 fs/jbd/checkpoint.c                               |    2 
 fs/jbd/recovery.c                                 |    2 
 fs/jbd/revoke.c                                   |    2 
 fs/jbd/transaction.c                              |    2 
 fs/jbd2/checkpoint.c                              |    2 
 fs/jbd2/recovery.c                                |    2 
 fs/jbd2/revoke.c                                  |    2 
 fs/jbd2/transaction.c                             |    2 
 fs/jfs/jfs_dmap.c                                 |    2 
 fs/jfs/jfs_imap.c                                 |    4 -
 fs/jfs/jfs_logmgr.c                               |    2 
 fs/libfs.c                                        |    5 +
 fs/reiserfs/journal.c                             |    4 -
 fs/select.c                                       |    4 -
 fs/xfs/xfs_itable.c                               |    2 
 include/asm-arm/arch-imx/imx-regs.h               |    2 
 include/asm-arm/arch-integrator/platform.h        |    2 
 include/asm-arm/arch-iop32x/glantank.h            |    2 
 include/asm-arm/arch-iop32x/n2100.h               |    2 
 include/asm-arm/arch-omap/board.h                 |    2 
 include/asm-arm/arch-omap/dma.h                   |    2 
 include/asm-arm/arch-omap/gpio.h                  |    2 
 include/asm-arm/arch-s3c2410/regs-power.h         |    2 
 include/asm-arm/arch-s3c2410/regs-s3c2443-clock.h |    2 
 include/asm-arm/arch-s3c2410/regs-watchdog.h      |    2 
 include/asm-arm/arch-s3c2410/udc.h                |    2 
 include/asm-arm/dma-mapping.h                     |    2 
 include/asm-arm26/io.h                            |    2 
 include/asm-arm26/memory.h                        |    4 -
 include/asm-arm26/setup.h                         |    2 
 include/asm-generic/bitops/atomic.h               |    2 
 include/asm-i386/bitops.h                         |    2 
 include/asm-i386/boot.h                           |    2 
 include/asm-i386/sync_bitops.h                    |    2 
 include/asm-m32r/system.h                         |    2 
 include/asm-m68k/atarihw.h                        |    2 
 include/asm-m68k/atariints.h                      |    2 
 include/asm-mips/bootinfo.h                       |    2 
 include/asm-powerpc/ppc-pci.h                     |    2 
 include/asm-ppc/hydra.h                           |    2 
 include/asm-sh/edosk7705.h                        |    2 
 include/asm-sh/snapgear.h                         |    2 
 include/asm-xtensa/platform-iss/simcall.h         |    2 
 include/linux/ext3_fs_i.h                         |    2 
 include/linux/ext4_fs_i.h                         |    2 
 include/linux/generic_acl.h                       |    2 
 include/linux/i2c-algo-bit.h                      |    2 
 include/linux/i2c-algo-pcf.h                      |    2 
 include/linux/irda.h                              |    2 
 include/linux/meye.h                              |    2 
 include/linux/mount.h                             |    2 
 include/linux/radix-tree.h                        |    4 -
 include/linux/security.h                          |    2 
 include/linux/sonypi.h                            |    2 
 include/linux/usb.h                               |    2 
 include/net/irda/af_irda.h                        |    2 
 include/net/irda/irda.h                           |    2 
 include/net/irda/iriap.h                          |    2 
 include/net/irda/iriap_event.h                    |    2 
 include/net/irda/irias_object.h                   |    2 
 include/net/irda/irlan_client.h                   |    2 
 include/net/irda/irlan_common.h                   |    2 
 include/net/irda/irlan_eth.h                      |    2 
 include/net/irda/irlan_event.h                    |    2 
 include/net/irda/irlan_filter.h                   |    2 
 include/net/irda/irlan_provider.h                 |    2 
 include/net/irda/irlap.h                          |    2 
 include/net/irda/irlmp.h                          |    2 
 include/net/irda/irlmp_event.h                    |    2 
 include/net/irda/irlmp_frame.h                    |    2 
 include/net/irda/irmod.h                          |    2 
 include/net/irda/irqueue.h                        |    2 
 include/net/irda/irttp.h                          |    2 
 include/net/irda/parameters.h                     |    2 
 include/net/irda/timer.h                          |    2 
 include/net/irda/wrapper.h                        |    2 
 init/Kconfig                                      |    6 -
 kernel/Kconfig.preempt                            |    4 -
 kernel/module.c                                   |   10 +--
 kernel/relay.c                                    |    2 
 kernel/sys.c                                      |    2 
 kernel/wait.c                                     |    2 
 mm/mmap.c                                         |    2 
 net/decnet/af_decnet.c                            |    2 
 net/ipv4/Kconfig                                  |    4 -
 net/ipv4/cipso_ipv4.c                             |    2 
 net/ipv4/ipvs/ip_vs_sed.c                         |    2 
 net/ipv4/udp.c                                    |    2 
 net/ipv6/netfilter/Kconfig                        |    2 
 net/llc/af_llc.c                                  |    2 
 net/netfilter/Kconfig                             |    2 
 net/netfilter/nf_conntrack_expect.c               |    2 
 net/sctp/chunk.c                                  |    2 
 net/sctp/socket.c                                 |    4 -
 net/sunrpc/svcauth.c                              |    2 
 scripts/basic/docproc.c                           |    2 
 security/selinux/Kconfig                          |    2 
 sound/core/Kconfig                                |    2 
 sound/oss/es1371.c                                |    2 
 sound/oss/pas2_pcm.c                              |    2 
 sound/oss/trident.c                               |    4 -
 sound/pci/ac97/ac97_codec.c                       |    2 
 sound/pci/ice1712/delta.h                         |    4 -
 sound/pci/mixart/mixart.c                         |    2 
 sound/soc/pxa/pxa2xx-ac97.h                       |    2 
 sound/soc/pxa/pxa2xx-i2s.h                        |    2 
 sound/sparc/dbri.c                                |    2 
 302 files changed, 438 insertions(+), 444 deletions(-)

