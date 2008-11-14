Return-Path: <linux-kernel-owner+w=401wt.eu-S1753977AbYKNHkn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977AbYKNHkn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 02:40:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750734AbYKNHkd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 02:40:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52892 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbYKNHkb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 02:40:31 -0500
Date: Fri, 14 Nov 2008 18:40:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for November 14
Message-Id: <20081114184021.ed198f4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Nov_2008_18_40_21_+1100__Z8.d3kOrLGghi3P"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Nov_2008_18_40_21_+1100__Z8.d3kOrLGghi3P
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081113:

New tree:
	staging

Removed tree:
	creds (it will now be merged via the security-testing tree)

Undropped tree:
	sh

Dropped trees (temporarily):
	sound (build problem)
	userns (it depends on creds)
	semaphore-removal (due to unfixed conflicts against Linus' tree)
	firmware (unfixed build failure)
	osd (build failure)

The arm tree lost its two conflicts.

The kvm tree lost its conflict.

The sound tree gained a build failure and was dropped.

The rr tree gained a conflict against the net tree.

The osd tree gained a build failure and was dropped.

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

We are up to 125 trees (counting Linus' and 14 trees of patches pending for
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
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
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
$ git reset --hard HEAD^
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
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
Merging voltage/for-next
Merging security-testing/next
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_cred.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_globals.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.h
Merging lblnet/master
Merging quilt/ttydev
CONFLICT (content): Merge conflict in fs/devpts/inode.c
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
Merging cpu_alloc/cpu_alloc
CONFLICT (content): Merge conflict in kernel/lockdep.c
CONFLICT (content): Merge conflict in kernel/module.c
Applying cpu_alloc: merge_fix_1
Merging cputime/cputime
Merging perfmon3/master
Merging osd/linux-next
$ git reset --hard HEAD^
Merging fatfs/master
Merging quilt/staging
Merging scsi-post-merge/master

--Signature=_Fri__14_Nov_2008_18_40_21_+1100__Z8.d3kOrLGghi3P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdK2UACgkQjjKRsyhoI8yQ4wCgg7yAckoew4FbBBj3A4xXXhhY
BdsAnAxKOV8SnvjAo/JB87U/MQrnXDch
=lUZc
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Nov_2008_18_40_21_+1100__Z8.d3kOrLGghi3P--
