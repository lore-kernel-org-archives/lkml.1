Return-Path: <linux-kernel-owner+w=401wt.eu-S1754411AbZIWHnl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754411AbZIWHnl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 03:43:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754156AbZIWHnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 03:43:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58414 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753786AbZIWHnj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 03:43:39 -0400
Date: Wed, 23 Sep 2009 17:43:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 23
Message-Id: <20090923174335.dc0f3ccf.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Sep_2009_17_43_35_+1000_wCtXT4STR+1Lc7Tb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Sep_2009_17_43_35_+1000_wCtXT4STR+1Lc7Tb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Please do not add code destined for 2.6.33 into linux-next trees until
(at least) 2.6.32-rc1 is out.  This will hopefully give those who have
stuff destined for just after -rc1 a chance.

Changes since 20090918:

Dropped tree: drbd (effectively (by reversion) due to a build problem).

We are seeing conflicts resolved and move from one tree to another as
Linus merges them.

I added the obvious fix for the kmemcheck warning.

The input-current tree lost its build failure.

The ocfs2 tree gained a conflict against Linus tree.

The jdelvare-hwmon gained a conflict against Linus' tree.

The rr tree lost its build failure.

The block tree gained a build failure due to on interaction between the
drbd tree (which has been merged into the block tree) and Linus' tree so
I reverted the drbd tree for today.

The usb tree gained a conflict against Linus' tree.

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
CONFLICT (content): Merge conflict in MAINTAINERS
Merging m68k-current/for-linus
Merging powerpc-merge/merge
Merging sparc-current/master
Merging scsi-rc-fixes/master
Merging net-current/master
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (delete/modify): drivers/staging/cpc-usb/TODO deleted in net-curre=
nt/master and modified in HEAD. Version HEAD of drivers/staging/cpc-usb/TOD=
O left in tree.
CONFLICT (delete/modify): drivers/staging/cpc-usb/cpc-usb_drv.c deleted in =
net-current/master and modified in HEAD. Version HEAD of drivers/staging/cp=
c-usb/cpc-usb_drv.c left in tree.
CONFLICT (delete/modify): drivers/staging/cpc-usb/cpc.h deleted in net-curr=
ent/master and modified in HEAD. Version HEAD of drivers/staging/cpc-usb/cp=
c.h left in tree.
CONFLICT (delete/modify): drivers/staging/cpc-usb/cpc_int.h deleted in net-=
current/master and modified in HEAD. Version HEAD of drivers/staging/cpc-us=
b/cpc_int.h left in tree.
CONFLICT (delete/modify): drivers/staging/cpc-usb/cpcusb.h deleted in net-c=
urrent/master and modified in HEAD. Version HEAD of drivers/staging/cpc-usb=
/cpcusb.h left in tree.
$ git rm -f drivers/staging/cpc-usb/TODO drivers/staging/cpc-usb/cpc-usb_dr=
v.c drivers/staging/cpc-usb/cpc.h drivers/staging/cpc-usb/cpc_int.h drivers=
/staging/cpc-usb/cpcusb.h
Merging sound-current/for-linus
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/tty.current
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-linus
Merging audit-current/for-linus
Merging crypto-current/master
Merging ide-curent/master
Merging dwmw2/master
Merging arm/devel
Merging davinci/for-next
Merging pxa/for-next
Merging thumb-2/thumb-2
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in arch/mips/Kconfig
CONFLICT (add/add): Merge conflict in arch/mips/bcm63xx/Makefile
CONFLICT (add/add): Merge conflict in arch/mips/bcm63xx/boards/board_bcm963=
xx.c
CONFLICT (delete/modify): arch/mips/lemote/lm2e/Makefile deleted in HEAD an=
d modified in mips/mips-for-linux-next. Version mips/mips-for-linux-next of=
 arch/mips/lemote/lm2e/Makefile left in tree.
CONFLICT (delete/modify): arch/mips/lemote/lm2e/pci.c deleted in HEAD and m=
odified in mips/mips-for-linux-next. Version mips/mips-for-linux-next of ar=
ch/mips/lemote/lm2e/pci.c left in tree.
CONFLICT (delete/modify): arch/mips/lemote/lm2e/prom.c deleted in HEAD and =
modified in mips/mips-for-linux-next. Version mips/mips-for-linux-next of a=
rch/mips/lemote/lm2e/prom.c left in tree.
$ git rm -f arch/mips/lemote/lm2e/Makefile arch/mips/lemote/lm2e/pci.c arch=
/mips/lemote/lm2e/prom.c
$ git checkout HEAD arch/mips/Kconfig arch/mips/bcm63xx/Makefile arch/mips/=
bcm63xx/boards/board_bcm963xx.c
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
Applying: kmemcheck: fix build warning
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
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
$ git checkout HEAD fs/nilfs2/super.c
Merging ocfs2/linux-next
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
CONFLICT (content): Merge conflict in drivers/hwmon/coretemp.c
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
CONFLICT (content): Merge conflict in scripts/basic/fixdep.c
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
Merging mmc/next
Merging input/next
Merging lsm/for-next
Merging block/for-next
[master 0bd997b] Revert "Merge branch 'drbd' of git://git.drbd.org/linux-2.=
6-drbd into for-linus"
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
Merging voltage/for-next
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
Merging oprofile/for-next
Merging percpu/for-next
Merging sfi/sfi-test
CONFLICT (content): Merge conflict in MAINTAINERS
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/x86/kernel/early_printk.c
Merging quilt/staging
Merging scsi-post-merge/master
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/scsi/Makefile
CONFLICT (add/add): Merge conflict in drivers/scsi/pmcraid.c
CONFLICT (content): Merge conflict in kernel/sysctl.c

--Signature=_Wed__23_Sep_2009_17_43_35_+1000_wCtXT4STR+1Lc7Tb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq50acACgkQjjKRsyhoI8wKlwCgugz7RL4UisUztmnSnYBatkwB
zzQAn2QhRyTo3J+gu+HT0SCa7Y6bJ2xZ
=fD20
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Sep_2009_17_43_35_+1000_wCtXT4STR+1Lc7Tb--
