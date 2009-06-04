Return-Path: <linux-kernel-owner+w=401wt.eu-S1753783AbZFDTW7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783AbZFDTW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 15:22:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752281AbZFDTWv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 15:22:51 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47807 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbZFDTWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 15:22:51 -0400
Date: Thu, 4 Jun 2009 21:22:46 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Matt Fleming <matt@console-pimps.org>
Cc: Stefan Bader <stefan.bader@canonical.com>, Jens Axboe <axboe@kernel.dk>,
       linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] mmc: prevent dangling block device from accessing stale
 queues
Message-ID: <20090604212246.36762996@mjolnir.ossman.eu>
In-Reply-To: <20090604191513.GA5702@console-pimps.org>
References: <4A280BD4.9080908@canonical.com>
	<20090604202900.57f31d6a@mjolnir.ossman.eu>
	<4A2819DA.7040603@canonical.com>
	<20090604191513.GA5702@console-pimps.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10530-1244143370-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10530-1244143370-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 4 Jun 2009 20:15:13 +0100
Matt Fleming <matt@console-pimps.org> wrote:

>=20
> Maybe I'm missing something, but why is the device instance being
> destroyed during a suspend? E.g why do you have mmcblk0 before suspend and
> mmcblk1 after suspend?

Because the card gets powered down during suspend and we have no way of
detecting what has happened to it when we come back up. USB does the
same thing (although it has slightly more intelligent hardware which
can keep track of removal as long as the host has some power).

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10530-1244143370-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkooHwoACgkQ7b8eESbyJLjMnQCfRNj8oVJWmW+nvXB6Zc41gnq/
7vsAn0BQx+87zBVW1PSRzeJlxdIsNc3E
=uwZN
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10530-1244143370-0001-2--
