Return-Path: <linux-kernel-owner+w=401wt.eu-S1758089AbZEMQ3L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758089AbZEMQ3L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 12:29:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753296AbZEMQ2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 12:28:54 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47314 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753256AbZEMQ2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 12:28:53 -0400
Date: Wed, 13 May 2009 18:28:46 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Luis Galdos <luis.galdos@digi.com>
Cc: Dan Williams <dcbw@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
       Pierre Ossman <drzeus@drzeus.cx>
Subject: Re: [LIBERTAS-SDIO]  Support for single transfer blocks?
Message-ID: <20090513182846.044fc461@mjolnir.ossman.eu>
In-Reply-To: <1242223408.11182.34.camel@localhost.localdomain>
References: <4A08392F.70108@digi.com>
	<20090512231150.bc0c65c6.akpm@linux-foundation.org>
	<1242223408.11182.34.camel@localhost.localdomain>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-7307-1242232130-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-7307-1242232130-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> > On Mon, 11 May 2009 16:41:51 +0200 Luis Galdos <luis.galdos@digi.com> w=
rote:
> > >=20
> > > * The transfer of Ethernet-frames works only if the "complete" frame =
is smaller than the=20
> > > block size of the SDIO-host. By larger packages, the SD8686 doesn't g=
enerate the expected=20
> > > IRQ (cause it expected a multiple transfer) and the driver detects a =
timeout.
> > >=20

Unfortunately, the libertas chip cannot support your host as it
requires everything to be done in a single transaction. So I'm afraid
you'll have to look at another host controller or another wifi chip.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-7307-1242232130-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoK9UIACgkQ7b8eESbyJLg9zACggIzHgig74u0ITvYVna8Z7pIw
mBIAoPGhYAkxdhJT1IchqcX7g3CNO6MP
=/U4z
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-7307-1242232130-0001-2--
