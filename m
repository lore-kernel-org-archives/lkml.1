Return-Path: <linux-kernel-owner+w=401wt.eu-S1753750AbZLAIDC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753750AbZLAIDC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 03:03:02 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753656AbZLAIDB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 03:03:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49486 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753600AbZLAIC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 03:02:59 -0500
Date: Tue, 1 Dec 2009 19:03:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for December 1
Message-Id: <20091201190301.0fb7abad.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_19_03_01_+1100_Q2fMCfZjbFVHFTJU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_19_03_01_+1100_Q2fMCfZjbFVHFTJU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since 20091130:

The origin tree gained a build failure for which I reverted a commit.
Ingo also reported another build failure for which I applied his patch.

The pxa tree lost its build failure.

The powerpc tree gained a build failure for which I reverted a commit.

The net tree gained a conflict against the wireless-current tree.

The mtd tree gained a conflict against the pxa tree.

The pcmcia tree lost 2 conflicts but gained another against the arm tree.

The trivial tree lost a conflict.

The percpu tree gained a conflict against the slab tree.

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

We are up to 154 trees (counting Linus' and 21 trees of patches pending
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
[master c298b36] Revert "FS-Cache: Handle pages pending storage that get ev=
icted under OOM conditions"
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
Merging mips/mips-for-linux-next
CONFLICT (content): Merge conflict in arch/mips/Kconfig
CONFLICT (content): Merge conflict in arch/mips/Makefile
CONFLICT (content): Merge conflict in arch/mips/include/asm/ftrace.h
CONFLICT (add/add): Merge conflict in arch/mips/kernel/ftrace.c
CONFLICT (add/add): Merge conflict in arch/mips/kernel/mcount.S
CONFLICT (content): Merge conflict in drivers/net/au1000_eth.c
CONFLICT (content): Merge conflict in drivers/staging/octeon/ethernet.c
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging parisc/next
Merging powerpc/next
CONFLICT (content): Merge conflict in drivers/serial/of_serial.c
Merging 4xx/next
Merging 52xx-and-virtex/next
Merging galak/next
Merging s390/features
Merging sh/master
Merging sparc/master
Merging xtensa/master
[master 6f607ee] Revert "powerpc/mm: Fix bug in pagetable cache cleanup wit=
h CONFIG_PPC_SUBPAGE_PROT"
Merging ceph/for-next
Merging cifs/master
Merging configfs/linux-next
Merging ecryptfs/next
Merging ext3/for_next
CONFLICT (content): Merge conflict in fs/cifs/dir.c
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
Merging ubifs/linux-next
Merging xfs/master
Merging reiserfs-bkl/reiserfs/kill-bkl
Merging vfs/for-next
Merging pci/linux-next
Merging hid/for-next
Merging quilt/i2c
Merging bjdooks-i2c/next-i2c
Merging quilt/jdelvare-hwmon
Merging quilt/kernel-doc
Merging v4l-dvb/master
Merging kbuild/for-next
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
CONFLICT (content): Merge conflict in net/mac80211/ht.c
CONFLICT (delete/modify): net/wireless/wext.c deleted in net/master and mod=
ified in HEAD. Version HEAD of net/wireless/wext.c left in tree.
$ git rm -f net/wireless/wext.c
Applying: wext: merg fixup
Merging wireless/master
Merging mtd/master
CONFLICT (content): Merge conflict in drivers/mtd/devices/m25p80.c
CONFLICT (content): Merge conflict in drivers/mtd/nand/pxa3xx_nand.c
Merging crypto/master
Merging sound/for-next
Applying: ASoC: tlv320dac33: Change RT wq to singlethread wq
Merging cpufreq/next
CONFLICT (content): Merge conflict in include/acpi/processor.h
Merging quilt/rr
CONFLICT (content): Merge conflict in arch/arm/kernel/vmlinux.lds.S
Applying: modpost: autoconf.h has moved to include/generated
Applying: staging: fix a silly typo
Applying: wireless: fix for mismerge
Merging mmc/next
Merging tmio-mmc/linux-next
Merging input/next
Merging lsm/for-next
Merging block/for-next
Merging quilt/device-mapper
Merging embedded/master
Merging firmware/master
Merging pcmcia/master
CONFLICT (content): Merge conflict in drivers/mtd/maps/pcmciamtd.c
CONFLICT (content): Merge conflict in drivers/net/pcmcia/fmvj18x_cs.c
CONFLICT (content): Merge conflict in drivers/net/pcmcia/nmclan_cs.c
CONFLICT (content): Merge conflict in drivers/net/wireless/ray_cs.c
CONFLICT (content): Merge conflict in drivers/pcmcia/Makefile
CONFLICT (content): Merge conflict in drivers/pcmcia/sa1100_h3600.c
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
CONFLICT (content): Merge conflict in Documentation/dontdiff
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
CONFLICT (content): Merge conflict in net/socket.c
Merging irda/for-next
Merging hwlat/for-linus
CONFLICT (content): Merge conflict in drivers/misc/Makefile
Merging drbd/for-jens
Merging catalin/for-next
Merging alacrity/linux-next
CONFLICT (content): Merge conflict in include/linux/Kbuild
CONFLICT (content): Merge conflict in lib/Kconfig
Merging i7core_edac/linux_next
Applying: i7core_edac: do not export static functions
Merging devicetree/next-devicetree
Merging spi/next-spi
Merging limits/writable_limits
Merging omap_dss2/for-next
Merging tip/auto-latest
CONFLICT (content): Merge conflict in arch/x86/kernel/kgdb.c
CONFLICT (content): Merge conflict in kernel/Makefile
CONFLICT (content): Merge conflict in kernel/irq/chip.c
CONFLICT (content): Merge conflict in kernel/printk.c
CONFLICT (content): Merge conflict in scripts/recordmcount.pl
Merging edac-amd/for-next
Merging oprofile/for-next
Merging percpu/for-next
CONFLICT (content): Merge conflict in arch/powerpc/platforms/pseries/hvCall=
.S
CONFLICT (content): Merge conflict in arch/x86/kvm/svm.c
CONFLICT (content): Merge conflict in kernel/softlockup.c
CONFLICT (content): Merge conflict in mm/slab.c
Applying: percpu: merge fixup for variable renaming
Merging workqueues/for-next
CONFLICT (content): Merge conflict in init/Kconfig
CONFLICT (content): Merge conflict in kernel/sched.c
Merging sfi/sfi-test
Merging asm-generic/next
Merging hwpoison/hwpoison
Merging sysctl/master
CONFLICT (content): Merge conflict in net/ipv6/addrconf.c
CONFLICT (content): Merge conflict in net/sctp/sysctl.c
Merging quilt/driver-core
Merging quilt/tty
Merging quilt/usb
CONFLICT (content): Merge conflict in arch/arm/plat-mxc/Makefile
Merging quilt/staging
CONFLICT (content): Merge conflict in drivers/staging/Kconfig
CONFLICT (content): Merge conflict in drivers/staging/Makefile
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_lab=
pc_cs.c
CONFLICT (content): Merge conflict in drivers/staging/comedi/drivers/ni_mio=
_cs.c
Merging scsi-post-merge/master
Applying: slow-work: Fix build bug in the !CONFIG_MODULES case

--Signature=_Tue__1_Dec_2009_19_03_01_+1100_Q2fMCfZjbFVHFTJU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksUzbUACgkQjjKRsyhoI8w+QQCeLqXy8pwz735uemHTRm/AMr/r
A7sAn11xaoJup4QVgyxD3HRk4eyIVYDu
=C34s
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_19_03_01_+1100_Q2fMCfZjbFVHFTJU--
