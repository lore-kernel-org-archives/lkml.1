Return-Path: <linux-kernel-owner+w=401wt.eu-S1757937AbYDHQBn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937AbYDHQBn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2008 12:01:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752793AbYDHQBe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Apr 2008 12:01:34 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:54125 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754042AbYDHQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2008 12:01:34 -0400
Subject: Re: [PATCH] introduce HAVE_EFFICIENT_UNALIGNED_ACCESS Kconfig
	symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andrew Morton <akpm@osdl.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, sam <sam@ravnborg.org>
In-Reply-To: <47FB920F.60503@s5r6.in-berlin.de>
References: <1207667127.14253.42.camel@johannes.berg>
	 <47FB920F.60503@s5r6.in-berlin.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DoSr0SYVcGbiKho2yzzH"
Date: Tue, 08 Apr 2008 18:00:49 +0200
Message-Id: <1207670449.5550.6.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DoSr0SYVcGbiKho2yzzH
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Stefan,

Thanks for the text review. I'll follow up with a new version in a
minute.

> > --- everything.orig/arch/Kconfig	2008-04-04 23:42:50.000000000 +0200
> > +++ everything/arch/Kconfig	2008-04-04 23:52:15.000000000 +0200
> > @@ -36,3 +36,22 @@ config HAVE_KPROBES
> > =20
> >  config HAVE_KRETPROBES
> >  	def_bool n
> > +
> > +config HAVE_EFFICIENT_UNALIGNED_ACCESS
> > +	def_bool n
> > +	help
> > +	  Some architectures are unable to perform unaligned accesses
> > +	  without the use of get_unaligned/put_unaligned. Others are
> > +	  unable to perform such accesses efficiently (e.g. trap on
>=20
> Wouldn't a comment be more appropriate instead of a help text?  This
> option shouldn't be a visible make XYZconfig prompt.
>=20
> I have no comment on the option itself; it's not my domain.

Note that the help text doesn't mean the option gets to be visible, only
the one-line description does, as in

config XYZ
	bool "description"

vs.
config XYZ
	bool

johannes

--=-DoSr0SYVcGbiKho2yzzH
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR/uWsKVg1VMiehFYAQJ/OA//TC53B8iR2LTTp/HLOShJM/mjaN4fSXq3
pfgpTIOKGGU7ygCWdXBQlvDBHGafpCKdmxI8MOtsQlozGm/YTRoe+uDqCH8z2CZ6
7E2XSeGY6lII5rZDidtO46jGIkuFvwgjUQDL87zOJOPPe4O8nUrVBKdbym2jOHnG
BlckWS0waU6QR+WPH8LayUCrIGxloT8csFHHCKjwfU4M5X2ctjUfxCrR7cexrrFl
WlCDhxWAaGhIMMxolWmQJy11Gt+oNbTOkxwDaeVQwArsL56pNdeNLb5k112xL+6t
6ukIqHxLLcNgcAV8QYafhRzMP1yHgoZlyRVfBf2XZUB98NIw8qimN5pKMeA6mXVY
OfccqE+ivOmGf/diT+8nca/whI5YXbx52qzWTOAubPoyYRVP+CHkuasecgH7x2IR
rjrhPeaLtBVOzKemD6BEIFFFDVIayRvPWK98VV5V98dvY9QDxYjNAbOjYX5mHgTj
91JPHqKER1BGMrpxcaOrXzygfHNS5sqhjuqNG1lDNztc8MCOBMMYBSEljTT1vRa4
4MBKRT9dT6U9zpe4MLt84Ev0zuUR2l7FNAtImQTRRvUNS2m+Ahd3eyuBX0yQCi18
wE81YpmWk56h/PcKIyAiVDgXWwuyvf3cAl/Yyz69HC5GDvBQceWuP2XhcvGYRDTq
2AYwuJUikcE=
=1j5g
-----END PGP SIGNATURE-----

--=-DoSr0SYVcGbiKho2yzzH--

