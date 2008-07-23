Return-Path: <linux-kernel-owner+w=401wt.eu-S1753727AbYGWE3S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727AbYGWE3S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 00:29:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752026AbYGWE3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 00:29:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39084 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007AbYGWE3H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 00:29:07 -0400
Date: Wed, 23 Jul 2008 14:28:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080723142859.ab9f909d.sfr@canb.auug.org.au>
In-Reply-To: <20080722153114.e9d44210.randy.dunlap@oracle.com>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
	<20080503160724.6c3e0392.sfr@canb.auug.org.au>
	<20080722153114.e9d44210.randy.dunlap@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_14_28_59_+1000_ycQ+39eCxJs3HBNz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_14_28_59_+1000_ycQ+39eCxJs3HBNz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 22 Jul 2008 15:31:14 -0700 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> > output from "git describe".  Alternatively, you can be based on another
> > tree in linux-next by using:
> >=20
> > # NEXT_BASE <name of a tree in linux-next>
>=20
> What do we use for BASE or NEXT_BASE if the base tree is linux-next?
> Just don't use these annotations?

The name from the Next/Trees file in any linux-next release.  You should
be very careful doing this if you don't control the other tree, though.
And you should let me know so that I can order the trees appropriately.

This was mainly added for Greg who has 4 quilt series in linux-next that
depend on each other.  If you depend on some random tree that changes day
to day your quilt series may no longer apply cleanly on top of it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jul_2008_14_28_59_+1000_ycQ+39eCxJs3HBNz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiGs4sACgkQjjKRsyhoI8xt1QCgkfudKjNFl0tUnrteGfP5Glu6
bSUAn0M9TZE5+bKememl99D1PeMaXhel
=yU8A
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_14_28_59_+1000_ycQ+39eCxJs3HBNz--
