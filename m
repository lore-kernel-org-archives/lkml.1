Return-Path: <linux-kernel-owner+w=401wt.eu-S1751875AbYHKGrM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751875AbYHKGrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2008 02:47:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751087AbYHKGq5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Aug 2008 02:46:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbYHKGqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2008 02:46:55 -0400
Date: Mon, 11 Aug 2008 16:46:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for August 11
Message-Id: <20080811164617.7b06df12.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__11_Aug_2008_16_46_17_+1000_712/AAyrf1O7CqYQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__11_Aug_2008_16_46_17_+1000_712/AAyrf1O7CqYQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080808:

Restored tree: avr32

The avr32 tree lost all its conflicts.

The kvm tree lost its conflict.

The creds tree lost its 2 conflicts against the cifs tree and its build
fix patch.

I have also applied the following patches for known problems:

	Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target
	xen-balloon: fix up sysfs issues
	ath9k: work around gcc ICE again

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

We are up to 108 trees (counting Linus' and 14 trees of patches pending for
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
HEAD is now at 685d87f Revert "pcm_native.c: remove unused label"
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
CONFLICT (content): Merge conflict in drivers/usb/gadget/omap_udc.c
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging dwmw2/master
Merging quilt/driver-core
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
Applying x86: export is_uv_system
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
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
CONFLICT (content): Merge conflict in include/asm-x86/cpufeature.h
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
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/reg-for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
CONFLICT (delete/modify): drivers/char/viocons.c deleted in HEAD and modifi=
ed in quilt/ttydev. Version quilt/ttydev of drivers/char/viocons.c left in =
tree.
$ git rm drivers/char/viocons.c
Merging agp/agp-next
Merging creds/next-creds
CONFLICT (content): Merge conflict in fs/xfs/xfs_acl.c
Applying Add cuImage.mpc866ads to the bootwrapper as a cuboot-8xx target
Applying xen-balloon: fix up sysfs issues
Applying ath9k: work around gcc ICE again

--Signature=_Mon__11_Aug_2008_16_46_17_+1000_712/AAyrf1O7CqYQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkif4DkACgkQjjKRsyhoI8yvJwCeNkAj+EO78mO5P+V37m2DzJjQ
bngAn1lsVQXn5rW87GMaPI9DcFCYiKK6
=xnG4
-----END PGP SIGNATURE-----

--Signature=_Mon__11_Aug_2008_16_46_17_+1000_712/AAyrf1O7CqYQ--
