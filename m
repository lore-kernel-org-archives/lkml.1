Return-Path: <linux-kernel-owner+w=401wt.eu-S1760736AbZAHQd7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760736AbZAHQd7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:33:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753500AbZAHQds
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:33:48 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36014 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753087AbZAHQds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:33:48 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090108162429.GA24884@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes>
	 <20090108162429.GA24884@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ReUmPbJkBCZEHWj0/VBD"
Date: Thu, 08 Jan 2009 17:34:10 +0100
Message-Id: <1231432450.8038.4.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ReUmPbJkBCZEHWj0/VBD
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-01-08 at 17:24 +0100, J=C3=B6rn Engel wrote:

> > Alright, back to this. I'm going to need something like the patch below
> > (except the update facility, which I thought I needed but then changed
> > my mind) which is on top of your patch. Does that look sane?
>=20
> At first glance it does.  The update looks like someone might need it,
> but doesn't have a user yet.  The btree_merge is similar, as I used to
> need it, but no longer do.  Maybe #if 0 those two.

Sure, works for me. I just had written it and didn't want to keep it
from the world after changing my mind about needing it.

> Well, I used to have heaps of btrees around and wanted to share the
> mempool between all of them.  Not sure if I still do, I believe not.
> Will check.
>=20
> If mempools aren't shared, I agree that encapsulating those bits is much
> nicer.

Just made the API a bit quirky, maybe just support both ways of using
things? Would only need a flag somewhere in the btree structure, I'd
think; ultimately it doesn't matter much to me though.

> > Another thing that I need is a visitor that deletes _some_ entries. How
> > can I do that? Additionally, it would be nice to be able to abort a tre=
e
> > walk, when you have determined that you can't continue for whatever
> > reason.
>=20
> If you want to open-code it, you can use btree_lookup_less().  I added
> that function sometime last month.  Basically something like this:
> 	key =3D btree_last(head, geo);
> 	while (key) {
> 		/* do something with key */
> 		key =3D btree_lookup_less(head, geo, key);
> 	}
>=20
> Maybe it should be renamed to btree_get_prev_key().  I never noticed how
> confusing it was because my head was busy with other problems.  The code
> is currently burried within my logfs tree:
> http://logfs.org/git?p=3Dlogfs;a=3Dsummary

I don't think I've understood this yet. That code above there is a
backwards walk over the key space, and it's safe to call
btree_remove(key) at /* do something with key */?

> Will merge it with your patch and respin later tonight or tomorrow...

Cool, thanks. Mainly making it a module for testing anyway.

johannes

--=-ReUmPbJkBCZEHWj0/VBD
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJZir+AAoJEKVg1VMiehFY9A0P/1Ycn2a6WFXi3TaarFZ/2Oxk
698z7S7Fn/ToCXOlYtUc8ivuhGFIRYjD74r4gnHGfaVEovkGBaApIyNPYxBgJbz5
SHz6z3Uksmnly8U3khaYIxpjD9csxvhTpF2Ap/asdZ2xMUHAkWY0BEaFCX7kzs8/
CZijRlcc2acUSQQ4Jqzq8NiHjJCSofIh6AlRBILkZvRdySjcf1jjL1N5eIbAe/HP
4cjF0tHFNu+UB6sgtqy48EFKZ81H5Tf9BddxDJoEEqDpyO+3tY7j9zs0rxoD/yVK
cQx+ktWbZWQQz8TQ7Is7wsiNlt1BUvrONp8CcUBsWpmZBmIuz41ZMW4mO38PLL6P
zjL+KhT6PDW/2oFaski2GB61DappML3PzynvGqSWEFmydzIUqSp5liazYIPiahwd
UpptMFzMA4hHzhhJhVKDLevgN+pcQzBJvtwYVGESdeIKQEC8ixWqcLoR/5zsqT7f
MfXCtyJmWO69+GYvKPA8iTnJc5v2YHVkcSQ3UWqfoRQWolf0ykGsWA/NoNcWaZTY
h4qwAxQ90l4OqShS5+AeTYHPWOpHn2xjhd4i+D19dulxffeLA5QKpgFwY/x1MJkb
IgxYUIQwq6ZOCe0n9g313h06PL5vvx1McH43Xsjxom8KnI0atMl7NHbtsR2a5Mo2
I9m6qxW+AhEiLdjGafXN
=zgKA
-----END PGP SIGNATURE-----

--=-ReUmPbJkBCZEHWj0/VBD--

