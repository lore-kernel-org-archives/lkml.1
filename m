Return-Path: <linux-kernel-owner+w=401wt.eu-S1757025AbZFPG7k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757025AbZFPG7k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:59:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751281AbZFPG7b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:59:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45839 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750902AbZFPG73 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:59:29 -0400
Date: Tue, 16 Jun 2009 16:59:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 16
Message-Id: <20090616165923.8ca4ddcb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Jun_2009_16_59_23_+1000_YM3gK/ZSYedt7ot1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jun_2009_16_59_23_+1000_YM3gK/ZSYedt7ot1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090615:

Removed tree: kmemleak (served its purpose)

This tree fails to build for powerpc allyesconfig.

The ext4 tree gained a build failure (after the slab tree was merged) so
I reverted 3 commits.

The ide tree lost its build failure.

The scsi tree lost its build failure.

The net tree lost its conflicts.

The rr tree lost a conflict, but gained another against Linus' tree.

The cifs tree lost its build failure.

The mfd tree lost its conflict.

The tip tree gained a conflict against the slab tree.

The driver-core tree lost 4 conflicts, but gained 2 more against the
powerpc tree.

The usb tree lost its conflicts.

The staging tree lost its conflicts.

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
CONFLICT (content): Merge conflict in include/linux/mmc/sdio_ids.h
Merging quota/for_next
Merging kbuild/master
Merging ide/for-next
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in drivers/platform/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
[master f9af17c] Revert "Merge branch 'oqo-wmi-EXPECT-REFRESH' into test"
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in arch/x86/include/asm/mce.h
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/sh/include/asm/smp.h
CONFLICT (content): Merge conflict in drivers/net/sfc/efx.c
Merging cifs/master
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
[master af5fbd8] Revert "jbd2: convert instrumentation from markers to trac=
epoints"
[master 2ef5ca0] Revert "ext4: Fix 64-bit block type problem on 32-bit plat=
forms"
[master 5d150fb] Revert "ext4: convert instrumentation from markers to trac=
epoints"
Merging uclinux/for-next
Merging md/for-next
CONFLICT (content): Merge conflict in drivers/md/md.c
CONFLICT (content): Merge conflict in drivers/md/raid5.c
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
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slub.c
Merging asm-generic/next
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/block/ps3disk.c
CONFLICT (content): Merge conflict in drivers/block/ps3vram.c
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
Applying: sparc: replace uses of CPU_MASK_ALL_PTR

--Signature=_Tue__16_Jun_2009_16_59_23_+1000_YM3gK/ZSYedt7ot1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko3QssACgkQjjKRsyhoI8z8tQCfTXXVqi9KkqjoGZ1Zmw4Z9Ktz
a/YAniWjogq0VmKV5dCVIqqH1Bp71E3d
=hhOt
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jun_2009_16_59_23_+1000_YM3gK/ZSYedt7ot1--
