Return-Path: <linux-kernel-owner+w=401wt.eu-S935486AbXFFUp3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935486AbXFFUp3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 16:45:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932771AbXFFUpU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 16:45:20 -0400
Received: from mx1-2.mail.ru ([194.67.23.121]:21918 "EHLO mx1.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1763548AbXFFUpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 16:45:19 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Thu, 7 Jun 2007 00:45:01 +0400
User-Agent: KMail/1.9.7
Cc: "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       "Samuel Ortiz" <samuel@sortiz.org>, linux-kernel@vger.kernel.org,
       "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706060729.13338.arvidjaar@mail.ru> <200706061309.28633.bjorn.helgaas@hp.com>
In-Reply-To: <200706061309.28633.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5655650.afaLAWbM9N";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706070045.14040.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5655650.afaLAWbM9N
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> On Tuesday 05 June 2007 09:29:11 pm Andrey Borzenkov wrote:
> > On Wednesday 06 June 2007, Bjorn Helgaas wrote:
> > > Something's wrong with this strategy.  The BIOS is telling us that an
> > > SMCf010 device is present, active, and responds at io ports 0x100-0x1=
07
> > > and 0x2e8-0x2ef.  The fact that it happens to be on the other side of
> > > an ISA or LPC bridge should be immaterial to the OS driver.
> >
> > I thought this as well.
>
> If this is really true, it also means we shouldn't twiddle with the
> bridge.  If the BIOS left us a working setup, the preconfiguration
> is certainly going to change it to something incompatible with the
> PNP info.
>
> What if we try the following patch, which keeps the FIR/SIR swap and
> just removes the preconfiguration?
>

I already tried different patch but with similar effect (switch off=20
preconfiguration) - it does not work. I am beginning to doubt whether drier=
=20
works on my system at all (i.e. before PnP change); have to find time to=20
test.

=2Dandrey

--nextPart5655650.afaLAWbM9N
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGZxzPR6LMutpd94wRAs7xAKCpv7tmD57nSPqnC6a7DANCTmDKmwCgn2F6
3gmsNn1Hgkm1vWnGfyU1kcI=
=0Xwe
-----END PGP SIGNATURE-----

--nextPart5655650.afaLAWbM9N--
