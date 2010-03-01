Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab0CAKCV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 05:02:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50379 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956Ab0CAKCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 05:02:18 -0500
Date: Mon, 1 Mar 2010 21:02:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 1
Message-Id: <20100301210210.c6f465e6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_21_02_10_+1100_YwR99p0zw_UpKUFi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_21_02_10_+1100_YwR99p0zw_UpKUFi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20100226:

We are seeing conflicts migrate from being between 2 trees in linux-next
to be between a tree and Linus' tree as things start to get merged.

The blackfin tree gained a build failure (due to a mismerge) for which I
applied a patch.

The m68k-current tree lost it conflict.

The omap tree gained a conflict against the arm tree.

The powerpc tree lost its conflicts.

The i2c tree gained a build failure so I used the version from
next-20100226.

The v4l-dvb tree lost a conflict.

The net tree gained a conflict against Linus' tree.

The wireless tree lost its conflicts.

The mtd tree gained a conflict agains Linus' tree and 2 build failures for
which I applied patches.

The mfd tree lost its conflicts.

The drm tree lost its conflicts.

The oprofile tree gained a conflict against Linus' tree.

The usb tree gained a conflict against the block tree.

The block tree gained a build failure for which I applied a patch.

The driver-core tree gained a build failure for which I applied a patch.

I applied a patch for Ingo Molnar (thanks) for a build failure in Linus'
tree on x86 allyesconfig.

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

We are up to 158 trees (counting Linus' and 22 trees of patches pending
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
Merging i.MX/for-next
CONFLICT (content): Merge conflict in arch/arm/Makefile
Merging msm/for-next
Merging omap/for-next
CONFLICT (content): Merge conflict in arch/arm/plat-omap/Kconfig
Merging pxa/for-next
Merging samsung/next-samsung
CONFLICT (content): Merge conflict in arch/arm/Kconfig
CONFLICT (content): Merge conflict in arch/arm/Makefile
Applying: arm: fix bad merge of arch/arm/Kconfig
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
Merging microblaze/next
CONFLICT (content): Merge conflict in arch/microblaze/include/asm/prom.h
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in arch/mips/alchemy/common/platform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/common/setup.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/db1200/pl=
atform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/db1x00/bo=
ard_setup.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/db1x00/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1100/pl=
atform.c
CONFLICT (content): Merge conflict in arch/mips/alchemy/devboards/pb1200/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1500/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/pb1550/pl=
atform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/platform.c
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/devboards/platform.h
CONFLICT (add/add): Merge conflict in arch/mips/alchemy/xxs1500/platform.c
CONFLICT (content): Merge conflict in arch/mips/cavium-octeon/octeon-irq.c
CONFLICT (content): Merge conflict in arch/mips/configs/db1200_defconfig
CONFLICT (content): Merge conflict in arch/mips/include/asm/mach-au1x00/au1=
000.h
CONFLICT (content): Merge conflict in drivers/pcmcia/au1000_generic.h
CONFLICT (add/add): Merge conflict in drivers/pcmcia/db1xxx_ss.c
CONFLICT (add/add): Merge conflict in drivers/pcmcia/xxs1500_ss.c
Merging parisc/next
Merging powerpc/next
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging genesis/master
CONFLICT (content): Merge conflict in arch/arm/Kconfig
Merging sparc/master
Merging xtensa/master
Applying: blackfin: fix mismerge of kernel/trace/trace_syscalls.c
Merging ceph/for-next
CONFLICT (content): Merge conflict in fs/gfs2/super.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
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
CONFLICT (content): Merge conflict in fs/gfs2/super.c
Applying: ceph: update for BDI_RECLAIMABLE change
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
Merging ubifs/linux-next
Merging xfs/master
Applying: nfsd: fixup for _xfs_log_force API change
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
Applying: logfs: fixup for write_inode API change
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
$ git reset --hard HEAD^
Merging refs/next/20100226/i2c
Merging bjdooks-i2c/next-i2c
CONFLICT (content): Merge conflict in drivers/i2c/busses/Kconfig
CONFLICT (content): Merge conflict in drivers/i2c/busses/Makefile
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
CONFLICT (add/add): Merge conflict in drivers/media/video/tvp7002.c
Merging kbuild/for-next
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
CONFLICT (content): Merge conflict in drivers/infiniband/core/uverbs_main.c
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/firmware/iscsi_ibft.c
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/nand/sh_flctl.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
CONFLICT (content): Merge conflict in drivers/acpi/processor_core.c
Applying: cpufreq: merge fixup for processor_core.c rename
Merging quilt/rr
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/char/hvc_console.c
CONFLICT (content): Merge conflict in drivers/char/hvc_console.h
Merging mmc/next
Merging tmio-mmc/linux-next
CONFLICT (content): Merge conflict in drivers/mfd/asic3.c
CONFLICT (content): Merge conflict in drivers/mfd/t7l66xb.c
CONFLICT (content): Merge conflict in drivers/mfd/tc6387xb.c
CONFLICT (content): Merge conflict in drivers/mfd/tc6393xb.c
CONFLICT (add/add): Merge conflict in drivers/mfd/tmio_core.c
CONFLICT (content): Merge conflict in drivers/mmc/host/tmio_mmc.c
CONFLICT (content): Merge conflict in drivers/mmc/host/tmio_mmc.h
CONFLICT (content): Merge conflict in include/linux/mfd/tmio.h
Merging input/next
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
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
CONFLICT (content): Merge conflict in security/tomoyo/realpath.c
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
CONFLICT (content): Merge conflict in arch/arm/mach-u300/include/mach/debug=
-macro.S
CONFLICT (content): Merge conflict in drivers/net/qlge/qlge_ethtool.c
CONFLICT (content): Merge conflict in drivers/net/qlge/qlge_main.c
CONFLICT (content): Merge conflict in drivers/net/typhoon.c
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
CONFLICT (content): Merge conflict in fs/notify/inotify/inotify_user.c
CONFLICT (content): Merge conflict in kernel/audit_tree.c
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in MAINTAINERS
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
Merging als/for-next
Merging tip/auto-latest
Applying: tip: fix trivial mismerge of tools/perf/util/probe-event.c
Merging edac-amd/for-next
Merging oprofile/for-next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/perf_event.c
Applying: oprofile: merge fixup for arch/x86/kernel/cpu/perf_event_p6.c
Merging percpu/for-next
Applying: slab: update for percpu API change
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging sysctl/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/base/power/main.c
CONFLICT (content): Merge conflict in drivers/pcmcia/ds.c
CONFLICT (content): Merge conflict in include/linux/device.h
Applying: i2c: update for semaphore to mutex conversion of devices
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/arm/mach-mx2/devices.c
CONFLICT (content): Merge conflict in arch/arm/mach-mx2/devices.h
CONFLICT (content): Merge conflict in drivers/usb/early/ehci-dbgp.c
CONFLICT (content): Merge conflict in drivers/usb/storage/scsiglue.c
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/rtl8192su/ieee80211/i=
eee80211_rx.c
CONFLICT (delete/modify): drivers/staging/sm7xx/smtc2d.c deleted in quilt/s=
taging and modified in HEAD. Version HEAD of drivers/staging/sm7xx/smtc2d.c=
 left in tree.
CONFLICT (delete/modify): drivers/staging/sm7xx/smtc2d.h deleted in quilt/s=
taging and modified in HEAD. Version HEAD of drivers/staging/sm7xx/smtc2d.h=
 left in tree.
$ git rm -f drivers/staging/sm7xx/smtc2d.c drivers/staging/sm7xx/smtc2d.h
Merging scsi-post-merge/master
Applying: block: fix for "Consolidate phys_segment and hw_segment limits"
Applying: sysfs: fix for thinko with sysfs_bin_attr_init()
Applying: mtd: nand: fix name space clash
Applying: dell-laptop: Fix build error by making buffer_mutex static
Applying: mtd: declare inline functions static

--Signature=_Mon__1_Mar_2010_21_02_10_+1100_YwR99p0zw_UpKUFi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLkKIACgkQjjKRsyhoI8zhvACfauYs9pl7+ZMYoUh2nTCA8CwN
UyAAoJpXN+3dUgcH5EzoX3rGPYashAUg
=m+zM
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_21_02_10_+1100_YwR99p0zw_UpKUFi--
