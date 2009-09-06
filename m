Return-Path: <linux-kernel-owner+w=401wt.eu-S1755026AbZIFNaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026AbZIFNaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Sep 2009 09:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754966AbZIFNaU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Sep 2009 09:30:20 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:51698 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754858AbZIFNaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Sep 2009 09:30:19 -0400
Date: Sun, 6 Sep 2009 15:30:18 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Tobias Diedrich <ranma@tdiedrich.de>
Cc: SDHCI development <sdhci-devel@lists.ossman.eu>,
       linux-kernel@vger.kernel.org
Subject: Re: QUIRK_FORCE_HISPD (was: Re: Ricoh R5C822 and QUIRK_FORCE_DMA)
Message-ID: <20090906153018.6c03d942@mjolnir.ossman.eu>
In-Reply-To: <20090801051716.GA28791@yamamaya.is-a-geek.org>
References: <20090430224524.GA9487@yamamaya.is-a-geek.org>
	<20090513195956.30f78012@mjolnir.ossman.eu>
	<20090609224145.GA11001@yamamaya.is-a-geek.org>
	<20090613125322.750a1180@mjolnir.ossman.eu>
	<20090801051716.GA28791@yamamaya.is-a-geek.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-24517-1252243821-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-24517-1252243821-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 1 Aug 2009 07:17:16 +0200
Tobias Diedrich <ranma@tdiedrich.de> wrote:

> Pierre Ossman wrote:
> > > On a related note, I had a little time to play a bit more with my
> > > R5C822 and found that I can also force-enable HISPD mode, which
> > > boost performance further.
> > >=20
> >=20
> > This seems odd. What frequency is the controller reporting?
> >=20
> > It could be that they originally wanted the controller to be
> > high-speed, but that they had stability problems and turned it off.
> > There is at least one other controller that went through that scenario.
>=20
> I assume thats host->max_clk?
> The controller seems to report 33MHz for that value.
>=20

Ah, then your controller is most likely not really high-speed. You're
getting a bit more performance as you are forcing things out-of-spec
and you're lucky enough that it still happens to work. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-24517-1252243821-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEARECAAYFAkqjuWwACgkQ7b8eESbyJLhnEwCgtHMbnq32l/087v+7EPBRbjgP
G6oAn12qYlI1lgObKy6SVXftsJROc04Y
=6l9K
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-24517-1252243821-0001-2--
