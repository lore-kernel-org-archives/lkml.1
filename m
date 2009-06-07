Return-Path: <linux-kernel-owner+w=401wt.eu-S1754942AbZFGJnt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942AbZFGJnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 05:43:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753073AbZFGJnk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 05:43:40 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39281 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814AbZFGJnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 05:43:39 -0400
Subject: Re: [ANN] Atheros 802.11n USB firmware source code released
From: Johannes Berg <johannes@sipsolutions.net>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       linux-kernel@vger.kernel.org, otus-devel@venema.h4ckr.net,
       David Woodhouse <dwmw2@infradead.org>,
       "John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1244334102.16810.3.camel@localhost>
References: <43e72e890906051204q22278e4cw6beeae27da50e988@mail.gmail.com>
	 <1244326943.12159.5.camel@localhost>  <1244334102.16810.3.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1DXZmgPadoca42y1QXNa"
Date: Sun, 07 Jun 2009 11:43:34 +0200
Message-Id: <1244367815.26071.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1DXZmgPadoca42y1QXNa
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-06-07 at 03:21 +0300, Maxim Levitsky wrote:

> > Is this source for same firmware that was closed?

Yes, but it was compiled differently afaik so you won't arrive at the
same binary.

> > Will AP mode work in future?

Well, not TYPE=3DAP, but we'll integrate whatever is necessary into one
firmware, I expect. It shouldn't be very hard given that AP mode really
works with the TYPE=3DSTA firmware already, almost.

> What does this mean:
>=20
> eeprom   : ORIGIN =3D 0x000000, LENGTH =3D 1024k
>=20
>=20
> Does the device have whole 1M of eeprom?
> What is there?

The eeprom is mapped there, but I don't think it's 1M, it's just the max
size of the mapping to the CPUs address space.

> Also what is this:
>=20
> sram     : ORIGIN =3D 0x100000, LENGTH =3D 64k

This is just memory. It's used for buffering frames and dma descriptors
etc. internally. I want to change the code to do this with the linker
script rather than manually assigning addresses in the source. But if
you grep for this address you'll find how it's used.

> Description says that pram is 32K, but:
> =20
> pram     : ORIGIN =3D 0x200000, LENGTH =3D 16k

Yeah, we're not exactly sure about this yet, but using 32k definitely
crashes the device.

johannes

--=-1DXZmgPadoca42y1QXNa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKK4vDAAoJEODzc/N7+Qma7UgQAKqMZgRxczqHMDNAV+NdeiU0
hQdbIaGVlLB2LiNbbfdFxEq/NUGUp8HIh8UXwlX+sWDBaFlD7z65yvxgzn/hO7L0
q6bc3MLihl7VMPlrnR3AUwEJzrGsrYyg2hCnGtdntyKJLrRWADxmREv99kFOx//F
mC6qMC84viMIaV27hUvOPwBIBeX4+zItzXnp9jW5KccAG3RbB/yXPdhn+Pn7SYGy
xvNryxllm6xcSoW3rlvbukgj1gQVOElvOOSqaK6eGCi6vIKTZE/JOmQ2iYLHm1TY
0nZLhppA1slYa3D6O0psNi4qGTorXIJehzFSZlokNmmm03XihK+dxCRaM2Tb2zpE
U8SBIF3wT6lgHPeeaFzKoxsS3qXgaTheXwk5p4Uwuoj7RobhQhFbKZaGl2JctFcn
BRCyx0kJPeHjK/6QXhF5EfWsHRdtPCkljHuUkQY6MzVcMRazNZ3FC+aMnmVbaV1D
0bFdOZpkuvUMDGYWavCRh6cveiNR2W3mzzJkCtAilc9ZC2uUM6ENJeLHOUi6rIJL
Daj/pAcFj3ExCYivTaUNGzFO76GN7bZz1uLUlzjBq8+ImRqGYIV9crTOifFVwm6u
8z/98u7MHBgUyNpqN6eTsK3vuQ41IfquiVDbM7VcdbrKQ/suExgY7tGdI7bwyIkU
T9vPyDcdbKy/O7AJMxjH
=7/A/
-----END PGP SIGNATURE-----

--=-1DXZmgPadoca42y1QXNa--

