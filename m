Return-Path: <linux-kernel-owner+w=401wt.eu-S1751821AbZKDGJr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbZKDGJr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 01:09:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750949AbZKDGJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 01:09:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41991 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZKDGJl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 01:09:41 -0500
Date: Wed, 4 Nov 2009 17:09:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for November 4
Message-Id: <20091104170931.4aa51b77.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Nov_2009_17_09_31_+1100_KKEQvELOudUVL.I4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Nov_2009_17_09_31_+1100_KKEQvELOudUVL.I4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20091102:

New tree: msm (an ARM platform)

My fixes tree contains a build fix for powerpc/kvm.

The pcmcia tree gained a build failure so I used the version from
next-20091102.

The trivial tree lost its conflict.

The percpu tree lost its build problem.

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

We are up to 146 trees (counting Linus' and 22 trees of patches pending for
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
Merging davinci/davinci-next
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging avr32/avr32-arch
CONFLICT (content): Merge conflict in arch/avr32/mach-at32ap/include/mach/c=
pu.h
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
Merging kbuild/master
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
CONFLICT (content): Merge conflict in arch/powerpc/kvm/timing.h
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (delete/modify): drivers/net/sfc/sfe4001.c deleted in net/master a=
nd modified in HEAD. Version HEAD of drivers/net/sfc/sfe4001.c left in tree.
CONFLICT (content): Merge conflict in drivers/net/wireless/libertas/cmd.c
CONFLICT (content): Merge conflict in drivers/staging/rtl8187se/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/rtl8192e/Kconfig
$ git rm -f drivers/net/sfc/sfe4001.c
Applying: net: merge fixup for drivers/net/sfc/falcon_boards.c
Merging wireless/master
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/board-omap3evm.c
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
CONFLICT (content): Merge conflict in drivers/pcmcia/Makefile
$ git reset --hard HEAD^
Merging refs/next/20091102/pcmcia
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
CONFLICT (content): Merge conflict in Documentation/dontdiff
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
Merging irda/for-next
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in drivers/misc/Makefile
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
CONFLICT (content): Merge conflict in arch/arm/mach-realview/core.h
CONFLICT (content): Merge conflict in arch/arm/mach-realview/realview_pb117=
6.c
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in drivers/net/Kconfig
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Merging devicetree/next-devicetree
Merging limits/writable_limits
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/kernel/kgdb.c
Merging oprofile/for-next
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/x86/kvm/svm.c
CONFLICT (content): Merge conflict in kernel/softlockup.c
CONFLICT (content): Merge conflict in mm/percpu.c
Applying: percpu: merge fixup for variable renaming
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
Merging scsi-post-merge/master

--Signature=_Wed__4_Nov_2009_17_09_31_+1100_KKEQvELOudUVL.I4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrxGpsACgkQjjKRsyhoI8xrYACfX5WOB9EtN4mSf+hGrzKm3C35
oWQAnRLxLwPygslyEJ1ww2Kxwu7Xz1vy
=tGRB
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Nov_2009_17_09_31_+1100_KKEQvELOudUVL.I4--
