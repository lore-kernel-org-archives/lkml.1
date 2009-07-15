Return-Path: <linux-kernel-owner+w=401wt.eu-S1755372AbZGORDY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372AbZGORDY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 13:03:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755229AbZGORDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 13:03:24 -0400
Received: from mail.open.by ([193.232.92.17]:52368 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754872AbZGORDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 13:03:23 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9042 [Jul 15 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Wed, 15 Jul 2009 20:03:51 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090715170351.GB3139@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
 <20090711235530.GA3231@localdomain.by>
 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
 <20090714162837.GC3145@localdomain.by>
 <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
 <20090715102733.GA3055@localdomain.by>
 <20090715113042.5dbb5822@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20090715113042.5dbb5822@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/15/09 11:30), Alan Cox wrote:
> > On (07/15/09 11:05), Alan Cox wrote:
> > > > Hello Alan,
> > > > I'm having another problem which I guess may be caused by pty/tty c=
hanges.
> > > > The problem is that ppp connection constantly hangups under load (d=
ownloading)=20
> > > > (it works perfectly with 30 kernel).
> > >=20
> > > Have you also got the unthrottle change reverted - without that rever=
t it
> > > certainly will hang as you describe.
> > >=20
> >=20
> I do yes
>=20

 d945cb9cce20ac7143c2de8d88b187f62db99bdc "pty: Rework the pty layer to use=
  the normal buffering logic"
 and REVERTED a6540f731d506d9e82444cf0020e716613d4c46c "ppp: Fix throttling=
 bugs"

seems to work.

	Sergey

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpeC/cACgkQfKHnntdSXjSGcwQAuDgNU1r+1lgdto4HdBaejLW8
+DbEVuixCG4PPBM9nlCxI2nK0KydKF/8KRw5iI/GszXlk4WXhlwDcWbAK7BoUPyH
3D4uw17BtcYbtn2cmPFeAC4pMVbrDr3CsstBNW6F7K37VYL8bgIfQrEoL9Oi5SUE
tNV6lyNnuGq/3zSqRA8=
=ROb6
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
