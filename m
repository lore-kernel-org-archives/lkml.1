Return-Path: <linux-kernel-owner+w=401wt.eu-S934661AbZLPHcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934661AbZLPHcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 02:32:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934648AbZLPHcV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 02:32:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48607 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934635AbZLPHcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 02:32:18 -0500
Date: Wed, 16 Dec 2009 18:32:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 16
Message-Id: <20091216183212.118c5e14.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_18_32_12_+1100_uZSY3K2GB2yZ3kV3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_18_32_12_+1100_uZSY3K2GB2yZ3kV3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

My usual call for calm: please do not put stuff destined for 2.6.34 into
linux-next trees until after 2.6.33-rc1.

Changes since 20091215:

The origin tree lost its build failure.

The avr32 tree lost its conflict.

The microblaze tree lost its conflict.

The mips tree lost 4 of its conflicts.

The acpi tree still has its build failure so I used the version from
next-20091211.  It also gained a conflict against Linus' tree.

The voltage tree lost its conflicts but gained a build failure that
required the revert of 5 commits.

The hwpoison tree gained a conflict against Linus' tree.

The hwpoison tree gained a build failure for which I applied a merge
fixup patch.

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

We are up to 155 trees (counting Linus' and 22 trees of patches pending
for Linus' tree), more are welcome (even if they are currently empty).
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
Merging kbuild-current/for-linus
Merging quilt/driver-core.current
Merging quilt/tty.current
Merging quilt/usb.current
Merging quilt/staging.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging arm/devel
Merging davinci/davinci-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
CONFLICT (content): Merge conflict in arch/m68k/include/asm/ptrace.h
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in drivers/pcmcia/Makefile
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
CONFLICT (content): Merge conflict in arch/powerpc/mm/fsl_booke_mmu.c
Merging galak/next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging ceph/for-next
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
Merging ext4/next
Merging fatfs/master
Merging fuse/for-next
Merging gfs2/master
Merging jfs/next
Merging logfs/master
Merging nfs/linux-next
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
CONFLICT (add/add): Merge conflict in fs/9p/cache.c
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/platform/x86/eeepc-laptop.c
CONFLICT (content): Merge conflict in include/acpi/processor.h
$ git reset --hard HEAD^
Merging refs/next/20091211/acpi
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/platform/x86/eeepc-laptop.c
CONFLICT (content): Merge conflict in include/acpi/processor.h
Merging ieee1394/for-next
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv-13=
94.c
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv-av=
c.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/firewire/firedtv-fw=
.c
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv.h
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/devices/m25p80.c
CONFLICT (content): Merge conflict in drivers/mtd/maps/pcmciamtd.c
CONFLICT (delete/modify): drivers/mtd/nand/excite_nandflash.c deleted in HE=
AD and modified in mtd/master. Version mtd/master of drivers/mtd/nand/excit=
e_nandflash.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/nand/pxa3xx_nand.c
CONFLICT (content): Merge conflict in kernel/printk.c
$ git rm -f drivers/mtd/nand/excite_nandflash.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Applying: modpost: autoconf.h has moved to include/generated
Applying: rr: cpufreq: fix up for api name change
Merging mmc/next
Merging tmio-mmc/linux-next
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
CONFLICT (content): Merge conflict in drivers/platform/x86/thinkpad_acpi.c
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_fb_helper.c
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging agp/agp-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
CONFLICT (content): Merge conflict in fs/afs/write.c
CONFLICT (content): Merge conflict in fs/cifs/dir.c
CONFLICT (content): Merge conflict in fs/ubifs/file.c
CONFLICT (content): Merge conflict in include/asm-generic/fcntl.h
CONFLICT (content): Merge conflict in include/net/compat.h
CONFLICT (content): Merge conflict in net/compat.c
CONFLICT (content): Merge conflict in net/socket.c
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging drbd/for-jens
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging limits/writable_limits
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
Merging omap_dss2/for-next
Merging tip/auto-latest
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in mm/memcontrol.c
Applying: hwpoison: fix for migrate_pages API change
Merging sysctl/master
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
[master 2bbac8a] Revert "twl4030-regulator: Fixes VAUX1-3 exclusion introdu=
ced"
[master 7b9fa19] Revert "Reset REMAP configuration in regulator probe"
[master e9fcc36] Revert "Define critical regulators as always_on"
[master 572df07] Revert "twl4030-regulator: Add all TWL regulators to twreg=
_info"
[master e890b10] Revert "twl4030-regulator: Remove regulator from all group=
s when disabling"

--Signature=_Wed__16_Dec_2009_18_32_12_+1100_uZSY3K2GB2yZ3kV3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksojPwACgkQjjKRsyhoI8xJUwCdEpuueJt5afG5STEcxAUY8sfh
CS4AoKQOAYaDcJU0/PYjAQRVb8IJs59k
=qwdU
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_18_32_12_+1100_uZSY3K2GB2yZ3kV3--
