Return-Path: <linux-kernel-owner+w=401wt.eu-S1758647AbZJEIEL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758647AbZJEIEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 04:04:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758627AbZJEIEK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 04:04:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33816 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758620AbZJEIEI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 04:04:08 -0400
Date: Mon, 5 Oct 2009 19:03:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 5
Message-Id: <20091005190324.7013a4bb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_19_03_24_+1100_F82y8njTgeFJ_+s6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_19_03_24_+1100_F82y8njTgeFJ_+s6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20091002:

Tree dropped: drbd (build failure)

My fixes tree contains a build fix for powerpc/kvm.

The patch that caused the boot failure has been removed from the scsi
tree.

The sound tree lost its build failure.

The block tree gained a build failure for which I reverted 3 commits (and
dropped the drbd tree).

The device-mapper tree gained a conflict against Linus' tree.

The suspend tree gained a build failure so I used the version from
next-20091002.

The sparc tree gained a build failure for which I applied a patch.

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

We are up to 139 trees (counting Linus' and 21 trees of patches pending for
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
CONFLICT (content): Merge conflict in drivers/rtc/Kconfig
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
Merging xfs/master
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
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
[master f87eae1] Revert "drbd: remove tracing bits"
[master ea7ffd0] Revert "dropping unneeded include autoconf.h"
[master 190d288] Revert "The DRBD driver"
Merging quilt/device-mapper
CONFLICT (content): Merge conflict in drivers/md/dm-log-userspace-transfer.c
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
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
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging omap/for-next
Merging quilt/aoe
Merging suspend/linux-next
$ git reset --hard HEAD^
Merging refs/next/20091002/suspend
Merging bluetooth/master
Merging fsnotify/for-next
Merging irda/for-next
Merging hwlat/for-linus
Merging drbd/for-jens
$ git reset --hard HEAD^
Merging kmemleak/kmemleak
Merging tip/auto-latest
Merging oprofile/for-next
Merging percpu/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
Applying: sparc: using HZ needs an include of linux/param.h

--Signature=_Mon__5_Oct_2009_19_03_24_+1100_F82y8njTgeFJ_+s6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJqEwACgkQjjKRsyhoI8wBjwCfU7yqo1ZsKqdLzUo0vSir22gf
Yc8Ani40BRKgZSbcTTEjdEAZ5OPgY+o1
=+PPX
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_19_03_24_+1100_F82y8njTgeFJ_+s6--
