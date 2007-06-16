Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbXFPQjL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbXFPQjL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 12:39:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbXFPQjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 12:39:01 -0400
Received: from mx34.mail.ru ([194.67.23.200]:13250 "EHLO mx27.mail.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753841AbXFPQjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 12:39:00 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Sat, 16 Jun 2007 20:38:56 +0400
User-Agent: KMail/1.9.7
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706151744.42366.arvidjaar@mail.ru> <200706150919.14150.bjorn.helgaas@hp.com>
In-Reply-To: <200706150919.14150.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3147790.IiCLUXoUjJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706162038.57296.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3147790.IiCLUXoUjJ
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007, Bjorn Helgaas wrote:
> On Friday 15 June 2007 07:44:41 am Andrey Borzenkov wrote:
> > On Friday 15 June 2007, Bjorn Helgaas wrote:
> > > Hi Andrey,
> > >
> > > If you have a chance, can you try the attached two patches?  The
> > > smsc-preconfig patch makes the HP nx5000 work, and the smsc-quirk
> > > patch makes the nw8000/nc8000 work, too.
> > >
> > > I've heard rumors that Windows does basically the same thing as the
> > > smsc-quirk patch, so I think there's a chance it might make your
> > > Toshiba work as well.
> > >
> > > I sent the smsc-preconfig patch to Andrew this morning.  I'm going
> > > to do some more testing other HP laptops before sending him the
> > > smsc-quirk patch.
> >
> > Does not work, sorry. (Patches were taken from your another mails but I
> > assume they are the same). Does not work even if I unload
> > PCMCIA/yenta_socket to "free" resources.
> >
> > I am out of ideas but am ready to test patches if someone has.
>
> Thanks for testing that.

it appears that quirk is not even applied because PnP tells us device is no=
t=20
active:

[  571.118483] pnp: PnP ACPI init
[  571.118611] ACPI: bus type pnp registered
[  571.158828] quirk_smc_enable: active =3D 0
[  571.182090] pnp: PnP ACPI: found 12 devices

so this patch effectively did not change anything.

well, that's correct so far, it really is not active after system boot. May=
=20
be, quirk should be applied when device is being activated, not when device=
=20
is being enumerated?

> I bought a Portege 4000 so I can work=20
> on this without bothering you.  I'll let you know if I make any
> progress on it.
>
> Bjorn



--nextPart3147790.IiCLUXoUjJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGdBIhR6LMutpd94wRAkUSAKCi1CAAzqMGl87+hcqqE6Lfxi3Z1gCfWlDH
A9Osnz9SwyPJRAuiNv5PSM4=
=D9Q2
-----END PGP SIGNATURE-----

--nextPart3147790.IiCLUXoUjJ--
