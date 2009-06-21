Return-Path: <linux-kernel-owner+w=401wt.eu-S1755155AbZFUS4l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755155AbZFUS4l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 14:56:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263AbZFUS4e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 14:56:34 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:56309 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754075AbZFUS4e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 14:56:34 -0400
Date: Sun, 21 Jun 2009 20:56:31 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Harald Welte <HaraldWelte@viatech.com>
Cc: Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sdhci: Specific quirk vor VIA SDHCI controller in
 VX855ES
Message-ID: <20090621205631.067429de@mjolnir.ossman.eu>
In-Reply-To: <20090619222828.GA4664@prithivi.gnumonks.org>
References: <20090618145338.GX7692@prithivi.gnumonks.org>
	<20090619213314.150f0d98@mjolnir.ossman.eu>
	<20090619222828.GA4664@prithivi.gnumonks.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-13696-1245610595-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-13696-1245610595-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 20 Jun 2009 00:28:28 +0200
Harald Welte <HaraldWelte@viatech.com> wrote:

> Hi!
>=20
> On Fri, Jun 19, 2009 at 09:33:14PM +0200, Pierre Ossman wrote:
>=20
> > Does this block have a name? Something nicer than 0x95d0 in the id list
> > would be nice.
>=20
> Unfortunately no.  We really have a big mess with those integrated chipse=
ts
> that have something like 15 PCI devices inside one component.  We cannot =
call
> all of them 'VX855'. or 'VX800', as that would clash.  Naming things
> 'PCI_DEVICE_VIA_VX800_SDHCI' is also not really correct, since the same
> block appearas in other integrated chipsets, too.
>=20
> As for VIA's documentation, every block is called something like D13F3 (p=
ci
> device 13 function 3), which doesn't really sound all that much better th=
an
> just putting a 0x95d0 there.
>=20
> To make things even furter complicated, some VIA Docs refer to the SDHCI
> controller as 'SDIO controller' and the via-sdmmc as 'SD card controller'=
...
>=20

Sounds like you guys need an official code name department. :)

I've queued up the patch.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-13696-1245610595-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAko+gmIACgkQ7b8eESbyJLhpBACdHud77uLTPh9/tfcxv1Gzu5si
yJMAoMwu7kMe3VEpo/Ao9OstjB6CKsZ2
=o7K5
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-13696-1245610595-0001-2--
