Return-Path: <linux-kernel-owner+w=401wt.eu-S1753268AbYL2QQz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753268AbYL2QQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 11:16:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbYL2QQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 11:16:39 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39478 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYL2QQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 11:16:36 -0500
Date: Tue, 30 Dec 2008 03:16:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 29
Message-Id: <20081230031621.60acd90b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Dec_2008_03_16_21_+1100_8wnKVbDV7H2y7Y0/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Dec_2008_03_16_21_+1100_8wnKVbDV7H2y7Y0/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081219:

Undropped tree:
	scci
	mtd

Dropped trees (temporarily):
	nfs (akpm request due to 2.6.30 features)
	kvm (build problem)
	rr (build poblem)
	semaphore-removal (due to unfixed conflicts against Linus' tree)
	cpu_alloc (build problem)
	audit (difficult conflicts)

Linus' tree had three build failures requiring patches and one requiring
a revert.

The timers tree gained a conflict against the cpus4096 tree and a build
failure requiring a merge fixup.

The nfs tree was dropped at Andrew Morton's request.

The kvm tree gained a conflict against the powerpc tree and a build
failure is still present so it was dropped.

The net tree lost all its conflicts.

The rr_cpumask tree gained a build failure that required a commit to be
reverted.

The rr tree lost a conflict, but gained a conflict against each of the
cpus4096 tree and Linus' tree and a build failure so it was dropped.

The cifs tree lost its conflicts.

The security-testing tree lost its conflicts.

The iommu tree gained 2 conflicts against Linus' tree.

The uwb tree gained a conflict against each of the usb tree and Linus'
tree.

The boot-params tree gained a conflict against each of Linus' tree, the
usb tree and the sparseirq tree.

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
http://www.canb.auug.org.au/~sfr/

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
Merging dwmw2/master
Applying: cifs: update for new IP4/6 address printing
Applying: net: ehea NAPI interface cleanup fix
Applying: net: ibmveth NAPI interface cleanup fix
Created commit e47e584: Revert "RDMA/addr: Add support for translating IPv6=
 addresses"
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
CONFLICT (content): Merge conflict in drivers/char/Makefile
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
CONFLICT (delete/modify): arch/sparc64/kernel/idprom.c deleted in sparc/mas=
ter and modified in HEAD. Version HEAD of arch/sparc64/kernel/idprom.c left=
 in tree.
$ git rm -f arch/sparc64/kernel/idprom.c
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/powerpc/platforms/85xx/mpc85xx_m=
ds.c
Merging quilt/usb
CONFLICT (content): Merge conflict in Documentation/DocBook/networking.tmpl
CONFLICT (content): Merge conflict in Documentation/DocBook/networking.tmpl
mark the corrected paths with 'git add <paths>' or 'git rm <paths>' and com=
mit the result.
Created commit dd1bc42: Revert "wimax: Makefile, Kconfig and docbook linkag=
e for the stack"
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in include/linux/hardirq.h
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
CONFLICT (content): Merge conflict in kernel/time/tick-sched.c
CONFLICT (content): Merge conflict in sound/drivers/pcsp/pcsp.c
Applying: sound: fixup for timers tree interaction
Merging pci/linux-next
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm.c
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging xfs/master
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_cred.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_globals.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.h
Merging infiniband/for-next
Merging acpi/test
Merging nfsd/nfsd-next
CONFLICT (content): Merge conflict in fs/lockd/host.c
CONFLICT (content): Merge conflict in fs/lockd/mon.c
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in arch/powerpc/kvm/powerpc.c
CONFLICT (content): Merge conflict in arch/x86/kernel/reboot.c
$ git reset --hard HEAD^
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
CONFLICT (content): Merge conflict in fs/ocfs2/namei.c
Merging ext4/next
Merging async_tx/next
Applying: net: async_tx merge fix
Merging udf/for_next
Merging net/master
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/corgi.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/poodle.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/spitz.c
CONFLICT (content): Merge conflict in drivers/mtd/devices/m25p80.c
CONFLICT (content): Merge conflict in drivers/mtd/devices/mtd_dataflash.c
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging rr_cpumask/master
CONFLICT (content): Merge conflict in kernel/sched.c
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/virtio/virtio_pci.c
CONFLICT (content): Merge conflict in kernel/rcuclassic.c
CONFLICT (content): Merge conflict in kernel/workqueue.c
$ git reset --hard HEAD^
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging bkl-removal/bkl-removal
CONFLICT (content): Merge conflict in fs/ioctl.c
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/bio.c
Merging embedded/master
Merging firmware/master
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
CONFLICT (content): Merge conflict in arch/x86/mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
Merging quilt/ttydev
CONFLICT (content): Merge conflict in fs/devpts/inode.c
Merging agp/agp-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
CONFLICT (content): Merge conflict in arch/x86/kernel/Makefile
CONFLICT (content): Merge conflict in arch/x86/mm/init_32.c
Merging uwb/for-upstream
CONFLICT (content): Merge conflict in drivers/usb/wusbcore/rh.c
CONFLICT (content): Merge conflict in drivers/uwb/wlp/eda.c
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
CONFLICT (content): Merge conflict in kernel/sched.c
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
CONFLICT (content): Merge conflict in Documentation/sysctl/vm.txt
CONFLICT (content): Merge conflict in kernel/fork.c
Merging boot-params/master
CONFLICT (content): Merge conflict in arch/arm/kernel/setup.c
CONFLICT (content): Merge conflict in arch/parisc/kernel/setup.c
CONFLICT (content): Merge conflict in arch/sh/boards/mach-microdev/setup.c
CONFLICT (content): Merge conflict in arch/sh/boards/mach-migor/setup.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/common.c
CONFLICT (content): Merge conflict in drivers/usb/core/usb.c
CONFLICT (content): Merge conflict in init/main.c
Merging trivial/for-next
Merging quilt/staging
CONFLICT (delete/modify): drivers/staging/winbond/linux/wbusb.c deleted in =
quilt/staging and modified in HEAD. Version HEAD of drivers/staging/winbond=
/linux/wbusb.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211netdev.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211wext.c
$ git rm -f drivers/staging/winbond/linux/wbusb.c
Merging scsi-post-merge/master
Applying: driver core: fix root_device_register for not CONFIG_MODULES
Created commit 257d8bc: Revert "cpumask: add sysfs displays for configured =
and disabled cpu maps"

--Signature=_Tue__30_Dec_2008_03_16_21_+1100_8wnKVbDV7H2y7Y0/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklY99UACgkQjjKRsyhoI8yTzACgg+U9tO5o3C1I5ZQZs9iqmwVP
eiUAn2GgEvgAWHRe8DSI3XjSM0okeq4p
=xQUV
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Dec_2008_03_16_21_+1100_8wnKVbDV7H2y7Y0/--
