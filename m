Return-Path: <linux-kernel-owner+w=401wt.eu-S1753446AbYDHJwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbYDHJwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 05:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751818AbYDHJwL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 05:52:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41223 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbYDHJwJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 05:52:09 -0400
Date: Tue, 8 Apr 2008 19:51:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for April 8
Message-Id: <20080408195158.49f646ed.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Apr_2008_19_51_58_+1000_Zd24_4=5zymU4urd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Apr_2008_19_51_58_+1000_Zd24_4=5zymU4urd
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

We are up to 54 trees, more are welcome (even if they are currently
empty).  Thanks to those who have contributed, and to those who haven't,
please do.

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
Created commit 172a87a: Revert "V4L/DVB (7497): pvrusb2: add new usb pid fo=
r 73xxx models"
Merging quilt/driver-core
Merging quilt/pci
Merging quilt/usb
Merging x86/for-akpm
Merging sched/for-akpm
Applying kernel-sched.c-needs-linux-tick.h.patch
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
CONFLICT (content): Merge conflict in arch/x86/kernel/setup_64.c
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
Merging sched-latest/latest
CONFLICT (content): Merge conflict in kernel/sched.c
CONFLICT (content): Merge conflict in lib/Kconfig.debug
Merging semaphore/semaphore
Merging quilt/ldp
Created commit b88cd41: Revert "aectc: add the aectc driver"
Applying parport_pc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying nsc-ircc: wrap PNP probe code in #ifdef CONFIG_PNP
Applying smsc-ircc2: wrap PNP probe code in #ifdef CONFIG_PNP

--Signature=_Tue__8_Apr_2008_19_51_58_+1000_Zd24_4=5zymU4urd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH+0BJTgG2atn1QN8RAso5AKCFM9F8AzxldC11LV7Ja/jXOKlffwCfWLS7
dzVPzkR0QD02vd4yGJ91i14=
=b6zF
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Apr_2008_19_51_58_+1000_Zd24_4=5zymU4urd--
