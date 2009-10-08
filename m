Return-Path: <linux-kernel-owner+w=401wt.eu-S1759102AbZJHRLu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759102AbZJHRLu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Oct 2009 13:11:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759026AbZJHRLt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Oct 2009 13:11:49 -0400
Received: from gold.linx.net ([195.66.232.40]:60886 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758992AbZJHRLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Oct 2009 13:11:48 -0400
Subject: Re: sata_mv 0000:03:06.0: PCI ERROR; PCI IRQ cause=0x30000040
From: Tony Vroon <tony@linx.net>
To: Bernie Innocenti <bernie@codewiz.org>
Cc: Mark Lord <liml@rtr.ca>, Harri Olin <harri.olin@gmail.com>,
       linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
       sysadmin <sysadmin@gnu.org>
In-Reply-To: <1255020134.30440.698.camel@giskard>
References: <1254546642.1438.135.camel@giskard> <4ACA6904.1060509@rtr.ca>
	 <4ACB3741.2030101@gmail.com> <1254852272.1471.172.camel@giskard>
	 <4ACBA33C.7090606@rtr.ca>  <1254873978.1471.463.camel@giskard>
	 <1254879618.1471.525.camel@giskard>  <4ACC076F.7020000@rtr.ca>
	 <1255020134.30440.698.camel@giskard>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZN9k4JSixqZ5Cv0qHfvM"
Organization: London Internet Exchange (LINX; AS5459)
Date: Thu, 08 Oct 2009 18:09:47 +0100
Message-Id: <1255021787.3386.24.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZN9k4JSixqZ5Cv0qHfvM
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-10-08 at 12:42 -0400, Bernie Innocenti wrote:
> El Tue, 06-10-2009 a las 23:13 -0400, Mark Lord escribi=C3=B3:
> I want to try reducing the frequency of the PCI-X bus, but the BIOS does
> not seem to provide a setting for it.  Is there another way?

Generally this is done with a physical jumper on the board instead.
You'll find it near to the bridge chip, which is almost always by NEC.
Another technique to slow the bridge down is to insert a regular PCI
card in the other slot (these bridges tend to offer 2 or 3 slots). As
the weakest link, it'll drag everything down to 33MHz.
An old PCI-X 66MHz-only card may prove helpful here as well. You don't
have to drive it in any way; getting power to it is sufficient.

Regards,
Tony V.

--=-ZN9k4JSixqZ5Cv0qHfvM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrOHNsACgkQp5vW4rUFj5o5dgCfUF4kpktUpy5ZKpu2ssjFgHFT
OTgAoLOv64BznJQ/fG5XoyixmPBahtw1
=hJ6f
-----END PGP SIGNATURE-----

--=-ZN9k4JSixqZ5Cv0qHfvM--

