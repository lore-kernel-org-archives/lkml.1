Return-Path: <linux-kernel-owner+w=401wt.eu-S1763310AbYEGVrV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763310AbYEGVrV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 17:47:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755378AbYEGVqf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 17:46:35 -0400
Received: from mail.gmx.net ([213.165.64.20]:39082 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754872AbYEGVqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 17:46:33 -0400
X-Authenticated: #44953887
X-Provags-ID: V01U2FsdGVkX19g3nxwDbVg6u9+fNP5OqIGfJunlLq8Xh7VTvc7Xd
	BN6+yKse0vW1/J
Subject: Re: [BUG]:WARNING: at arch/x86/kernel/rtc.c:122 in 2.6.26-rc1
From: Mirco Tischler <mt-ml@gmx.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>, lkml <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de>
References: <1210183536.28099.10.camel@mtlp.tischlernetz>
	 <alpine.LFD.1.10.0805072102010.3318@apollo.tec.linutronix.de>
	 <1210188734.5456.14.camel@mtlp.tischlernetz>
	 <alpine.LFD.1.10.0805072253480.3318@apollo.tec.linutronix.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b7EHX6rmLDq+NB/GcQ3D"
Date: Wed, 07 May 2008 23:46:17 +0200
Message-Id: <1210196777.26103.8.camel@mtlp.tischlernetz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b7EHX6rmLDq+NB/GcQ3D
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mi, 2008-05-07 at 22:58 +0200, Thomas Gleixner wrote:
> On Wed, 7 May 2008, Mirco Tischler wrote:
>=20
> > On Mi, 2008-05-07 at 21:06 +0200, Thomas Gleixner wrote:
> > > > [11677.490019] CPU1 is down
> > > > [11677.490149] Extended CMOS year: 2000
> > > > [11677.490149] x86 PAT enabled: cpu 0, old 0x7040600070406, new
> > > > 0x7010600070106
> > > > [11677.490747] Back to C!
> > > > [11677.490952] microcode: CPU0 updated from revision 0x92 to 0x92, =
date
> > > > =3D 03132007=20
>=20
> That's an odd one: updated from revision 0x92 to 0x92
>=20
> It's right before the warning triggers. Is this microcode message in
> all your boot/resume logs ?
Yes, wondered about that too. It's defintely not on all resumes. But it
is on more than that single one triggering the warning:
May  7 19:53:21 kernel: [4307505.090195] Extended CMOS year: 2000
May  7 19:53:21 kernel: [4307505.090195] x86 PAT enabled: cpu 0, old 0x7040=
600070406, new 0x7010600070106
May  7 19:53:21 kernel: [4307505.090195] Back to C!
May  7 19:53:21 kernel: [4307505.090195] microcode: CPU0 updated from revis=
ion 0x92 to 0x92, date =3D 03132007=20
May  7 19:53:21 kernel: [4307505.090195] Extended CMOS year: 2000

May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000
May  7 21:52:04 kernel: [4294896.091827] x86 PAT enabled: cpu 0, old 0x7040=
600070406, new 0x7010600070106
May  7 21:52:04 kernel: [4294896.091827] Back to C!
May  7 21:52:04 kernel: [4294896.091827] Extended CMOS year: 2000

Thanks
Mirco

--=-b7EHX6rmLDq+NB/GcQ3D
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIIiMpz+diZ7c2xfgRAqOUAJ9rXguv45iuQGB2iXikJHNb8IL/swCfV3J/
gOfeoEquBG5kUUjjveuzmOo=
=wddx
-----END PGP SIGNATURE-----

--=-b7EHX6rmLDq+NB/GcQ3D--

