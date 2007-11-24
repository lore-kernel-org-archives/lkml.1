Return-Path: <linux-kernel-owner+w=401wt.eu-S1755949AbXKXS2i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbXKXS2i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 13:28:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196AbXKXS23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 13:28:29 -0500
Received: from smtp3.netcabo.pt ([212.113.174.30]:44239 "EHLO
	exch01smtp12.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755623AbXKXS22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 13:28:28 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhRuAHf8R0dThJYTPGdsb2JhbACBW4Vjh3YBAQEBNQI
Date: Sat, 24 Nov 2007 18:28:22 +0000
From: Luciano Rocha <strange@nsk.no-ip.org>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
       davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
Subject: Re: [RFC] Documentation about unaligned memory access
Message-ID: <20071124182822.GB17654@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	Pierre Ossman <drzeus-list@drzeus.cx>,
	Daniel Drake <dsd@gentoo.org>, linux-kernel@vger.kernel.org,
	davem@davemloft.net, kune@deine-taler.de, johannes@sipsolutions.net
References: <20071123001554.12F8B9D4A1F@zog.reactivated.net> <20071124143441.41657307@poseidon.drzeus.cx> <20071124155052.GA15440@bit.office.eurotux.com> <20071124171931.699aa1ff@poseidon.drzeus.cx> <20071124172236.GA16944@bit.office.eurotux.com> <20071124183525.13c41374@poseidon.drzeus.cx>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8GpibOaaTibBMecb"
Content-Disposition: inline
In-Reply-To: <20071124183525.13c41374@poseidon.drzeus.cx>
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 24 Nov 2007 18:28:25.0399 (UTC) FILETIME=[CD12CC70:01C82EC7]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--8GpibOaaTibBMecb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 24, 2007 at 06:35:25PM +0100, Pierre Ossman wrote:
> On Sat, 24 Nov 2007 17:22:36 +0000
> Luciano Rocha <strange@nsk.no-ip.org> wrote:
>=20
> > On Sat, Nov 24, 2007 at 05:19:31PM +0100, Pierre Ossman wrote:
> > > It most certainly does not. gcc will assume that an int* has int alig=
nment. memcpy() is a builtin, which gcc can translate to pretty much anythi=
ng. And C specifies that a pointer to foo, will point to a real object of t=
ype foo, so gcc can't be blamed for the unsafe typecasts. I have tested thi=
s the hard way, so this is not just speculation.
> >=20
> > Yes, on *int and other assumed aligned pointers, gcc uses its internal
> > version.
> >=20
> > However, my point is that those pointers, unless speaking of packed
> > structures, can safely be assumed aligned, while char*/void* can't.
> >=20
>=20
> I get the sensation we're violently in agreement here, just misunderstand=
ing each other. :)

That's it. :)

Sorry for the noise,...

--=20
lfr
0/0

--8GpibOaaTibBMecb
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHSG1GinSul6a7oB8RAjjuAKCJihwbblK1bClk+9QEtLwAXxIzwACeIRyk
8K/JiW3s4gzdO1BxCDEFCxg=
=z6NQ
-----END PGP SIGNATURE-----

--8GpibOaaTibBMecb--
