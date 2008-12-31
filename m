Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYLaNdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYLaNdc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 08:33:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756051AbYLaNdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 08:33:17 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38398 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbYLaNdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 08:33:12 -0500
Date: Thu, 1 Jan 2009 00:32:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 31
Message-Id: <20090101003258.eaa44700.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Jan_2009_00_32_58_+1100_oKL/QL5unpIFfK7D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Jan_2009_00_32_58_+1100_oKL/QL5unpIFfK7D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081230:

Dropped trees (temporarily):
	driver-core (build problem)
	usb (depends on driver-core)
	kvm (build problem)
	semaphore-removal (due to unfixed conflicts against Linus' tree)
	cpu_alloc (build problem)
	audit (difficult conflicts)
	staging (depends on usb)

I substituted a fix commit from the infiniband tree for the revert build
fix for Linus' tree.

The xfs tree lost its 4 conflicts.

The scsi tree lost its build failure.

The firmware tree lost 3 conflicts (because the conflicting commits were
removed from the scsi tree).

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
final fixups (if any), it is also built with powerpc allnoconfig,
44x_defconfig and allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES) and
i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 132 trees (counting Linus' and 15 trees of patches pending for
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
Merging arm-current/master
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
CONFLICT (content): Merge conflict in drivers/char/tty_audit.c
Created commit 309ba8e: Merge commit 'audit-current/for-linus'
Merging dwmw2/master
$ git cherry-pick 2c4ab6243f91cda62f22af2eb8a6c07590de37b1
Created commit 7c453f0: RDMA/addr: Fix build breakage when IPv6 is disabled
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging mips/mips-for-linux-next
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in include/linux/hardirq.h
Created commit 6620d2d: Merge commit 'tip-core/auto-core-next'
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
CONFLICT (content): Merge conflict in kernel/time/tick-sched.c
Created commit b665237: Merge commit 'timers/auto-timers-next'
Merging pci/linux-next
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm.c
Created commit 7afc9a5: Merge branch 'quilt/device-mapper'
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
Merging nfsd/nfsd-next
CONFLICT (content): Merge conflict in fs/lockd/host.c
CONFLICT (content): Merge conflict in fs/lockd/mon.c
Created commit ff8ad19: Merge commit 'nfsd/nfsd-next'
Merging ieee1394/for-next
Merging ubi/linux-next
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/namei.c
Created commit 41d1404: Merge commit 'ocfs2/linux-next'
Merging ext4/next
Merging async_tx/next
Applying: net: async_tx merge fix
Created commit 74129d6: Merge commit 'async_tx/next'
Merging udf/for_next
Merging net/master
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/corgi.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/poodle.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/spitz.c
Created commit 8b5bb2a: Merge commit 'mtd/master'
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging rr_cpumask/master
CONFLICT (content): Merge conflict in kernel/sched.c
Created commit 1653d97: Merge commit 'rr_cpumask/master'
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/rcuclassic.c
Created commit a788be2: Merge branch 'quilt/rr'
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging bkl-removal/bkl-removal
CONFLICT (content): Merge conflict in fs/ioctl.c
Created commit 28240e8: Merge commit 'bkl-removal/bkl-removal'
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/net/tg3.c
CONFLICT (content): Merge conflict in firmware/Makefile
CONFLICT (content): Merge conflict in firmware/WHENCE
Created commit b64483f: Merge commit 'firmware/master'
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in arch/x86/mm/Makefile
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slub.c
Created commit 6e893bf: Merge commit 'kmemcheck/auto-kmemcheck-next'
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Created commit 0463080: Merge commit 'lblnet/master'
Merging quilt/ttydev
CONFLICT (content): Merge conflict in fs/devpts/inode.c
Created commit e078ab9: Merge branch 'quilt/ttydev'
Merging agp/agp-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
CONFLICT (content): Merge conflict in drivers/uwb/wlp/eda.c
Created commit 3c3975b: Merge commit 'uwb/for-upstream'
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
CONFLICT (content): Merge conflict in kernel/sched.c
Created commit db8f43b: Merge commit 'cputime/cputime'
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
CONFLICT (content): Merge conflict in kernel/fork.c
Created commit fd70d10: Merge commit 'nommu/master'
Merging boot-params/master
CONFLICT (content): Merge conflict in arch/arm/kernel/setup.c
CONFLICT (content): Merge conflict in arch/parisc/kernel/setup.c
CONFLICT (content): Merge conflict in arch/sh/boards/mach-microdev/setup.c
CONFLICT (content): Merge conflict in arch/sh/boards/mach-migor/setup.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/common.c
Created commit 45ff2be: Merge commit 'boot-params/master'
Merging trivial/for-next

--Signature=_Thu__1_Jan_2009_00_32_58_+1100_oKL/QL5unpIFfK7D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklbdIoACgkQjjKRsyhoI8wV9ACfeRm/LDe4ELZoqJexBTd811IY
GcMAoJE93bTqijYuOPLFWjBsKpGGPqBc
=wZgG
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Jan_2009_00_32_58_+1100_oKL/QL5unpIFfK7D--
