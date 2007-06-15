Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbXFONo6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbXFONo6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2007 09:44:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753874AbXFONos
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jun 2007 09:44:48 -0400
Received: from mx6.mail.ru ([194.67.23.26]:3881 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753840AbXFONor (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2007 09:44:47 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Subject: Re: 2.6.22-rc: regression: no irda0 interface (2.6.21 was OK), smsc does not find chip
Date: Fri, 15 Jun 2007 17:44:41 +0400
User-Agent: KMail/1.9.7
Cc: Samuel Ortiz <samuel@sortiz.org>,
       "Linus Walleij (LD/EAB)" <linus.walleij@ericsson.com>,
       linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>, ambx1@neo.rr.com,
       linux-pcmcia@lists.infradead.org
References: <A6D19A13FE030A409EC4362C172E091F016F51AF@eseldmw101.eemea.ericsson.se> <200706111804.49752.arvidjaar@mail.ru> <200706141530.56176.bjorn.helgaas@hp.com>
In-Reply-To: <200706141530.56176.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3371302.lUAsfQqc9K";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706151744.42366.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3371302.lUAsfQqc9K
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Friday 15 June 2007, Bjorn Helgaas wrote:
> Hi Andrey,
>
> If you have a chance, can you try the attached two patches?  The
> smsc-preconfig patch makes the HP nx5000 work, and the smsc-quirk
> patch makes the nw8000/nc8000 work, too.
>
> I've heard rumors that Windows does basically the same thing as the
> smsc-quirk patch, so I think there's a chance it might make your
> Toshiba work as well.
>
> I sent the smsc-preconfig patch to Andrew this morning.  I'm going
> to do some more testing other HP laptops before sending him the
> smsc-quirk patch.
>

Does not work, sorry. (Patches were taken from your another mails but I ass=
ume=20
they are the same). Does not work even if I unload PCMCIA/yenta_socket=20
to "free" resources.

I am out of ideas but am ready to test patches if someone has.

--nextPart3371302.lUAsfQqc9K
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGcpfKR6LMutpd94wRAkDCAKDKJ2Pg9ZgEv+0PNSFdrPxhSHD6/wCgh/cF
RuY2GDTL8x8TlLLKDoSI3O4=
=2AFF
-----END PGP SIGNATURE-----

--nextPart3371302.lUAsfQqc9K--
