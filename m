Return-Path: <linux-kernel-owner+w=401wt.eu-S1161383AbXDXOBp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161383AbXDXOBp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2007 10:01:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161473AbXDXOBp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Apr 2007 10:01:45 -0400
Received: from [80.68.207.6] ([80.68.207.6]:57006 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161383AbXDXOBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2007 10:01:44 -0400
Subject: Re: [ANNOUNCE] UidBind LSM 0.1
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: casey@schaufler-ca.com
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <316971.67258.qm@web36607.mail.mud.yahoo.com>
References: <316971.67258.qm@web36607.mail.mud.yahoo.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NcNmnrKXoNH3iGlUDt2A"
Organization: UnBit
Date: Tue, 24 Apr 2007 16:01:35 +0200
Message-Id: <1177423295.6547.11.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NcNmnrKXoNH3iGlUDt2A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Il giorno mar, 24/04/2007 alle 06.51 -0700, Casey Schaufler ha scritto:
> --- Roberto De Ioris <roberto@unbit.it> wrote:
>=20
> > Hi all,
> > this is a very simple module that allows bind() to tcp/udp port (>=3D10=
24)
> > only for the uids defined in a configfs tree.
>=20
> Would you be so kind as to cross post to linux-security-module?
> Methinks that you might get additional valuable feedback there.


Surely, in the next hour i will release a new version with tcp/udp
support and the possibility to specify ipv4 addresses.
I will post in linux-security-module too

>=20
> > It is a first version, it only works for PF_INET sockets and makes no
> > difference between tcp and udp (i am working on this)
> >=20
> > For (little) more info see=20
> >=20
> > http://projects.unbit.it/uidbind/
> >=20
> > Patch attached is for vanilla 2.6.20.7
>=20
> It would be correct to return -EACCES rather than -EPERM in the
> access denial case. EACCES indicates that an access control decision
> failed, while EPERM indicates that use of a privileged operation
> was attempted while not possessing appropriate privilege.

Done, thanks :)


--=20
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it
Wii: 2999 4476 3509 0964

--=-NcNmnrKXoNH3iGlUDt2A
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa =?ISO-8859-1?Q?=E8?= una parte del messaggio
	firmata digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLg2/l5tD0kpw00gRAgZYAJ4ig64z5WgY4xnhMVTshnnB4SNFEQCfYLg5
MPjTV810NuuYFll+7q1oYog=
=iSz0
-----END PGP SIGNATURE-----

--=-NcNmnrKXoNH3iGlUDt2A--

