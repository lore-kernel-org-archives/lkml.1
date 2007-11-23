Return-Path: <linux-kernel-owner+w=401wt.eu-S1756263AbXKWQkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263AbXKWQkU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 11:40:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXKWQkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 11:40:06 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:37125 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408AbXKWQkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 11:40:05 -0500
Date: Fri, 23 Nov 2007 17:39:58 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: ARM Linux Mailing List <linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Wifi chips on SDIO interface
Message-ID: <20071123173958.31e63bf1@poseidon.drzeus.cx>
In-Reply-To: <4747006D.3080704@atmel.com>
References: <4747006D.3080704@atmel.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-31251-1195836003-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-31251-1195836003-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

I'll just readd my reply again. :)

On Fri, 23 Nov 2007 16:13:18 +0100
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> I take advantage of this thread to ask a question about the SDIO cards
> you are using to test the stack.
>=20
> I look at the page on the MMC wiki :
> http://mmc.drzeus.cx/wiki/SDIO
> but cannot see a card using the Marvell 8xxx chipset : Can you give me
> advice on which SDIO cards you are using. =20

That whole site is unfortunately completely unmaintained. I'll probably pul=
l the plug on the entire thing in the near future.

I'm afraid the only card I'm using actively is the Marvell 8686. Of my coll=
ection, it's the only one working well enough to do anything useful.

>=20
> Another point, do you know what the plans are for future SDIO wifi chips
> support ?
>  =20

Not much. Atheros 6001 support is on its way (OpenMoko has this chip, so th=
ey're looking at it). The chip unfortunately seems to be a bit misdesigned =
when it comes to timeouts so it has problems initializing. I have no idea w=
hat the current status is.

I also have a Socket wifi card, but they haven't shown any interest in prov=
iding specs, so it's just a paperweight right now.

> The Marvell chip seems a bit particular as a wifi chip (802.11 stack
> included in chip). Do you think that other chips are more or less
> difficult to interface through SDIO ? =20

Well, full MAC is probably a must when it comes to SDIO. The bus is simply =
too slow and too high-latency to get any decent software MAC running.

Rgds
Pierre

--=_hera.drzeus.cx-31251-1195836003-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRwJf7b8eESbyJLgRAmhvAJ4ubEebnnk4aP/NXcHfRffumwPllgCg8LHJ
lGyCukBfAMi8mQMS7AT21Y4=
=tsUP
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-31251-1195836003-0001-2--
