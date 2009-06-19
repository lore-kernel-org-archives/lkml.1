Return-Path: <linux-kernel-owner+w=401wt.eu-S1759182AbZFSH0r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759182AbZFSH0r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jun 2009 03:26:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758835AbZFSH0d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Jun 2009 03:26:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43321 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758810AbZFSH0a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jun 2009 03:26:30 -0400
Date: Fri, 19 Jun 2009 17:26:22 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 19
Message-Id: <20090619172622.05adb236.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Jun_2009_17_26_22_+1000_nvyZN7KvoUf_o/UM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jun_2009_17_26_22_+1000_nvyZN7KvoUf_o/UM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090618:

My fixes tree contains this one commit:

	kallsyms: fix inverted valid symbol checking (hopefully this will
make arm configs build reliably again).

This tree fails to build for powerpc allyesconfig.

Linus' tree gained a build failure due to a compiler bug.  I have
reverted a commit.

The ext4 tree lost its build failure.

The acpi tree lost its conflicts and build failure.

The slab tree gained a build failure due to a change in Linus' tree.  I
have applied a patch.

The md tree lost its conflicts.

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
final fixups (if any), it is also built with powerpc allnoconfig (32 and
64 bit), ppc44x_defconfig and allyesconfig (minus
CONFIG_PROFILE_ALL_BRANCHES) and i386, sparc and sparc64 defconfig.
These builds also have CONFIG_ENABLE_WARN_DEPRECATED,
CONFIG_ENABLE_MUST_CHECK and CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 128 trees (counting Linus' and 19 trees of patches pending for
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
Merging fixes/fixes
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
Merging crypto-current/master
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (add/add): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-errata.c
CONFLICT (content): Merge conflict in arch/mips/mm/tlbex.c
CONFLICT (content): Merge conflict in arch/mips/sibyte/swarm/setup.c
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in drivers/char/hw_random/Makefile
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging cifs/master
Merging configfs/linux-next
CONFLICT (content): Merge conflict in fs/configfs/dir.c
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging jfs/next
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl-rc6
CONFLICT (content): Merge conflict in fs/reiserfs/super.c
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
Merging ide/for-next
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
$ git reset --hard HEAD^
Merging refs/next/20090617/kvm
CONFLICT (content): Merge conflict in arch/x86/include/asm/mce.h
Applying: kvm/powerpc: make 32 bit constant unsigned long
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/platform/x86/eeepc-laptop.c
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/sh/include/asm/smp.h
CONFLICT (content): Merge conflict in drivers/net/sfc/efx.c
Merging mmc/next
Merging input/next
Merging bkl-removal/bkl-removal
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in mm/Makefile
Applying: slqb: fix for macro name change
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
CONFLICT (content): Merge conflict in drivers/watchdog/Makefile
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in drivers/pci/intr_remapping.c
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging omap/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging edac-amd/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging tip/auto-latest
Merging asm-generic/next
Merging quilt/driver-core
CONFLICT (rename/modify): Merge conflict in drivers/net/wireless/ath/ath5k/=
Kconfig
CONFLICT (content): Merge conflict in drivers/block/ps3disk.c
CONFLICT (content): Merge conflict in drivers/block/ps3vram.c
CONFLICT (content): Merge conflict in drivers/scsi/lpfc/lpfc_debugfs.c
CONFLICT (content): Merge conflict in kernel/trace/trace.c
CONFLICT (content): Merge conflict in scripts/tracing/draw_functrace.py
Merging quilt/usb
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (add/add): Merge conflict in drivers/staging/octeon/Kconfig
Merging scsi-post-merge/master
[master d6355d0] Revert "fbdev: move logo externs to header file"

--Signature=_Fri__19_Jun_2009_17_26_22_+1000_nvyZN7KvoUf_o/UM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko7PZ4ACgkQjjKRsyhoI8we1gCdE1JcVBz/j9PU4aJcbKnsvOJm
ckAAn12/LMGcSXbSwP+tB4FdA8/R8skm
=w69m
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jun_2009_17_26_22_+1000_nvyZN7KvoUf_o/UM--
