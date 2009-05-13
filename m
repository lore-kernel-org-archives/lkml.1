Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbZEMGsy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbZEMGsy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 02:48:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752161AbZEMGsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 02:48:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35630 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbZEMGsj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 02:48:39 -0400
Date: Wed, 13 May 2009 16:48:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for May 13
Message-Id: <20090513164832.c8a0de7d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_May_2009_16_48_32_+1000_TIdGnrIWNYX1LGJT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_May_2009_16_48_32_+1000_TIdGnrIWNYX1LGJT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090512:

The vfs tree gained a conflict against the ext4 tree.

The block tree gained a build failure due to interactions with the scsi
tree.  I reverted a commit and applied a patch.

The kmemleak tree required one less merge fix.

The driver-core tree lost its build failure.

I applied 2 patches for runtime problems in the net tree so as to not
hold up testing.  These patches (or something similar) should be added to
the net tree at some point.

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

We are up to 136 trees (counting Linus' and 18 trees of patches pending for
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
CONFLICT (content): Merge conflict in arch/arm/Kconfig
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
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging tracing/auto-tracing-next
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
Merging v4l-dvb/master
Merging quota/for_next
Merging kbuild/master
[master 3d1799d] Revert "initconst adjustments"
Merging ide/for-next
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
CONFLICT (content): Merge conflict in include/Kbuild
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in include/linux/mmc/sdio_ids.h
Merging wireless/master
[master 3565650] Revert "rfkill: remove user_claim stuff"
Merging mtd/master
Merging crypto/master
Merging vfs/for-next
CONFLICT (content): Merge conflict in fs/ext4/super.c
CONFLICT (content): Merge conflict in fs/fuse/inode.c
Merging sound/for-next
Merging cpufreq/next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/acpi-cpuf=
req.c
Merging cifs/master
Merging mmc/next
Merging input/next
Merging bkl-removal/bkl-removal
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in drivers/block/hd.c
CONFLICT (content): Merge conflict in drivers/block/mg_disk.c
CONFLICT (content): Merge conflict in drivers/ide/ide-atapi.c
CONFLICT (content): Merge conflict in drivers/ide/ide-cd.c
CONFLICT (content): Merge conflict in drivers/ide/ide-floppy.c
CONFLICT (content): Merge conflict in drivers/ide/ide-tape.c
[master d43bc92] Revert "block: move completion related functions back to b=
lk-core.c"
Applying: scsi/block: fixup scsi_transport_fc for block changes
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
Merging agp/agp-next
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
Merging suspend/linux-next
Merging bluetooth/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in init/main.c
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/usb/serial/sierra.c
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/rt2860/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt2870/common/mlme.c
CONFLICT (content): Merge conflict in drivers/staging/rt3070/common/mlme.c
Merging scsi-post-merge/master
Applying: net/ibmveth: fix panic in probe
Applying: net: remove needless (now buggy) & from dev->dev_addr

--Signature=_Wed__13_May_2009_16_48_32_+1000_TIdGnrIWNYX1LGJT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoKbUAACgkQjjKRsyhoI8xvTACaA6ab9K+JBJhzmWc9t/Sp9kJ+
vDwAn1T6slEwqT2zJFmuaoVJI1Hcl/Zj
=tDVf
-----END PGP SIGNATURE-----

--Signature=_Wed__13_May_2009_16_48_32_+1000_TIdGnrIWNYX1LGJT--
