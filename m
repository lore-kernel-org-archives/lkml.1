Return-Path: <linux-kernel-owner+w=401wt.eu-S1751770AbXBRBMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751770AbXBRBMx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 20:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751774AbXBRBMx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 20:12:53 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33149 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751770AbXBRBMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 20:12:52 -0500
Date: Sun, 18 Feb 2007 02:12:53 +0100
From: Adrian Bunk <bunk@stusta.de>
To: Linus Torvalds <torvalds@osdl.org>
Cc: linux-kernel@vger.kernel.org
Subject: please pull from the trivial tree
Message-ID: <20070218011253.GS13958@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/bunk/trivial.git


This tree contains the following:

Adrian Bunk (1):
      correct a dead URL in the IP_MULTICAST help text

Erik Hovland (1):
      trivial documentation patch for platform.txt

James Nelson (1):
      Documentation/kernel-docs.txt update.

Jesper Juhl (2):
      Remove duplicate listing of Cris arch from README
      update I/O sched Kconfig help texts - CFQ is now default, not AS.

John Daiker (1):
      add a help text for BLK_DEV_GENERIC

Matthew Wilcox (1):
      fix SCSI_SCAN_ASYNC help text

Nicolas Kaiser (1):
      arch/cris: typo in KERN_INFO

Patrick Pletscher (1):
      kernel/printk.c: comment fix

Randy Dunlap (2):
      doc: make doc. for maxcpus= more visible
      kbuild: more doc. cleanups

Robert P. J. Day (9):
      kbuild: Replace remaining "depends" with "depends on"
      Various typo fixes.
      Use ARRAY_SIZE() macro in i386 relocs.c file
      Replace remaining references to "driverfs" with "sysfs".
      Remove useless FIND_FIRST_BIT() macro from cardbus.c.
      Correct trivial typo in log2.h.
      drivers/scsi/a100u2w.c: trivial typo patch
      Fix misspellings of "agressive".
      Fix comment typo "spin_lock_irqrestore".

Shane Shrybman (1):
      drivers/net/eexpress.c: remove duplicate comment

Simon Depiets (1):
      fix the BAYCOM_SER_HDX help text

Tobias Klauser (1):
      Storage class should be before const qualifier

Uwe Kleine-König (1):
      Fix typos concerning hierarchy

Willy Tarreau (1):
      rio: typo in bitwise AND expression.


 Documentation/driver-model/platform.txt           |    4 
 Documentation/filesystems/sysfs-pci.txt           |    2 
 Documentation/kbuild/makefiles.txt                |   28 -
 Documentation/kernel-docs.txt                     |  257 ++++++--------
 Documentation/kernel-parameters.txt               |    9 
 Documentation/sh/new-machine.txt                  |    4 
 Documentation/video4linux/bttv/Insmod-options     |    2 
 README                                            |    2 
 arch/arm/Kconfig                                  |    2 
 arch/arm/mm/Kconfig                               |    2 
 arch/cris/arch-v10/drivers/pcf8563.c              |    2 
 arch/cris/arch-v32/drivers/pcf8563.c              |    2 
 arch/i386/boot/compressed/relocs.c                |    9 
 arch/i386/kernel/topology.c                       |    2 
 arch/i386/oprofile/nmi_int.c                      |   14 
 arch/ia64/kernel/perfmon.c                        |    2 
 arch/m32r/lib/usercopy.c                          |    4 
 arch/m68knommu/platform/5307/timers.c             |    2 
 arch/mips/kernel/machine_kexec.c                  |    4 
 arch/parisc/kernel/topology.c                     |    2 
 arch/powerpc/kernel/rtas.c                        |    2 
 arch/powerpc/mm/numa.c                            |    2 
 arch/sh/kernel/cpu/sh2/clock-sh7619.c             |    4 
 arch/sh/kernel/cpu/sh2a/clock-sh7206.c            |    4 
 arch/v850/Kconfig                                 |    2 
 arch/x86_64/kernel/time.c                         |    2 
 block/Kconfig.iosched                             |    9 
 drivers/base/cpu.c                                |    2 
 drivers/base/node.c                               |    2 
 drivers/char/rio/rio_linux.c                      |    2 
 drivers/i2c/busses/i2c-ali1535.c                  |    2 
 drivers/i2c/busses/i2c-ali15x3.c                  |    2 
 drivers/i2c/busses/i2c-amd756.c                   |    2 
 drivers/i2c/busses/i2c-amd8111.c                  |    2 
 drivers/i2c/busses/i2c-i801.c                     |    2 
 drivers/i2c/busses/i2c-piix4.c                    |    2 
 drivers/i2c/busses/i2c-sis5595.c                  |    2 
 drivers/i2c/busses/i2c-sis630.c                   |    2 
 drivers/i2c/busses/i2c-sis96x.c                   |    2 
 drivers/i2c/busses/i2c-via.c                      |    2 
 drivers/ide/Kconfig                               |    3 
 drivers/ieee1394/ohci1394.c                       |    2 
 drivers/infiniband/hw/ipath/ipath_iba6110.c       |    2 
 drivers/infiniband/hw/ipath/ipath_iba6120.c       |    2 
 drivers/input/serio/libps2.c                      |    2 
 drivers/isdn/i4l/isdn_ppp.c                       |    2 
 drivers/media/dvb/dvb-core/dvb_frontend.c         |    2 
 drivers/media/dvb/frontends/dib3000mb.c           |    2 
 drivers/media/video/pvrusb2/pvrusb2-audio.c       |    2 
 drivers/media/video/pvrusb2/pvrusb2-cx2584x-v4l.c |    2 
 drivers/media/video/pvrusb2/pvrusb2-std.c         |    4 
 drivers/media/video/pvrusb2/pvrusb2-tuner.c       |    2 
 drivers/media/video/pvrusb2/pvrusb2-video-v4l.c   |    2 
 drivers/media/video/pvrusb2/pvrusb2-wm8775.c      |    2 
 drivers/net/e1000/e1000_hw.h                      |    2 
 drivers/net/eexpress.c                            |    7 
 drivers/net/hamradio/Kconfig                      |    3 
 drivers/net/wireless/wavelan_cs.c                 |    8 
 drivers/pci/pcie/aer/aerdrv.h                     |    2 
 drivers/pcmcia/cardbus.c                          |    2 
 drivers/sbus/char/vfc_i2c.c                       |    2 
 drivers/scsi/Kconfig                              |    5 
 drivers/scsi/a100u2w.c                            |    2 
 drivers/scsi/arm/eesox.c                          |    2 
 drivers/scsi/osst.c                               |   12 
 drivers/scsi/scsi_scan.c                          |    2 
 drivers/scsi/scsi_transport_fc.c                  |    2 
 drivers/scsi/scsi_transport_sas.c                 |    4 
 drivers/scsi/st.c                                 |   38 +-
 drivers/scsi/sym53c8xx_2/sym_fw1.h                |    4 
 drivers/scsi/sym53c8xx_2/sym_fw2.h                |    4 
 drivers/usb/host/ehci-dbg.c                       |    2 
 fs/cifs/README                                    |    2 
 fs/cifs/cifssmb.c                                 |    4 
 fs/ext4/extents.c                                 |   14 
 fs/lockd/svc.c                                    |    2 
 fs/ocfs2/namei.c                                  |    2 
 include/asm-arm/uaccess.h                         |    6 
 include/asm-arm26/uaccess.h                       |   10 
 include/asm-ia64/kexec.h                          |    2 
 include/asm-ia64/pal.h                            |   14 
 include/linux/device.h                            |    4 
 include/linux/ext4_fs_extents.h                   |    4 
 include/linux/log2.h                              |    2 
 include/linux/moduleparam.h                       |    2 
 include/linux/seqlock.h                           |    2 
 kernel/printk.c                                   |    2 
 lib/textsearch.c                                  |    2 
 net/ipv4/Kconfig                                  |    2 
 net/ipv4/tcp_cong.c                               |    2 
 90 files changed, 304 insertions(+), 314 deletions(-)

