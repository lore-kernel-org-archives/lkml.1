Return-Path: <linux-kernel-owner+w=401wt.eu-S1753225AbYKYKiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225AbYKYKiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 05:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752523AbYKYKh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 05:37:56 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44338 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520AbYKYKhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 05:37:55 -0500
Date: Tue, 25 Nov 2008 21:37:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for November 25
Message-Id: <20081125213738.881b425e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Nov_2008_21_37_38_+1100_TvSMLK4nkG5RqIM+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Nov_2008_21_37_38_+1100_TvSMLK4nkG5RqIM+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081124:

Undropped trees:
	net
	userns

Dropped trees (temporarily):
	ftrace (build problems)
	v4l-dvb (build problem)
	kbuild (build problem)
	rr (build problem)
	ttydev (build problem)
	semaphore-removal (due to unfixed conflicts against Linus' tree)
	cpu_alloc (build problem)

The 4xx tree gained a conflict against the powerpc-merge tree.

The ftrace tree lost a conflict, but gained 2 build problems (and lots of
warnings) and was dropped.

The v4l-dvb tree gained a build problem and was dropped.

The kbuild tree gained a build problem and was dropped.

The kvm tree gained a conflict against the x86 tree.

The ocfs2 tree gained a header check problem.

The rr tree gained 2 build problems and was dropped.

The firmware tree gained a conflict against the net tree.

The kmemcheck tree lost a conflict.

The security-testing tree gained a conflict against the nfsd tree.

The cputime tree gained a conflict against the tip-core tree.

The perfmon3 tree gained 2 conflicts against the x86 tree.
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
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 126 trees (counting Linus' and 15 trees of patches pending for
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
Merging md-current/for-2.6.26
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
CONFLICT (content): Merge conflict in arch/powerpc/configs/ppc44x_defconfig
Merging galak/next
Merging pxa/for-next
Merging s390/features
CONFLICT (content): Merge conflict in drivers/char/Makefile
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
$ git reset --hard HEAD^
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
$ git reset --hard HEAD^
Merging jfs/next
Merging kbuild/master
$ git reset --hard HEAD^
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
CONFLICT (content): Merge conflict in arch/x86/kernel/reboot.c
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
Applying ocfs2: temporary includes fix
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Applying net: async_tx merge fix
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/kernel/io_apic.c
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
CONFLICT (content): Merge conflict in kernel/irq/manage.c
CONFLICT (content): Merge conflict in kernel/irq/proc.c
$ git reset --hard HEAD^
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging bkl-removal/bkl-removal
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/net/tg3.c
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
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in fs/ocfs2/namei.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_cred.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_globals.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.h
Merging lblnet/master
Merging agp/agp-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
CONFLICT (content): Merge conflict in fs/proc/base.c
CONFLICT (content): Merge conflict in kernel/exit.c
Merging bdev/master
Merging dwmw2-iommu/master
Merging userns/next
Merging cputime/cputime
CONFLICT (content): Merge conflict in kernel/sched.c
Merging perfmon3/master
CONFLICT (content): Merge conflict in arch/x86/kernel/entry_64.S
CONFLICT (content): Merge conflict in arch/x86/kernel/signal_32.c
Merging osd/linux-next
Merging fatfs/master
Merging quilt/staging
Merging scsi-post-merge/master

--Signature=_Tue__25_Nov_2008_21_37_38_+1100_TvSMLK4nkG5RqIM+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkr1XIACgkQjjKRsyhoI8z1FQCeN25B+OO+zAxyIaubt7jIgcnH
4zEAn24XkB0v1/ycwrfZXYj/C8JAXj6m
=ob4h
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Nov_2008_21_37_38_+1100_TvSMLK4nkG5RqIM+--
