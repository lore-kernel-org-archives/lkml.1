Return-Path: <linux-kernel-owner+w=401wt.eu-S1752287Ab0ABXiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab0ABXiM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 18:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657Ab0ABXiK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 18:38:10 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35565 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162Ab0ABXiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 18:38:09 -0500
Date: Sun, 3 Jan 2010 00:38:04 +0100
From: Pierre Ossman <pierre@ossman.eu>
To: Ben Nizette <bn@niasdigital.com>
Cc: Hein_Tibosch <hein_tibosch@yahoo.es>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v3] mmc: Make ID freq configurable
Message-ID: <20100103003804.66021fe9@mjolnir.ossman.eu>
In-Reply-To: <AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com>
References: <1246492196.2980.17.camel@linux-51e8.site>
	<20090702135849.21370282@hskinnemoen-d830>
	<1246537056.2980.60.camel@linux-51e8.site>
	<4B3E570C.2060602@yahoo.es>
	<63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com>
	<4B3F019F.6010306@yahoo.es>
	<49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com>
	<20100102130809.121b7e10@mjolnir.ossman.eu>
	<AD8E15FA-A476-4275-A750-5EB587A93CEC@niasdigital.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-31714-1262475490-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-31714-1262475490-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Jan 2010 09:23:30 +1100
Ben Nizette <bn@niasdigital.com> wrote:

> >=20
> > Broken cards seem to be all over the spectrum, so I wouldn't be
> > suprised if you find ones that break if you go too low as well.
>=20
> Yea good point, though given there might not even be a One Freq to Rule T=
hem All, how about:
>=20
> ---8<---
>=20
> From: Ben Nizette <bn@niasdigital.com>
> Subject: [PATCH v3] mmc: Make ID freq configurable
>=20
> While the SD spec specifies a range of frequencies for the ID phase from =
100-400kHz, not all cards play by the rules.  This patch adds a Kconfig opt=
ion to allow the user to tweak this to their card/host config, though the d=
efault of 250kHz should be fine for all spec-abiding cards and most others =
besides.
>=20
> Signed-off-by: Ben Nizette <bn@niasdigital.com>
>=20

This is not a good solution. We all use the same pool of cards so we
should all be using the same init sequence. If there isn't a single
frequency where all cards will work, then we'll have to make something
more advanced where the kernel will try the init several times with
different clocking.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-31714-1262475490-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAks/2N4ACgkQ7b8eESbyJLgKQACfa+JDwY97aaPlgxQ4bYVU+WaW
5mEAoOECi8nNIlbrq9aiHzQRj9prTFKu
=xxzx
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-31714-1262475490-0001-2--
