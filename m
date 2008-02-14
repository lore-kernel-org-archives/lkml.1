Return-Path: <linux-kernel-owner+w=401wt.eu-S1763863AbYBNJj3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763863AbYBNJj3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 04:39:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752499AbYBNJjS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 04:39:18 -0500
Received: from ip-58-28-152-52.static-xdsl.xnet.co.nz ([58.28.152.52]:54565
	"EHLO sol.unix.geek.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752605AbYBNJjR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 04:39:17 -0500
Subject: Re: Is there a "blackhole" /dev/null directory?
From: Jasper Bryant-Greene <jasper@unix.geek.nz>
To: rzryyvzy <rzryyvzy@trashmail.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080214093051.7240852AB0E31@trashmail.net>
References: <20080214093051.7240852AB0E31@trashmail.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AnWaFotjNc5aBulw2PDn"
Date: Thu, 14 Feb 2008 22:39:17 +1300
Message-Id: <1202981957.10928.17.camel@phobos.jasper.bg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AnWaFotjNc5aBulw2PDn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-02-14 at 10:30 +0100, rzryyvzy wrote:
> /dev/null is often very useful, specially if programs force to save data =
in some file. But some programs like to creates different temporary file na=
mes, so /dev/null could no more work.
>=20
> What is with a "/dev/null"-directory?
> I mean a "blackhole pseudo directory" which eats every write to null.
>=20
> Here is how it could work:
> mount -t nulldir nulldir /dev/nulldir
>=20
> Now if a program does a create(2),
> it creates in the memory the file with its fd.
> Then if a program does a write(2) to the fd, it eats the writes and give =
out fakely it has written the number of bytes.
> When the program calls does a close(2) of the fd, then the complete inode=
 is deleted in the memory.
>=20
> The directory should  be permanently empty except for the inodes with ope=
n file descriptors. So only inode information would be temporary saved in t=
his "nulldir tmpfs" directory.
>=20
> Is there already existing a possibility to create a null directory?

This could be done fairly trivially with FUSE, and IMHO is a good use
for FUSE because since you're just throwing most data away, performance
is not a concern.

-j

--=-AnWaFotjNc5aBulw2PDn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHtAxFJdSFNCc4WA0RAhVSAKCTUvqedIFU+6WlPZRnZSQumcTF4gCfQVnK
P8K64TTh0MHQTEpNXuAOUi0=
=bwou
-----END PGP SIGNATURE-----

--=-AnWaFotjNc5aBulw2PDn--

