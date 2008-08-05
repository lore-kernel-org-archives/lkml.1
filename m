Return-Path: <linux-kernel-owner+w=401wt.eu-S1759122AbYHEH7g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122AbYHEH7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 03:59:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754673AbYHEH70
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 03:59:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754487AbYHEH7X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 03:59:23 -0400
Date: Tue, 5 Aug 2008 17:59:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 5
Message-Id: <20080805175914.7649537f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Aug_2008_17_59_14_+1000_yWq0vufAmWr+KMmQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Aug_2008_17_59_14_+1000_yWq0vufAmWr+KMmQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080804:

New tree: dwmw2

Changed tree: the powerpc tree is back in Paulus' hands.

Temporarily dropped tree: v4l-dvb (got lots of conflicts against the
version that was merged to Linus).

The xfs tree lost a conflict.

The crypto tree gained a build fix patch.

The mfd tree had a commit reverted due to a build failure.

I merged Linus' tree a second time at the end of the tree today since it
contained several fixes for which I have been carrying patches/reverts.

I have also applied the following patches for known problems:

	Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target
	Revert "Input: expand keycode space"
	wireless: prevent ath9k from building on PowerPC (this is
		redundant because of the following reverts).
	Revert "list.h: add list_cut_position()"
	Revert "ath9k: Add new Atheros IEEE 802.11n driver"

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

We are up to 107 trees (counting Linus' and 14 trees of patches pending for
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
Applying usb: two more functions are needed when CONFIG_PM is not set
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging dwmw2/master
Merging quilt/driver-core
Applying driver-core: kobject verification fixup
Merging quilt/usb
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in include/asm-generic/vmlinux.lds.h
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in net/sunrpc/svc.c
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging x86/auto-x86-next
CONFLICT (content): Merge conflict in arch/x86/kernel/genapic_64.c
CONFLICT (content): Merge conflict in drivers/pci/dmar.c
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
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
Merging hwmon/testing
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in include/linux/kvm.h
Merging dlm/next
Merging scsi/master
Merging ia64/test
Merging tests/master
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
Applying crypto: tetsmgr linking fix
Merging vfs/for-next
Merging sound/for-next
Merging arm/devel
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
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
Merging generic-ipi/auto-generic-ipi-next
Merging mips/mips-for-linux-next
Merging mfd/for-next
Created commit c09d8ee: Revert "mfd: driver for the TMIO NAND controller"
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging master_tmp
Applying Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target
Created commit d8f1869: Revert "Input: expand keycode space"
Applying wireless: prevent ath9k from building on PowerPC
Created commit f3df396: Revert "list.h: add list_cut_position()"
Created commit 9c5c7ee: Revert "ath9k: Add new Atheros IEEE 802.11n driver"

--Signature=_Tue__5_Aug_2008_17_59_14_+1000_yWq0vufAmWr+KMmQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiYCFIACgkQjjKRsyhoI8zl4ACgq8jmZ43Cb0RnxB4Qj+PgdE4z
x6QAnA+XwvZxTy5L13LSfssVOArQQtip
=ROlX
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Aug_2008_17_59_14_+1000_yWq0vufAmWr+KMmQ--
