Return-Path: <linux-kernel-owner+w=401wt.eu-S1754760Ab0ALXXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab0ALXXG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 18:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754122Ab0ALXXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 18:23:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46748 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0ALXXD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 18:23:03 -0500
Date: Wed, 13 Jan 2010 10:22:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: albin.tonnerre@free-electrons.com, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: linux-next: Tree for January 12 (unlzo)
Message-Id: <20100113102254.332dbf33.sfr@canb.auug.org.au>
In-Reply-To: <20100112083013.1dad8a8d.randy.dunlap@oracle.com>
References: <20100112171739.2011a0eb.sfr@canb.auug.org.au>
	<20100112083013.1dad8a8d.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__13_Jan_2010_10_22_54_+1100_+lz2xdQNFM4moxc/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__13_Jan_2010_10_22_54_+1100_+lz2xdQNFM4moxc/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 12 Jan 2010 08:30:13 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:53: error: ex=
pected '=3D', ',', ';', 'asm' or '__attribute__' before 'parse_header'
> arch/x86/boot/compressed/../../../../lib/decompress_unlzo.c:90: error: ex=
pected '=3D', ',', ';', 'asm' or '__attribute__' before 'unlzo'
>=20
> Problem is the "INIT" there, seems to be undefined.

Caused by an interaction between Linus' tree and the squashfs tree that
is being worked on.  It should not occur with today's linux-next as the
squashfs changes have been removed pending a fix.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__13_Jan_2010_10_22_54_+1100_+lz2xdQNFM4moxc/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktNBE4ACgkQjjKRsyhoI8x7qACdFhrnmNsTN/oWK493LSZkDuo4
2iMAnjgAzjdfebNF5FDuiyI38d4T9NOh
=sx/V
-----END PGP SIGNATURE-----

--Signature=_Wed__13_Jan_2010_10_22_54_+1100_+lz2xdQNFM4moxc/--
