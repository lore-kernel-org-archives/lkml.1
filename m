Return-Path: <linux-kernel-owner+w=401wt.eu-S1751834AbZAZIYN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834AbZAZIYN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2009 03:24:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbZAZIX6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Jan 2009 03:23:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44797 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777AbZAZIX4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2009 03:23:56 -0500
Date: Mon, 26 Jan 2009 19:23:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for January 26
Message-Id: <20090126192349.1804bc27.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__26_Jan_2009_19_23_49_+1100_J=F6xgv+REVztSx2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Jan_2009_19_23_49_+1100_J=F6xgv+REVztSx2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

A happy Australia Day to all my Aussie comrades.

News:  I will be on leave for the rest of the week, so there will
probably be no linux-next release until Feb 2  (I know I said this on
Friday, but I really mean it this time :-)).

Changes since 20090123:

Dropped trees (temporarily):
	cpu_alloc (build problem)
	audit (difficult conflicts)

I merged the mfd tree immediately after Linus' tree instead of applying
the build fix patch it has.

The driver-core tree gained a build failure that caused me to revert a
commit.

The ide tree gained a conflict against the driver-core tree.

The net tree lost its build failure only to gain another that caused me
to revert a couple of commits.

The sound tree lost its conflict.

The slab tree gained a conflict against the ftrace tree.

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
ppc44x_defconfig and allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES) and
i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 132 trees (counting Linus' and 18 trees of patches pending for
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
Merging mfd/for-next
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
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
CONFLICT (delete/modify): arch/m68knommu/include/asm/Kbuild deleted in m68k=
nommu/for-next and modified in HEAD. Version HEAD of arch/m68knommu/include=
/asm/Kbuild left in tree.
$ git rm -f arch/m68knommu/include/asm/Kbuild
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
Merging quilt/driver-core
Merging quilt/usb
Created commit f05bd35: Revert "driver core: get rid of struct device's bus=
_id string array"
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in arch/x86/kernel/setup_percpu.c
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/for-next
Merging quilt/i2c
CONFLICT (content): Merge conflict in arch/arm/configs/magician_defconfig
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in drivers/ide/ide-acpi.c
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Created commit fd0b769: Revert "com20020: Fix allyesconfig build failure."
Created commit e21f5dd: Revert "com20020: convert to net_devic_ops"
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/acpi-cpuf=
req.c
Merging v9fs/for-next
Merging quilt/rr
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging bkl-removal/bkl-removal
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in include/linux/slub_def.h
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
Merging generic-ipi/auto-generic-ipi-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
CONFLICT (content): Merge conflict in kernel/irq/handle.c
Merging iommu/auto-iommu-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Applying: proc: fixup for pppoe changes
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in include/linux/dma_remapping.h
Merging cputime/cputime
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging squashfs/master
Merging omap/for-next
Merging kmemleak/kmemleak
CONFLICT (content): Merge conflict in include/linux/slab.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in mm/vmalloc.c
Merging quilt/staging
Merging scsi-post-merge/master

--Signature=_Mon__26_Jan_2009_19_23_49_+1100_J=F6xgv+REVztSx2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkl9cxUACgkQjjKRsyhoI8xcKwCdEN2ZP++ERRaKrtCMLcz+TuBN
HlgAn0oI07PSGCl+noiEF+l+EYKO7FKq
=ETcr
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Jan_2009_19_23_49_+1100_J=F6xgv+REVztSx2--
