Return-Path: <linux-kernel-owner+w=401wt.eu-S1754068AbYCYGwk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068AbYCYGwk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2008 02:52:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750829AbYCYGwc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Mar 2008 02:52:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37949 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbYCYGwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2008 02:52:31 -0400
Date: Tue, 25 Mar 2008 17:52:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: Tree for March 25
Message-Id: <20080325175224.3ee62b09.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Mar_2008_17_52_24_+1100_43fdtmsRgWgo.oyt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Mar_2008_17_52_24_+1100_43fdtmsRgWgo.oyt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I have created today's linux-next tree at
git://git.kernel.org/pub/scm/linux/kernel/git/sfr/linux-next.git
(tar balls at
http://www.kernel.org/pub/linux/kernel/people/sfr/linux-next/).

You can see which trees have been included by looking in the Next/Trees
file in the source.  There are also quilt-import.log and merge.log files
in the Next directory.  Between each merge, the tree was built with
a ppc64_defconfig for powerpc and an allmodconfig for x86_64.

There were a few merge conflicts (fairly trivial) and a couple of build
failures that have been notified.

I have added POWERPC-really-export-empty_zero_page.patch and reverted
async-tx commit 9974693221954ef1019f87d32ae26a0757d2ee85 ("dmaengine: ack
to flags: make use of the unused bits in the 'ack' field") as these are
still needed to make powerpc allmodconfig build (in particular ext4 and
drivers/dma/fsldma.c).  These have been reported previously.

We are up to 48 trees, more are welcome (even if they are currently
empty).  The influx of new trees has slowed completely.  Thanks to those
who have contributed, and to those who haven't, please do.

In particular, I have very few of the architecture trees ....

Status of my local build tests is at
http://kisskb.ellerman.id.au/linux-next.  If maintainers want to give
advice about cross compilers/configs that work, we are always open to add
more builds.

Thanks to Jan Dittmer for adding the linux-next tree to his build tests
at http://l4x.org/k/.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Mar_2008_17_52_24_+1100_43fdtmsRgWgo.oyt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH6KEtTgG2atn1QN8RArsBAJwMGOu9szJkgOO76S+oDdASl6SfkwCghegG
om6F5WIy7yT+IcHIvjKYJS4=
=p0lb
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Mar_2008_17_52_24_+1100_43fdtmsRgWgo.oyt--
