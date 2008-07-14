Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYGNKNP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYGNKNP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 06:13:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757300AbYGNKM5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 06:12:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47633 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756330AbYGNKM4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 06:12:56 -0400
Date: Mon, 14 Jul 2008 20:12:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for July 14
Message-Id: <20080714201249.947400d0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Jul_2008_20_12_49_+1000_S1ZLOHLNdXvcP3Jg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Jul_2008_20_12_49_+1000_S1ZLOHLNdXvcP3Jg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

With the opening of the merge window, I am hoping my job becomes easier
again ... :-)

Changes since next-20080711:

Changed tree: powerpc (I am now fetching Ben's version)

The sched tree lost a conflict.

The x86 tree gained a conflict against the stackprotector tree.

The v4l-dvb tree lost a conflict.

The powerpc tree gained a conflict against the ftrace tree and required a
couple of build fix patches (see below) but lost a previous build fix
patch.

The rr tree gained a conflict against the ftrace tree but lost a build
fix patch.

I have also applied the following patches for known problems:

	sparc64: sysdev API change fallout
	s390: fix compile error due to smp_call_function
	powerpc: mman.h export fixups
	powerpc/stacktrace: EXPORT SYMBOL_GPL needs module.h

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

We are up to 106 trees (counting Linus' and 14 trees of patches pending for
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

--Signature=_Mon__14_Jul_2008_20_12_49_+1000_S1ZLOHLNdXvcP3Jg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkh7JqEACgkQjjKRsyhoI8wgCACdFXESstCaUozjhK8aEf7J5FtP
cGAAnRAi0Ng0ashzv/4YZCFdrlTcl2Cu
=S+40
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Jul_2008_20_12_49_+1000_S1ZLOHLNdXvcP3Jg--
