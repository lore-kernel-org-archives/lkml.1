Return-Path: <linux-kernel-owner+w=401wt.eu-S1758863AbZFMKxg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758863AbZFMKxg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 06:53:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751278AbZFMKx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 06:53:29 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:57084 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751100AbZFMKx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 06:53:28 -0400
Date: Sat, 13 Jun 2009 12:53:22 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Tobias Diedrich <ranma+kernel@tdiedrich.de>
Cc: SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: QUIRK_FORCE_HISPD (was: Re: Ricoh R5C822 and QUIRK_FORCE_DMA)
Message-ID: <20090613125322.750a1180@mjolnir.ossman.eu>
In-Reply-To: <20090609224145.GA11001@yamamaya.is-a-geek.org>
References: <20090430224524.GA9487@yamamaya.is-a-geek.org>
	<20090513195956.30f78012@mjolnir.ossman.eu>
	<20090609224145.GA11001@yamamaya.is-a-geek.org>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24879-1244890409-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24879-1244890409-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jun 2009 00:41:45 +0200
Tobias Diedrich <ranma+kernel@tdiedrich.de> wrote:

> Pierre Ossman wrote:
> > Might be a system problem so it's Lenovo that disabled it. You're the
> > first report I've seen on this since the DMA logic was reworked so that
> > DMA didn't have to be forced for most cases.
>=20
> FWIW, so far I haven't had any errors due to dma being enabled.
>=20
> I tried changing the CAPS using setpci, but they seem to be
> read-only (unless theres are write-protect bit somewhere in the
> config space).

They tend to be write-protected, yes. Usually there are some other
registers you need to fiddle with first.

> On a related note, I had a little time to play a bit more with my
> R5C822 and found that I can also force-enable HISPD mode, which
> boost performance further.
>=20

This seems odd. What frequency is the controller reporting?

It could be that they originally wanted the controller to be
high-speed, but that they had stability problems and turned it off.
There is at least one other controller that went through that scenario.

> I tried improving the write speed by adding support for
> APP_CMD_SET_WR_BLOCK_COUNT to the block driver, but did not see any
> improvement.
> It's still in the patch, in case you are interested.

I've tried this before, and I got the same results you did.

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24879-1244890409-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkozhSgACgkQ7b8eESbyJLi2/gCfQ5ugXKQvoI5q7OXCthtpwYsP
Xa4AoMNEioRzjmThgu6GoJJKEJDXMzqc
=soiF
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24879-1244890409-0001-2--
