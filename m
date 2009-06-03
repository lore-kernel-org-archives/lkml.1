Return-Path: <linux-kernel-owner+w=401wt.eu-S1756662AbZFCGfh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662AbZFCGfh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 02:35:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754207AbZFCGfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 02:35:30 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36875 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752268AbZFCGf3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 02:35:29 -0400
Date: Wed, 3 Jun 2009 08:35:26 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Kalpesh Rathod <kalpeshrathod@gmail.com>
Cc: Kalpesh Rathod <kalpeshrathod@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: SDIO irq handler context
Message-ID: <20090603083526.34efe753@mjolnir.ossman.eu>
In-Reply-To: <cee4bbc90905132155q1215bbbdqb246f194fd9ef352@mail.gmail.com>
References: <cee4bbc90905132155q1215bbbdqb246f194fd9ef352@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-25015-1244010929-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-25015-1244010929-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 May 2009 10:25:37 +0530
Kalpesh Rathod <kalpeshrathod@gmail.com> wrote:

> Hi,
>=20
> SDIO driver irq handler runs in which context?
> It always runs in process context ?
> or
> It runs in either interrupt context or process context? If this is the ca=
se,
> in_interrupt can be used to distinguish?
>=20

It's run in process context as the sdio accessors sleep.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-25015-1244010929-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkomGbEACgkQ7b8eESbyJLiBhwCgjT3EzIbWX7kLstJHUggxnQ30
I3kAoKlVh8+NJ3NN86FKvV1QcgF/1P0o
=OTBw
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-25015-1244010929-0001-2--
