Return-Path: <linux-kernel-owner+w=401wt.eu-S1757116AbZEVL2Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757116AbZEVL2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 07:28:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756197AbZEVL2D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 07:28:03 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:35577 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756116AbZEVL2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 07:28:01 -0400
Date: Fri, 22 May 2009 13:27:55 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq@rere.qmqm.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2.6.29.2] Driver for CB710/720 memory card reader
 (MMC part) - v4
Message-ID: <20090522132755.144efcca@mjolnir.ossman.eu>
In-Reply-To: <20090508151622.GA23006@rere.qmqm.pl>
References: <20080909090613.GA22158@rere.qmqm.pl>
	<20080911201307.GA31730@rere.qmqm.pl>
	<20080912234302.GA19230@rere.qmqm.pl>
	<20080920130006.69d50cbb@mjolnir.drzeus.cx>
	<20080925062924.GA32105@rere.qmqm.pl>
	<20081004215122.0626cd7b@mjolnir.drzeus.cx>
	<20081029141146.GA17741@rere.qmqm.pl>
	<20081114220658.38f0645c@mjolnir.drzeus.cx>
	<20090201185435.GA9165@rere.qmqm.pl>
	<20090221134603.6bc3c385@mjolnir.ossman.eu>
	<20090508151622.GA23006@rere.qmqm.pl>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26545-1242991679-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26545-1242991679-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 8 May 2009 17:16:22 +0200
Micha=C5=82 Miros=C5=82aw <mirq@rere.qmqm.pl> wrote:

> Here is next version of the CB710 SD/MMC reader driver. As in previous
> versions the code is divided in two parts - virtual 'bus' driver that
> handles PCI device and registers three new devices one per card reader
> type. The other device handles SD/MMC part of the reader.
>=20
> Key changes from v3:
>  - kerneldoc for sg_mapping_iterator extension
>  - free/restore IRQ during suspend/resume
>  - protect slot->irq_handler by spinlock instead of RCU
>  - remove verify_serialization()
>  - Kconfig
>  - complete patch for linux kernel 2.6.29.2
>=20

Looks good to me. I just want you to add a MAINTAINERS entry so that
people know who to contact if they have problems with this driver.

> My patches for sg_mapping_iterator extension went to /dev/null, so I have
> incorporated them to the cb710 core driver module for now. Probably someo=
ne
> with more karma points should look at them (sgbuf2.{c,h}) and push further
> if they are of any value to other driver writers.

Give them to Andrew Morton. He's good at finding the right people and
making sure they notice. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26545-1242991679-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoWjD8ACgkQ7b8eESbyJLiYIACg9fh+WLhzVeJmp+9AU5laAUBl
Pj4AoNIpBhpMPWXx+q908CWoom98yLqf
=nRqk
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26545-1242991679-0001-2--
