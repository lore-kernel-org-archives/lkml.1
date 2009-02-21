Return-Path: <linux-kernel-owner+w=401wt.eu-S1754145AbZBUQF1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145AbZBUQF1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Feb 2009 11:05:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751163AbZBUQFP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Feb 2009 11:05:15 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:53441 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750998AbZBUQFN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Feb 2009 11:05:13 -0500
Date: Sat, 21 Feb 2009 17:05:04 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 01/13] sdhci: Add quirk for controllers with no
 end-of-busy IRQ
Message-ID: <20090221170504.657ff791@mjolnir.ossman.eu>
In-Reply-To: <20090220173308.GA7583@oksana.dev.rtsoft.ru>
References: <20090220173228.GA5091@oksana.dev.rtsoft.ru>
	<20090220173308.GA7583@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-16056-1235232310-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-16056-1235232310-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 20 Feb 2009 20:33:08 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> From: Ben Dooks <ben-linux@fluff.org>
>=20
> The Samsung SDHCI (and FSL eSDHC) controller block seems to fail
> to generate an INT_DATA_END after the transfer has completed and
> the bus busy state finished.
>=20
> Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
> new busy method are the cause of the behaviour change.
>=20
> Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---

Any objections to me merging this right away? It is needed for another
controller.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-16056-1235232310-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmgJjYACgkQ7b8eESbyJLjETgCgsJi+RmPSnZ4hyM/0HMbEGGXS
UNUAmQHl8pQ0tqXFhrfcEcN+QThpB956
=y4YH
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-16056-1235232310-0001-2--
