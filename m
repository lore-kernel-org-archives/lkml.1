Return-Path: <linux-kernel-owner+w=401wt.eu-S1762125AbXEZSTj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762125AbXEZSTj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 14:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753674AbXEZSTc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 14:19:32 -0400
Received: from www.sf-tec.de ([62.27.20.187]:36758 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753592AbXEZSTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 14:19:31 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Richard Mittendorfer <delist@gmx.net>
Subject: Re: [BUG] Warning in mm/slab.c:777
Date: Sat, 26 May 2007 20:19:19 +0200
User-Agent: KMail/1.9.7
References: <200705260849.00356.eike-kernel@sf-tec.de> <20070526184622.cfdba54a.delist@gmx.net>
In-Reply-To: <20070526184622.cfdba54a.delist@gmx.net>
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1302086.fzkjkjTNo7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705262019.24816.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1302086.fzkjkjTNo7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

You wrote:
> Also sprach Rolf Eike Beer <eike-kernel@sf-tec.de> (Sat, 26 May 2007=20
08:48:55 +0200):
> > After bootup (runlevel 5) I found this in dmesg:
> >
> > WARNING: at mm/slab.c:777 __find_general_cachep()
> >  [<c0165fe1>] __kmalloc+0x40/0xc3
> >  [<f8f4d5ed>] drm_rmdraw+0x126/0x24e [drm]
> >  [<c023e68b>] skb_dequeue+0x39/0x3f
> >  [<f8f4d4c7>] drm_rmdraw+0x0/0x24e [drm]
> >  [<f8f4e10e>] drm_ioctl+0x14c/0x192 [drm]
> >  [<c0172cb0>] do_ioctl+0x4c/0x62
> >  [<c0172efd>] vfs_ioctl+0x237/0x249
> >  [<c017aff3>] mntput_no_expire+0x11/0x68
> >  [<c0172f5b>] sys_ioctl+0x4c/0x65
> >  [<c0103cde>] sysenter_past_esp+0x5f/0x85
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> > Kernel is Linus' git of yesterday, the first occurence of this in my lo=
gs
> > was on May 16th.
>
> It may be the same zero request I hit in slub, and according to
> http://bugzilla.kernel.org/show_bug.cgi?id=3D8476 people care about. Also
> I remember a mail from Linus, where he meant it's handled quite well
> (currently no link cause fetching thze whole IMAP quite takes some
> time, sry).

Thank you for your information. It may be the same alloc, but it's independ=
ent=20
of SLUB:

CONFIG_SLAB=3Dy
# CONFIG_SLUB is not set
# CONFIG_SLOB is not set

Eike

--nextPart1302086.fzkjkjTNo7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGWHosXKSJPmm5/E4RAge/AJ9UA+gp2MB1acyP3BqqBAX89A1ifwCglLLq
ThdQlEjXJPAVPzKlM73vwNo=
=6Dl1
-----END PGP SIGNATURE-----

--nextPart1302086.fzkjkjTNo7--
