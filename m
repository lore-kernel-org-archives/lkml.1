Return-Path: <linux-kernel-owner+w=401wt.eu-S1755715AbZCPSaa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715AbZCPSaa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 14:30:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754316AbZCPSaT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 14:30:19 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47680 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754131AbZCPSaS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 14:30:18 -0400
Date: Mon, 16 Mar 2009 19:30:10 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, drzeus-wbsd@drzeus.cx,
       Magnus Damm <magnus.damm@gmail.com>, ian@mnementh.co.uk,
       akpm@linux-foundation.org
Subject: Re: [PATCH 00/05] tmio_mmc: Minor fixes and cnf/irq changes
Message-ID: <20090316193010.56644165@mjolnir.ossman.eu>
In-Reply-To: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
References: <20090311125845.1563.31960.sendpatchset@rx1.opensource.se>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-8816-1237228211-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-8816-1237228211-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Mar 2009 21:58:45 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> tmio_mmc: Minor fixes and cnf/irq changes
>=20
> These patches fix two trivial issues and updates the tmio_mmc
> driver to support hardware configurations that lack the cnf io
> area (only a single ctl area) but may use multiple interrupts.
>=20
> [PATCH 01/05] tmio_mmc: Fix one off, use resource_size() in probe()
> [PATCH 02/05] tmio_mmc: Fix use after free in remove()
> [PATCH 03/05] tmio_mmc: Break out cnf area operations
> [PATCH 04/05] tmio_mmc: Make cnf area optional
> [PATCH 05/05] tmio_mmc: Support multiple interrupts
>=20
> Signed-off-by: Magnus Damm <damm@opensource.se>
> ---

I've queued up patch one and two for now. Thanks.

Ian, I noticed that there isn't a MAINTAINERS entry for this driver.
Care to send me a patch to remedy that?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-8816-1237228211-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm+mrQACgkQ7b8eESbyJLitXwCgihzCplEO1Dh8W4KStVn4gh+E
W/4AoINThg8t6bqWKNIz5QvHDJogbdKN
=34ym
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-8816-1237228211-0001-2--
