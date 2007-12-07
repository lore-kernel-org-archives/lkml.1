Return-Path: <linux-kernel-owner+w=401wt.eu-S1755868AbXLGXjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbXLGXjR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 18:39:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbXLGXjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 18:39:08 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34578 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751825AbXLGXjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 18:39:07 -0500
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org
In-Reply-To: <20071207152249.360af326.akpm@linux-foundation.org>
References: <1197059904.15428.15.camel@localhost>
	 <20071207150251.a0dbae23.akpm@linux-foundation.org>
	 <1197068983.15428.29.camel@localhost>
	 <20071207152249.360af326.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-DqAwPAeW7Gfhi+oYS+Kg"
Date: Fri, 07 Dec 2007 23:39:04 +0000
Message-Id: <1197070744.15428.33.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0mmf-0001l1-AJ-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DqAwPAeW7Gfhi+oYS+Kg
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
> On Fri, 07 Dec 2007 23:09:43 +0000
> Zan Lynx <zlynx@acm.org> wrote:
>=20
> >=20
> > On Fri, 2007-12-07 at 15:02 -0800, Andrew Morton wrote:
> > > On Fri, 07 Dec 2007 20:38:24 +0000
> > > Zan Lynx <zlynx@acm.org> wrote:
> > >=20
> > > > While I'm reporting problems I'll get this one out there.
> > > >=20
> > > > I normally use a USB-2 memory card reader but I also have a PCMCIA
> > > > CompactFlash adapter that I use occasionally.  During the MM series
> > > > kernels 2.6.22 and 23 (I am pretty sure) this didn't work at all.  =
I
> > > > don't know about vanilla since I don't run that.
> > > >=20
> > > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, bu=
t I
> > > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I =
got
> > > > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > > > reader.
> > > >
> >=20
[cut]
> Oh, OK.  Hopefully the ata guys can help out with this.
>=20
> I don't know if it actually strictly a regression?  Did libata ever suppo=
rt
> that device in any earlier kernels?

That could be why it didn't work for a few kernel versions.  I
reconfigured for a libata-only system a while back.  And, since I
usually use the USB-2 flash reader I didn't care much about the PCMCIA.

I will try reverting that patch later tonight, in a few hours.
--=20
Zan Lynx <zlynx@acm.org>

--=-DqAwPAeW7Gfhi+oYS+Kg
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWdmYG8fHaOLTWwgRAm8vAKCY1iRViJwnnqs4Q1gu6gR/LZT5awCdHab7
VKBRbOgE/uAmzSeUsngtHU8=
=a9VD
-----END PGP SIGNATURE-----

--=-DqAwPAeW7Gfhi+oYS+Kg--

