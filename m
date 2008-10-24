Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbYJXGTy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbYJXGTy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 02:19:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751066AbYJXGTo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 02:19:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44969 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695AbYJXGTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 02:19:43 -0400
Date: Fri, 24 Oct 2008 17:19:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 24
Message-Id: <20081024171932.1e8131d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__24_Oct_2008_17_19_32_+1100_yXDW7Nyh3GnB=LP1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__24_Oct_2008_17_19_32_+1100_yXDW7Nyh3GnB=LP1
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

Changes since 20081023:

Dropped trees:
	v4l-dvb (the tree is a mess)

Trees undropped:
	proc

The acpi tree lost its conflicts and build fix patches.

The vfs tree lost its build fix patches.

The rr tree gained a conflict against Linus' tree but lost one of its
build fix patches.

The leds tree lost its build fix patch.

The creds tree lost most of its conflicts.

The oprofile tree lost a conflict.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	Work around ld bug in older binutils (powerpc patch)
	ftrace: rename FTRACE to FUNCTION_TRACER more successfully. (sh patch)
	linux-next: rr tree build warning
	build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
	nfsctl: credentials error
	coda: credentials error

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
Merging galak/powerpc-next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Created commit b36580a: Revert "USB: remove info() macro from usb.h"
Created commit 82717d9: Revert "USB: remove warn() macro from usb.h"
Merging tip-core/auto-core-next
CONFLICT (rename/modify): Merge conflict in arch/um/include/asm/system.h
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/pda.h
Merging timers/auto-timers-next
Merging pci/linux-next
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
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/dcache.c
CONFLICT (content): Merge conflict in fs/ext4/namei.c
CONFLICT (content): Merge conflict in fs/fat/inode.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
CONFLICT (content): Merge conflict in fs/gfs2/ops_export.c
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfs/getroot.c
CONFLICT (content): Merge conflict in fs/ocfs2/export.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_export.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in include/linux/namei.h
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (rename/modify): Merge conflict in arch/x86/include/asm/ipi.h
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in kernel/params.c
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/smp.c
Applying x86: cpumask change fallout
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
CONFLICT (content): Merge conflict in drivers/serial/8250_pci.c
Applying hvc_console: fallout from tty_do_resize change
Merging agp/agp-next
Merging creds/creds-v3
CONFLICT (content): Merge conflict in fs/devpts/inode.c
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
Merging oprofile/auto-oprofile-next
CONFLICT (content): Merge conflict in drivers/oprofile/event_buffer.h
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
Merging scsi-post-merge/master
Applying sparc: qlogicpti fallout from sbus removal
Applying Work around ld bug in older binutils
Applying ftrace: rename FTRACE to FUNCTION_TRACER more successfully.
Applying linux-next: rr tree build warning
Applying build failure at x86/kernel/pci-dma.c with !CONFIG_PCI
Applying nfsctl: credentials error
Applying coda: credentials error

--Signature=_Fri__24_Oct_2008_17_19_32_+1100_yXDW7Nyh3GnB=LP1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkBaPQACgkQjjKRsyhoI8yn5ACcCsl8pRAfPKPduby87LO0iZQB
dsIAnjwaNfy5NHfkwDgPwU7DLsrdxC9L
=QC54
-----END PGP SIGNATURE-----

--Signature=_Fri__24_Oct_2008_17_19_32_+1100_yXDW7Nyh3GnB=LP1--
