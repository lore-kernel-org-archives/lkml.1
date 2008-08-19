Return-Path: <linux-kernel-owner+w=401wt.eu-S1754632AbYHSIzZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754632AbYHSIzZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 04:55:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752416AbYHSIzH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 04:55:07 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36550 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbYHSIzE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 04:55:04 -0400
Date: Tue, 19 Aug 2008 18:54:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 19
Message-Id: <20080819185454.d9c74915.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Aug_2008_18_54_54_+1000_kNKRM.sixKknduuQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Aug_2008_18_54_54_+1000_kNKRM.sixKknduuQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080818:

Linus' tree lost its build fix patch.

The v4l-dvb tree gained a conflict against the usb tree.

The vfs tree gained a conflict against eahc of Linus' tree and the ia64
tree.=20

The arm tree gained a build fix patch.

The input tree gained a build fix patch due to a conflict with the usb
tree.

The ttydev tree lost 3 conflicts but gained another against the usb tree.

I have also applied the following patches for known problems:

	Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target

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

We are up to 110 trees (counting Linus' and 14 trees of patches pending for
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
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in kernel/module.c
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in kernel/fork.c
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in include/asm-x86/pda.h
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
CONFLICT (content): Merge conflict in drivers/media/video/zr364xx.c
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in include/asm-x86/kvm.h
Merging dlm/next
Merging scsi/master
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging quilt/m68k
Merging powerpc/powerpc-next
Merging ext4/next
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging sparc/master
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
CONFLICT (content): Merge conflict in include/asm-x86/cpufeature.h
Merging vfs/for-next
CONFLICT (content): Merge conflict in arch/ia64/ia32/sys_ia32.c
CONFLICT (content): Merge conflict in arch/powerpc/kernel/sys_ppc32.c
CONFLICT (content): Merge conflict in fs/nfsd/export.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_export.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_iops.c
Merging sound/for-next
Merging arm/devel
Applying ucb1400: restore NO_IRQ definition
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Applying input/cm109: fix up for info() removal
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Kconfig
CONFLICT (content): Merge conflict in drivers/media/dvb/ttpci/Makefile
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging m68knommu/for-next
Merging uclinux/for-next
Merging md/for-next
Merging cris/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
Merging generic-ipi/auto-generic-ipi-next
Merging mips/mips-for-linux-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
CONFLICT (content): Merge conflict in drivers/net/usb/hso.c
CONFLICT (content): Merge conflict in drivers/usb/serial/safe_serial.c
Merging agp/agp-next
Merging creds/next-creds
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_linux.h
CONFLICT (content): Merge conflict in fs/xfs/xfs_inode.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_vnodeops.c
CONFLICT (content): Merge conflict in include/linux/capability.h
CONFLICT (add/add): Merge conflict in include/linux/cred.h
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in security/commoncap.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
CONFLICT (content): Merge conflict in security/smack/smack_lsm.c
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
CONFLICT (content): Merge conflict in include/linux/init.h
Applying Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target

--Signature=_Tue__19_Aug_2008_18_54_54_+1000_kNKRM.sixKknduuQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiqil4ACgkQjjKRsyhoI8wlUwCgmKtYkLZ8BGCgsdEBvNMYmXJ/
SsEAoI1NkOyYeAa9bTDh0x8F3SRNDGke
=IpM3
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Aug_2008_18_54_54_+1000_kNKRM.sixKknduuQ--
