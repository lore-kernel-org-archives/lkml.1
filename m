Return-Path: <linux-kernel-owner+w=401wt.eu-S1758042AbZCYLge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758042AbZCYLge (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 07:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbZCYLgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 07:36:25 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41023 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbZCYLgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 07:36:24 -0400
Date: Wed, 25 Mar 2009 12:36:13 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Manuel Lauss <mano@roarinelk.homelinux.net>, linux-kernel@vger.kernel.org
Subject: Re: MMC layer regression with single-block controllers
Message-ID: <20090325123613.06404b17@mjolnir.ossman.eu>
In-Reply-To: <20090325110401.GM27476@kernel.dk>
References: <20090323092802.GA30122@roarinelk.homelinux.net>
	<20090324210138.71029c2c@mjolnir.ossman.eu>
	<20090325104837.GA18389@roarinelk.homelinux.net>
	<20090325110401.GM27476@kernel.dk>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26860-1237980979-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26860-1237980979-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Mar 2009 12:04:01 +0100
Jens Axboe <jens.axboe@oracle.com> wrote:

>=20
> Well, as the warning tells you, it's not supported. But that doesn't
> mean you can't do single sector transfers and complete the IO when you
> have done all of them.
>=20

That's an annoying limitation and sort of defeats the purpose of
specifying a maximum sector count. Why can't it go below 8?

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26860-1237980979-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknKFy8ACgkQ7b8eESbyJLhstACgtdRhmg8fs4hHfUU2v4DkvqwH
seAAn24Kw5FbrrycZrMKnueJ2yFR5knQ
=q+OH
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26860-1237980979-0001-2--
