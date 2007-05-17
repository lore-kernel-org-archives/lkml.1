Return-Path: <linux-kernel-owner+w=401wt.eu-S1754338AbXEQKBv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754338AbXEQKBv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2007 06:01:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755615AbXEQKBm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 May 2007 06:01:42 -0400
Received: from mx.laposte.net ([81.255.54.16]:44877 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbXEQKBl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2007 06:01:41 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <1179098742.7322.5.camel@rousalka.dyndns.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-yfb8umPLm5nputMVM3M6"
Organization: Adresse perso
Date: Thu, 17 May 2007 12:00:02 +0200
Message-Id: <1179396003.31796.4.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.nim.2) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-yfb8umPLm5nputMVM3M6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le lundi 14 mai 2007 =C3=A0 01:25 +0200, Nicolas Mailhot a =C3=A9crit :

> It happened once so far. The load was moderate (and certainly not
> comparable to what I did for Mel yesterday)

Make that twice. The interesting thing is it was preceded by CD/DVD
access just before, to something is rotten there.

10:52:35 ISO 9660 Extensions: RRIP_1991A
11:52:36 Unable to handle kernel NULL pointer dereference at 00000000000000=
00 RIP:=20
11:52:36 [<0000000000000000>]
11:52:36 PGD 2438a067 PUD c484067 PMD 0=20
11:52:36 Oops: 0010 [1] SMP=20
11:52:36 CPU 1=20
11:52:36 Pid: 30655, comm: bash Not tainted 2.6.21-11.mm2.fc7.nim #1
11:52:36 RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
11:52:36 RSP: 0000:ffff810006199ee0  EFLAGS: 00010296
11:52:36 RAX: ffffffff804426a0 RBX: ffff81000903f800 RCX: 00007fff8a5e9874
11:52:36 RDX: 0000000000005410 RSI: ffff81000903f800 RDI: ffff810006a37b88
11:52:36 RBP: 00007fff8a5e9874 R08: 0000000000000000 R09: 0000000000000004
11:52:36 R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000005410
11:52:36 R13: 00000000000000ff R14: 00000000000000ff R15: 0000000000000008
11:52:36 FS:  00002b1c204ccf40(0000) GS:ffff810004017180(0000) knlGS:000000=
0000000000
11:52:36 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
11:52:36 CR2: 0000000000000000 CR3: 000000000f83b000 CR4: 00000000000006e0
11:52:36 Process bash (pid: 30655, threadinfo ffff810006198000, task ffff81=
0024319c80)
11:52:36 Stack:  ffffffff80285451 ffff81000903f800 00007fff8a5e9874 00007ff=
f8a5e9874
11:52:36 ffffffff802856be 0000000000005410 00000000000000ff ffff81000903f80=
0
11:52:36 0000000000000000 00007fff8a5e9874 0000000000005410 00000000000000f=
f
11:52:36 Call Trace:
11:52:36 [<ffffffff80285451>] do_ioctl+0x55/0x6b
11:52:36 [<ffffffff802856be>] vfs_ioctl+0x257/0x270
11:52:36 [<ffffffff80285730>] sys_ioctl+0x59/0x79
11:52:36 [<ffffffff8020955c>] tracesys+0xdc/0xe1
11:52:36=20
11:52:36 INFO: lockdep is turned off.
11:52:36=20
11:52:36 Code:  Bad RIP value.
11:52:36 RIP  [<0000000000000000>]
11:52:36 RSP <ffff810006199ee0>
11:52:36 CR2: 0000000000000000

I'd try rc2-mm1, but I don't know if the patches of Mel Gorman &
Christoph Lameter for bug #8464 have been merged yet

Regards,

--=20
Nicolas Mailhot

--=-yfb8umPLm5nputMVM3M6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZMJ50ACgkQI2bVKDsp8g0pKgCg1wEPCl4kD0yi/an6O+DnGEzK
7HAAn0cy8e3TFNDOJvBCfLmxlyzXNeCz
=3DAj
-----END PGP SIGNATURE-----

--=-yfb8umPLm5nputMVM3M6--
