Return-Path: <linux-kernel-owner+w=401wt.eu-S1755758AbZJMFX4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758AbZJMFX4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 01:23:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751988AbZJMFXz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 01:23:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47890 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750819AbZJMFXy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 01:23:54 -0400
Date: Tue, 13 Oct 2009 16:23:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 13
Message-Id: <20091013162312.8b93998b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_16_23_12_+1100_mznkVBy051/S_9l/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_16_23_12_+1100_mznkVBy051/S_9l/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Changes since 20091012:

Dropped tree: i7core_edac (difficult merge conflict)

My fixes tree contains a build fix for powerpc/kvm.

The net tree gained a build failure for which I reverted a commit.

The sound tree lost its build failure.

The mfd tree still lost its build failure.

The voltage tree lost its build failure.

The suspend tree lost its build failure.

The percpu tree gained a build failure so I used the version from
next-20091012.

The tty tree gained a build failure for which I reverted a commit.

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

We are up to 143 trees (counting Linus' and 22 trees of patches pending for
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
Merging parisc/next
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
CONFLICT (content): Merge conflict in fs/ecryptfs/Kconfig
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
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
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
Merging i7core_edac/linux_next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
CONFLICT (content): Merge conflict in drivers/edac/Makefile
$ git reset --hard
Merging tip/auto-latest
Merging oprofile/for-next
Merging percpu/for-next
$ git reset --hard HEAD^
Merging refs/next/20091012/percpu
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
[master fe79f27] Revert "tty: esp: remove broken driver"
Merging scsi-post-merge/master
[master d8fba4d] Revert "cnic: Add main functions to support bnx2x devices."

--Signature=_Tue__13_Oct_2009_16_23_12_+1100_mznkVBy051/S_9l/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrUDsAACgkQjjKRsyhoI8zHaQCfd+r37GdxXah1uesSRU16DbxT
ri4An2WF2mFFXD8ruwLb5/DM+Ble31sK
=FMyo
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_16_23_12_+1100_mznkVBy051/S_9l/--
