Return-Path: <linux-kernel-owner+w=401wt.eu-S1755848AbYKFEgT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755848AbYKFEgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 23:36:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753070AbYKFEgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 23:36:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44177 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752789AbYKFEgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 23:36:04 -0500
Date: Thu, 6 Nov 2008 15:35:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org, wli@holomorphy.com,
       sparclinux@vger.kernel.org
Subject: Re: tty warning
Message-Id: <20081106153555.ed45a874.sfr@canb.auug.org.au>
In-Reply-To: <20081105.202557.233628145.davem@davemloft.net>
References: <20081106152421.a9cf964f.sfr@canb.auug.org.au>
	<20081105.202557.233628145.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Nov_2008_15_35_55_+1100_9UkBm175BGAlgdh3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Nov_2008_15_35_55_+1100_9UkBm175BGAlgdh3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 05 Nov 2008 20:25:57 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 6 Nov 2008 15:24:21 +1100
>=20
> > These are things like:
> >=20
> >                 termios->c_cc[VTIME] =3D 0;
> >=20
> > termios is a (struct ktermios *) which has "cc_t c_cc[NCCS];".  NCCS is
> > 17 and VTIME is also 17.  I assume the intention is to actually fill in
> > _x_cc[0], but why is it done this way and not more directly?
>=20
> It's just some historical stuff.
>=20
> I've tried to rectify it, but it is non-trivial to fix and
> all it does is pacify a warning rather than fix a real problem
> so... ;-)
>=20
> This has been brought up perhaps 5 or 6 times in the past half
> year :)

Yeah, I guess that is when the compilers started complaining.

Oh, well :-(

[BTW, the number of warnings is itself becoming a real problem ... :-( ]
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__6_Nov_2008_15_35_55_+1100_9UkBm175BGAlgdh3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkSdCsACgkQjjKRsyhoI8waUgCgh3NeGLTpeN1R+90QwSdomEvA
vd8AoK0AaawR4PiosPH8eV7in2kPc0nU
=9N7B
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Nov_2008_15_35_55_+1100_9UkBm175BGAlgdh3--
