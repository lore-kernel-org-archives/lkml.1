Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbYGXIDe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbYGXIDe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 04:03:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751221AbYGXIDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 04:03:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60355 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750977AbYGXIDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 04:03:12 -0400
Date: Thu, 24 Jul 2008 18:03:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 24
Message-Id: <20080724180301.9d1dcfb6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Jul_2008_18_03_01_+1000_D_tJvxXAyXGO_dXV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Jul_2008_18_03_01_+1000_D_tJvxXAyXGO_dXV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080723:

The cris tree is still unfetchable.

The driver-core.current tree gained a conflict against Linus' tree.

The driver-core tree lost all of its conflicts.

The cpus4096 tree lost its conflict.

The ide tree lost its two conflicts, but needed a build fix patch.

The acpi tree is back with quite a few conflicts (most against Linus' tree).

The ubifs tree lost 5 conflicts, but gained several more due to a partial
merge to Linus' tree.

The hdlc tree lost its two conflicts.

The ttydev tree lost its conflicts.

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
CONFLICT (content): Merge conflict in drivers/dca/dca-sysfs.c
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
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
Created commit f730f87: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
Applying ide: fix typo in drivers/ide/ppc/pmac.c
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (rename/modify): Merge conflict in arch/x86/mm/srat_32.c
CONFLICT (content): Merge conflict in Documentation/ABI/testing/sysfs-firmw=
are-acpi
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/sleep.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process.c
CONFLICT (content): Merge conflict in drivers/acpi/executer/exdump.c
CONFLICT (content): Merge conflict in drivers/acpi/hardware/hwgpe.c
CONFLICT (content): Merge conflict in drivers/acpi/processor_throttling.c
CONFLICT (content): Merge conflict in drivers/acpi/scan.c
CONFLICT (content): Merge conflict in drivers/acpi/sleep/main.c
CONFLICT (content): Merge conflict in drivers/acpi/system.c
CONFLICT (content): Merge conflict in drivers/acpi/video.c
CONFLICT (content): Merge conflict in drivers/char/apm-emulation.c
CONFLICT (content): Merge conflict in drivers/misc/Kconfig
CONFLICT (add/add): Merge conflict in drivers/misc/compal-laptop.c
CONFLICT (content): Merge conflict in drivers/misc/fujitsu-laptop.c
CONFLICT (content): Merge conflict in drivers/pci/pci.c
CONFLICT (content): Merge conflict in drivers/pci/pci.h
CONFLICT (content): Merge conflict in include/acpi/acconfig.h
CONFLICT (content): Merge conflict in include/acpi/acexcep.h
CONFLICT (content): Merge conflict in include/acpi/acmacros.h
CONFLICT (content): Merge conflict in include/acpi/acpi_bus.h
CONFLICT (content): Merge conflict in include/acpi/actbl1.h
CONFLICT (content): Merge conflict in include/acpi/actypes.h
CONFLICT (content): Merge conflict in include/linux/ioport.h
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
Created commit aff684f: Revert "Convert qla_os to use mutex instead of sema=
phore"
Created commit 9fba210: Revert "qla2xxx: Turn vport_sem into vport_mutex"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
CONFLICT (add/add): Merge conflict in Documentation/filesystems/ubifs.txt
CONFLICT (add/add): Merge conflict in fs/ubifs/budget.c
CONFLICT (add/add): Merge conflict in fs/ubifs/commit.c
CONFLICT (add/add): Merge conflict in fs/ubifs/debug.c
CONFLICT (add/add): Merge conflict in fs/ubifs/dir.c
CONFLICT (add/add): Merge conflict in fs/ubifs/file.c
CONFLICT (add/add): Merge conflict in fs/ubifs/io.c
CONFLICT (add/add): Merge conflict in fs/ubifs/journal.c
CONFLICT (add/add): Merge conflict in fs/ubifs/log.c
CONFLICT (add/add): Merge conflict in fs/ubifs/misc.h
CONFLICT (add/add): Merge conflict in fs/ubifs/orphan.c
CONFLICT (add/add): Merge conflict in fs/ubifs/super.c
CONFLICT (add/add): Merge conflict in fs/ubifs/ubifs.h
$ git checkout ubifs/linux-next Documentation/filesystems/ubifs.txt fs/ubif=
s/budget.c fs/ubifs/commit.c fs/ubifs/debug.c fs/ubifs/dir.c fs/ubifs/file.=
c fs/ubifs/io.c fs/ubifs/journal.c fs/ubifs/log.c fs/ubifs/misc.h fs/ubifs/=
orphan.c fs/ubifs/super.c fs/ubifs/ubifs.h
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
Merging drm/drm-next
CONFLICT (add/add): Merge conflict in drivers/gpu/Makefile
CONFLICT (add/add): Merge conflict in drivers/gpu/drm/i830/Makefile
CONFLICT (content): Merge conflict in include/Kbuild
CONFLICT (add/add): Merge conflict in include/drm/Kbuild
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Applying firmware: fix typo in qlogicpti.c
Applying firmware: conversion fallout in qlogicpti.c
Applying firmware: another typo in the conversion

--Signature=_Thu__24_Jul_2008_18_03_01_+1000_D_tJvxXAyXGO_dXV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiINzUACgkQjjKRsyhoI8yGzQCgqAzT2ad0EZXqWFccUWQ/6EyT
adMAn14V27PwJHwu+/w/CqylgmpM7CoD
=ZI6J
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Jul_2008_18_03_01_+1000_D_tJvxXAyXGO_dXV--
