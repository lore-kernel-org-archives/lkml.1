Return-Path: <linux-kernel-owner+w=401wt.eu-S1753259AbZGWGcK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259AbZGWGcK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jul 2009 02:32:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752908AbZGWGcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Jul 2009 02:32:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35712 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752907AbZGWGcH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:32:07 -0400
Date: Thu, 23 Jul 2009 16:32:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 23
Message-Id: <20090723163201.6951a44b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__23_Jul_2009_16_32_01_+1000_Ns47My/M7Iq93bLl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__23_Jul_2009_16_32_01_+1000_Ns47My/M7Iq93bLl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090722:

This tree fails to build for powerpc allyesconfig (final link problem).

The v4l-dvb tree gained 4 conflicts against the davinci tree.

The sound tree gained a conflict against the davinci tree.

I merged an updated version of Linus' tree at the end to get a build fix.

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

We are up to 134 trees (counting Linus' and 19 trees of patches pending for
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
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/dma-octeon.c
CONFLICT (add/add): Merge conflict in arch/mips/cavium-octeon/executive/cvm=
x-helper-errata.c
CONFLICT (content): Merge conflict in arch/mips/mm/tlbex.c
CONFLICT (content): Merge conflict in arch/mips/sibyte/swarm/setup.c
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in drivers/char/hw_random/Makefile
CONFLICT (add/add): Merge conflict in drivers/dma/txx9dmac.c
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging cifs/master
Merging configfs/linux-next
CONFLICT (content): Merge conflict in fs/configfs/dir.c
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
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl-rc6
CONFLICT (content): Merge conflict in fs/reiserfs/journal.c
CONFLICT (content): Merge conflict in fs/reiserfs/super.c
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/board-dm646x-ev=
m.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/dm355.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/dm644x.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/dm646x.c
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/include/mach/dm=
355.h
CONFLICT (content): Merge conflict in arch/arm/mach-davinci/include/mach/dm=
644x.h
Merging quota/for_next
Merging kbuild/master
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwmc3200wifi/net=
dev.c
CONFLICT (content): Merge conflict in net/wireless/scan.c
Merging wireless/master
Merging mtd/master
Merging crypto/master
Merging sound/for-next
CONFLICT (content): Merge conflict in sound/soc/davinci/davinci-evm.c
Merging cpufreq/next
Merging quilt/rr
Merging mmc/next
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
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
$ git reset --hard HEAD^
Merging refs/next/20090713/ttydev
CONFLICT (content): Merge conflict in drivers/usb/serial/generic.c
CONFLICT (content): Merge conflict in drivers/usb/serial/pl2303.c
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
Merging edac-amd/for-next
Merging fsnotify/for-next
Merging irda/for-next
Merging hwlat/for-linus
Merging tip/auto-latest
CONFLICT (content): Merge conflict in drivers/oprofile/oprofile_stats.c
CONFLICT (content): Merge conflict in include/linux/rcupdate.h
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/sh/kernel/vmlinux.lds.S
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/perf_counter.c
CONFLICT (content): Merge conflict in drivers/cpufreq/cpufreq_ondemand.c
Merging sfi/sfi-test
Merging asm-generic/next
Merging quilt/driver-core
CONFLICT (content): Merge conflict in init/main.c
Merging quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
Merging update origin/master

--Signature=_Thu__23_Jul_2009_16_32_01_+1000_Ns47My/M7Iq93bLl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpoA+EACgkQjjKRsyhoI8yLcQCaAmnFL46RzaHWNkbt7D/DETAP
+DsAnjK8e4SjZKNDXLxInWjsafDLKRdC
=eNvo
-----END PGP SIGNATURE-----

--Signature=_Thu__23_Jul_2009_16_32_01_+1000_Ns47My/M7Iq93bLl--
