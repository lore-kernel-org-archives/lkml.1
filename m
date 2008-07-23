Return-Path: <linux-kernel-owner+w=401wt.eu-S1753916AbYGWIPu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916AbYGWIPu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 04:15:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751138AbYGWIPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 04:15:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36872 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbYGWIPb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 04:15:31 -0400
Date: Wed, 23 Jul 2008 18:15:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 23
Message-Id: <20080723181524.52da5090.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_18_15_24_+1000_yoLhp+II2+SDQ5ct"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_18_15_24_+1000_yoLhp+II2+SDQ5ct
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080722:

Temporarily dropped trees: acpi (confusion about its source).
	ttydev (conflicts but completely merged to Linus).
	ubifs (too many conflicts due to out of date base).

The s390 tree was not able to be fetched (network problem).

Linus' tree lost its build fix for powerpc.

The driver-core tree gained more conflicts than it lost yesterday due to
a partial merge with Linus' tree.

The sched tree lost a conflict.

The x86 tree gained a conflict against the pci-current tree.

The kbuild tree gained a conflict against Linus' tree.

The ide tree gained a conflict against the sparc-current tree.

The ubi tree lost it conflict.

The kvm tree is back and has no conflicts.

The galak tree lost its conflict.

The rr tree lost two conflicts.

The kmemcheck tree lost a conflict.

I have also applied the following patches for known problems:

	firmware: fix typo in qlogicpti.c
	firmware: conversion fallout in qlogicpti.c
	firmware: another typo in the conversion

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(patches at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).  If you
are tracking the linux-next tree using git, you should not use "git pull"
to do so as that will try to merge the new linux-next release with the
old one.  You should use "git fetch" as mentioned in the FAQ on the wiki
(see below).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups, it is also built with powerpc allnoconfig,
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 105 trees (counting Linus' and 14 trees of patches pending for
Linus' tree), more are welcome (even if they are currently empty).
Thanks to those who have contributed, and to those who haven't, please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next .  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ , the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

There is a wiki covering stuff to do with linux-next at
http://linux.f-seidel.de/linux-next/pmwiki/ .  Thanks to Frank Seidel.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

$ git checkout master
$ git reset --hard stable
Merging origin/master
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/mips/kernel/rtlx.c
CONFLICT (content): Merge conflict in arch/mips/sibyte/common/sb_tbprof.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpuid.c
CONFLICT (content): Merge conflict in arch/x86/kernel/msr.c
CONFLICT (content): Merge conflict in block/bsg.c
CONFLICT (content): Merge conflict in drivers/block/aoe/aoechr.c
CONFLICT (content): Merge conflict in drivers/block/paride/pg.c
CONFLICT (content): Merge conflict in drivers/block/paride/pt.c
CONFLICT (content): Merge conflict in drivers/block/pktcdvd.c
CONFLICT (content): Merge conflict in drivers/char/dsp56k.c
CONFLICT (content): Merge conflict in drivers/char/ip2/ip2main.c
CONFLICT (content): Merge conflict in drivers/char/ipmi/ipmi_devintf.c
CONFLICT (content): Merge conflict in drivers/char/istallion.c
CONFLICT (content): Merge conflict in drivers/char/lp.c
CONFLICT (content): Merge conflict in drivers/char/mem.c
CONFLICT (content): Merge conflict in drivers/char/misc.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4000_cs.c
CONFLICT (content): Merge conflict in drivers/char/pcmcia/cm4040_cs.c
CONFLICT (content): Merge conflict in drivers/char/ppdev.c
CONFLICT (content): Merge conflict in drivers/char/raw.c
CONFLICT (content): Merge conflict in drivers/char/snsc.c
CONFLICT (content): Merge conflict in drivers/char/stallion.c
CONFLICT (content): Merge conflict in drivers/char/tty_io.c
CONFLICT (content): Merge conflict in drivers/char/vc_screen.c
CONFLICT (content): Merge conflict in drivers/char/viotape.c
CONFLICT (content): Merge conflict in drivers/char/vt.c
CONFLICT (content): Merge conflict in drivers/char/xilinx_hwicap/xilinx_hwi=
cap.c
CONFLICT (content): Merge conflict in drivers/dca/dca-sysfs.c
CONFLICT (content): Merge conflict in drivers/hid/hidraw.c
CONFLICT (content): Merge conflict in drivers/hwmon/hwmon.c
CONFLICT (content): Merge conflict in drivers/i2c/i2c-dev.c
CONFLICT (content): Merge conflict in drivers/ide/ide-tape.c
CONFLICT (content): Merge conflict in drivers/ieee1394/dv1394.c
CONFLICT (content): Merge conflict in drivers/ieee1394/raw1394.c
CONFLICT (content): Merge conflict in drivers/ieee1394/video1394.c
CONFLICT (content): Merge conflict in drivers/infiniband/core/cm.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/ipath/ipath_fil=
e_ops.c
CONFLICT (content): Merge conflict in drivers/isdn/capi/capi.c
CONFLICT (content): Merge conflict in drivers/macintosh/adb.c
CONFLICT (content): Merge conflict in drivers/misc/phantom.c
CONFLICT (content): Merge conflict in drivers/mtd/mtdchar.c
CONFLICT (content): Merge conflict in drivers/net/ppp_generic.c
CONFLICT (content): Merge conflict in drivers/net/wan/cosa.c
CONFLICT (content): Merge conflict in drivers/s390/char/raw3270.c
CONFLICT (content): Merge conflict in drivers/s390/char/tape_class.c
CONFLICT (content): Merge conflict in drivers/s390/char/vmur.c
CONFLICT (content): Merge conflict in drivers/scsi/dpt_i2o.c
CONFLICT (content): Merge conflict in drivers/spi/spidev.c
CONFLICT (content): Merge conflict in drivers/usb/core/devio.c
CONFLICT (content): Merge conflict in drivers/usb/core/file.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/printer.c
CONFLICT (content): Merge conflict in drivers/usb/mon/mon_bin.c
CONFLICT (content): Merge conflict in drivers/video/console/fbcon.c
CONFLICT (content): Merge conflict in drivers/video/fbmem.c
CONFLICT (content): Merge conflict in fs/coda/psdev.c
CONFLICT (content): Merge conflict in sound/core/init.c
CONFLICT (content): Merge conflict in sound/oss/soundcard.c
CONFLICT (content): Merge conflict in sound/sound_core.c
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
CONFLICT (content): Merge conflict in kernel/sched_fair.c
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in drivers/pci/dmar.c
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
CONFLICT (content): Merge conflict in Makefile
CONFLICT (content): Merge conflict in include/Kbuild
Created commit e10f1f4: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
CONFLICT (delete/modify): include/asm-sparc/ide_32.h deleted in HEAD and mo=
dified in quilt/ide. Version quilt/ide of include/asm-sparc/ide_32.h left i=
n tree.
CONFLICT (delete/modify): include/asm-sparc/ide_64.h deleted in HEAD and mo=
dified in quilt/ide. Version quilt/ide of include/asm-sparc/ide_64.h left i=
n tree.
$ git rm include/asm-sparc/ide_32.h include/asm-sparc/ide_64.h
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging quilt/m68k
Merging powerpc/next
Merging lblnet/master
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging sparc/master
Merging galak/powerpc-next
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-at91/board-yl-9200.c
CONFLICT (delete/modify): drivers/mtd/maps/mtx-1_flash.c deleted in HEAD an=
d modified in mtd/master. Version mtd/master of drivers/mtd/maps/mtx-1_flas=
h.c left in tree.
$ git rm drivers/mtd/maps/mtx-1_flash.c
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/master
Merging arm/devel
CONFLICT (rename/delete): Renamed arch/arm/configs/em_x270_defconfig->arch/=
sh/configs/sh7785lcr_defconfig in HEAD and deleted in arm/devel
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/stop_machine.c
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in include/asm-sparc64/semaphore.h
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_attr.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_def.h
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mbx.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_mid.c
CONFLICT (content): Merge conflict in drivers/scsi/qla2xxx/qla_os.c
$ git reset --hard
$ git checkout -b tmp semaphore-removal/semaphore-removal
Created commit c2ac8b1: Revert "Convert qla_os to use mutex instead of sema=
phore"
Created commit c631978: Revert "qla2xxx: Turn vport_sem into vport_mutex"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
CONFLICT (add/add): Merge conflict in Documentation/filesystems/ubifs.txt
CONFLICT (content): Merge conflict in drivers/mtd/ubi/debug.c
CONFLICT (content): Merge conflict in drivers/mtd/ubi/scan.c
CONFLICT (content): Merge conflict in drivers/mtd/ubi/ubi-media.h
CONFLICT (content): Merge conflict in drivers/mtd/ubi/vmt.c
CONFLICT (content): Merge conflict in drivers/mtd/ubi/vtbl.c
CONFLICT (add/add): Merge conflict in fs/ubifs/budget.c
CONFLICT (add/add): Merge conflict in fs/ubifs/debug.c
CONFLICT (add/add): Merge conflict in fs/ubifs/dir.c
CONFLICT (add/add): Merge conflict in fs/ubifs/file.c
CONFLICT (add/add): Merge conflict in fs/ubifs/io.c
CONFLICT (add/add): Merge conflict in fs/ubifs/log.c
CONFLICT (add/add): Merge conflict in fs/ubifs/misc.h
CONFLICT (add/add): Merge conflict in fs/ubifs/super.c
CONFLICT (add/add): Merge conflict in fs/ubifs/ubifs.h
$ git reset --hard
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
Merging pcmcia/master
Merging battery/master
CONFLICT (content): Merge conflict in drivers/power/Kconfig
CONFLICT (content): Merge conflict in drivers/power/Makefile
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging m68knommu/for-next
Merging uclinux/for-next
Merging md/for-next
Merging cris/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in kernel/sysctl.c
Merging generic-ipi/auto-generic-ipi-next
Merging mips/mips-for-linux-next
Merging mfd/for-next
Merging hdlc/hdlc-next
CONFLICT (content): Merge conflict in drivers/net/wan/cosa.c
CONFLICT (content): Merge conflict in drivers/net/wan/pc300_drv.c
Merging drm/drm-next
CONFLICT (add/add): Merge conflict in drivers/gpu/Makefile
CONFLICT (add/add): Merge conflict in drivers/gpu/drm/i830/Makefile
CONFLICT (content): Merge conflict in include/Kbuild
CONFLICT (add/add): Merge conflict in include/drm/Kbuild
Merging voltage/reg-for-linus
Merging security-testing/next
Merging quilt/ttydev
CONFLICT (content): Merge conflict in drivers/char/istallion.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/serial.c
CONFLICT (content): Merge conflict in drivers/usb/serial/cp2101.c
CONFLICT (content): Merge conflict in drivers/usb/serial/ir-usb.c
CONFLICT (content): Merge conflict in drivers/usb/serial/usb-serial.c
CONFLICT (content): Merge conflict in net/bluetooth/rfcomm/tty.c
$ git reset --hard
Applying firmware: fix typo in qlogicpti.c
Applying firmware: conversion fallout in qlogicpti.c
Applying firmware: another typo in the conversion

--Signature=_Wed__23_Jul_2008_18_15_24_+1000_yoLhp+II2+SDQ5ct
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiG6JwACgkQjjKRsyhoI8zTiACfdeHgEinS/NiBClBHbGSVTk5g
AfMAnjbYOUNasOmQKa52CVIOAl2niII4
=JVLZ
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_18_15_24_+1000_yoLhp+II2+SDQ5ct--
