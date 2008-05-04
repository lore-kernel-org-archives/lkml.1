Return-Path: <linux-kernel-owner+w=401wt.eu-S1758123AbYEDUXA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758123AbYEDUXA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 16:23:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756153AbYEDUWw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 16:22:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:40752 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756103AbYEDUWv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 16:22:51 -0400
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX19oU5F2jKxoewgUMtY0XBBN3XV2117eiPXKW/2fva
	nHOI9o+etwdqbe
Date: Sun, 4 May 2008 22:22:46 +0200
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
Subject: Re: Hard lockup with kernel 2.6.25 and 2.6.25.1
Message-ID: <20080504222246.50dc6f5b@highlander.home.lan>
In-Reply-To: <alpine.LNX.1.10.0805042155530.11757@fbirervta.pbzchgretzou.qr>
References: <20080504005209.13af2b2c@highlander.home.lan>
	<20080503231813.GA18248@kroah.com>
	<20080504115108.7b5a8e3f@highlander.home.lan>
	<alpine.LNX.1.10.0805042155530.11757@fbirervta.pbzchgretzou.qr>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/UQojl6.Jb94t/j=VrL.t+EN";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/UQojl6.Jb94t/j=VrL.t+EN
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 4 May 2008 21:56:26 +0200 (CEST)
Jan Engelhardt <jengelh@medozas.de> wrote:

>=20
> On Sunday 2008-05-04 11:51, Malte Schr=C3=B6der wrote:
> >>=20
> >> If it's repeatable, it would be interesting if you are able to do a
> >> git-bisect to try to narrow the issue down...
> >
> >Hmm, that's about the only box of mine where bisecting a kernel really
> >hurts. It's my central VoIP, internet, mail and other stuff gateway and
> >it takes ages to boot (it's the box where my old hardware ends up).
>=20
> You can compile the tree elsewhere (without nfs) and then run the
> appropriate install mechanisms with an NFS mount.
>=20

Oh, that's not the problem, I use the debian's kernel-package
build-system
. The problem is that the affected box is about the only box
where I really don't like downtime because it handles my
internet connection, email and telephony.
Besides from that I am currently trying to find the last working
kernel-version, since 2.6.24.6 shows the same problem.
I am currently running 2.6.24.5 again. Let's see if that runs stable.
When I have found a stable kernel I think I will bisect it, but I am
quite busy currently so it could take a while. Who knows, maybe it's
not the kernel's fault at all but some strange kind of hardware failure.

Regards
--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/UQojl6.Jb94t/j=VrL.t+EN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHhsZ4q3E2oMjYtURAnsBAKDGwEKqsXt2AEwdnwBFZnrgG9Dq6QCfaqVk
5XutwNXRYsJUYiApw/Zxro8=
=e1r7
-----END PGP SIGNATURE-----

--Sig_/UQojl6.Jb94t/j=VrL.t+EN--
