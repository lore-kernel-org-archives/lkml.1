Return-Path: <linux-kernel-owner+w=401wt.eu-S1753104AbYG1GPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104AbYG1GPs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 02:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbYG1GPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 02:15:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40640 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236AbYG1GPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 02:15:39 -0400
Date: Mon, 28 Jul 2008 16:15:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 28
Message-Id: <20080728161531.7256dcfe.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Jul_2008_16_15_31_+1000_bJZks9OwVvysxWWL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Jul_2008_16_15_31_+1000_bJZks9OwVvysxWWL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Changes since next-20080725:

Temporarily dropped tree: acpi (it is being moved to a new tree and is
just accumulating conflicts against Linus' tree).

Linus' tree lost one build fix patch but gained three more.

The kbuild tree lost its conflicts.

The inifinband tree lost its conflicts.

The mtd tree lost its conflicts.

The vfs tree lost its conflict.

The rr tree lost one its conflict but gained three more against Linus'
tree.

The trivial tree gained a conflict against Linus' tree.

The kmemcheck tree lost its conflict gained two more against Linus' tree.

I have also applied the following patches for known problems:

	hfcmulti is not supported on big endian
	scsi: msleep is declared in delay.h

The sparc(32) defconfig build still fails.

----------------------------------------------------------------------------

Just for interest, this is what is left in linux-next (i.e. isn't in
Linus' tree yet).  This is only an approximation and some have been
merged or requests for merging sent since this was done.

The commit list for each tree was generated using:

git rev-list --pretty=3D'format:%m%H' --no-merges --left-right --cherry-pic=
k \
	origin/master...<head> | sed -n 's/^>//p'

So should have ignored identical patches, but may be confused by fix ups
on one side.

Tree				Commits
----				-------
kvm				1298
xfs				188
sh				64
rr				48
x86				47
ide				30
hdlc				28
kmemcheck			22
stackprotector			19
ubifs				16
voltage				15
driver-core.current		14
ext4				13
arm-current			12
hwmon				12
ocfs2				12
firmware			9
semaphore-removal		9
battery				7
net-current			7
tests				7
tip-core			7
acpi				6
input				6
s390				6
device-mapper			5
i2c				5
trivial				5
dlm				4
driver-core			4
timers				4
v4l-dvb				4
kernel-doc			3
kgdb				3
nfsd				3
sound				3
crypto				2
infiniband			2
safe-poison-pointers		2
sched				2
cpus4096			1
cris				1
drm				1
genirq				1
gfs2				1
ieee1394			1
usb				1

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

We are up to 105 trees (counting Linus' and 14 trees of patches pending for
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
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Jul_2008_16_15_31_+1000_bJZks9OwVvysxWWL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiNZAMACgkQjjKRsyhoI8wnWQCdH/wmNCgidTvqDpSeyeMcqdKM
KngAn1UPYUktQvVN4mQ3Zqp6HKvvsYDz
=GOTp
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Jul_2008_16_15_31_+1000_bJZks9OwVvysxWWL--
