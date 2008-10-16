Return-Path: <linux-kernel-owner+w=401wt.eu-S1756289AbYJPKfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289AbYJPKfx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2008 06:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756344AbYJPKek
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Oct 2008 06:34:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50187 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756246AbYJPKeh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2008 06:34:37 -0400
Date: Thu, 16 Oct 2008 21:18:11 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for October 16
Message-Id: <20081016211811.a523c8f2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__16_Oct_2008_21_18_11_+1100_/a6tlkTzU2urGQkg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Oct_2008_21_18_11_+1100_/a6tlkTzU2urGQkg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's tree will not build for powerpc allyesconfig, sparc(32) defconfig
and probably some other configurations.  I just ran out of time trying to
fix all the errors. :-(

New trees:
	iommu
	watchdog
	proc

Dropped trees:
	tests (because its future is in doubt and it has conflicts)
	hid (too many conflicts for me to fix today)
	v4l-dvb (the tree is a mess)
	sparseirq (too many conflicts for me to fix today)
	scsi-post-merge (appears to be superceded)
	bdev (too many conflicts for me to fix today)

The actual changes from Sept 19 are not really relevant at this point -
those interested can read the summary below or the actual merge log in
the tree.

I have also applied the following patches for known problems:

	sparc: qlogicpti fallout from sbus removal
	tip-core/powerpc: phys_addr_t has moved to linux/types.h
	v9fs: don't export static functions
	tpm: don't export static functions
	mfd/wm8350: don't export static functions

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
final fixups, it is also built with powerpc allnoconfig,
44x_defconfig and allyesconfig and i386, sparc and sparc64 defconfig.

Below is a summary of the state of the merge.

We are up to 120 trees (counting Linus' and 14 trees of patches pending for
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
$ git cherry-pick c917a47312d1dcfadbb8d558fab121d4d6467d10
Created commit 5f21bf1: Revert "MIPS: DS1286: New RTC driver"
Created commit dbe292a: Revert "RTC: M48T35: new RTC driver"
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging sparc-current/master
Merging sound-current/for-linus
Merging arm-current/master
Merging pci-current/for-linus
Merging wireless-current/master
Merging kbuild-current/master
Merging quilt/driver-core.current
Merging quilt/usb.current
Merging cpufreq-current/fixes
Merging input-current/for-linus
Merging md-current/for-2.6.26
Merging dwmw2/master
Merging arm/devel
Merging avr32/avr32-arch
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging quilt/m68k
Merging m68knommu/for-next
Merging mips/mips-for-linux-next
Merging parisc/master
CONFLICT (rename/delete): Renamed include/asm-parisc/a.out.h->arch/parisc/i=
nclude/asm/a.out.h in parisc/master and deleted in HEAD
$ git rm -f arch/parisc/include/asm/a.out.h
Merging powerpc/next
Merging 4xx/next
Merging galak/powerpc-next
Merging pxa/for-next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging x86/auto-x86-next
Merging xtensa/master
Merging quilt/driver-core
Merging quilt/usb
Created commit 12e0536: Revert "USB: ohci: add support for tmio-ohci cell"
Created commit e5065ec: Revert "USB: remove info() macro from usb.h"
Created commit 7ba38cf: Revert "USB: remove warn() macro from usb.h"
Merging tip-core/auto-core-next
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/types.h
CONFLICT (content): Merge conflict in arch/powerpc/platforms/Kconfig.cputype
Merging cpus4096/auto-cpus4096-next
CONFLICT (content): Merge conflict in include/asm-x86/smp.h
Merging ftrace/auto-ftrace-next
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/module.c
CONFLICT (add/add): Merge conflict in scripts/bootgraph.pl
Merging genirq/auto-genirq-next
Merging safe-poison-pointers/auto-safe-poison-pointers-next
Merging sched/auto-sched-next
Merging stackprotector/auto-stackprotector-next
CONFLICT (content): Merge conflict in kernel/fork.c
Merging timers/auto-timers-next
Applying DECLARE_PER_CPU needs linux/percpu.h
Merging pci/linux-next
CONFLICT (content): Merge conflict in drivers/pci/pcie/aspm.c
Created commit ac06c0d: Revert "powerpc/PCI: Add legacy PCI access via sysf=
s"
Merging quilt/device-mapper
Merging hid/mm
CONFLICT (content): Merge conflict in drivers/hid/Kconfig
CONFLICT (content): Merge conflict in drivers/hid/Makefile
CONFLICT (content): Merge conflict in drivers/hid/hid-core.c
CONFLICT (add/add): Merge conflict in drivers/hid/hid-dell.c
CONFLICT (add/add): Merge conflict in drivers/hid/hid-dummy.c
CONFLICT (add/add): Merge conflict in drivers/hid/hid-ids.h
CONFLICT (content): Merge conflict in drivers/hid/usbhid/hid-core.c
CONFLICT (content): Merge conflict in include/linux/hid.h
$ git reset --hard
Merging quilt/i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/stable
CONFLICT (rename/add): Renamed arch/mips/au1000/mtx-1/init.c->arch/mips/pci=
/pci-bcm47xx.c in HEAD. arch/mips/pci/pci-bcm47xx.c added in v4l-dvb/stable
CONFLICT (content): Merge conflict in Documentation/usb/anchors.txt
CONFLICT (content): Merge conflict in Documentation/video4linux/CARDLIST.cx=
88
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in arch/arm/include/asm/io.h
CONFLICT (content): Merge conflict in arch/arm/mach-omap1/mcbsp.c
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/mcbsp.c
CONFLICT (content): Merge conflict in arch/arm/mach-versatile/core.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/devices.c
CONFLICT (content): Merge conflict in arch/arm/plat-omap/include/mach/mcbsp=
.h
CONFLICT (content): Merge conflict in arch/arm/plat-omap/mcbsp.c
CONFLICT (content): Merge conflict in arch/avr32/boards/atstk1000/atstk1002=
.c
CONFLICT (content): Merge conflict in arch/powerpc/include/asm/sections.h
CONFLICT (content): Merge conflict in arch/s390/lib/delay.c
CONFLICT (content): Merge conflict in arch/sparc64/kernel/pci_psycho.c
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/mtrr/main.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/setup.c
CONFLICT (content): Merge conflict in drivers/ata/pata_marvell.c
CONFLICT (content): Merge conflict in drivers/ide/ide-dma.c
CONFLICT (content): Merge conflict in drivers/ide/pci/hpt366.c
CONFLICT (content): Merge conflict in drivers/media/dvb/dvb-core/dvb_fronte=
nd.c
CONFLICT (content): Merge conflict in drivers/media/dvb/dvb-usb/Kconfig
CONFLICT (add/add): Merge conflict in drivers/media/dvb/dvb-usb/af9015.c
CONFLICT (content): Merge conflict in drivers/media/dvb/dvb-usb/dib0700_dev=
ices.c
CONFLICT (content): Merge conflict in drivers/media/dvb/dvb-usb/dvb-usb-ids=
.h
CONFLICT (content): Merge conflict in drivers/media/dvb/dvb-usb/dw2102.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/af9013.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/af9013_pr=
iv.h
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/cx24116.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/stb6000.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/stv0288.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/frontends/stv0288.h
CONFLICT (content): Merge conflict in drivers/media/video/cx88/cx88-cards.c
CONFLICT (content): Merge conflict in drivers/media/video/cx88/cx88-dvb.c
CONFLICT (content): Merge conflict in drivers/media/video/cx88/cx88.h
CONFLICT (content): Merge conflict in drivers/media/video/em28xx/em28xx-dvb=
.c
CONFLICT (content): Merge conflict in drivers/media/video/gspca/Kconfig
CONFLICT (content): Merge conflict in drivers/media/video/gspca/Makefile
CONFLICT (content): Merge conflict in drivers/media/video/gspca/gspca.c
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_bridge.h
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_core.c
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_mt9m111.c
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_mt9m111.h
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_ov9650.h
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_po1030.h
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_s5k4aa.h
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_s5k83a.c
CONFLICT (add/add): Merge conflict in drivers/media/video/gspca/m5602/m5602=
_s5k83a.h
CONFLICT (content): Merge conflict in drivers/media/video/gspca/sonixj.c
CONFLICT (content): Merge conflict in drivers/media/video/gspca/t613.c
CONFLICT (content): Merge conflict in drivers/media/video/ivtv/ivtv-ioctl.c
CONFLICT (content): Merge conflict in drivers/media/video/saa5249.c
CONFLICT (content): Merge conflict in drivers/media/video/v4l2-dev.c
CONFLICT (content): Merge conflict in drivers/media/video/zr364xx.c
CONFLICT (content): Merge conflict in drivers/memstick/core/mspro_block.c
CONFLICT (content): Merge conflict in drivers/mmc/host/atmel-mci.c
CONFLICT (content): Merge conflict in drivers/net/e1000e/ich8lan.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath9k/beacon.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ath9k/core.h
CONFLICT (content): Merge conflict in drivers/net/wireless/ath9k/main.c
CONFLICT (content): Merge conflict in drivers/pci/intel-iommu.c
CONFLICT (content): Merge conflict in drivers/pci/pcie/aspm.c
CONFLICT (content): Merge conflict in drivers/pci/probe.c
CONFLICT (content): Merge conflict in drivers/pcmcia/ds.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_fc.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_fsf.c
CONFLICT (content): Merge conflict in drivers/s390/scsi/zfcp_qdio.c
CONFLICT (content): Merge conflict in drivers/usb/serial/option.c
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_super.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_log.c
CONFLICT (delete/modify): include/asm-parisc/sections.h deleted in HEAD and=
 modified in v4l-dvb/stable. Version v4l-dvb/stable of include/asm-parisc/s=
ections.h left in tree.
CONFLICT (content): Merge conflict in include/asm-x86/cpufeature.h
CONFLICT (content): Merge conflict in include/asm-x86/idle.h
CONFLICT (content): Merge conflict in include/linux/dvb/frontend.h
CONFLICT (content): Merge conflict in include/linux/ide.h
CONFLICT (content): Merge conflict in include/media/ir-common.h
CONFLICT (content): Merge conflict in include/media/v4l2-dev.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/hrtimer.c
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in lib/swiotlb.c
CONFLICT (content): Merge conflict in net/core/dev.c
CONFLICT (content): Merge conflict in net/ipv6/tcp_ipv6.c
CONFLICT (content): Merge conflict in net/key/af_key.c
CONFLICT (content): Merge conflict in net/netfilter/nf_conntrack_proto_gre.c
CONFLICT (content): Merge conflict in net/sctp/sm_statefuns.c
CONFLICT (content): Merge conflict in net/xfrm/xfrm_policy.c
CONFLICT (content): Merge conflict in net/xfrm/xfrm_state.c
$ git reset --hard
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in drivers/acpi/Kconfig
CONFLICT (content): Merge conflict in drivers/acpi/scan.c
CONFLICT (content): Merge conflict in drivers/pnp/Makefile
Applying drivers has no idle subdirectory
Applying acpi: acpi_os_hotplug_execute needs to be exported
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging ubi/linux-next
Merging kvm/master
CONFLICT (content): Merge conflict in arch/x86/kvm/i8254.c
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
CONFLICT (content): Merge conflict in fs/ext4/namei.c
Applying vfs: fix up merge of ext4
Merging sound/for-next
Merging cpufreq/next
Merging v9fs/for-next
Merging quilt/rr
CONFLICT (content): Merge conflict in kernel/module.c
Merging cifs/master
Merging mmc/next
Merging gfs2/master
Merging input/next
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
Merging semaphore/semaphore
Merging semaphore-removal/semaphore-removal
CONFLICT (content): Merge conflict in net/9p/trans_virtio.c
Merging bkl-removal/bkl-removal
Merging trivial/next
CONFLICT (content): Merge conflict in Documentation/edac.txt
CONFLICT (content): Merge conflict in include/linux/securebits.h
Merging ubifs/linux-next
Merging lsm/for-next
Merging block/for-next
CONFLICT (content): Merge conflict in include/linux/interrupt.h
CONFLICT (content): Merge conflict in kernel/softirq.c
Merging embedded/master
Merging firmware/master
CONFLICT (content): Merge conflict in drivers/scsi/qlogicpti.c
CONFLICT (content): Merge conflict in firmware/WHENCE
Merging pcmcia/master
Merging battery/master
CONFLICT (content): Merge conflict in drivers/power/Makefile
Merging leds/for-mm
Merging backlight/for-mm
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
CONFLICT (content): Merge conflict in drivers/md/md.c
Applying Fix do_mounts_md use of msleep
Merging kmemcheck/auto-kmemcheck-next
CONFLICT (content): Merge conflict in MAINTAINERS
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in mm/Makefile
CONFLICT (content): Merge conflict in mm/slab.c
CONFLICT (content): Merge conflict in mm/slub.c
Merging generic-ipi/auto-generic-ipi-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-linus
Merging security-testing/next
Merging lblnet/master
Merging quilt/ttydev
Merging agp/agp-next
Merging creds/next-creds-subsys
CONFLICT (content): Merge conflict in fs/namespace.c
CONFLICT (content): Merge conflict in fs/nfsd/nfs4recover.c
CONFLICT (content): Merge conflict in include/linux/sched.h
CONFLICT (content): Merge conflict in kernel/exit.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in kernel/signal.c
CONFLICT (content): Merge conflict in net/9p/client.c
CONFLICT (content): Merge conflict in security/selinux/hooks.c
Merging oprofile/auto-oprofile-next
Merging fastboot/auto-fastboot-next
CONFLICT (content): Merge conflict in drivers/md/Kconfig
CONFLICT (content): Merge conflict in include/linux/init.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (add/add): Merge conflict in scripts/bootgraph.pl
Merging sparseirq/auto-sparseirq-next
CONFLICT (content): merge conflict in arch/x86/kernel/traps.c
CONFLICT (delete/modify): arch/x86/kernel/apic_64.c deleted in sparseirq/au=
to-sparseirq-next and modified in HEAD. Version HEAD of arch/x86/kernel/api=
c_64.c left in tree.
CONFLICT (content): Merge conflict in arch/x86/kernel/cpu/common.c
CONFLICT (add/add): Merge conflict in arch/x86/kernel/dumpstack_32.c
CONFLICT (add/add): Merge conflict in arch/x86/kernel/dumpstack_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_32.c
CONFLICT (content): Merge conflict in arch/x86/kernel/process_64.c
CONFLICT (content): Merge conflict in arch/x86/kernel/smpboot.c
CONFLICT (content): Merge conflict in arch/x86/mm/ioremap.c
CONFLICT (content): Merge conflict in arch/x86/oprofile/nmi_int.c
CONFLICT (content): Merge conflict in drivers/serial/8250.c
CONFLICT (content): Merge conflict in include/asm-x86/fixmap_64.h
CONFLICT (content): Merge conflict in include/asm-x86/pgtable.h
CONFLICT (content): Merge conflict in include/linux/pci_ids.h
CONFLICT (content): Merge conflict in kernel/irq/chip.c
$ git reset --hard
Merging iommu/auto-iommu-next
Merging uwb/for-upstream
CONFLICT (content): Merge conflict in Documentation/ABI/testing/sysfs-bus-u=
sb
Merging watchdog/master
Merging proc/proc
Applying sparc: qlogicpti fallout from sbus removal
Applying tip-core/powerpc: phys_addr_t has moved to linux/types.h
Applying v9fs: don't export static functions
Applying tpm: don't export static functions
Applying mfd/wm8350: don't export static functions

--Signature=_Thu__16_Oct_2008_21_18_11_+1100_/a6tlkTzU2urGQkg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkj3FOMACgkQjjKRsyhoI8zzGgCfT3XUoEevbB3/fNEhZpcXfXfF
9tgAoIErgrJ8q7BS/6KAFCXTZCfvKHYr
=OgeN
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Oct_2008_21_18_11_+1100_/a6tlkTzU2urGQkg--
