Return-Path: <linux-kernel-owner+w=401wt.eu-S1756819AbZCRGiv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756819AbZCRGiv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:38:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZCRGil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 02:38:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:57629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024AbZCRGij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 02:38:39 -0400
Date: Wed, 18 Mar 2009 17:38:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 18
Message-Id: <20090318173830.7ea03dfb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__18_Mar_2009_17_38_30_+1100_G65W4vEAHZN5Qg9T"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__18_Mar_2009_17_38_30_+1100_G65W4vEAHZN5Qg9T
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20090317:

The net tree lost its conflicts.

The rr tree lost its build failure (and lots of warnings).

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
CONFLICT (content): Merge conflict in arch/parisc/kernel/irq.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/elf.h
Merging xtensa/master
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging cpus4096/auto-cpus4096-next
Merging tracing/auto-tracing-next
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (delete/modify): block/blktrace.c deleted in tracing/auto-tracing-=
next and modified in HEAD. Version HEAD of block/blktrace.c left in tree.
CONFLICT (content): Merge conflict in kernel/irq/handle.c
$ git rm -f block/blktrace.c
Applying: tracing: blktrace merge fix
Applying: trace: percpu fixup
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
CONFLICT (content): Merge conflict in arch/x86/Kconfig
CONFLICT (content): Merge conflict in arch/x86/mm/init_32.c
CONFLICT (content): Merge conflict in arch/x86/mm/init_64.c
CONFLICT (content): Merge conflict in kernel/trace/ring_buffer.c
CONFLICT (content): Merge conflict in mm/Makefile
Applying: kmemcheck: arch/x86/mm/init.c merge fix
Merging generic-ipi/auto-generic-ipi-next
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
Merging sparseirq/auto-sparseirq-next
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
Merging watchdog/master
Merging proc/proc
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Applying: proc: remove a new user of proc_dir_entry::owner
Merging bdev/master
Merging dwmw2-iommu/master
Merging cputime/cputime
Merging osd/linux-next
CONFLICT (add/add): Merge conflict in drivers/scsi/osd/osd_initiator.c
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
Merging scsi-post-merge/master
[master f4ed012] Revert "[SCSI] mpt2sas v00.100.11.15"

--Signature=_Wed__18_Mar_2009_17_38_30_+1100_G65W4vEAHZN5Qg9T
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknAluYACgkQjjKRsyhoI8zmoACgvchaRPPdgJbHMx8tVyt4H6Cr
sPcAnj5rtOirtDWZl3siEjQvkWAIiLvR
=YPIs
-----END PGP SIGNATURE-----

--Signature=_Wed__18_Mar_2009_17_38_30_+1100_G65W4vEAHZN5Qg9T--
