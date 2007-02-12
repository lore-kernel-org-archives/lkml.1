Return-Path: <linux-kernel-owner+w=401wt.eu-S1030502AbXBLXre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030502AbXBLXre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:47:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030525AbXBLXre
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:47:34 -0500
Received: from proxima.lp0.eu ([85.158.45.36]:43211 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030502AbXBLXrA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:47:00 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=thunder.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:Subject:References:In-Reply-To:X-Enigmail-Version:OpenPGP:Content-Type:Sender:Reply-To;
	b=U50EhVrKNYGZAcC9x58Bh47lkk7H8ZM8dk3xGXDZH/jcL7g6NMdJFgBcYaCC5w/tppDTIWMru+oKrSv66rN/IWHHEVKPf5o4d74bsHyHXB+YU/d9jl72pm9JfxHusL51;
Message-ID: <45D0FC66.5030205@simon.arlott.org.uk>
Date: Mon, 12 Feb 2007 23:46:46 +0000
From: Simon Arlott <simon@arlott.org>
User-Agent: Thunderbird 1.5.0.5 (X11/20060819)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Kyle McMartin <kyle@mcmartin.ca>,
       Mark de Vries <mark@asphyx.net>, linux-kernel@vger.kernel.org
Subject: Re: Which CPU for VIA C7/Esther?
References: <1171301858.3557.6.camel@localhost> <20070212191441.GB20686@athena.road.mcmartin.ca> <20070212201635.GD10697@redhat.com>
In-Reply-To: <20070212201635.GD10697@redhat.com>
X-Enigmail-Version: 0.94.1.2
OpenPGP: id=89C93563
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig464143F700D457FC32EA8AAB"
Reply-To: Simon Arlott <6bc04bda904655a1b91hgkso0000m4ev@thunder.lp0.eu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig464143F700D457FC32EA8AAB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 12/02/07 20:16, Dave Jones wrote:
> On Mon, Feb 12, 2007 at 02:14:41PM -0500, Kyle McMartin wrote:
>  > On Mon, Feb 12, 2007 at 06:37:38PM +0100, Mark de Vries wrote:
>  > > I've been googeling for about an hour now and can't find an answer=
 to:
>  > > What type of CPU should I select when compiling a recent 2.6 kerne=
l if I
>  > > have a VIA Esther CPU?
>  >=20
>  > > stepping        : 9
>  >=20
>  > config MVIAC3_2
>  >         bool "VIA C3-2 (Nehemiah)"
>  >         help
>  >           Select this for a VIA C3 "Nehemiah". Selecting this enable=
s usage
>  >           of SSE and tells gcc to treat the CPU as a 686.
>  >           Note, this kernel will not boot on older (pre model 9) C3s=
=2E
>  >=20
>  > Is the one you want, I believe.
>=20
> The C7 doesn't seem to care much which you optimise it for.
> Any of the 686 options should work just fine, but MVIAC3_2 is no
> worse than any of the others.
>=20

MVIAC3_2 doesn't enable X86_GOOD_APIC, try M686 (Pentium-Pro) - but that =
won't enable MMX and SSE (via -march=3Dc3-2).
These CPUs support SSE2 too... there should probably be an option for C7 =
that passes 686/mmx/sse/sse2 to gcc. (The c3-2 option could even cause gc=
c to alter code for the C3-2 that's not necessary for the C7, but I've no=
t checked what else gcc does with -march=3Dc3-2).

Also, for the C7 you'll want CRYPTO_DEV_PADLOCK_* (Hardware Crypto Device=
s, Support for VIA PadLock ACE) and HW_RANDOM_VIA (VIA HW Random Number G=
enerator support).

--=20
Simon Arlott


--------------enig464143F700D457FC32EA8AAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2.2 (GNU/Linux)

iQIVAwUBRdD8ZqRtx1WjQ8ihAQpdiw//cwISuzZkGrbh8yHhYNtZgUd8fJxU4Xnd
btTjMaag8zZ5eNwjh9X6nJz1J9X3em6ogfCBSCBrWwLlfTeJ8RGDt9/PgR9ToxdM
vdKw3LJ48sEzbKsnLHqnjSYu+wXLtbDdJ/USGH8H0eT1vZVLdcv/A7WOZv6RRL61
zRh4ZqjmDf2eciboG8eEsk86JZUOgojkaBiVbKnFi/AgAfEzv2d2X6MJa3IAb3t3
BaKRyK4GQImAqg4Jw3JxketEIOvRe7wzuArxdR0Cck7EUYw7yloHvyF7b/a2sRQr
Yd4jg5EN1VSgWP0qsaU8Zx0akCO5XBdvet/kMvlaeE9+QYiUUX3+xS27cTQfYdyO
t9ThWAzSLLjONbXYPF9RwFvykMfAplkynzAEXn7SP+G//PnxJamUjWRuMX2dC/8R
hA8O00+ptGraOci4GRdSwyvq+yk39f1XcVyLaS0ctA3qUKNWSVXWnBwqZF40k3GO
YBT7Bf0fQjHFjQyIZLhTDXov0maiqXHzoxbjvbxaTjVHqPpoG3D0y5cE28AZMxVF
mPdgndPuh7nvDPgnW/D9vl7RV35/Y1DYdyCOgvMZE2nM43yn6bbIBYKk/PN9I7ar
cZ5R1NcUMRHjpWLWPrh2Yh0LV+jJsXlrwietTImNp7f/FqHd3BOwaP/K7PVuO9/n
zwmkWxme2P0=
=tckc
-----END PGP SIGNATURE-----

--------------enig464143F700D457FC32EA8AAB--
