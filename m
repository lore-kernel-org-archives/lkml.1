Return-Path: <linux-kernel-owner+w=401wt.eu-S1754782AbYKCHce@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754782AbYKCHce (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 02:32:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752916AbYKCHcZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 02:32:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43749 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbYKCHcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 02:32:23 -0500
Date: Mon, 3 Nov 2008 18:32:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for November 3
Message-Id: <20081103183214.aac32543.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_Nov_2008_18_32_14_+1100_+oXdX/j7_F7k4q/n"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Nov_2008_18_32_14_+1100_+oXdX/j7_F7k4q/n
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081031:

Dropped trees (temporarily):
	v4l-dvb (due to an unfixed build failure)
	semaphore-removal (due to unfixed conflicts against Linus' tree)

Removed tree:
	trivial (Jesper no longer has the time to maintain it)

The USB tree had three commits excluded (2 cause a build failure and the
other is not intended for mainline).

The net tree lost its conflict.

The sound tree lost its conflict.

The slab tree gained 3 conflicts against Linus' tree and the merge needed
fixing.

The creds tree lost 2 conflicts.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	nfsctl: credentials error
	coda: credentials error
	cpu_alloc: per_cpu_offset is already defined for !CONFIG_SMP
	ia64: Fix gru compiler warning
	ps3: ps3-lpm.c compile fix
	cell: fix ras.c compilation

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

We are up to 122 trees (counting Linus' and 14 trees of patches pending for
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
Merging powerpc/powerpc-next
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
$ git reset --hard HEAD^
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
$ git reset --hard HEAD^
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Applying fs: xfs needs inode_wait to be exported
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
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
$ git reset --hard
Merging bkl-removal/bkl-removal
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
CONFLICT (content): Merge conflict in fs/proc/inode.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/vmscan.c
CONFLICT (content): Merge conflict in mm/vmstat.c
Applying slab: xfs mismerge fix
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
CONFLICT (delete/modify): Documentation/DocBook/wanbook.tmpl deleted in hdl=
c/hdlc-next and modified in HEAD. Version HEAD of Documentation/DocBook/wan=
book.tmpl left in tree.
CONFLICT (delete/modify): drivers/net/wan/syncppp.c deleted in hdlc/hdlc-ne=
xt and modified in HEAD. Version HEAD of drivers/net/wan/syncppp.c left in =
tree.
$ git rm -f drivers/net/wan/syncppp.c Documentation/DocBook/wanbook.tmpl
Merging drm/drm-next
Merging voltage/for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging creds/creds-v4
CONFLICT (content): Merge conflict in fs/ext4/balloc.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_cred.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_globals.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.h
CONFLICT (content): Merge conflict in security/selinux/hooks.c
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
Merging userns/next
Merging scsi-post-merge/master
Applying sparc: qlogicpti fallout from sbus removal
Applying nfsctl: credentials error
Applying coda: credentials error
Applying cpu_alloc: per_cpu_offset is already defined for !CONFIG_SMP
Applying ia64: Fix gru compiler warning
Applying ps3: ps3-lpm.c compile fix
Applying cell: fix ras.c compilation

--Signature=_Mon__3_Nov_2008_18_32_14_+1100_+oXdX/j7_F7k4q/n
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkOqP4ACgkQjjKRsyhoI8xDYgCeINF4zBx9aaUMbKu9VIrnJoPM
+SYAnjmDaQUg+Jvp9TsNWKDhyC8yUBUO
=fIA8
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Nov_2008_18_32_14_+1100_+oXdX/j7_F7k4q/n--
