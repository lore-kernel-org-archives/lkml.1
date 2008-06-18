Return-Path: <linux-kernel-owner+w=401wt.eu-S1755745AbYFRNgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745AbYFRNgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 09:36:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752829AbYFRNft
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 09:35:49 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:3810 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755243AbYFRNfi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 09:35:38 -0400
Date: Wed, 18 Jun 2008 15:35:30 +0200
From: Erik Mouw <mouw@nl.linux.org>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Hans J. Koch" <hjk@linutronix.de>,
       Nicolas Ferre <nicolas.ferre@atmel.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Andrew Victor <linux@maxim.org.za>, Pierre Ossman <drzeus@drzeus.cx>,
       Eric BENARD <ebenard@free.fr>,
       ARM Linux Mailing List 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: [PATCH 0/7] mmc: at91_mci: rework to allow better transfer
Message-ID: <20080618133530.GG6788@gateway.home>
References: <483FE9E7.7020707@atmel.com> <20080609124623.5b6bda48@mjolnir.drzeus.cx> <484E4F61.7010007@atmel.com> <20080614182831.0360bd77@mjolnir.drzeus.cx> <4858DDC1.6080802@atmel.com> <20080618104723.GA6788@gateway.home> <20080618111607.GB6788@gateway.home> <20080618114057.GE2226@local> <1213789670.26255.1200.camel@pmac.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zaRBsRFn0XYhEU69"
Content-Disposition: inline
In-Reply-To: <1213789670.26255.1200.camel@pmac.infradead.org>
Organization: Eric Conspiracy Secret Labs
X-Eric-Conspiracy: There is no conspiracy!
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zaRBsRFn0XYhEU69
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 18, 2008 at 12:47:50PM +0100, David Woodhouse wrote:
> On Wed, 2008-06-18 at 13:40 +0200, Hans J. Koch wrote:
> >=20
> > I avoided the German umlaut in my name by using the abbreviation "Hans
> > J. Koch" on mailing lists. Unfortunately, I still have one mail client
> > that uses the full name. I'll fix that to avoid similar trouble.
> >=20
> > On the other hand, I used that for quite a while now, and didn't have
> > problems. It shouldn't be too difficult to have these programs use
> > UTF-8 (or any other charset) properly these days.
>=20
> I'm not convinced it's a problem with rfc2047 handling; I think it's
> simpler brain-damage than that on mailman's part. It's to do with line
> wrapping, iirc -- if an address spans two lines, like: David Woodhouse
>  <dwmw2@infradead.org>, then mailman will brokenly insert a comma where
> the line break happened -- or something like that.

It's a bit more complicated cause Mailman gets this right:

  ARM Linux Mailing List=20
  <linux-arm-kernel@lists.arm.linux.org.uk>,

It also gets RFC2407 right:

  =3D?ISO-8859-1?Q?Ville_Syrj=3DE4l=3DE4?=3D <syrjala@sci.fi>

I guess it's a combination that goes wrong:

  =3D?ISO-8859-1?Q?Hans-J=3DFCrgen_?=3D =3D?ISO-8859-1?Q?Koch?=3D=20
  <hjk@linutronix.de>

Maybe if J=FCrgen's mailer made that something like:

 =3D?ISO-8859-1Q!Hans-J=3DFCrgen_Koch?=3D

Mailman wouldn't have crippled the address?

Oh well, rmk isn't available for a few days so I can't really debug the
Mailman version on lists.arm.linux.org.uk :(


Erik

--=20
Erik Mouw -- mouw@nl.linux.org

--zaRBsRFn0XYhEU69
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIWQ8i/PlVHJtIto0RAvDSAKCAr2oa7XSP4gI8htTMpqd9cm1EYQCeIXG5
4HD2iMj1slEiz3A6apffOjc=
=cG09
-----END PGP SIGNATURE-----

--zaRBsRFn0XYhEU69--
