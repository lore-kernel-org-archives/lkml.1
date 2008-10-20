Return-Path: <linux-kernel-owner+w=401wt.eu-S1753723AbYJTM72@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753723AbYJTM72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:59:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751719AbYJTM7U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:59:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58018 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569AbYJTM7S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:59:18 -0400
Date: Mon, 20 Oct 2008 23:59:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 20
Message-Id: <20081020235904.2f9a8db4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Oct_2008_23_59_04_+1100_HoBPuy/3l4u6AoLP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Oct_2008_23_59_04_+1100_HoBPuy/3l4u6AoLP
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

Changes since 20081017:

Dropped trees:
	tests (because its future is in doubt and it has conflicts)
	v4l-dvb (the tree is a mess)
	bdev (too many conflicts for me to fix today)

The driver-core.current tree needed a fixup in order to be imported.  It
also gained a conflict against Linus' tree.

The driver-core tree lost all its conflicts.

The tip-core tree lost its 2 conflicts.

The pci tree gained a conflicts against Linus' tree but lost a build fix
revert.

The acpi tree gained a conflict against Linus' tree.

The kvm tree lost its conflict.

The mtd tree had a commit reverted to fix a build failure.

The vfs tree gained a build fix patch.

The v9fs tree lost its conflict.

The block tree lost its 2 conflicts.

The battery tree lost its conflict.

The hdlc tree lost its conflict.

The drm tree lost its conflict.

The ttydev tree had a commit reverted to fix a build failure.

The creds tree gained a conflict against the ttydev tree but lost 2
conflicts and a build fix patch.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	tpm: don't export static functions
	mfd/wm8350: don't export static functions
	ibm_newemac: Fix new MAL feature handling
	staging: sxg depends on X86

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

We are up to 120 trees (counting Linus' and 14 trees of patches pending for
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
$ git cherry-pick c917a47312d1dcfadbb8d558fab121d4d6467d10
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
CONFLICT (content): Merge conflict in Documentation/sysctl/kernel.txt
Merging quilt/usb.current
CONFLICT (content): Merge conflict in drivers/usb/misc/Makefile
CONFLICT (content): Merge conflict in drivers/usb/serial/option.c
CONFLICT (content): Merge conflict in include/linux/usb/Kbuild
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
CONFLICT (rename/delete): Renamed include/asm-parisc/a.out.h->arch/parisc/i=
nclude/asm/a.out.h in parisc/master and deleted in HEAD
$ git rm -f arch/parisc/include/asm/a.out.h
Merging powerpc/next
Merging 4xx/next
Merging galak/powerpc-next
Merging pxa/for-next
Merging s390/features
Merging sh/master
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in arch/sh/include/asm/elf.h
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/misc/Kconfig
Applying USB: unbreak recursive dependancy
Created commit d6cb159: Revert "USB: remove info() macro from usb.h"
Created commit 1fa79d8: Revert "USB: remove warn() macro from usb.h"
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in include/asm-x86/smp.h
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/module.c
CONFLICT (add/add): Merge conflict in scripts/bootgraph.pl
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in kernel/fork.c
Merging timers/auto-timers-next
CONFLICT (content): Merge conflict in arch/x86/kvm/i8254.c
Applying DECLARE_PER_CPU needs linux/percpu.h
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/pcie/aspm.c
CONFLICT (content): Merge conflict in drivers/pci/quirks.c
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/acpi/boot.c
CONFLICT (content): Merge conflict in drivers/acpi/Kconfig
CONFLICT (content): Merge conflict in drivers/acpi/scan.c
CONFLICT (content): Merge conflict in drivers/pnp/Makefile
CONFLICT (content): Merge conflict in drivers/pnp/quirks.c
Applying acpi: merge fix for dpulicate acpi_mcfg_64bit_base_addr
Applying acpi: acpi_os_hotplug_execute needs to be exported
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
Merging mtd/master
Created commit 2c510b5: Revert "[MTD] [NAND] GPIO NAND flash driver"
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Applying vfs: fix up merge of ext4
Applying vfs/xfs: fallout from i_vnode change
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/md/md.c
CONFLICT (content): Merge conflict in kernel/module.c
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
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Created commit c4052e6: Revert "8250-oxsemi-mainpine"
Merging agp/agp-next
Merging creds/next-creds-subsys
CONFLICT (content): Merge conflict in fs/devpts/inode.c
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in include/linux/sched.h
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in kernel/signal.c
CONFLICT (content): Merge conflict in net/9p/client.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
CONFLICT (content): Merge conflict in drivers/md/Kconfig
CONFLICT (content): Merge conflict in include/linux/init.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (add/add): Merge conflict in scripts/bootgraph.pl
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
CONFLICT (content): Merge conflict in Documentation/ABI/testing/sysfs-bus-u=
sb
CONFLICT (content): Merge conflict in drivers/Makefile
Merging watchdog/master
Merging proc/proc
Merging scsi-post-merge/master
Applying sparc: qlogicpti fallout from sbus removal
Applying tpm: don't export static functions
Applying mfd/wm8350: don't export static functions
Applying ibm_newemac: Fix new MAL feature handling
Applying staging: sxg depends on X86

--Signature=_Mon__20_Oct_2008_23_59_04_+1100_HoBPuy/3l4u6AoLP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj8gJgACgkQjjKRsyhoI8y5jgCaA2aqh3Rn+5KtbC+ssom1Lr8b
FDYAmQHPpvX40Wo3cDrvs3JIXrRRSwcq
=8Boj
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Oct_2008_23_59_04_+1100_HoBPuy/3l4u6AoLP--
