Return-Path: <linux-kernel-owner+w=401wt.eu-S1751762AbXDWVFK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbXDWVFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2007 17:05:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753641AbXDWVFK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Apr 2007 17:05:10 -0400
Received: from [80.68.207.6] ([80.68.207.6]:45620 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751762AbXDWVFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2007 17:05:08 -0400
Subject: Re: [ANNOUNCE] UidBind LSM 0.1
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0704231435430.15351@mtl.rackplans.net>
References: <1177318451.20613.8.camel@hagrid>
	 <Pine.LNX.4.64.0704231435430.15351@mtl.rackplans.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-8Aqp9hIFVvQGkaNYGSKr"
Organization: UnBit
Date: Mon, 23 Apr 2007 23:04:59 +0200
Message-Id: <1177362299.20613.28.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-8Aqp9hIFVvQGkaNYGSKr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Il giorno lun, 23/04/2007 alle 14.38 -0400, Gerhard Mack ha scritto:
> On Mon, 23 Apr 2007, Roberto De Ioris wrote:
> > Hi all,
> > this is a very simple module that allows bind() to tcp/udp port (>=3D10=
24)
> > only for the uids defined in a configfs tree.
> >=20
> > It is a first version, it only works for PF_INET sockets and makes no
> > difference between tcp and udp (i am working on this)
> >=20
> > For (little) more info see=20
> >=20
> > http://projects.unbit.it/uidbind/
> >=20
> > Patch attached is for vanilla 2.6.20.7
>=20
> Is it possible to lock a range of ports to a uid? =20

I think i can implement something like a configfs item named
'8081-8090', instead of only '8081'.
I will need to validate the range, but its not too difficult.

>=20
> Also, is it possible to lock a uid to one ip address?  For example usera=20
> can only bind to 10.0.0.23 while userb can only bind to 10.0.0.24.=20

This is simple to add and i have already a patch for it.
In the next few days i will post it.


--=20
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it
Wii: 2999 4476 3509 0964

--=-8Aqp9hIFVvQGkaNYGSKr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa =?ISO-8859-1?Q?=E8?= una parte del messaggio
	firmata digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLR97l5tD0kpw00gRAgneAJ0fRCges28amoN9UOPNxMWlNkGvtQCeOUEt
a339l35Ng1TTYcZI7CiO62o=
=Obg0
-----END PGP SIGNATURE-----

--=-8Aqp9hIFVvQGkaNYGSKr--

