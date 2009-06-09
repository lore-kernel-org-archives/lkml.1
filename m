Return-Path: <linux-kernel-owner+w=401wt.eu-S1763103AbZFIKuz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763103AbZFIKuz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 06:50:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762381AbZFIKun
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 06:50:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53459 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762628AbZFIKuj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 06:50:39 -0400
Date: Tue, 9 Jun 2009 20:50:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for June 9
Message-Id: <20090609205034.bc5805d7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_20_50_34_+1000_fovX0NHUOulR/ZrC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_20_50_34_+1000_fovX0NHUOulR/ZrC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

More last minute rush ...

Changes since 20090604:

New trees:
	irda
	voyager

Dropped tree:
	voyager (build problem)

This tree fails to build for powerpc allyesconfig.

The vfs tree lost a conflict, but gained conflicts against the fuse and
nilfs trees.

The kbuild tree gained a conflict against the x86 tree and a build failure
so I used the version from next-20090605.

The net tree gained a conflict against the scsi tree.

The mtd tree lost its conflict.

The rr tree lost its conflict, but gained a conflict against the x86
tree.  It also gained a build failure for which I reverted a commit.

The block tree gained conflicts against the rr and ide trees.

The security-testing tree gained a build failure for which I reverted a
commit.

The watchdog tree gained a conflict against the arm tree.

The driver-core tree gained a conflict against the scsi tree.

The voyager tree gained a conflict against the rr tree and a build
failure so I dropped it for today.

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

We are up to 144 trees (counting Linus' and 19 trees of patches pending for
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
CONFLICT (content): Merge conflict in drivers/char/hw_random/Kconfig
CONFLICT (content): Merge conflict in drivers/char/hw_random/Makefile
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
CONFLICT (delete/modify): fs/gfs2/ops_super.c deleted in HEAD and modified =
in vfs/for-next. Version vfs/for-next of fs/gfs2/ops_super.c left in tree.
CONFLICT (content): Merge conflict in fs/nilfs2/super.c
CONFLICT (content): Merge conflict in fs/nilfs2/the_nilfs.c
CONFLICT (content): Merge conflict in fs/nilfs2/the_nilfs.h
CONFLICT (content): Merge conflict in fs/reiserfs/super.c
CONFLICT (content): Merge conflict in include/linux/magic.h
$ git rm -f fs/gfs2/ops_super.c
Applying: vfs/gfs2: fixup merge for file removal
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
CONFLICT (content): Merge conflict in scripts/Makefile.lib
$ git reset --hard HEAD^
Merging refs/next/20090605/kbuild
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
CONFLICT (content): Merge conflict in Documentation/feature-removal-schedul=
e.txt
CONFLICT (content): Merge conflict in drivers/platform/x86/Kconfig
CONFLICT (content): Merge conflict in drivers/platform/x86/toshiba_acpi.c
CONFLICT (content): Merge conflict in drivers/scsi/fcoe/fcoe.c
CONFLICT (content): Merge conflict in include/linux/mmc/sdio_ids.h
Merging wireless/master
[master df6f8ff] Revert "Merge branch 'oqo-wmi-EXPECT-REFRESH' into test"
Merging mtd/master
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (rename/modify): Merge conflict in arch/x86/kernel/cpu/mcheck/mce.c
Merging cifs/master
Merging mmc/next
Merging input/next
Merging bkl-removal/bkl-removal
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/block/virtio_blk.c
CONFLICT (content): Merge conflict in drivers/ide/ide-atapi.c
CONFLICT (content): Merge conflict in drivers/ide/ide-cd.c
CONFLICT (content): Merge conflict in drivers/ide/ide-floppy.c
CONFLICT (content): Merge conflict in drivers/ide/ide-tape.c
CONFLICT (content): Merge conflict in include/linux/virtio_blk.h
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
CONFLICT (content): Merge conflict in drivers/md/md.c
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
CONFLICT (content): Merge conflict in drivers/watchdog/Makefile
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in drivers/pci/intr_remapping.c
Merging cputime/cputime
Merging osd/linux-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
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
Merging irda/for-next
Merging asm-generic/next
CONFLICT (content): Merge conflict in arch/arm/include/asm/page.h
Merging quilt/driver-core
CONFLICT (content): Merge conflict in arch/x86/kernel/microcode_core.c
CONFLICT (content): Merge conflict in drivers/base/firmware_class.c
CONFLICT (content): Merge conflict in drivers/scsi/ibmvscsi/ibmvscsi.c
CONFLICT (content): Merge conflict in init/main.c
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/class/cdc-acm.c
CONFLICT (content): Merge conflict in drivers/usb/serial/cp210x.c
CONFLICT (content): Merge conflict in drivers/usb/serial/ftdi_sio.c
CONFLICT (content): Merge conflict in drivers/usb/serial/kobil_sct.c
CONFLICT (content): Merge conflict in drivers/usb/serial/sierra.c
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/rt2860/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt2870/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt3070/common/mlme.c
Merging voyager/master
CONFLICT (content): Merge conflict in drivers/lguest/Kconfig
$ git reset --hard HEAD^
Merging scsi-post-merge/master
CONFLICT (content): Merge conflict in include/Kbuild
[master 0e528d9] Revert "security: use mmap_min_addr indepedently of securi=
ty models"
[master 45b2cc2] Revert "module: trim exception table on init free."

--Signature=_Tue__9_Jun_2009_20_50_34_+1000_fovX0NHUOulR/ZrC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouPnoACgkQjjKRsyhoI8wwsACferpXzIvslrw1wsSP4xzVhEtR
ZwIAn1AmGc8Ci0eQtFXfqPQ9sCHVaFx/
=kTEo
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_20_50_34_+1000_fovX0NHUOulR/ZrC--
