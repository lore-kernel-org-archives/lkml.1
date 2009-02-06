Return-Path: <linux-kernel-owner+w=401wt.eu-S1757516AbZBFLpz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516AbZBFLpz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 06:45:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753621AbZBFLpr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 06:45:47 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43112 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753368AbZBFLpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 06:45:45 -0500
Date: Fri, 6 Feb 2009 22:45:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for February 6
Message-Id: <20090206224538.7d9f8126.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Feb_2009_22_45_38_+1100_9IlQHBPcg937/_+L"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Feb_2009_22_45_38_+1100_9IlQHBPcg937/_+L
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090205:

Removed tree:
	cpu_alloc (until work recommences)

Dropped trees (temporarily):
	quota (build problem)
	ide (build problem)
	security-testing (build problem)
	audit (difficult conflicts)

The tip-core tree gained a conflict against Linus' tree.

The pci tree gained a conflict against the pci-current tree.

The quota tree gained a build failure and was dropped.

The ide tree lost its 2 conflicts but gained a build failure and was
dropped.

The security-testing tree gained a conflict against Linus' tree and a
build failure and was dropped.

The proc tree lost its conflict.

The cpufreq tree lost its build failure.

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
final fixups (if any), it is also built with powerpc allnoconfig,
ppc44x_defconfig and allyesconfig (minus CONFIG_PROFILE_ALL_BRANCHES) and
i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 131 trees (counting Linus' and 18 trees of patches pending for
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
CONFLICT (content): Merge conflict in drivers/char/tty_audit.c
CONFLICT (content): Merge conflict in kernel/auditsc.c
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
CONFLICT (content): Merge conflict in arch/arm/configs/magician_defconfig
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in arch/x86/mach-voyager/voyager_smp.c
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/pcie/portdrv_pci.c
Merging quilt/device-mapper
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging quota/for_next
$ git reset --hard HEAD^
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
$ git reset --hard HEAD^
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
Created commit d79806d: Revert "platform/x86: Add oqo-wmi driver for model =
2 OQO backlight and rfkill control"
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging ocfs2/linux-next
Merging ext4/next
CONFLICT (content): Merge conflict in fs/ext4/ext4.h
Merging async_tx/next
Merging udf/for_next
Merging net/master
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl-agn.c
CONFLICT (content): Merge conflict in drivers/net/wireless/iwlwifi/iwl3945-=
base.c
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/powernow-=
k8.c
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
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
CONFLICT (content): Merge conflict in sound/isa/Kconfig
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
CONFLICT (content): Merge conflict in include/linux/slub_def.h
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging uclinux/for-next
Merging md/for-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
CONFLICT (content): Merge conflict in mm/Makefile
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
CONFLICT (content): Merge conflict in fs/namei.c
$ git reset --hard HEAD^
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
CONFLICT (content): Merge conflict in kernel/irq/handle.c
Merging iommu/auto-iommu-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
Merging bdev/master
Merging dwmw2-iommu/master
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in include/linux/dma_remapping.h
Merging cputime/cputime
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
Merging squashfs/master
Merging omap/for-next
Merging kmemleak/kmemleak
CONFLICT (content): Merge conflict in include/linux/slab.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging quilt/staging
Merging scsi-post-merge/master

--Signature=_Fri__6_Feb_2009_22_45_38_+1100_9IlQHBPcg937/_+L
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmMIuIACgkQjjKRsyhoI8ywGgCeNHMAADa5nDYo8Afv2rvvrDNS
P5kAoIBcP682ksNVA8MqKgX7dDh3mnFI
=t57N
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Feb_2009_22_45_38_+1100_9IlQHBPcg937/_+L--
