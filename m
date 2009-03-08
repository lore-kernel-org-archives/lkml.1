Return-Path: <linux-kernel-owner+w=401wt.eu-S1752302AbZCHOR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302AbZCHOR3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 10:17:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752045AbZCHORS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 10:17:18 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57000 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbZCHORR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 10:17:17 -0400
Date: Sun, 8 Mar 2009 15:17:10 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: avorontsov@ru.mvista.com
Cc: Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 07/13] sdhci: Add support for hosts with strict 32 bit
 addressing
Message-ID: <20090308151710.637fe280@mjolnir.ossman.eu>
In-Reply-To: <20090304174845.GC7477@oksana.dev.rtsoft.ru>
References: <20090213144630.GA13436@oksana.dev.rtsoft.ru>
	<20090213144722.GG23889@oksana.dev.rtsoft.ru>
	<20090221165833.6dec220a@mjolnir.ossman.eu>
	<20090304174845.GC7477@oksana.dev.rtsoft.ru>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-21860-1236521833-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-21860-1236521833-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Mar 2009 20:48:45 +0300
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> But I see the point of confusion... Instead of teaching
> "SDHCI core" to work with 32 bits hosts, we'd better handle this
> in the eSDHC part, in the accessors.
>=20
> This is relatively trivial and should not cause much overhead
> (at least when using DMA), just a small state machine with
> the xfer mode register shadowed in software (plus, notice that
> this also handles BLOCK_SIZE, as I promised in another email):
>=20

Me like. Keeps my life a lot saner. :)

Just be aware that there is a remote risk of breakage as people hacking
on sdhci-core won't be aware of esdhc's, let's call it unique,
behaviour. Some testing now and then on your part would be prudent. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-21860-1236521833-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkmz02kACgkQ7b8eESbyJLi+9ACfTPELBvqvxvpyZrSpgjCBL32t
ARYAn1KnDdIMAk/ONTs4epEqRHmMx+Ej
=drI/
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-21860-1236521833-0001-2--
