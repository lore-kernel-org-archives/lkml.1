Return-Path: <linux-kernel-owner+w=401wt.eu-S1764615AbZE0USj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764615AbZE0USj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:18:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932283AbZE0UNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:13:49 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:48728 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932435AbZE0UNr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:13:47 -0400
Date: Wed, 27 May 2009 22:13:42 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.29.4] Driver for CB710/720 memory card reader (MMC
 part) - v5 fixed
Message-ID: <20090527221342.3a1ba44d@mjolnir.ossman.eu>
In-Reply-To: <20090522183359.GA3567@rere.qmqm.pl>
References: <20080920130006.69d50cbb@mjolnir.drzeus.cx>
	<20080925062924.GA32105@rere.qmqm.pl>
	<20081004215122.0626cd7b@mjolnir.drzeus.cx>
	<20081029141146.GA17741@rere.qmqm.pl>
	<20081114220658.38f0645c@mjolnir.drzeus.cx>
	<20090201185435.GA9165@rere.qmqm.pl>
	<20090221134603.6bc3c385@mjolnir.ossman.eu>
	<20090508151622.GA23006@rere.qmqm.pl>
	<20090522132755.144efcca@mjolnir.ossman.eu>
	<20090522175501.GA673@rere.qmqm.pl>
	<20090522183359.GA3567@rere.qmqm.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-4487-1243455226-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-4487-1243455226-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 22 May 2009 20:33:59 +0200
Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl> wrote:

> [I messed up source trees for previous diff, please use this one instead.]
>=20
> Here is a version of the CB710 SD/MMC reader driver ready for inclusion
> upstream. The code is divided in two parts. There is a virtual 'bus' driv=
er
> that handles PCI device and registers three new devices one per card read=
er
> type. The other driver handles SD/MMC part of the reader.
>=20
> Changes from v4:
>   - sg_mapping_iterator extension renamed to avoid namespace clashes
>     when/if the extension would be merged upstream
>   - appended sgbuf2.h to cb710.h
>   - move from IDR to IDA for device ID generation
>   - cleanup after IDA on module unload
>   - added MAINTAINERS entry
> =20
> Signed-off-by: Micha=C5=82 Miros=C5=82aw <mirq-linux@rere.qmqm.pl>
>=20

Queued.

Nice work. :)

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-4487-1243455226-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkodnvoACgkQ7b8eESbyJLhL0wCZAcbewYaoL6k/awBHyu1gbxzm
rfcAn14vBR83mhLSDCOQAO7Ajal8+wry
=MOL1
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-4487-1243455226-0001-2--
