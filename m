Return-Path: <linux-kernel-owner+w=401wt.eu-S1423268AbXDYH23@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423268AbXDYH23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 03:28:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423266AbXDYH23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 03:28:29 -0400
Received: from [80.68.207.18] ([80.68.207.18]:57681 "EHLO smtp.unbit.it"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1423264AbXDYH21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 03:28:27 -0400
Subject: Re: [ANNOUNCE] UidBind LSM 0.2
From: Roberto De Ioris <roberto@unbit.it>
Reply-To: roberto@unbit.it
To: Gerhard Mack <gmack@innerfire.net>
Cc: linux-security-module@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704241809400.21879@mtl.rackplans.net>
References: <36153.9499.qm@web36603.mail.mud.yahoo.com>
	 <Pine.LNX.4.64.0704241809400.21879@mtl.rackplans.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-orxwhm9xJLR21m6i3aDm"
Organization: UnBit
Date: Wed, 25 Apr 2007 09:28:22 +0200
Message-Id: <1177486102.25490.6.camel@hagrid>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-orxwhm9xJLR21m6i3aDm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Il giorno mar, 24/04/2007 alle 18.11 -0400, Gerhard Mack ha scritto:
> On Tue, 24 Apr 2007, Casey Schaufler wrote:
>=20
> > --- Gerhard Mack <gmack@innerfire.net> wrote:

> > If you're daring you could propose that low number ports be treated
> > the same way as other ports, with the default ownership being root and
> > the default ACL allowing only root.
>=20
> ACL may be more complicated than needed when a simple GID addition would=20
> make this right about perfect.


The unix way(TM) for specifying multiple uid is...ehm.. groups :)
I will add the gid,tcp_gid and udp_gid configfs attributes in the next
release.
The 'check order' will be:

uidbind/<port>/<ip>/<proto>_uid =20
uidbind/<port>/<ip>/uid
uidbind/<port>/<proto>_uid
uidbind/<port>/uid
uidbind/<port>/<ip>/<proto>_gid =20
uidbind/<port>/<ip>/gid
uidbind/<port>/<proto>_gid
uidbind/<port>/gid

I am investigating the possibility of port-range use, particularly the
overlap checks and performance problems.

--=20
Roberto De Ioris
http://unbit.it
JID: roberto@jabber.unbit.it
Wii: 2999 4476 3509 0964

--=-orxwhm9xJLR21m6i3aDm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Questa =?ISO-8859-1?Q?=E8?= una parte del messaggio
	firmata digitalmente

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLwMWl5tD0kpw00gRAgcoAJ9gHY7w/q/TuF9XpwGLcwgcCDZDTACfc6SE
ePagi65WXWrzb9mVX7Vd1y4=
=8lB3
-----END PGP SIGNATURE-----

--=-orxwhm9xJLR21m6i3aDm--

