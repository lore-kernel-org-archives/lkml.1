Return-Path: <linux-kernel-owner+w=401wt.eu-S1764603AbYD1FuE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764603AbYD1FuE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2008 01:50:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751605AbYD1Ftx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Apr 2008 01:49:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50984 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355AbYD1Ftw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2008 01:49:52 -0400
Date: Mon, 28 Apr 2008 15:49:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 28
Message-Id: <20080428154941.3b13014e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta2 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Apr_2008_15_49_41_+1000_Dln61zqvMrPTgNNQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Apr_2008_15_49_41_+1000_Dln61zqvMrPTgNNQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next tree is called next-20080428a.  I had to add a commit
removing two top level localversion-.. files as they caused the creation
of utsrelease.h to fail.  So if you fetched 20080428, please fetch the
new one.

Changes since next-20080424:

The HTC PASIC3 LED/DS1WM chip support has been fixed up.

The 'driver core: remove no longer used "struct class_device"' patch
breakage has been fixed.

Greg has given up the PCI tree.  I will add the new one when it is ready.

Conflicts continue to disappear due to code being merged upstream.  Also
several minor/whitespace conflicts have turned up due to merging slightly
different versions of patches than what is in the linux-next tree.

A new tree: sempahore-removal.  This immediately caused a build problem -
patch applied an reported.

The conflict between the x86-latest and kvm trees has gone.

The firesat driver now builds ok, but the appleir has build problems and
has been reverted.

I am still carrying the PNP fixup patches.
----------------------------------------------------------------------------

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64. After the
final fixups, it is also built with powerpc allnoconfig,
44x/ebony_defconfig and allyesconfig.

Below is a summary of the state of the merge.

We are up to 58 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/, the guys at http://test.kernel.org/ and Randy
Dunlap for doing many randconfig builds.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Merging origin/master
Merging x86-fixes/for-linus
Merging sched-fixes/for-linus
Merging powerpc-merge/merge
Merging scsi-rc-fixes/master
Merging net-current/master
Merging quilt/driver-core
CONFLICT (content): Merge conflict in drivers/net/phy/phy_device.c
Merging quilt/usb
CONFLICT (content): Merge conflict in drivers/input/joystick/xpad.c
CONFLICT (content): Merge conflict in drivers/usb/core/hub.c
CONFLICT (content): Merge conflict in drivers/usb/core/quirks.c
CONFLICT (content): Merge conflict in drivers/usb/host/Kconfig
CONFLICT (content): Merge conflict in include/linux/usb.h
Merging x86/for-akpm
Merging sched/for-akpm
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
CONFLICT (rename/delete): Renamed Documentation/smart-config.txt->Documenta=
tion/kbuild/smart-config.txt in quilt/kernel-doc and deleted in HEAD
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
Merging acpi/test
CONFLICT (content): Merge conflict in arch/x86/kernel/apm_32.c
Merging blackfin/for-linus
Merging nfsd/nfsd-next
CONFLICT (add/add): Merge conflict in Documentation/filesystems/nfs-rdma.txt
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
Merging dlm/next
Merging scsi/master
Merging ia64/test
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging selinux/for-akpm
Merging quilt/m68k
Merging powerpc/powerpc-next
Merging hrt/mm
Merging lblnet/master
Merging ext4/next
CONFLICT (content): Merge conflict in fs/jbd2/journal.c
CONFLICT (content): Merge conflict in fs/jbd2/revoke.c
Merging 4xx/next
Merging async_tx/next
Merging udf/for_next
Merging security-testing/next
Merging net/master
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
Merging semaphore/semaphore
CONFLICT (content): Merge conflict in Documentation/DocBook/kernel-locking.=
tmpl
Merging semaphore-removal/semaphore-removal
Applying idr.h-needs-spinlock.h
Merging x86-latest/latest
CONFLICT (content): Merge conflict in include/asm-x86/reboot.h
Merging sched-latest/latest
CONFLICT (content): Merge conflict in arch/x86/kernel/e820_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/fault.c
CONFLICT (content): Merge conflict in arch/x86/mm/init_64.c
CONFLICT (content): Merge conflict in arch/x86/mm/numa_64.c
CONFLICT (content): Merge conflict in arch/x86/pci/k8-bus_64.c
CONFLICT (content): Merge conflict in arch/x86/pci/mmconfig-shared.c
CONFLICT (content): Merge conflict in include/asm-x86/reboot.h
CONFLICT (content): Merge conflict in init/main.c
CONFLICT (content): Merge conflict in kernel/fork.c
CONFLICT (content): Merge conflict in mm/bootmem.c
Merging quilt/ldp
Created commit 88849e6: Revert "Input: add appleir driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP

--Signature=_Mon__28_Apr_2008_15_49_41_+1000_Dln61zqvMrPTgNNQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIFWV9TgG2atn1QN8RArDxAKCXLZo4w3Q6g66NimCHhX+ANQMnkwCferJO
+DrqrnOsn3mVlrBWjqo8Iqk=
=KtvP
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Apr_2008_15_49_41_+1000_Dln61zqvMrPTgNNQ--
