Return-Path: <linux-kernel-owner+w=401wt.eu-S1754571AbYH1Id0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571AbYH1Id0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:33:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbYH1IdR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:33:17 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51735 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752830AbYH1IdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:33:14 -0400
Date: Thu, 28 Aug 2008 18:33:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 28
Message-Id: <20080828183307.23c6be82.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Aug_2008_18_33_07_+1000_3uX2eIi5aypxBwZS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Aug_2008_18_33_07_+1000_3uX2eIi5aypxBwZS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080827:

The hid tree lost a conflict.

The net tree gained a conflict against the net-current tree.

The block tree gained 3 conflicts against Linus' tree (2 trivial and
unreported).

The firmware tree gained 2 conflicts against the sound tree.

The creds tree gained a conflict against the net-current tree.

I have also applied the following patches for known problems:

	ftrace: protect the definition of ftrace_release
	revert BUILD_BUG_ON change
	sparseirq: export nr_irqs on m68k/sparc/s390
	VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
	sparc32: Implement smp_call_function_single().
	x86: use x2apic id reported by cpuid during topology discovery, fix

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

We are up to 113 trees (counting Linus' and 14 trees of patches pending for
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
Merging galak/powerpc-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in kernel/module.c
Applying ftrace: remove warning of old objcopy and local functions
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in kernel/fork.c
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in include/asm-x86/cpufeature.h
CONFLICT (content): Merge conflict in include/asm-x86/pda.h
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
CONFLICT (content): Merge conflict in drivers/hid/usbhid/hid-core.c
Applying HID: fix for warn() removal
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/stable
CONFLICT (content): Merge conflict in drivers/media/video/zr364xx.c
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in drivers/misc/acer-wmi.c
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in include/asm-x86/kvm.h
Merging dlm/next
Merging scsi/master
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in net/mac80211/mlme.c
Merging mtd/master
Merging wireless/master
Merging crypto/master
CONFLICT (content): Merge conflict in include/asm-x86/cpufeature.h
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
Applying rr: build fix for remove CONFIG_KMOD from net
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in block/cmd-filter.c
CONFLICT (content): Merge conflict in block/scsi_ioctl.c
CONFLICT (content): Merge conflict in drivers/ide/ide-disk.c
CONFLICT (content): Merge conflict in include/linux/genhd.h
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging embedded/master
Merging firmware/master
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
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/traps_64.c
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/char/tty_io.c
CONFLICT (content): Merge conflict in drivers/char/vt.c
CONFLICT (content): Merge conflict in drivers/net/usb/hso.c
CONFLICT (content): Merge conflict in drivers/usb/serial/aircable.c
CONFLICT (content): Merge conflict in drivers/usb/serial/keyspan_pda.c
CONFLICT (content): Merge conflict in drivers/usb/serial/safe_serial.c
Merging agp/agp-next
Merging creds/next-creds
CONFLICT (content): Merge conflict in drivers/net/wan/sbni.c
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
$ git checkout HEAD drivers/net/wan/sbni.c
Merging oprofile/auto-oprofile-next
CONFLICT (content): Merge conflict in arch/x86/kernel/apic_32.c
Merging fastboot/auto-fastboot-next
CONFLICT (content): Merge conflict in include/linux/init.h
Merging sparseirq/auto-sparseirq-next
CONFLICT (delete/modify): arch/x86/kernel/apic_64.c deleted in sparseirq/au=
to-sparseirq-next and modified in HEAD. Version HEAD of arch/x86/kernel/api=
c_64.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/xen/spinlock.c
CONFLICT (content): Merge conflict in drivers/serial/68328serial.c
CONFLICT (content): Merge conflict in drivers/serial/8250.c
Applying revert BUILD_BUG_ON change
Applying ftrace: protect the definition of ftrace_release
Applying sparseirq: export nr_irqs on m68k/sparc/s390
Applying VIDEO_SH_MOBILE_CEU should depend on HAS_DMA
Applying sparc32: Implement smp_call_function_single().
Applying x86: use x2apic id reported by cpuid during topology discovery, fix

--Signature=_Thu__28_Aug_2008_18_33_07_+1000_3uX2eIi5aypxBwZS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki2YsMACgkQjjKRsyhoI8zlFwCdFHF1UPcQ8YDxmJ4VTR5LyKLf
VgkAn3HM4wlbj9F1LL6EBE/8Lus2VL4A
=l8iz
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Aug_2008_18_33_07_+1000_3uX2eIi5aypxBwZS--
