Return-Path: <linux-kernel-owner+w=401wt.eu-S1754194AbZFCJKI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754194AbZFCJKI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 05:10:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753263AbZFCJJ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 05:09:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55224 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbZFCJJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 05:09:56 -0400
Date: Wed, 3 Jun 2009 19:09:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 3
Message-Id: <20090603190952.2dd0cc70.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Jun_2009_19_09_52_+1000_iF8.xkxXHlvgvsym"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Jun_2009_19_09_52_+1000_iF8.xkxXHlvgvsym
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Looks like a real rush since -rc7 ...

Changes since 20090602:

This tree fails to build for powerpc allyesconfig.

Moved tree: device-mapper (it now assumes some of the commits in the
	block tree have been applied)

The x86 tree lost its conflict.

The kvm tree gained a conflict against the x86 tree.

The net tree gained a conflict against Linus' tree.

The wireless tree gained conflicts against the x86 (1) and acpi (2) trees.
It also gained a build failure due to an interaction with the acpi tree
for which I reverted 2 commits from the acpi tree.

The block tree lost its build failure due to updates in the device-mapper
tree.

The genirq tree lost its 2 conflicts.

The trivial tree gained a conflict against the wireless tree.

The driver-core tree gained conflicts against the trivial (1), x86 (1),
firmware (1) and ttydev (3) trees.

The ubi tree gained a build failure for which I reverted 2 commits.

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

We are up to 142 trees (counting Linus' and 19 trees of patches pending for
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
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
CONFLICT (content): Merge conflict in arch/arm/mach-pxa/viper.c
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging configfs/linux-next
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
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/ext4/super.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
CONFLICT (delete/modify): fs/gfs2/ops_super.c deleted in HEAD and modified =
in vfs/for-next. Version vfs/for-next of fs/gfs2/ops_super.c left in tree.
CONFLICT (content): Merge conflict in fs/reiserfs/super.c
$ git rm -f fs/gfs2/ops_super.c
Applying: vfs/gfs2: fixup merge for file removal
Applying: vfs: fix mismerge of fs/reiserfs/xattr.c
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
Merging ide/for-next
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in arch/x86/include/asm/mce.h
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/forcedeth.c
CONFLICT (content): Merge conflict in include/linux/mmc/sdio_ids.h
Merging wireless/master
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/platform/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
[master f168b47] Revert "oqo: dev_set_name()"
[master e52d8f8] Revert "platform/x86: Add oqo-wmi driver for model 2 OQO b=
acklight and rfkill control"
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/nand/mxc_nand.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/powernow-=
k8.c
Merging cifs/master
Merging mmc/next
Merging input/next
Merging bkl-removal/bkl-removal
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/ide/ide-atapi.c
CONFLICT (content): Merge conflict in drivers/ide/ide-cd.c
CONFLICT (content): Merge conflict in drivers/ide/ide-floppy.c
CONFLICT (content): Merge conflict in drivers/ide/ide-tape.c
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
Applying: md: fix fallout from block tree API change
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging tracing/auto-tracing-next
CONFLICT (content): Merge conflict in block/blk-sysfs.c
CONFLICT (content): Merge conflict in net/core/drop_monitor.c
CONFLICT (content): Merge conflict in net/core/net-traces.c
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
CONFLICT (content): Merge conflict in kernel/sched.c
Merging generic-ipi/auto-generic-ipi-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in drivers/pci/intr_remapping.c
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
CONFLICT (content): Merge conflict in Documentation/rfkill.txt
Merging audit/for-next
Merging omap/for-next
Merging quilt/aoe
Merging kmemleak/kmemleak
CONFLICT (delete/modify): arch/x86/kernel/vmlinux_32.lds.S deleted in HEAD =
and modified in kmemleak/kmemleak. Version kmemleak/kmemleak of arch/x86/ke=
rnel/vmlinux_32.lds.S left in tree.
CONFLICT (delete/modify): arch/x86/kernel/vmlinux_64.lds.S deleted in HEAD =
and modified in kmemleak/kmemleak. Version kmemleak/kmemleak of arch/x86/ke=
rnel/vmlinux_64.lds.S left in tree.
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in mm/slob.c
$ git rm -f arch/x86/kernel/vmlinux_32.lds.S arch/x86/kernel/vmlinux_64.lds=
.S
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
CONFLICT (content): Merge conflict in include/linux/ring_buffer.h
CONFLICT (content): Merge conflict in include/linux/slab.h
CONFLICT (content): Merge conflict in kernel/trace/ring_buffer.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging suspend/linux-next
Merging bluetooth/master
Merging edac-amd/for-next
Merging fsnotify/for-next
Merging asm-generic/next
CONFLICT (content): Merge conflict in arch/arm/include/asm/page.h
Merging quilt/driver-core
CONFLICT (content): Merge conflict in Documentation/trace/ftrace.txt
CONFLICT (content): Merge conflict in arch/x86/kernel/microcode_core.c
CONFLICT (content): Merge conflict in drivers/base/firmware_class.c
CONFLICT (content): Merge conflict in init/main.c
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/class/cdc-acm.c
CONFLICT (content): Merge conflict in drivers/usb/serial/cp210x.c
CONFLICT (content): Merge conflict in drivers/usb/serial/ftdi_sio.c
CONFLICT (content): Merge conflict in drivers/usb/serial/sierra.c
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/rt2860/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt2870/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt3070/common/mlme.c
Merging scsi-post-merge/master
CONFLICT (content): Merge conflict in include/Kbuild
[master 10346ca] Revert "UBI: make gluebi a separate module"
[master b6f540e] Revert "UBI: remove built-in gluebi"

--Signature=_Wed__3_Jun_2009_19_09_52_+1000_iF8.xkxXHlvgvsym
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkomPeAACgkQjjKRsyhoI8xkagCfQCWw5nBCaeRYxbFEAymN+Ib8
ZdQAnjvaNdugOJjHV551VwNlcL1UP0Dw
=FULs
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Jun_2009_19_09_52_+1000_iF8.xkxXHlvgvsym--
