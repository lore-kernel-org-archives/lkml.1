Return-Path: <linux-kernel-owner+w=401wt.eu-S1754046AbZIGRAC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046AbZIGRAC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 13:00:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753122AbZIGRAB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 13:00:01 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:55191 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZIGRAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 13:00:00 -0400
Date: Mon, 7 Sep 2009 18:59:56 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Matthieu CASTET <matthieu.castet@parrot.com>
Cc: "sdhci-devel@lists.ossman.eu" <sdhci-devel@lists.ossman.eu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: sdhci can turn off irq up to 200 ms
Message-ID: <20090907185956.3f53440c@mjolnir.ossman.eu>
In-Reply-To: <4AA4D8BA.602@parrot.com>
References: <4A4B6184.7000903@parrot.com>
	<4A55C631.7030103@parrot.com>
	<20090906152537.15303d69@mjolnir.ossman.eu>
	<4AA4D8BA.602@parrot.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-5586-1252342801-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-5586-1252342801-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Sep 2009 11:56:10 +0200
Matthieu CASTET <matthieu.castet@parrot.com> wrote:

> Pierre Ossman a =C3=A9crit :
> >=20
> > I seem to recall having problems with jiffies not updating with those
> > locks held (or perhaps it was when inside the isr).
> >=20
> > What arch have you been testing this on?
> It have been tested on arm.
>=20

Things might be different there. I suggest you also try to get it
tested on x86, where this driver sees most of its use.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-5586-1252342801-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqlPA8ACgkQ7b8eESbyJLhOlgCg4XiY5Ew7tyqBkxQRlK9zhq1v
/C8An2SKn3VY84zyfnlmIxFD1SNmSruh
=Y1ie
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-5586-1252342801-0001-2--
