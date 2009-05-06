Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbZEFRam@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbZEFRam (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 13:30:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751401AbZEFRac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 13:30:32 -0400
Received: from mx40.mail.ru ([94.100.176.54]:50992 "EHLO mx40.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983AbZEFRab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 13:30:31 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Bank screen after resume on Dell XPS M1330
Date: Wed, 6 May 2009 21:30:23 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.29.1-desktop-4mnb; KDE/4.2.71; i686; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
References: <200905031111.50789.arvidjaar@mail.ru> <200905061955.13161.arvidjaar@mail.ru> <20090506165226.GA9072@elf.ucw.cz>
In-Reply-To: <20090506165226.GA9072@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3802586.PxiQHfATqJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200905062130.26099.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3802586.PxiQHfATqJ
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Wednesday 06 of May 2009 20:52:26 Pavel Machek wrote:
> On Wed 2009-05-06 19:55:10, Andrey Borzenkov wrote:
> > On Tuesday 05 of May 2009 23:49:02 Pavel Machek wrote:
> > > On Mon 2009-05-04 06:27:35, Andrey Borzenkov wrote:
> > > > On Sunday 03 of May 2009 15:56:03 Matthew Garrett wrote:
> > > > > On Sun, May 03, 2009 at 03:43:28PM +0400, Andrey Borzenkov=20
wrote:
> > > > > > On Sunday 03 of May 2009 14:59:32 Matthew Garrett wrote:
> > > > > > > On Sun, May 03, 2009 at 11:11:47AM +0400, Andrey
> > > > > > > Borzenkov
> >
> > wrote:
> > > > > > > > 01:00.0 VGA compatible controller: nVidia Corporation
> > > > > > > > GeForce 8400M GS (rev a1)
> > > > > > >
> > > > > > > We don't know how to reinitialise nvidia graphics
> > > > > > > hardware.
> > > > > >
> > > > > > Just in case - same issue also after resume from
> > > > > > hibernation. I was under impression, that hibernation does
> > > > > > not have these issues as card goes via normal POST routine.
> > > > >
> > > > > Hm. That sounds a bit weirder.
> > > >
> > > > Is it worth further debugging? Anything I can provide?
> > >
> > > Try it with minimum config, init=3D/bin/bash? Switch to plain vga
> > > console?
> >
> > As stated in my first mail, that is exactly what I started with :)
>
> Ok, ok, and even that failed with hibernation?

You are right, I was not careful when testing. I tested once more with=20
two different kernels; hibernation works (also in normal init 3) as long=20
as video settings are the same between suspend and resume. If they=20
differ (e.g. plain VGA before suspend and frame buffer after) display is=20
most likely completely garbled (but still is not blank).

Of course, any attempt to switch to X (using nv driver) after resume is=20
doomed. OTOH *starting* X after resume seems to work.=20

Sorry for the noise.

--nextPart3802586.PxiQHfATqJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkoByS8ACgkQR6LMutpd94yWgwCgjUPHY6uS0pVCJ+LRpGzyuPhj
jp8AoJlAvEBF95F03npMOVZM6QoyHMH6
=SwRv
-----END PGP SIGNATURE-----

--nextPart3802586.PxiQHfATqJ--
