Return-Path: <linux-kernel-owner+w=401wt.eu-S1755178AbZFCUJT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178AbZFCUJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:09:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbZFCUJH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:09:07 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51550 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750954AbZFCUJG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:09:06 -0400
Date: Wed, 3 Jun 2009 22:09:02 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Alessandro Bono <alessandro.bono@gmail.com>
Cc: sdhci-devel@list.drzeus.cx, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Sdhci-devel] 2.6.29.1 sdhci: irq 19: nobody cared
Message-ID: <20090603220902.56f97abc@mjolnir.ossman.eu>
In-Reply-To: <1239980418.6220.15.camel@champagne>
References: <1239980418.6220.15.camel@champagne>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-31215-1244059746-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-31215-1244059746-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 17 Apr 2009 17:00:18 +0200
Alessandro Bono <alessandro.bono@gmail.com> wrote:

> Hi
>=20
> This is a bug that occur from time to time on my (unsed) sdhci card
> drive
> this is with kernel 2.6.29.1 (not a regression, I had the same problem
> with older kernel)
>=20
> [ 2885.888003] irq 19: nobody cared (try booting with the "irqpoll"
> option)

Unfortunately it's most likely something else, which happens to be
sharing the interrupt line with the SD controller. Please try to get in
touch with the Linux ACPI people. They are generally very good at
sorting out irq issues.

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

--=_freyr.ossman.eu-31215-1244059746-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkom2GIACgkQ7b8eESbyJLjvwgCfZGlmSGJMdyDaWC45ZA1qNEbG
m90An2cK0sJeMMOwJayEBls4o6B3sfEu
=uOOm
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-31215-1244059746-0001-2--
