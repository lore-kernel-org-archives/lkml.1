Return-Path: <linux-kernel-owner+w=401wt.eu-S1757700AbXEQRDT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700AbXEQRDT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 13:03:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755975AbXEQRDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 13:03:12 -0400
Received: from mx.laposte.net ([81.255.54.16]:26829 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754649AbXEQRDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 13:03:11 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <20070517094557.c96f7e54.randy.dunlap@oracle.com>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
	 <1179396003.31796.4.camel@rousalka.dyndns.org>
	 <20070517094557.c96f7e54.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-sbB+MxtwoJoMaD54dtL0"
Organization: Adresse perso
Date: Thu, 17 May 2007 18:59:56 +0200
Message-Id: <1179421196.5000.5.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.nim.2) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sbB+MxtwoJoMaD54dtL0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le jeudi 17 mai 2007 =C3=A0 09:45 -0700, Randy Dunlap a =C3=A9crit :
> On Thu, 17 May 2007 12:00:02 +0200 Nicolas Mailhot wrote:
>=20
> > Le lundi 14 mai 2007 =C3=A0 01:25 +0200, Nicolas Mailhot a =C3=A9crit :
> >=20
> > > It happened once so far. The load was moderate (and certainly not
> > > comparable to what I did for Mel yesterday)
> >=20
> > Make that twice. The interesting thing is it was preceded by CD/DVD
> > access just before, to something is rotten there.
> >=20
> > 10:52:35 ISO 9660 Extensions: RRIP_1991A
> > 11:52:36 Unable to handle kernel NULL pointer dereference at 0000000000=
000000 RIP:=20
> > 11:52:36 [<0000000000000000>]
> > 11:52:36 PGD 2438a067 PUD c484067 PMD 0=20
> > 11:52:36 Oops: 0010 [1] SMP=20
> > 11:52:36 CPU 1=20
> > 11:52:36 Pid: 30655, comm: bash Not tainted 2.6.21-11.mm2.fc7.nim #1
>=20
> so just what is this kernel?  A hybrid of -mm and -fc7 or what?

-mm + md-improve-partition-detection-in-md-array.patch revert + Mel's
patches for bug #8464 + the fedora nouveau patch

the fc7.nim is there because it was build in an F7 buildroot, not
because it carries the full Fedora patchset

> Can you boot with "kstack=3D32" so that we can see more of the stack?

I can try. It's not triggering quickly though

--=20
Nicolas Mailhot

--=-sbB+MxtwoJoMaD54dtL0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZMigYACgkQI2bVKDsp8g2MRQCg2cvWCEdC6xDfGLS5yh5rYKfw
yoEAoJ5pO+XZp769OkAjoNGMSVtoOVMM
=bZYm
-----END PGP SIGNATURE-----

--=-sbB+MxtwoJoMaD54dtL0--
