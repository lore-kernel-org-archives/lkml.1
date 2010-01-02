Return-Path: <linux-kernel-owner+w=401wt.eu-S1751949Ab0ABMIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0ABMIS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jan 2010 07:08:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751488Ab0ABMIR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Jan 2010 07:08:17 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51927 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab0ABMIQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jan 2010 07:08:16 -0500
Date: Sat, 2 Jan 2010 13:08:09 +0100
From: Pierre Ossman <pierre@ossman.eu>
To: Ben Nizette <bn@niasdigital.com>
Cc: Hein_Tibosch <hein_tibosch@yahoo.es>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Adrian Hunter <adrian.hunter@nokia.com>, linux-mmc@vger.kernel.org,
       linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v2] mmc: lower init clock frequency to 300kHz
Message-ID: <20100102130809.121b7e10@mjolnir.ossman.eu>
In-Reply-To: <49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com>
References: <1246492196.2980.17.camel@linux-51e8.site>
	<20090702135849.21370282@hskinnemoen-d830>
	<1246537056.2980.60.camel@linux-51e8.site>
	<4B3E570C.2060602@yahoo.es>
	<63809451-ED1D-487A-AE63-F72B23D136D8@niasdigital.com>
	<4B3F019F.6010306@yahoo.es>
	<49985427-DCB9-40E1-815B-43C812B41DE3@niasdigital.com>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.18.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26580-1262434098-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26580-1262434098-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 2 Jan 2010 20:07:01 +1100
Ben Nizette <bn@niasdigital.com> wrote:

>=20
> Pierre, thoughts?  All my cards were borderline spec but Hein's got a mai=
nstream, common card which seems to completely ignore the spec.  Can we jus=
t take the few-hundred-uS hit and allow initialization down at the bottom e=
nd, say 100kHz?
>=20

Broken cards seem to be all over the spectrum, so I wouldn't be
suprised if you find ones that break if you go too low as well.

Basically you'll just have to try something and watch the bug reports.
Perhaps doing the bisect approach and choosing the intermediate value
each time? I.e. halvway between 400 and 100 for now (250). If that is
too fast, then halway between that and 100 (175), and so on.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by FRA, a
  Swedish intelligence agency. Make sure your server uses
  encryption for SMTP traffic and consider using PGP for
  end-to-end encryption.

--=_freyr.ossman.eu-26580-1262434098-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.13 (GNU/Linux)

iEYEARECAAYFAks/Ny0ACgkQ7b8eESbyJLhkWwCdEW8fCGvxdmCgG3bWao/5VMRz
s/IAnjRKKidbbCZlt0MAGg+cAuH/K7Ee
=QdN+
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26580-1262434098-0001-2--
