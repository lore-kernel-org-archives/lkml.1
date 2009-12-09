Return-Path: <linux-kernel-owner+w=401wt.eu-S1756745AbZLIGrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756745AbZLIGrn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 01:47:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756693AbZLIGrk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 01:47:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59886 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756688AbZLIGrj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 01:47:39 -0500
Date: Wed, 9 Dec 2009 17:47:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 9
Message-Id: <20091209174738.3b8c28a6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_17_47_38_+1100_pqJXxw+HG=KnQ=_a"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_17_47_38_+1100_pqJXxw+HG=KnQ=_a
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

My usual call for calm: please do not put stuff destined for 2.6.34 into
linux-next trees until after 2.6.33-rc1.

Changes since 20091208:

Since Linus is now merging trees into his, various conflicts move from
tree to tree.

The omap tree lost its conflict.

The samsung tree no longer needed a fixup and lost all its conflicts.

The powerpc tree gained a conflict against Linus' tree.

The ext3 tree lost its conflict.

The kbuild tree inherited a merge fixup from the net tree.

The kvm tree lost its conflicts.

The net tree lost its merge fixups.

The kgdb tree lost its conflict.

The slab tree lost its build failure.

The omap_dss2 tree gained a conflict against the omap tree.

The tip tree gained a conflict against Linus' tree.

The percpu tree lost 2 conflicts and its merge fixup (due to changes in
the kgdb and tip trees).

The hwpoison tree lost its build failure.

The sysctl tree lost its conflicts.

The tty tree gained a conflict agains the trivial tree.

The usb tree gained a build failure for which I reverted a commit.

The staging tree gained a conflict against Linus' tree.

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

We are up to 155 trees (counting Linus' and 22 trees of patches pending
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
Merging msm/for-next
Merging omap/for-next
Merging pxa/for-next
Merging samsung/next-samsung
Merging avr32/avr32-arch
CONFLICT (content): Merge conflict in arch/avr32/mach-at32ap/include/mach/c=
pu.h
Merging blackfin/for-linus
Merging cris/for-next
Merging ia64/test
Merging m68k/for-next
Merging m68knommu/for-next
CONFLICT (content): Merge conflict in arch/m68k/include/asm/ptrace.h
Merging microblaze/next
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in arch/mips/Kconfig
CONFLICT (content): Merge conflict in arch/mips/Makefile
CONFLICT (content): Merge conflict in arch/mips/include/asm/ftrace.h
CONFLICT (add/add): Merge conflict in arch/mips/kernel/ftrace.c
CONFLICT (add/add): Merge conflict in arch/mips/kernel/mcount.S
CONFLICT (content): Merge conflict in drivers/pcmcia/Makefile
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging parisc/next
Merging powerpc/next
CONFLICT (content): Merge conflict in include/linux/kvm.h
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
Merging ceph/for-next
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
Merging nfsd/nfsd-next
Merging nilfs2/for-next
Merging ocfs2/linux-next
Merging squashfs/master
Merging udf/for_next
Merging v9fs/for-next
CONFLICT (add/add): Merge conflict in fs/9p/cache.c
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
Merging pci/linux-next
CONFLICT (content): Merge conflict in arch/x86/kernel/amd_iommu_init.c
CONFLICT (content): Merge conflict in drivers/pci/dmar.c
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
Applying: net: fix for utsrelease.h moving to generated
Merging kconfig/for-next
Merging ide/master
Merging libata/NEXT
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in drivers/pci/hotplug/acpiphp_glue.c
Merging ieee1394/for-next
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv-13=
94.c
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv-av=
c.c
CONFLICT (add/add): Merge conflict in drivers/media/dvb/firewire/firedtv-fw=
.c
CONFLICT (content): Merge conflict in drivers/media/dvb/firewire/firedtv.h
Merging ubi/linux-next
Merging kvm/linux-next
Merging dlm/next
Merging scsi/master
Merging async_tx/next
Merging net/master
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/devices/m25p80.c
CONFLICT (content): Merge conflict in drivers/mtd/maps/pcmciamtd.c
CONFLICT (delete/modify): drivers/mtd/nand/excite_nandflash.c deleted in HE=
AD and modified in mtd/master. Version mtd/master of drivers/mtd/nand/excit=
e_nandflash.c left in tree.
CONFLICT (content): Merge conflict in drivers/mtd/nand/pxa3xx_nand.c
CONFLICT (content): Merge conflict in kernel/printk.c
$ git rm -f drivers/mtd/nand/excite_nandflash.c
Merging crypto/master
Merging sound/for-next
Merging cpufreq/next
CONFLICT (content): Merge conflict in include/acpi/processor.h
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/arm/kernel/vmlinux.lds.S
Applying: modpost: autoconf.h has moved to include/generated
Merging mmc/next
Merging tmio-mmc/linux-next
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
Merging battery/master
Merging leds/for-mm
Merging backlight/for-mm
CONFLICT (content): Merge conflict in drivers/platform/x86/thinkpad_acpi.c
Merging kgdb/kgdb-next
Merging slab/for-next
Merging uclinux/for-next
Merging md/for-next
Merging mfd/for-next
Merging hdlc/hdlc-next
Merging drm/drm-next
Merging voltage/for-next
CONFLICT (content): Merge conflict in drivers/mfd/Kconfig
CONFLICT (content): Merge conflict in drivers/mfd/Makefile
Merging security-testing/next
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
CONFLICT (content): Merge conflict in Documentation/video4linux/gspca.txt
CONFLICT (content): Merge conflict in drivers/md/dm-crypt.c
CONFLICT (content): Merge conflict in drivers/media/video/cx18/cx18-mailbox=
.h
CONFLICT (content): Merge conflict in kernel/irq/chip.c
Merging audit/for-next
Merging quilt/aoe
Merging suspend/linux-next
Merging bluetooth/master
Merging fsnotify/for-next
CONFLICT (content): Merge conflict in arch/x86/ia32/ia32entry.S
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_32.h
CONFLICT (content): Merge conflict in arch/x86/include/asm/unistd_64.h
CONFLICT (content): Merge conflict in arch/x86/kernel/syscall_table_32.S
CONFLICT (content): Merge conflict in fs/afs/write.c
CONFLICT (content): Merge conflict in fs/cifs/dir.c
CONFLICT (content): Merge conflict in fs/ubifs/file.c
CONFLICT (content): Merge conflict in include/asm-generic/fcntl.h
CONFLICT (content): Merge conflict in net/compat.c
CONFLICT (content): Merge conflict in net/socket.c
Merging irda/for-next
CONFLICT (content): Merge conflict in drivers/net/irda/irda-usb.c
Merging hwlat/for-linus
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
CONFLICT (content): Merge conflict in arch/arm/mach-omap2/io.c
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/Kconfig
CONFLICT (content): Merge conflict in arch/x86/include/asm/x86_init.h
CONFLICT (content): Merge conflict in arch/x86/kernel/x86_init.c
CONFLICT (content): Merge conflict in kernel/Makefile
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/x86/kvm/svm.c
CONFLICT (content): Merge conflict in mm/slab.c
Merging workqueues/for-next
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
CONFLICT (content): Merge conflict in MAINTAINERS
Merging sysctl/master
Merging quilt/driver-core
Merging quilt/tty
CONFLICT (content): Merge conflict in drivers/mmc/card/sdio_uart.c
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/Makefile
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_lab=
pc_cs.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_mio=
_cs.c
CONFLICT (content): Merge conflict in drivers/staging/vt6655/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/vt6656/Kconfig
[master c435540] Revert "USB: prepare for changover to Runtime PM framework"
Merging scsi-post-merge/master

--Signature=_Wed__9_Dec_2009_17_47_38_+1100_pqJXxw+HG=KnQ=_a
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksfSAsACgkQjjKRsyhoI8xrKQCfchHV+fsUK5TyPr1ClG8UgKcB
RIoAn3Wougp9ruDFIevnGdGl8wdxso73
=cK2U
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_17_47_38_+1100_pqJXxw+HG=KnQ=_a--
