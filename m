Return-Path: <linux-kernel-owner+w=401wt.eu-S1753310AbYJ2IZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310AbYJ2IZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 04:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752561AbYJ2IZl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 04:25:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35780 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475AbYJ2IZh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 04:25:37 -0400
Date: Wed, 29 Oct 2008 19:25:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 29
Message-Id: <20081029192528.bc26e7b4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__29_Oct_2008_19_25_28_+1100_3lJ6H57SX9I3aAx_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Oct_2008_19_25_28_+1100_3lJ6H57SX9I3aAx_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's tree will not build for powerpc allyesconfig (libc aborts the
link due to a free() problem), sparc(32) defconfig and probably some
other configurations.

I am no longer commenting on conflicts that are clearly just caused by
slight differences in what has been merged into Linus' tree and
linux-next or conflicts caused by further changes in the linux-next after
a subset of a tree has been merged.

Changes since 20081028:

New Tree:
	userns

Undropped tree:
	v4l-dvb

Dropped tree:
	rr (too many conflicts for today)

The s390 tree gained a conflict against the net-current tree.

The tip-core tree lost its conflict.

The stackprotector tree lost its conflict.

The v4l-dvb tree gained a build fix patch.

The kvm tree gained a conflict against Linus' tree.

The net tree gained a conflict against the net-current tree.

The rr tree gained lots of conflicts and was dropped for today.

The hdlc tree gained a conflict against the net-current tree.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	Work around ld bug in older binutils (powerpc patch)
	ftrace: rename FTRACE to FUNCTION_TRACER more successfully. (sh patch)
	nfsctl: credentials error
	coda: credentials error
	cpu_alloc: per_cpu_offset is already defined for !CONFIG_SMP
	ia64-fix-arch-ia64-kernel-iosapicc-build (pinched from v2.6.28-rc2-mm1)

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

We are up to 121 trees (counting Linus' and 14 trees of patches pending for
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
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging quilt/m68k
Merging m68knommu/for-next
Merging mips/mips-for-linux-next
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
Merging s390/features
CONFLICT (content): Merge conflict in drivers/s390/net/qeth_l2_main.c
CONFLICT (content): Merge conflict in drivers/s390/net/qeth_l3_main.c
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Created commit 8abf9a9: Revert "USB: remove info() macro from usb.h"
Created commit fa8469b: Revert "USB: remove warn() macro from usb.h"
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Applying v4l-dvb: fallout from DVB_DYNAMIC_MINORS addition
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in include/linux/kvm_host.h
CONFLICT (content): Merge conflict in virt/kvm/kvm_main.c
Merging dlm/next
Merging scsi/master
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/wireless/p54/p54common.c
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/bigsmp/api=
c.h
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/es7000/api=
c.h
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/ipi.h
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/mach-defau=
lt/mach_apic.h
CONFLICT (content): Merge conflict in arch/powerpc/platforms/cell/spu_base.c
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/kernel/genx2apic_cluster.c
CONFLICT (content): Merge conflict in arch/x86/kernel/genx2apic_phys.c
CONFLICT (content): Merge conflict in arch/x86/kernel/genx2apic_uv_x.c
CONFLICT (content): Merge conflict in include/linux/cpumask.h
CONFLICT (content): Merge conflict in kernel/Kconfig.preempt
CONFLICT (content): Merge conflict in kernel/cpu.c
CONFLICT (content): Merge conflict in kernel/params.c
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/stop_machine.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in lib/cpumask.c
$ git reset --hard
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/scsi/qlogicpti.c
CONFLICT (content): Merge conflict in firmware/WHENCE
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in mm/Makefile
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
CONFLICT (delete/modify): drivers/net/wan/syncppp.c deleted in hdlc/hdlc-ne=
xt and modified in HEAD. Version HEAD of drivers/net/wan/syncppp.c left in =
tree.
$ git rm -f drivers/net/wan/syncppp.c
Merging drm/drm-next
Merging voltage/for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging creds/creds-v4
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
Merging cpu_alloc/cpu_alloc
CONFLICT (content): Merge conflict in kernel/lockdep.c
CONFLICT (content): Merge conflict in kernel/module.c
Merging scsi-post-merge/master
Merging userns/next
Applying sparc: qlogicpti fallout from sbus removal
Applying Work around ld bug in older binutils
Applying ftrace: rename FTRACE to FUNCTION_TRACER more successfully.
Applying nfsctl: credentials error
Applying coda: credentials error
Applying cpu_alloc: per_cpu_offset is already defined for !CONFIG_SMP
Applying ia64-fix-arch-ia64-kernel-iosapicc-build

--Signature=_Wed__29_Oct_2008_19_25_28_+1100_3lJ6H57SX9I3aAx_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkIHfgACgkQjjKRsyhoI8wprQCfZ62UnyRsph86ATiomhIpJtzZ
8acAoIjQFamC46yNPIZfCgQkeYiyc+Ri
=of6t
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Oct_2008_19_25_28_+1100_3lJ6H57SX9I3aAx_--
