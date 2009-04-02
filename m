Return-Path: <linux-kernel-owner+w=401wt.eu-S935119AbZDBGEy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935119AbZDBGEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 02:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZDBGEo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 02:04:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37680 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754111AbZDBGEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 02:04:42 -0400
Date: Thu, 2 Apr 2009 17:04:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 2
Message-Id: <20090402170432.9bc4fbf8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Apr_2009_17_04_32_+1100_F4WBs.I7shDB58.6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Apr_2009_17_04_32_+1100_F4WBs.I7shDB58.6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090401:

Various conflicts have moved around due to some trees being merged into
Linus' tree.

The pci tree lost its conflict.

The nfs tree gained a conflict against Linus' tree.

The vfs tree gained 2 build failures due to interactions with the nfs
tree.  I applied merge fixup patches.

The scsi tree gained a build failure that looks like a compiler problem.
I reverted a commit to work around it for today.

The kmemleak tree lost 3 conflicts.

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

We are up to 133 trees (counting Linus' and 18 trees of patches pending for
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
Merging mips/mips-for-linux-next
Merging parisc/master
Merging powerpc/next
Merging 4xx/next
Merging galak/next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in include/linux/netfilter/xt_limit.h
CONFLICT (content): Merge conflict in include/linux/netfilter/xt_statistic.h
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/topology.h
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/common.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/intel_cacheinfo.c
CONFLICT (content): Merge conflict in drivers/oprofile/buffer_sync.c
Merging tracing/auto-tracing-next
CONFLICT (add/add): Merge conflict in arch/parisc/include/asm/ftrace.h
CONFLICT (content): Merge conflict in include/linux/slub_def.h
CONFLICT (content): Merge conflict in kernel/extable.c
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Applying: net: tracing interface fixup
Applying: tracing: fixup for ftrace_push_return_trace API change
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging v4l-dvb/master
CONFLICT (content): Merge conflict in arch/sh/boards/board-ap325rxa.c
CONFLICT (content): Merge conflict in drivers/media/video/cx25840/cx25840-a=
udio.c
CONFLICT (content): Merge conflict in drivers/media/video/em28xx/em28xx-aud=
io.c
CONFLICT (content): Merge conflict in include/linux/i2c-id.h
Merging quota/for_next
CONFLICT (content): merge conflict in fs/quota/dquot.c
CONFLICT (content): Merge conflict in fs/Kconfig
CONFLICT (content): Merge conflict in fs/ext4/ext4.h
CONFLICT (content): Merge conflict in fs/ext4/inode.c
CONFLICT (content): Merge conflict in fs/reiserfs/namei.c
CONFLICT (content): Merge conflict in fs/reiserfs/stree.c
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
CONFLICT (content): Merge conflict in fs/nfs/file.c
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/longhaul.c
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
Merging ext4/next
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/Makefile
Merging crypto/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in include/linux/mnt_namespace.h
Applying: vfs: merge fix for put_fs_struct/free_fs_struct change
Applying: nfs: fixup for fallout from cleaning up includes of fs_struct.h
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/extable.c
CONFLICT (content): Merge conflict in kernel/module.c
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging bkl-removal/bkl-removal
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in firmware/Makefile
CONFLICT (content): Merge conflict in firmware/WHENCE
CONFLICT (content): Merge conflict in sound/isa/Kconfig
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
CONFLICT (content): Merge conflict in fs/devpts/inode.c
Merging agp/agp-next
Merging generic-ipi/auto-generic-ipi-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
Merging cputime/cputime
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging audit/for-next
Merging squashfs/master
Merging omap/for-next
Merging quilt/aoe
Merging kmemleak/kmemleak
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in mm/slob.c
Merging suspend/linux-next
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/media/video/v4l2-device.c
CONFLICT (content): Merge conflict in drivers/net/wimax/i2400m/usb-notif.c
CONFLICT (content): Merge conflict in drivers/sh/maple/maple.c
CONFLICT (content): Merge conflict in drivers/spi/spi_mpc83xx.c
CONFLICT (content): Merge conflict in fs/sysfs/bin.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in lib/Makefile
Merging quilt/usb
CONFLICT (rename/delete): Rename drivers/usb/misc/phidget.h->arch/arm/mach-=
gemini/include/mach/vmalloc.h in HEAD and deleted in quilt/usb
Merging quilt/staging
Merging scsi-post-merge/master
[master 426177c] Revert "[SCSI] fcoe, libfcoe: Add support for FIP. FCoE di=
scovery and keep-alive."
[master e421071] Revert "[SCSI] fcoe, libfc: fix double fcoe_softc memory a=
lloc"
[master a541eba] Revert "[SCSI] fcoe: cleans up libfcoe.h and adds fcoe.h f=
or fcoe module"

--Signature=_Thu__2_Apr_2009_17_04_32_+1100_F4WBs.I7shDB58.6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknUVXAACgkQjjKRsyhoI8yj+gCeOFVDgwmHjlmK1VeQGn96EIWf
VMoAn1hRbK0E1zoZmBcGeKBECEYKW4xl
=vtHY
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Apr_2009_17_04_32_+1100_F4WBs.I7shDB58.6--
