Return-Path: <linux-kernel-owner+w=401wt.eu-S1755312AbYGJGfQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755312AbYGJGfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 02:35:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753534AbYGJGfF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 02:35:05 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58285 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752923AbYGJGfE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 02:35:04 -0400
Date: Thu, 10 Jul 2008 08:34:57 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
 disabling IRQ
Message-ID: <20080710083457.7887d363@mjolnir.drzeus.cx>
In-Reply-To: <20080624181656.GB14243@hardeman.nu>
References: <20080624181656.GB14243@hardeman.nu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11481-1215671701-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11481-1215671701-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

When sending bug reports, you should have a look in MAINTAINERS and
make sure you cc the relevant people responsible for the part of the
kernel you're having problems with. Thankfully Andrew Morton noticed
your mail and forwarded it to me.

On Tue, 24 Jun 2008 20:16:56 +0200
David H=C3=A4rdeman <david@hardeman.nu> wrote:

> I'm using my brand new HP 8510w laptop with kernel 2.6.25 (Debian kernel=
=20
> 2.6.25-2-amd64 version 2.6.25-5 to be exact) and the integrated memory=20
> card reader is detected by the sdhci kernel module.
>=20
> However, about 10 minutes after boot I get the following message in=20
> dmesg (pid and process may change of course):
>=20
> [  697.844419] irq 19: nobody cared (try booting with the "irqpoll" optio=
n)

Do you have a card in at this point? And can you give me a complete
dmesg dump. The sdhci hardware might not be the culprit, but just a
trigger in that it enables that interrupt line.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11481-1215671701-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh1rZQACgkQ7b8eESbyJLigIgCg7FwPtcwCdQTcYldTYh57ekWM
sCgAoOR7eSjH4kim9oULRIplkQukskPJ
=f+5K
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11481-1215671701-0001-2--
