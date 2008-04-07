Return-Path: <linux-kernel-owner+w=401wt.eu-S1754701AbYDGHB7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701AbYDGHB7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2008 03:01:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750975AbYDGHBv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Apr 2008 03:01:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50620 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158AbYDGHBu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2008 03:01:50 -0400
Date: Mon, 7 Apr 2008 17:01:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 7
Message-Id: <20080407170144.e446de74.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__7_Apr_2008_17_01_44_+1000_b7RLgjMA+S2smx+F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Apr_2008_17_01_44_+1000_b7RLgjMA+S2smx+F
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

New: I have added a branch called "history" that just stitches all the
linux-next trees together.  I am not sure if this will be useful to
anyone.

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

There were a few merge conflicts (fairly trivial) and one build failure
(reverted and notified).  Below is a summary of the state of the merge.

We are up to 51 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests will be at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/ and the guys at http://test.kernel.org/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

Merging origin/master
Created commit 4076487: Revert "V4L/DVB (7497): pvrusb2: add new usb pid fo=
r 73xxx models"
Merging quilt/driver-core
Merging quilt/pci
Merging quilt/usb
Merging quilt/device-mapper
Merging hid/mm
Merging quilt/i2c
Merging quilt/kernel-doc
Merging avr32/avr32-arch
Merging v4l-dvb/stable
Merging s390/features
Merging sh/master
Merging jfs/next
Merging kbuild/master
Merging quilt/ide
CONFLICT (content): Merge conflict in Documentation/ide/ide.txt
CONFLICT (content): Merge conflict in Documentation/kernel-parameters.txt
CONFLICT (content): Merge conflict in drivers/ide/ide.c
Merging libata/NEXT
Merging nfs/linux-next
Merging xfs/master
Merging infiniband/for-next
CONFLICT (content): Merge conflict in drivers/infiniband/hw/amso1100/c2_pro=
vider.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/cxgb3/iwch_prov=
ider.c
CONFLICT (content): Merge conflict in drivers/infiniband/hw/nes/nes_verbs.c
Applying infiniband-fix-2
Merging acpi/test
Merging blackfin/for-linus
Merging nfsd/nfsd-next
Merging ieee1394/for-next
Merging hwmon/testing
Merging ubi/master
Merging kvm/master
CONFLICT (add/add): Merge conflict in include/asm-s390/sysinfo.h
Merging dlm/next
Merging scsi-rc-fixes/master
Merging scsi/master
Merging ia64/test
CONFLICT (content): Merge conflict in arch/ia64/mm/tlb.c
Merging tests/master
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging ocfs2/linux-next
Merging selinux/for-akpm
Merging quilt/m68k
Merging powerpc-merge/merge
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
CONFLICT (content): Merge conflict in MAINTAINERS
Merging galak/powerpc-next
Merging mtd/master
Merging wireless/master
Merging crypto/master
Merging vfs/vfs-2.6.25
CONFLICT (content): Merge conflict in fs/xfs/linux-2.6/xfs_ioctl.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_ialloc.c
CONFLICT (content): Merge conflict in fs/xfs/xfs_sb.h
Merging semaphore/semaphore
Merging quilt/ldp
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP

--Signature=_Mon__7_Apr_2008_17_01_44_+1000_b7RLgjMA+S2smx+F
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH+cbcTgG2atn1QN8RArqtAKCBUfa0b0JA4gZJg4BVhxBXDc7d5ACeM8pj
sok2YPaIxLDBnC7t7YmoCjY=
=uHvU
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Apr_2008_17_01_44_+1000_b7RLgjMA+S2smx+F--
