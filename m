Return-Path: <linux-kernel-owner+w=401wt.eu-S1762527AbXEZTK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762527AbXEZTK7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 15:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755119AbXEZTKw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 15:10:52 -0400
Received: from mx.laposte.net ([81.255.54.16]:25076 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753674AbXEZTKv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 15:10:51 -0400
Subject: Re: [Bug 8473] New: Oops: 0010 [1] SMP
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>,
       linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
       Christoph Lameter <clameter@sgi.com>
In-Reply-To: <1179421196.5000.5.camel@rousalka.dyndns.org>
References: <200705132102.l4DL2onF003014@fire-2.osdl.org>
	 <20070513154718.bb338ceb.akpm@linux-foundation.org>
	 <1179098742.7322.5.camel@rousalka.dyndns.org>
	 <1179396003.31796.4.camel@rousalka.dyndns.org>
	 <20070517094557.c96f7e54.randy.dunlap@oracle.com>
	 <1179421196.5000.5.camel@rousalka.dyndns.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-ywpth4yo9+MmsED4S3Wo"
Organization: Adresse perso
Date: Sat, 26 May 2007 21:10:15 +0200
Message-Id: <1180206615.3430.8.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 (2.11.2-1.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ywpth4yo9+MmsED4S3Wo
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le jeudi 17 mai 2007 =C3=A0 18:59 +0200, Nicolas Mailhot a =C3=A9crit :
> Le jeudi 17 mai 2007 =C3=A0 09:45 -0700, Randy Dunlap a =C3=A9crit :
>=20
> > Can you boot with "kstack=3D32" so that we can see more of the stack?
>=20
> I can try. It's not triggering quickly though

Seems I was completely wrong about the trigger, but anyway it happened
again, this time on 2.6.22-rc2.mm1.cfs14 (and I had kept kstack=3D32)

 BUG: using smp_processor_id() in preemptible [00000001] code: bash/3857
 caller is oops_begin+0xb/0x6f
=20
 Call Trace:
 [<ffffffff8020ab4d>] show_trace+0x34/0x4f
 [<ffffffff8020ab7a>] dump_stack+0x12/0x17
 [<ffffffff8030d92d>] debug_smp_processor_id+0xad/0xbc
 [<ffffffff8042388f>] oops_begin+0xb/0x6f
 [<ffffffff8042520b>] do_page_fault+0x66a/0x7c0
 [<ffffffff804234bd>] error_exit+0x0/0x84
=20
 Unable to handle kernel NULL pointer dereference at 0000000000000000 RIP:=20
 [<0000000000000000>]
 PGD bdd2067 PUD c133067 PMD 0=20
 Oops: 0010 [1] PREEMPT SMP=20
 CPU 1=20
 Pid: 3857, comm: bash Not tainted 2.6.22-0.8.rc2.mm1.cfs14.fc8.nim #1
 RIP: 0010:[<0000000000000000>]  [<0000000000000000>]
 RSP: 0018:ffff81000cb03ee0  EFLAGS: 00010296
 RAX: ffffffff8044dbc0 RBX: ffff81000c3aa8c0 RCX: 00007fff549dcae4
 RDX: 0000000000005410 RSI: ffff81000c3aa8c0 RDI: ffff81000ba913d8
 RBP: 00007fff549dcae4 R08: 0000000000000000 R09: 00000000ffffffff
 R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000005410
 R13: 00000000000000ff R14: 00000000000000ff R15: 0000000000000000
 FS:  00002b06560d8f40(0000) GS:ffff810004017180(0000) knlGS:00000000000000=
00
 CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
 CR2: 0000000000000000 CR3: 000000000bc55000 CR4: 00000000000006e0
 Process bash (pid: 3857, threadinfo ffff81000cb02000, task ffff81000adc59a=
0)
 Stack:  ffffffff8028ada9 ffff81000c3aa8c0 00007fff549dcae4 00007fff549dcae=
4
 ffffffff8028b016 0000000000005410 00000000000000ff ffff81000c3aa8c0
 0000000000000000 00007fff549dcae4 0000000000005410 00000000000000ff
 ffffffff8028b088 0000000000000000 0000000080209571 00000000ffffffff
 00007fff549dce87 0000000000000f11 00007fff549dcfb8 00007fff549dddb0
 ffffffff802095dc 0000000000000246 0000000000000008 00000000ffffffff
 0000000000000000 ffffffffffffffda ffffffffffffffff 00007fff549dcae4
 0000000000005410 00000000000000ff 0000000000000010 0000003d340c9117
 Call Trace:
 Inexact backtrace:
 [<ffffffff8028ada9>] do_ioctl+0x55/0x6b
 [<ffffffff8028b016>] vfs_ioctl+0x257/0x270
 [<ffffffff8028b088>] sys_ioctl+0x59/0x79
 [<ffffffff802095dc>] tracesys+0xdc/0xe1
=20
 INFO: lockdep is turned off.
=20
 Code:  Bad RIP value.
 RIP  [<0000000000000000>]
 RSP <ffff81000cb03ee0>
 CR2: 0000000000000000

--=20
Nicolas Mailhot

--=-ywpth4yo9+MmsED4S3Wo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZYhhcACgkQI2bVKDsp8g1RGQCgnfyMuH0QFrRJRYqOOx6OxIMh
778AoPSxnOhn2EM3jWPt2yU8c2j4Zfhp
=DhGj
-----END PGP SIGNATURE-----

--=-ywpth4yo9+MmsED4S3Wo--
