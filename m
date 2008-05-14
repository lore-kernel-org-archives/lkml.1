Return-Path: <linux-kernel-owner+w=401wt.eu-S1762043AbYENNDc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762043AbYENNDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2008 09:03:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758465AbYENNDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 May 2008 09:03:24 -0400
Received: from mail.gmx.net ([213.165.64.20]:47647 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755949AbYENNDX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2008 09:03:23 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19Si6ccjBRSj/ouXncciAOkY5NLz54XmaFM/HwJIo
	o/Agx78d8Fmn4a
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Jeff Dike <jdike@addtoit.com>
Subject: Re: UML build issue with v2.6.26-rc2-129-g9604006
Date: Wed, 14 May 2008 15:03:17 +0200
User-Agent: KMail/1.9.7
Cc: WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org
References: <200805141301.30027.toralf.foerster@gmx.de> <20080514112217.GC2520@hacking> <20080514125548.GA6373@c2.user-mode-linux.org>
In-Reply-To: <20080514125548.GA6373@c2.user-mode-linux.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1665891.XduEX7dOq2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805141503.20065.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1665891.XduEX7dOq2
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Wednesday 14 May 2008 14:55:48 Jeff Dike wrote :
> On Wed, May 14, 2008 at 07:22:17PM +0800, WANG Cong wrote:
> > On Wed, May 14, 2008 at 01:01:27PM +0200, =3D?ISO-8859-1?Q?Toralf_F=3DF=
6rster_ wrote:
> > >Today I got:
> > >
> > >...
> > >  CC      arch/um/os-Linux/skas/process.o
> > >  LD      arch/um/os-Linux/skas/built-in.o
> > >  CC      arch/um/os-Linux/sys-i386/registers.o
> > >arch/um/os-Linux/sys-i386/registers.c:8:22: error: asm/user.h: No such=
 file or directory
> > >arch/um/os-Linux/sys-i386/registers.c: In function 'arch_init_register=
s':
> > >arch/um/os-Linux/sys-i386/registers.c:78: error: storage size of 'fpx_=
regs' isn't known
> > >arch/um/os-Linux/sys-i386/registers.c:78: warning: unused variable 'fp=
x_regs'
> > >make[2]: *** [arch/um/os-Linux/sys-i386/registers.o] Error 1
> > >make[1]: *** [arch/um/os-Linux/sys-i386] Error 2
> > >make: *** [arch/um/os-Linux] Error 2
> >=20
> >=20
> > Hmm, it seems that I can't reproduce it with your .config.
> > And <asm/user.h> does exist.
>=20
> I bet he's using the headers exported by the current kernel, not what
> his distro gives him.
>=20
> 			Jeff
>=20

Right, IIRC I ran into this some times ago under Gentoo Linux.

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1665891.XduEX7dOq2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgq4xgACgkQhyrlCH22naNQtQCgpB3sW7Y3lBdF1g1q1XRJsyI9
5N4AoKQ/A2yhJloMU56+rMHEWli7Ac+v
=jQKK
-----END PGP SIGNATURE-----

--nextPart1665891.XduEX7dOq2--
