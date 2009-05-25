Return-Path: <linux-kernel-owner+w=401wt.eu-S1753422AbZEYLso@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422AbZEYLso (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 07:48:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751599AbZEYLsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 07:48:37 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:54704 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbZEYLsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 07:48:36 -0400
Date: Mon, 25 May 2009 13:48:23 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: David Brownell <david-b@pacbell.net>
Cc: Wolfgang =?UTF-8?B?TcO8ZXM=?= <wolfgang.mues@auerswald.de>,
       "Matt Fleming" <matt@console-pimps.org>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Mike Frysinger" <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc_spi: use EILSEQ for possible transmission errors
Message-ID: <20090525134823.3ab040dd@mjolnir.ossman.eu>
In-Reply-To: <200905201902.51377.david-b@pacbell.net>
References: <200905192149.07778.david-b@pacbell.net>
	<200905200220.46569.david-b@pacbell.net>
	<20090520120851.49783a8e@mjolnir.ossman.eu>
	<200905201902.51377.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-6281-1243252115-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-6281-1243252115-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 May 2009 19:02:51 -0700
David Brownell <david-b@pacbell.net> wrote:

> On Wednesday 20 May 2009, Pierre Ossman wrote:
> > >		 Remember that the
> > > firmware in the card can leverage "that's erased" knowledge for
> > > things like wear leveling. =C2=A0SSDs and other storage devices would
> > > likewise benefit from such knowledge. =C2=A0I'm quite certain there's
> > > been discussion about adding support for that in the block layer.
> >=20
> > It's already in AFAIK. I even had code for hooking it up to mmc_block.
> > But it didn't produce any measurable results so I never merged it.
>=20
> I'd expect the results would take time to show.  As in, they would
> facilitate wear leveling logic, which may be difficult to measure
> except by testing various cards to destruction ... even for vendors
> that *do* have decent wear leveling.  :)
>=20

Who are these mythical decent vendors you speak of? ;)

Seriously though, the modifications to mmc_block can still be found
here if anyone wants to play with it:

http://git.infradead.org/users/drzeus/discard-2.6.git

I haven't checked if it still applies to the current version of the
kernel though, so you're on your own. ;)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-6281-1243252115-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkoahYwACgkQ7b8eESbyJLhk+QCgtP4mknr8gLpoUfoWXsJHx04M
/GkAoM67aXzhJa7wu7WbUaLcEOOywNHm
=Vn/Z
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-6281-1243252115-0001-2--
