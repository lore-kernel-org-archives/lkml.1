Return-Path: <linux-kernel-owner+w=401wt.eu-S1754652AbZGALJa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754652AbZGALJa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 07:09:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbZGALJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 07:09:23 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:38467 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055AbZGALJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 07:09:23 -0400
Date: Wed, 1 Jul 2009 13:09:19 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
  queues
Message-ID: <20090701130919.1cb7ec04@mjolnir.ossman.eu>
In-Reply-To: <5201e28f0906230801s11723e1bj61ac7560bfbbe55c@mail.gmail.com>
References: <4A280BD4.9080908@canonical.com>
	<20090610210247.GC1381@ucw.cz>
	<5201e28f0906230801s11723e1bj61ac7560bfbbe55c@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-8633-1246446565-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-8633-1246446565-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jun 2009 17:01:14 +0200
Stefan Bader <stefan.bader@canonical.com> wrote:

> I did not see any news related to this issue. Pierre, are you waiting
> on more info from my side? Or did I miss a change somewhere else?
>=20

I plan to have a closer look at this first. I believe your solution is
a workaround and doesn't solve the real issue. As such, I want to have
one more go at finding and fixing the real problem before committing
this. Your analysis should help a lot in that effort.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-8633-1246446565-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpLQ+IACgkQ7b8eESbyJLg/vgCff3eeuxzhA7RpBfW9f9kKQb1D
kR0AnjM7SXkRijcTvEfWWl6gBd9mv8h0
=Q5Tj
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-8633-1246446565-0001-2--
