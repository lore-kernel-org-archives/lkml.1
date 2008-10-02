Return-Path: <linux-kernel-owner+akpm=40linux-foundation.org-S1752687AbYJBChp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687AbYJBChp (ORCPT <rfc822;akpm@linux-foundation.org>);
	Wed, 1 Oct 2008 22:37:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750769AbYJBChe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Oct 2008 22:37:34 -0400
Received: from mx39.mail.ru ([194.67.23.35]:64639 "EHLO mx39.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbYJBChe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2008 22:37:34 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Dave <kilroyd@googlemail.com>
Subject: Re: Agere Hermes source-code: copyright situation
Date: Thu, 2 Oct 2008 06:37:18 +0400
User-Agent: KMail/1.9.10
Cc: Greg KH <greg@kroah.com>, TJ <linux@tjworld.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Casual J. Programmer" <casualprogrammer@googlemail.com>,
        linux-wireless@vger.kernel.org,
        Alexander Shirshikov <alexander.shirshikov@gmail.com>
References: <200809290949.35749.arvidjaar@mail.ru> <20081001200039.GA29874@kroah.com> <48E400FA.2090305@gmail.com>
In-Reply-To: <48E400FA.2090305@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1698025.PZ9SIvic6A";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810020637.27321.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1698025.PZ9SIvic6A
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

TJ you can answer me using arvidjaar (at) newmail dot ru. Hopefully
one of them works. Re WPA2 - there is no information how to setup
CCMP/AES (even if firmware supports it); so no WPA2.

On Thursday 02 October 2008, Dave wrote:
> Greg KH wrote:
> > On Wed, Oct 01, 2008 at 05:40:29PM +0100, TJ wrote:
> >> On Wed, 2008-10-01 at 14:13 +0400, Andrey Borzenkov wrote:
> >>>On Wednesday 01 October 2008, Greg KH wrote:
> >>>> On Mon, Sep 29, 2008 at 09:49:34AM +0400, Andrey Borzenkov wrote:
> >>>>> I have here driver that can be built for two different types of
> >>>>> hardware from basically the same sources (this is port of old Agere
> >>>>> drivers for Hermes-I/Hermes-II chipsets).
> >>>>=20
> >>>> Cool, do you have a link to the code, I'd be glad to add it to
> >>>> drivers/staging/ if it's not in a fully-mergable state yet to get wi=
der
> >>>> users for it.
> >>>
> >>> You can look at it here: http://arvidjaar.newmail.ru/wlags49.tar.bz
> >>>
> >>> I doubt that it is suitable for inclusion at current state if ever.
> >>> This is taken directly from Agere 2.4 sources; the only parts that we=
re
> >>> touched are kernel glue and wireless extensions interface.
> >>>
> >>> And it is not GPL'ed, of course. I attach E-Mail I received a while
> >>> back with answere from Agere legal department.
> >>
> >> I'm attaching the original email I sent to Agere and their response for
> >> the record, hoping it helps clarify the legal position.
> >=20
> > Very nice, thanks for forwarding this on.
> >=20
> > As the license is BSD, that means we can place it in the kernel tree.
> > Do you all mind if I add it to the drivers/staging/ directory so you can
> > work on cleaning it up within the main kernel tree infrastructure?
>

I do not mind but it is likely makes no sense for H-I now; and
I do not own H-II myself so cannot work on it. If we are focusing on
H-2/2.5, it would make more sense to make similar modifications to
7.22 driver set from Agere to avoid overlap with Orinoco.
=20
> (cc'ing linux-wireless)
>
> FYI, Hermes I hardware is already covered by the orinoco driver. WPA and =
firmware download functionality (which is supported by the Agere driver, bu=
t not orinoco in 2.6.27) is already in the wireless queue for 2.6.28.
>=20

Yes, I discovered this yesterday as well. Thank you!

How are you going to distribute firmware? You will need 9.x firmware from
original Agere driver; do I understand it correctly that it will come
with orinoco in binary form?

> This leaves Hermes-II (and USB?) hardware which orinoco does not support,=
 but could if someone had access to a card for development.
>=20

As I initially wrote driver for internal consumption my mods supports
PCMCIA only.

Unfortunately I do not own Hermes-II device myself. I was asked recently
by Alexander who is owing such device and modification of Agere sources was
pretty trivial. I Cc to him; Aexander are you interested in aiding of
H-II driver development for mainstream?

--nextPart1698025.PZ9SIvic6A
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjkM+EACgkQR6LMutpd94wE/QCguH9MsaXikBy7BhVS8ALHFxic
IDEAn3hFFUwPTSy0IfuX+fe3nCvJKYZ3
=lswN
-----END PGP SIGNATURE-----

--nextPart1698025.PZ9SIvic6A--
