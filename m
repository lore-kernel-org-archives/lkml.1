Return-Path: <linux-kernel-owner+w=401wt.eu-S1759321AbZAHGSj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759321AbZAHGSj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 01:18:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbZAHGRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 01:17:49 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51065 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932AbZAHGRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 01:17:47 -0500
Date: Thu, 8 Jan 2009 17:17:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for January 8
Message-Id: <20090108171730.19a41e14.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Jan_2009_17_17_30_+1100_y/PXKrL/j4meL6cx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Jan_2009_17_17_30_+1100_y/PXKrL/j4meL6cx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090107:

Undropped tree:
	rr

Dropped trees (temporarily):
	ocfs2 (build problem)
	cpu_alloc (build problem)
	audit (difficult conflicts)

The ftrace tree lost its build failure.

The ocfs2 tree gained a build failure and was dropped.

The async_tx tree lost it build failure.

The rr tree lost its build failure.

The security-testing tree lost its conflict.

The ttydev tree lost its conflict.

The nommu tree gained a conflict against Linus' tree.

The final tree had a build failure for the sparc64 build - I
cherry-picked the fix from Linus' tree.

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

We are up to 129 trees (counting Linus' and 15 trees of patches pending for
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
CONFLICT (content): Merge conflict in kernel/auditsc.c
Merging dwmw2/master
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
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in kernel/rcuclassic.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
CONFLICT (content): Merge conflict in kernel/time/tick-common.c
Merging pci/linux-next
Merging quilt/device-mapper
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
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
CONFLICT (content): Merge conflict in drivers/scsi/scsi_ioctl.c
Merging ocfs2/linux-next
$ git reset --hard HEAD^
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/devices/m25p80.c
CONFLICT (content): Merge conflict in drivers/mtd/devices/mtd_dataflash.c
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in init/main.c
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging bkl-removal/bkl-removal
CONFLICT (content): Merge conflict in fs/ioctl.c
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/net/starfire.c
CONFLICT (content): Merge conflict in drivers/net/tg3.c
CONFLICT (content): Merge conflict in firmware/Makefile
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
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
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
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
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
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (delete/modify): mm/tiny-shmem.c deleted in HEAD and modified in n=
ommu/master. Version nommu/master of mm/tiny-shmem.c left in tree.
$ git rm -f mm/tiny-shmem.c
Merging trivial/for-next
Merging squashfs/master
Merging quilt/staging
Merging scsi-post-merge/master
$ git cherry-pick b13d3720ecd29d5044334fdbbae3432f26802bae
Created commit 95867e1: topology: Fix sparc64 build.

--Signature=_Thu__8_Jan_2009_17_17_30_+1100_y/PXKrL/j4meL6cx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkllmnoACgkQjjKRsyhoI8xamgCfVWf2a1JapM4CE8k2f2/QvJn/
yl8An0MYbPRyz2z8JfuoFxfdf5b8P27J
=rrd1
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Jan_2009_17_17_30_+1100_y/PXKrL/j4meL6cx--
