Return-Path: <linux-kernel-owner+w=401wt.eu-S1760096AbZAMXcn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760096AbZAMXcn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:32:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758511AbZAMXcU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:32:20 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36390 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758269AbZAMXcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:32:19 -0500
Subject: Re: [PATCH] backlight: don't default y
From: Johannes Berg <johannes@sipsolutions.net>
To: Valdis.Kletnieks@vt.edu
Cc: Richard Purdie <rpurdie@openedhand.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <37023.1231889418@turing-police.cc.vt.edu>
References: <1231856997.3671.38.camel@johannes>
	 <37023.1231889418@turing-police.cc.vt.edu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ppC3P8G4bkzynbnXmZPq"
Date: Wed, 14 Jan 2009 00:31:52 +0100
Message-Id: <1231889512.3728.21.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ppC3P8G4bkzynbnXmZPq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-13 at 18:30 -0500, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 13 Jan 2009 15:29:57 +0100, Johannes Berg said:
> > Not all the backlight drivers make sense, especially not the "generic"
> > one that works on some sharp devices. "default n" is also absolutely
> > pointless, and not everybody needs LCD backlight support either.
>=20
> >  config BACKLIGHT_GENERIC
> >  	tristate "Generic (aka Sharp Corgi) Backlight Driver"
> >  	depends on BACKLIGHT_CLASS_DEVICE
> > -	default y
> >  	help
>=20
> I asked about this one recently - apparently it's planned to be much more
> generic, but the help text still implies it's Sharp-specific.

Even if, it still shouldn't be default y.

johannes

--=-ppC3P8G4bkzynbnXmZPq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJbSRmAAoJEKVg1VMiehFYjCcP/2ObV9r3r21v5Wfq19HUvJOx
XMtvJFhzfPm3DCiSvjY09c1e6fQuT8ZdT186Z15m28J65rYNTQdhOpFu/OvkZdjb
irbIfoNIYOmVVMjXVeTdUnTSDeaMoAjGoQ+pworbF1qIkDmNYE13+tylp0SwmW9y
RWltJnoyaogcFRUpVjMpsx1ZGCfnowtvJEi+ltX/ZwmTXLXuANUlgmCPcWM9bl5p
X4nZuxPTLAnZqG6r/fPC8U9R+7dVIZ6jTroTpVCYs2kteFasp5HbcwU4q7A40Esp
/MJ1k7oueUousRa8LMn+B8lpdpOfe96spXSycNBnYg1TRIfPqEOle71OV4oh4wPq
UVAXiZxpd7mobDvIw2VqDHVbaFz9Ix5wJ136oljeAJ9LXQ6coi77dZ+98HcrK+fM
6ySIxLz1eu1i7S7yj8VHeoAc7Ut9a7zAuEZ5TbZ3b/QWMkH+2EkjmYayaqvoEFI1
8ZF3WntwAc97ejSmPv3rGvBm2MfrB0w1neqUmooRW22EKwHzn9CZmoEYpVpIBTAu
xLVLnyc1YvO+UNUirjPxLYkK5QXAeK5i6UCvIdJwAWyCrfUn5Gmn0mqe6C7N58ft
KVkitvBVcdUgNAN98vsokvg3fdJONGmvYvLEsRnfiBcBZH7abaNd8G9tDCOFsN02
1I+J513J/OcyOTZbeLd3
=d8oD
-----END PGP SIGNATURE-----

--=-ppC3P8G4bkzynbnXmZPq--

