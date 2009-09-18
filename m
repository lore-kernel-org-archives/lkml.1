Return-Path: <linux-kernel-owner+w=401wt.eu-S1755685AbZIRGkk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755685AbZIRGkk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 02:40:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751530AbZIRGkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 02:40:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47111 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbZIRGki (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 02:40:38 -0400
Date: Fri, 18 Sep 2009 16:40:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 18
Message-Id: <20090918164031.8ea35164.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__18_Sep_2009_16_40_31_+1000_nBqPfYDdYg5qlc5h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__18_Sep_2009_16_40_31_+1000_nBqPfYDdYg5qlc5h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add code destined for 2.6.33 into linux-next trees until
(at least) 2.6.32-rc1 is out.  This will hopefully give those who have
stuff destined for just after -rc1 a chance.

Changes since 20090917:

We are seeing conflicts move from one tree to another as Linus merges
them.

The input-current tree still has a build failure so I used the version from
next-20090916.

The blackfin tree lost its conflict.

The ext4 tree lost its conflict.

The nfsd tree lost its build failure.

The xfs tree lost its conflict.

The i2c tree lost its conflict.

The rr tree still has a build failure so I used the version from
next-20090908.

----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
(patches at http://www.kernel.org/pub/linux/kernel/v2.6/next/ ).  If you
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
CONFIG_PROFILE_ALL_BRANCHES - this fails its final link) and i386, sparc
and sparc64 defconfig. These builds also have
CONFIG_ENABLE_WARN_DEPRECATED, CONFIG_ENABLE_MUST_CHECK and
CONFIG_DEBUG_INFO disabled when necessary.

Below is a summary of the state of the merge.

We are up to 140 trees (counting Linus' and 21 trees of patches pending for
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
Merging quilt/tty.current
CONFLICT (content): Merge conflict in drivers/serial/serial_cs.c
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
$ git reset --hard HEAD^
Merging refs/next/20090916/input-current
Merging arm/devel
Merging davinci/for-next
Merging pxa/for-next
Merging thumb-2/thumb-2
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
CONFLICT (content): Merge conflict in arch/ia64/kernel/vmlinux.lds.S
Merging m68k/for-next
Merging m68knommu/for-next
CONFLICT (content): Merge conflict in arch/m68k/include/asm/processor.h
Merging microblaze/next
Merging mips/mips-for-linux-next
Merging parisc/next
CONFLICT (content): Merge conflict in arch/parisc/include/asm/thread_info.h
CONFLICT (content): Merge conflict in arch/parisc/kernel/entry.S
CONFLICT (content): Merge conflict in arch/parisc/kernel/signal.c
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
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
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
CONFLICT (content): Merge conflict in fs/ubifs/super.c
Merging xfs/master
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in drivers/media/video/sh_mobile_ceu_cam=
era.c
Merging quota/for_next
Merging kbuild/master
CONFLICT (content): Merge conflict in scripts/extract-ikconfig
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/acpi/power.c
CONFLICT (content): Merge conflict in drivers/pci/dmar.c
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/module.c
$ git reset --hard HEAD^
Merging refs/next/20090908/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Merging mmc/next
Merging input/next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/fs-writeback.c
CONFLICT (content): Merge conflict in mm/page-writeback.c
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
CONFLICT (content): Merge conflict in drivers/power/wm97xx_battery.c
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in firmware/Makefile
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/regulator/Kconfig
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
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
Merging fsnotify/for-next
Merging irda/for-next
Merging hwlat/for-linus
Merging drbd/drbd
Merging kmemleak/kmemleak
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
Applying: tip: fix merge for cupmask update
Merging oprofile/for-next
Merging percpu/for-next
Merging sfi/sfi-test
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
CONFLICT (content): Merge conflict in init/main.c
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
CONFLICT (content): Merge conflict in drivers/scsi/Makefile
CONFLICT (add/add): Merge conflict in drivers/scsi/pmcraid.c
CONFLICT (content): Merge conflict in kernel/sysctl.c

--Signature=_Fri__18_Sep_2009_16_40_31_+1000_nBqPfYDdYg5qlc5h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqzK18ACgkQjjKRsyhoI8wbjgCgnOCa5OLcaQbyB60rrnuQhxXC
vOoAmwRn4e86zCJljuGj+vaCPQRolpyY
=RV/M
-----END PGP SIGNATURE-----

--Signature=_Fri__18_Sep_2009_16_40_31_+1000_nBqPfYDdYg5qlc5h--
