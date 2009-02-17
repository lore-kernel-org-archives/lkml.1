Return-Path: <linux-kernel-owner+w=401wt.eu-S1753173AbZBQJiy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbZBQJiy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 04:38:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751025AbZBQJip
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 04:38:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52050 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090AbZBQJim (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 04:38:42 -0500
Date: Tue, 17 Feb 2009 20:38:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for February 17
Message-Id: <20090217203832.d6f2ef79.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Feb_2009_20_38_32_+1100_fWSvwmElvw_GecFw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Feb_2009_20_38_32_+1100_fWSvwmElvw_GecFw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090216:

Dropped tree:
	rr (build failure)

The tip-core tree lost its 2 conflicts.

The ftrace tree gained a conflict against the x86 tree.

The stackprotector tree gained a conflicts against the x86 tree.

The rr tree gained conflicts against the v4l-dvb, hid and ftrace trees.
It also gained a build failure and so was dropped for today.

The kmemcheck tree lost 2 conflicts.

The sparseirq tree lost its cnflict.

The trivial tree gained a conflict against the v4l-dvb tree.

The kmemleak gained a conflict against the tip-core tree.

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
CONFLICT (content): Merge conflict in arch/arm/mach-at91/gpio.c
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
Merging quilt/driver-core
Merging quilt/usb
Merging tip-core/auto-core-next
Merging cpus4096/auto-cpus4096-next
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in arch/x86/Kconfig
Merging genirq/auto-genirq-next
CONFLICT (content): Merge conflict in kernel/irq/handle.c
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in arch/x86/kernel/setup_percpu.c
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/for-next
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging v4l-dvb/master
Merging quota/for_next
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
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
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
CONFLICT (content): Merge conflict in sound/soc/pxa/pxa2xx-i2s.c
Merging cpufreq/next
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging quilt/rr
CONFLICT (delete/modify): arch/x86/include/asm/es7000/apic.h deleted in HEA=
D and modified in quilt/rr. Version quilt/rr of arch/x86/include/asm/es7000=
/apic.h left in tree.
CONFLICT (delete/modify): arch/x86/include/asm/numaq/apic.h deleted in HEAD=
 and modified in quilt/rr. Version quilt/rr of arch/x86/include/asm/numaq/a=
pic.h left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/powernow-=
k8.c
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
CONFLICT (content): Merge conflict in drivers/media/video/saa7134/saa7134-c=
ore.c
CONFLICT (content): Merge conflict in drivers/media/video/saa7134/saa7134.h
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
CONFLICT (content): Merge conflict in kernel/module.c
$ git rm -f arch/x86/include/asm/es7000/apic.h
$ git rm -f arch/x86/include/asm/numaq/apic.h
Applying: rr: fixup for cpumask:remove-address-of-CPU_MASK_ALL
$ git reset --hard HEAD^
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
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in mm/Makefile
Merging generic-ipi/auto-generic-ipi-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
CONFLICT (content): Merge conflict in arch/x86/include/asm/dma-mapping.h
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
Merging fatfs/master
Merging fuse/for-next
Merging jc_docs/docs-next
Merging nommu/master
Merging trivial/for-next
CONFLICT (content): Merge conflict in drivers/media/video/gspca/t613.c
Merging audit/for-next
Merging squashfs/master
Merging omap/for-next
Merging quilt/aoe
Merging kmemleak/kmemleak
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in include/linux/slab.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging quilt/staging
Merging scsi-post-merge/master

--Signature=_Tue__17_Feb_2009_20_38_32_+1100_fWSvwmElvw_GecFw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmahZgACgkQjjKRsyhoI8wzwQCfUw8TOZk9NNRW2tF7yenKjRJU
RCcAn1IdCb1D/vEV9SiX7x9RqSfLgnLh
=MBoU
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Feb_2009_20_38_32_+1100_fWSvwmElvw_GecFw--
