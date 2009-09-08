Return-Path: <linux-kernel-owner+w=401wt.eu-S1753988AbZIHITr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988AbZIHITr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 04:19:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753907AbZIHITq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 04:19:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56676 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753780AbZIHITo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 04:19:44 -0400
Date: Tue, 8 Sep 2009 18:19:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for September 8
Message-Id: <20090908181939.108aeb3c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Sep_2009_18_19_39_+1000_f=ntUKmQP5k+s62W"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Sep_2009_18_19_39_+1000_f=ntUKmQP5k+s62W
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090907:

Removed trees:
	edac-amd (temporarily, at the request of the maintainer)

The v4l-dvb tree lost a conflict.

The acpi tree still has a build failure so I used the version from
next-20090831.

The async_tx tree still has a build failure so I used the version from
next-20090904.

The wireless tree still has a (slab tree revealed) build failure so I
used the version from 20090904.

The drm tree gained conflicts against Linus' tree.

The security-testing tree still has a build failure (affecting several
architectures) so I used the version from 20090902.

The trivial tree lost its conflicts.

The scsi-post-merge tree still has a build failure so I used the version
from 20090904.

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
Merging parisc/next
Merging powerpc/next
CONFLICT (content): Merge conflict in kernel/gcov/Kconfig
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
CONFLICT (content): Merge conflict in net/sunrpc/cache.c
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_lrw.c
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
Merging pci/linux-next
CONFLICT (content): Merge conflict in arch/powerpc/kernel/pci_64.c
Applying: pci: merge fixup for fundamental reset conflict with powerpc tree
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in drivers/media/video/sh_mobile_ceu_cam=
era.c
Merging quota/for_next
Merging kbuild/master
Merging kconfig/for-next
CONFLICT (content): Merge conflict in scripts/extract-ikconfig
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
$ git reset --hard HEAD^
Merging refs/next/20090831/acpi
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging async_tx/next
$ git reset --hard HEAD^
Merging refs/next/20090904/async_tx
Merging net/master
Merging wireless/master
$ git reset --hard HEAD^
Merging refs/next/20090904/wireless
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
Merging mmc/next
Merging input/next
CONFLICT (content): Merge conflict in drivers/base/platform.c
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/ubifs/super.c
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
CONFLICT (content): Merge conflict in drivers/input/misc/Kconfig
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/r300.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/radeon_asic.h
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/rs600.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/rs690.c
CONFLICT (content): Merge conflict in drivers/gpu/drm/radeon/rv515.c
CONFLICT (content): Merge conflict in firmware/Makefile
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/regulator/Kconfig
Merging security-testing/next
CONFLICT (content): Merge conflict in arch/arm/kernel/signal.c
CONFLICT (content): Merge conflict in arch/parisc/include/asm/thread_info.h
CONFLICT (content): Merge conflict in arch/parisc/kernel/entry.S
CONFLICT (content): Merge conflict in arch/parisc/kernel/signal.c
$ git reset --hard HEAD^
Merging refs/next/20090902/security-testing
Applying: security: fix merge for tun_struct changes
Merging lblnet/master
CONFLICT (content): Merge conflict in drivers/net/tun.c
Merging agp/agp-next
CONFLICT (content): Merge conflict in drivers/char/agp/uninorth-agp.c
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
Merging drbd/drbd
Merging kmemleak/kmemleak
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/include/asm/socket.h
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
CONFLICT (content): Merge conflict in drivers/pci/dmar.c
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in include/linux/rcupdate.h
CONFLICT (content): Merge conflict in kernel/fork.c
Applying: tip: fix merge for cupmask update
Merging oprofile/for-next
CONFLICT (content): Merge conflict in kernel/trace/ring_buffer.c
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/sh/kernel/vmlinux.lds.S
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in mm/percpu.c
Merging sfi/sfi-test
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/base/class.c
CONFLICT (content): Merge conflict in drivers/mtd/mtdcore.c
CONFLICT (content): Merge conflict in init/main.c
Merging quilt/tty
CONFLICT (content): Merge conflict in arch/x86/include/asm/termios.h
CONFLICT (content): Merge conflict in drivers/char/n_tty.c
Merging quilt/usb
Merging quilt/staging
CONFLICT (delete/modify): drivers/staging/at76_usb/at76_usb.c deleted in qu=
ilt/staging and modified in HEAD. Version HEAD of drivers/staging/at76_usb/=
at76_usb.c left in tree.
CONFLICT (delete/modify): drivers/staging/epl/VirtualEthernetLinux.c delete=
d in quilt/staging and modified in HEAD. Version HEAD of drivers/staging/ep=
l/VirtualEthernetLinux.c left in tree.
$ git rm -f drivers/staging/epl/VirtualEthernetLinux.c
$ git rm -f drivers/staging/at76_usb/at76_usb.c
Merging scsi-post-merge/master
$ git reset --hard HEAD^
Merging refs/next/20090904/scsi-post-merge

--Signature=_Tue__8_Sep_2009_18_19_39_+1000_f=ntUKmQP5k+s62W
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqmE5sACgkQjjKRsyhoI8woLwCbB+exUTkyjV83xRRP+Ksc92B3
nKgAn3anH7KteulLf8EBdRzyByxNxTko
=ksWD
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Sep_2009_18_19_39_+1000_f=ntUKmQP5k+s62W--
