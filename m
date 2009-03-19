Return-Path: <linux-kernel-owner+w=401wt.eu-S1754936AbZCSLKp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754936AbZCSLKp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Mar 2009 07:10:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbZCSLKf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Mar 2009 07:10:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59539 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402AbZCSLKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Mar 2009 07:10:33 -0400
Date: Thu, 19 Mar 2009 22:10:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 19
Message-Id: <20090319221024.5e2ad6e5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__19_Mar_2009_22_10_24_+1100_DOOKGjvEaE9LA8Tt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Mar_2009_22_10_24_+1100_DOOKGjvEaE9LA8Tt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090318:

The x86 tree lost a conflict.

The cpus4096 tree gained a conflict against the x86 tree and a build
problem for which I applied a fixup patch.

The tracing tree lost all its conflicts.

The net tree gained a build error due to a conflict with the tracing tree
for which I applied a merge fixup patch.

The rr tree gained a conflict against the cpus4096 tree.

The kmemcheck tree lost 3 conflicts, but gained another against the x86
tree.

The iommu tree gained conflicts against the kernel-doc, kmemcheck and x86
trees.

The osd tree lost its conflict.

The staging tree gained some conflicts against Linus' tree.

The scsi tree lost its build failure.

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

We are up to 134 trees (counting Linus' and 18 trees of patches pending for
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
CONFLICT (content): Merge conflict in arch/arm/mach-mx1/devices.c
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
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/elf.h
Merging xtensa/master
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/common.c
Merging tracing/auto-tracing-next
Merging genirq/auto-genirq-next
CONFLICT (content): Merge conflict in kernel/irq/handle.c
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
CONFLICT (content): Merge conflict in lib/Makefile
Merging stackprotector/auto-stackprotector-next
Merging timers/auto-timers-next
Merging pci/linux-next
Merging quilt/device-mapper
Merging hid/for-next
Merging quilt/i2c
CONFLICT (content): Merge conflict in drivers/i2c/busses/i2c-mpc.c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging v4l-dvb/master
Merging quota/for_next
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in drivers/ide/ide-dma.c
CONFLICT (content): Merge conflict in drivers/ide/ide-floppy.c
CONFLICT (content): Merge conflict in include/linux/ide.h
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
CONFLICT (content): Merge conflict in fs/ext4/inode.c
Merging async_tx/next
Merging udf/for_next
Merging net/master
Merging wireless/master
Applying: net: tracing interface fixup
Merging mtd/master
Merging crypto/master
Merging vfs/for-next
Merging sound/for-next
CONFLICT (content): Merge conflict in sound/soc/pxa/pxa2xx-i2s.c
Merging cpufreq/next
CONFLICT (content): Merge conflict in arch/x86/include/asm/timer.h
Merging v9fs/for-next
CONFLICT (content): Merge conflict in net/9p/protocol.c
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/powerpc/kernel/irq.c
CONFLICT (content): Merge conflict in arch/s390/include/asm/tlbflush.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/topology.h
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/powernow-=
k8.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/speedstep=
-ich.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/cpufreq/speedstep=
-lib.c
CONFLICT (content): Merge conflict in arch/x86/lguest/boot.c
CONFLICT (delete/modify): arch/x86/mach-default/setup.c deleted in HEAD and=
 modified in quilt/rr. Version quilt/rr of arch/x86/mach-default/setup.c le=
ft in tree.
CONFLICT (delete/modify): arch/x86/mach-voyager/setup.c deleted in HEAD and=
 modified in quilt/rr. Version quilt/rr of arch/x86/mach-voyager/setup.c le=
ft in tree.
CONFLICT (content): Merge conflict in drivers/firmware/dcdbas.c
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
CONFLICT (content): Merge conflict in drivers/media/video/saa7134/saa7134-c=
ore.c
CONFLICT (content): Merge conflict in drivers/media/video/saa7134/saa7134.h
CONFLICT (content): Merge conflict in drivers/net/virtio_net.c
CONFLICT (content): Merge conflict in kernel/module.c
$ git rm -f arch/x86/mach-default/setup.c
$ git rm -f arch/x86/mach-voyager/setup.c
Applying: rr: x86 irqaction merge fixup
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
Merging bkl-removal/bkl-removal
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in fs/bio-integrity.c
CONFLICT (content): Merge conflict in fs/bio.c
CONFLICT (content): Merge conflict in include/linux/bio.h
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
CONFLICT (content): Merge conflict in include/linux/rcupdate.h
CONFLICT (content): Merge conflict in include/linux/slub_def.h
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
CONFLICT (content): Merge conflict in drivers/gpu/drm/drm_proc.c
Merging voltage/for-next
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/x86/kernel/head_32.S
CONFLICT (content): Merge conflict in kernel/trace/ring_buffer.c
CONFLICT (content): Merge conflict in mm/Makefile
Merging generic-ipi/auto-generic-ipi-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in lib/Makefile
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Applying: proc: remove a new user of proc_dir_entry::owner
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
CONFLICT (content): Merge conflict in drivers/scsi/iscsi_tcp.c
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
CONFLICT (content): Merge conflict in include/linux/percpu.h
CONFLICT (content): Merge conflict in include/linux/slab.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/module.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slob.c
CONFLICT (content): Merge conflict in mm/slub.c
CONFLICT (content): Merge conflict in mm/vmalloc.c
Merging suspend/linux-next
CONFLICT (content): Merge conflict in drivers/xen/manage.c
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/media/video/v4l2-device.c
CONFLICT (content): Merge conflict in drivers/net/wimax/i2400m/usb-notif.c
CONFLICT (content): Merge conflict in drivers/sh/maple/maple.c
Applying: acpi: update thermal for bus_id removal
Applying: net: update dnet.c for bus_id removal
Merging quilt/usb
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (delete/modify): drivers/staging/benet/be_int.c deleted in HEAD an=
d modified in quilt/staging. Version quilt/staging of drivers/staging/benet=
/be_int.c left in tree.
$ git rm -f drivers/staging/benet/be_int.c
Merging scsi-post-merge/master
Applying powerpc/sparc: mmzone.h needs cpumask_t to be defined

--Signature=_Thu__19_Mar_2009_22_10_24_+1100_DOOKGjvEaE9LA8Tt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknCKCAACgkQjjKRsyhoI8zOUgCgkC35U7DkgajVuUOpmexUWzys
8cAAnApcqwmy7DJaEJbOO/khn9TZO3bY
=qZ5z
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Mar_2009_22_10_24_+1100_DOOKGjvEaE9LA8Tt--
