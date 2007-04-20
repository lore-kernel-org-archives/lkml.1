Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbXDTLoW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbXDTLoW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 07:44:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754444AbXDTLoV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 07:44:21 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:39269 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbXDTLoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 07:44:21 -0400
Subject: Re: VMWare Workstation 6 for debugging Linux Kernel (!)
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Petr Vandrovec <petr@vmware.com>
Cc: Andi Kleen <andi@firstfloor.org>, Xavier Bestel <xavier.bestel@free.fr>,
       roland <devzero@web.de>, linux-kernel@vger.kernel.org
In-Reply-To: <4628A238.3010602@vmware.com>
References: <03f401c782d4$95c323e0$eeeea8c0@aldipc>
	 <1177058522.14404.132.camel@frg-rhel40-em64t-04>
	 <p73r6qf49zc.fsf@bingen.suse.de>  <4628A238.3010602@vmware.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7R0sM3+x+3jCTIcOyERA"
Date: Fri, 20 Apr 2007 21:44:14 +1000
Message-Id: <1177069454.11136.14.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7R0sM3+x+3jCTIcOyERA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-20 at 04:21 -0700, Petr Vandrovec wrote:
> Andi Kleen wrote:
> > Xavier Bestel <xavier.bestel@free.fr> writes:
> >=20
> >> On Fri, 2007-04-20 at 00:46 +0200, roland wrote:
> >>
> >>> We just quietly added an exciting feature to Workstation 6.0. I belie=
ve it=20
> >>> will make WS6 a great tool for Linux kernel development. You can now =
debug=20
> >>> kernel of Linux VM with gdb running on the Host without changing anyt=
hing in=20
> >>> the Guest VM. No kdb, no recompiling and no need for second machine. =
All you=20
> >>> need is a single line in VM's configuration file.
> >> I think qemu has the exact same feature.
> >=20
> > It doesn't seem to work for x86-64 there though.
>=20
> Hello,
>=20
> Do you mean with qemu or with VMware?  Yes, we do not support replay=20
> with 64bit guests, but debug interface should just work.  Only gotcha is=20
> that for 64bit guest you need another option:
>=20
> debugStub.listen.guest64 =3D "TRUE"

Ah. That might help :)

> and then you need to attach gdb to port 8864 (*).  Unfortunately it does=20
> not seem possible to build gdb which would support 16bit/32bit code=20
> while using 64bit gdb on-wire format, so there are two interfaces.  And=20
> if you single-step switch from 64bit mode to 32bit mode or back, you=20
> also have to switch gdbs.  Yes, it is a bit unintuitive, and=20
> additionally one gdb silently ignores breakpoints set up by other gdb,=20
> so you need to keep breakpoints in sync between two gdbs yourself :-(
>=20
> (*) If you are using gdb which has both 32bit and 64bit support, be sure=20
> to issue appropriate 'set architecture xxx' before 'target remote=20
> localhost:88xx' (i386:x86-64 for port 8864, i386 or i8086 for port=20
> 8832).  Otherwise gdb is going to die complaining it could not parse=20
> remote reply.

That too.

Thanks!

Nigel

--=-7R0sM3+x+3jCTIcOyERA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGKKeON0y+n1M3mo0RAjb/AKCBIQJpR9l6TRjX3l0oW9aszUbqWgCgtbvO
pLkJNdxdpwmlAJuuSyzh5M8=
=Uo+A
-----END PGP SIGNATURE-----

--=-7R0sM3+x+3jCTIcOyERA--

