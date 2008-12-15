Return-Path: <linux-kernel-owner+w=401wt.eu-S1753704AbYLOPHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbYLOPHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 10:07:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753922AbYLOPG5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 10:06:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52198 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbYLOPGz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 10:06:55 -0500
Date: Tue, 16 Dec 2008 02:06:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 15
Message-Id: <20081216020642.fc1007d9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Dec_2008_02_06_42_+1100_GlK9rxg1iI3r0ph7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Dec_2008_02_06_42_+1100_GlK9rxg1iI3r0ph7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20081212:

New tree:
	boot-params

Undropped tree:
	mtd
	staging

Dropped trees (temporarily):
	v4l-dvb (build problem)
	rr (difficult conflicts)
	semaphore-removal (due to unfixed conflicts against Linus' tree)
	cpu_alloc (build problem)
	perfmon3 (concerns from the x86 team)
	audit (difficult conflicts)
	nommu (build problem)
	boot-params (build problem)

The ftrace tree lost a conflict.

The device-mapper tree gained a conflict against the ftrace tree.

The net tree gained a conflict against the net-current tree.

The sound tree gained a conflict against the times tree and needed a
fixup patch for an interaction withe the timers tree.

The rr_cpumask tree gained a conflict against the sparseirq tree and 2
conflicts against the cpus4096 tree.

Th rr tree gained several difficult conflicts and was dropped.

The block tree gained a conflict against the ftrace tree.

The boot-params tree gained a conflict against each of the sparseirq,
parisc, arm and sh trees and gained a build problem, so was dropped.

I also applied "Define smp_call_function_many for UP" from Rusty Russell
and reverted 2 commits from the scsi tree due to build problems.

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

We are up to 133 trees (counting Linus' and 15 trees of patches pending for
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
HEAD is now at 6c34bc2 Revert "radeonfb: accelerate imageblit and other imp=
rovements"
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
Merging audit-current/for-linus
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
CONFLICT (content): Merge conflict in drivers/char/Makefile
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/powerpc/platforms/85xx/mpc85xx_m=
ds.c
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/pci-driver.c
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm.c
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
CONFLICT (content): Merge conflict in fs/xfs/xfs_rename.c
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
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (delete/modify): arch/sparc64/kernel/idprom.c deleted in HEAD and =
modified in net/master. Version net/master of arch/sparc64/kernel/idprom.c =
left in tree.
CONFLICT (content): Merge conflict in drivers/net/e1000e/ich8lan.c
CONFLICT (content): Merge conflict in fs/lockd/host.c
CONFLICT (content): Merge conflict in fs/lockd/mon.c
$ git rm -f arch/sparc64/kernel/idprom.c
Applying: net: async_tx merge fix
Merging mtd/master
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/corgi.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/poodle.c
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/spitz.c
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
CONFLICT (content): Merge conflict in sound/drivers/pcsp/pcsp.c
Applying: sound: fixup for timers tree interaction
Merging cpufreq/next
Merging v9fs/for-next
Merging rr_cpumask/master
CONFLICT (content): Merge conflict in arch/x86/kernel/io_apic.c
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/sched_stats.h
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/kernel/io_apic.c
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
CONFLICT (content): Merge conflict in include/linux/cpumask.h
CONFLICT (content): Merge conflict in kernel/cpu.c
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in kernel/sched_stats.h
$ git reset --hard
Merging cifs/master
CONFLICT (content): Merge conflict in fs/cifs/connect.c
Applying: cifs: update for new IP4/6 address printing
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
CONFLICT (content): Merge conflict in drivers/char/tty_audit.c
CONFLICT (content): Merge conflict in fs/cifs/cifs_fs_sb.h
CONFLICT (content): Merge conflict in fs/ocfs2/namei.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_cred.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_globals.h
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.h
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
Merging uwb/for-upstream
Merging watchdog/master
CONFLICT (content): Merge conflict in drivers/watchdog/iTCO_wdt.c
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
CONFLICT (content): Merge conflict in kernel/sched.c
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging trivial/for-next
Merging audit/for-next
CONFLICT (content): Merge conflict in include/linux/audit.h
CONFLICT (content): Merge conflict in kernel/auditsc.c
CONFLICT (content): Merge conflict in kernel/capability.c
CONFLICT (content): Merge conflict in security/commoncap.c
$ git reset --hard
Merging quilt/staging
CONFLICT (delete/modify): drivers/staging/winbond/linux/wbusb.c deleted in =
quilt/staging and modified in HEAD. Version HEAD of drivers/staging/winbond=
/linux/wbusb.c left in tree.
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211netdev.c
CONFLICT (content): Merge conflict in drivers/staging/wlan-ng/p80211wext.c
$ git rm -f drivers/staging/winbond/linux/wbusb.c
Merging scsi-post-merge/master
Merging boot-params/master
CONFLICT (content): Merge conflict in arch/arm/kernel/setup.c
CONFLICT (content): Merge conflict in arch/parisc/kernel/setup.c
CONFLICT (content): Merge conflict in arch/sh/boards/mach-migor/setup.c
CONFLICT (content): Merge conflict in init/main.c
$ git reset --hard HEAD^
Applying: Define smp_call_function_many for UP
Created commit 65f3ebc: Revert "[SCSI] fcoe: Fibre Channel over Ethernet"
Created commit 15c07d6: Revert "[SCSI] libfc: A modular Fibre Channel libra=
ry"

--Signature=_Tue__16_Dec_2008_02_06_42_+1100_GlK9rxg1iI3r0ph7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklGcoIACgkQjjKRsyhoI8y1JACfRJeJU7xlpYff/ZavLe3z1CZx
NnkAnjcigNxfj3dlulHkuNGOZf+BBFxY
=thwd
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Dec_2008_02_06_42_+1100_GlK9rxg1iI3r0ph7--
