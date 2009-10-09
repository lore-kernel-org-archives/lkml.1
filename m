Return-Path: <linux-kernel-owner+w=401wt.eu-S1756821AbZJIIHl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756821AbZJIIHl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 04:07:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755523AbZJIIHk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 04:07:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34887 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755432AbZJIIHh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 04:07:37 -0400
Date: Fri, 9 Oct 2009 19:06:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 9
Message-Id: <20091009190654.741eeffd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__9_Oct_2009_19_06_54_+1100_=bjS1hj_TcI2/CxS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Oct_2009_19_06_54_+1100_=bjS1hj_TcI2/CxS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20091008:

New trees: staging.current
	reiserfs-bkl

My fixes tree contains a build fix for powerpc/kvm.

Linus' tree gained a build failure for which I reverted a commit.

The parisc tree gained a conflict against Linus' tree.

The mfd tree still has a build failure so I used the version from
next-20091005.

The drm tree lost its conflicts.

The suspend tree lost its build failure.

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

We are up to 142 trees (counting Linus' and 22 trees of patches pending for
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
Merging quilt/staging.current
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
CONFLICT (content): Merge conflict in arch/parisc/kernel/ptrace.c
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
Merging reiserfs-bkl/reiserfs/kill-bkl
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
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
$ git reset --hard HEAD^
Merging refs/next/20091005/mfd
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
Merging bluetooth/master
Merging fsnotify/for-next
Merging irda/for-next
Merging hwlat/for-linus
Merging drbd/for-jens
CONFLICT (add/add): Merge conflict in drivers/block/drbd/Kconfig
CONFLICT (add/add): Merge conflict in drivers/block/drbd/Makefile
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_actlog.c
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_int.h
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_main.c
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_nl.c
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_receiver.c
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_req.c
CONFLICT (add/add): Merge conflict in drivers/block/drbd/drbd_worker.c
CONFLICT (add/add): Merge conflict in include/linux/drbd.h
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in lib/Kconfig
Merging tip/auto-latest
CONFLICT (content): Merge conflict in drivers/mtd/maps/gpio-addr-flash.c
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
[master 9b2aec4] Revert "ahci: filter FPDMA non-zero offset enable for Aspi=
re 3810T"

--Signature=_Fri__9_Oct_2009_19_06_54_+1100_=bjS1hj_TcI2/CxS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrO7x4ACgkQjjKRsyhoI8xVuACdF+n4jbCih18p6XhPgnblfWDN
xykAni8rY8xsZzKwj1t5wLGWxg+22vR/
=1Yxh
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Oct_2009_19_06_54_+1100_=bjS1hj_TcI2/CxS--
