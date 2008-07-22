Return-Path: <linux-kernel-owner+w=401wt.eu-S1753968AbYGVIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968AbYGVIlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 04:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752183AbYGVIlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 04:41:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41847 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557AbYGVIlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 04:41:06 -0400
Date: Tue, 22 Jul 2008 18:40:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 22
Message-Id: <20080722184059.a58c79d7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jul_2008_18_40_59_+1000_Lft1Kzka/CgFUxx="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jul_2008_18_40_59_+1000_Lft1Kzka/CgFUxx=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080721:

Temporarily dropped trees: acpi (confusion about its source).
	kvm, ttydev (too many conflict caused by partial merge to Linus).

The s390 and cris trees were not able to be fetched (network problem).

Linus' tree required a build fix for powerpc.

The net-current tree lost its build breakage.

The driver-core tree gained a conflict against Linus' tree but lost 21
conflicts and two build fix patches.

The usb tree lost 6 conflicts and a build fix patch.

The cpus4096 tree traded an acpi conflict for a cpufreq one (tranferred
over from the cpufreq tree).

The sched tree gained a conflict against eahc of Linus' and the cpus4096
trees.

The x86 tree lost a conflict and a build fix patch.

The ide tree lost two conflicts.

The nfsd tree lost a conflict.

The ubi tree gained a conflict against Linus' tree.

The kvm tree was partially merged and gained so many conflicts against
Linus' tree that I have temporarily dropped it.

The vfs tree lost two conflicts.

The cpusfreq tree lost a conflict.

The rr tree gained a conflict against the cpus4096 tree.

The kmemcheck tree gained a conflict against Linus' tree.

The ttydev tree was partially merged upstream and gained so many
conflicts that I have temporarily dropped it.

I have also applied the following patches for known problems:

	sparc32: pass -m32 when building vmlinux.lds
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
http://www.canb.auug.org.au/~sfr/

$ git checkout master
$ git reset --hard stable
Merging origin/master
Applying  serial: fix struct uart_info change fallout
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
CONFLICT (content): Merge conflict in drivers/usb/core/devio.c
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
CONFLICT (content): Merge conflict in include/asm-x86/thread_info.h
CONFLICT (content): Merge conflict in kernel/sched_fair.c
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
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
CONFLICT (content): Merge conflict in include/Kbuild
Created commit 3b7168b: Revert "kconfig: normalize int/hex values"
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
CONFLICT (content): Merge conflict in drivers/mtd/ubi/cdev.c
Merging kvm/master
CONFLICT (content): Merge conflict in arch/powerpc/kvm/Makefile
CONFLICT (content): Merge conflict in arch/x86/kvm/mmu.c
CONFLICT (content): Merge conflict in arch/x86/kvm/svm.c
CONFLICT (content): Merge conflict in arch/x86/kvm/vmx.c
CONFLICT (content): Merge conflict in arch/x86/kvm/x86.c
CONFLICT (content): Merge conflict in arch/x86/kvm/x86_emulate.c
CONFLICT (content): Merge conflict in include/asm-x86/kvm.h
CONFLICT (content): Merge conflict in include/asm-x86/kvm_host.h
CONFLICT (content): Merge conflict in include/linux/kvm.h
CONFLICT (content): Merge conflict in virt/kvm/kvm_trace.c
$ git reset --hard
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
CONFLICT (content): Merge conflict in drivers/net/fs_enet/fs_enet-main.c
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
CONFLICT (content): Merge conflict in drivers/net/tun.c
CONFLICT (content): Merge conflict in include/linux/if_tun.h
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
Created commit 4e3f5f0: Revert "Convert qla_os to use mutex instead of sema=
phore"
Created commit 24394e2: Revert "qla2xxx: Turn vport_sem into vport_mutex"
$ git checkout master
CONFLICT (content): Merge conflict in drivers/net/ps3_gelic_wireless.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/for_andrew
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
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_32.c
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
CONFLICT (content): Merge conflict in drivers/char/mxser.c
CONFLICT (content): Merge conflict in drivers/char/specialix.c
CONFLICT (content): Merge conflict in drivers/char/synclink_gt.c
CONFLICT (content): Merge conflict in drivers/char/tty_io.c
CONFLICT (content): Merge conflict in drivers/usb/gadget/serial.c
CONFLICT (delete/modify): drivers/usb/serial/airprime.c deleted in HEAD and=
 modified in quilt/ttydev. Version quilt/ttydev of drivers/usb/serial/airpr=
ime.c left in tree.
CONFLICT (content): Merge conflict in drivers/usb/serial/cp2101.c
CONFLICT (content): Merge conflict in drivers/usb/serial/io_ti.c
CONFLICT (content): Merge conflict in drivers/usb/serial/ir-usb.c
CONFLICT (content): Merge conflict in drivers/usb/serial/usb-serial.c
CONFLICT (content): Merge conflict in include/linux/tty.h
CONFLICT (content): Merge conflict in net/bluetooth/rfcomm/tty.c
$ git rm drivers/usb/serial/airprime.c
$ git reset --hard
Applying sparc32: pass -m32 when building vmlinux.lds
Applying firmware: fix typo in qlogicpti.c
Applying firmware: conversion fallout in qlogicpti.c
Applying firmware: another typo in the conversion

--Signature=_Tue__22_Jul_2008_18_40_59_+1000_Lft1Kzka/CgFUxx=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiFnRsACgkQjjKRsyhoI8xgQQCgi/cOY9zv5zSOheNePdIc0sw4
3C0AnRTqKSt20/k4c++h99MRsejqIR6F
=zfv/
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jul_2008_18_40_59_+1000_Lft1Kzka/CgFUxx=--
