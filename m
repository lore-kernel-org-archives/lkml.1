Return-Path: <linux-kernel-owner+w=401wt.eu-S1762967AbXJEOZ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762967AbXJEOZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2007 10:25:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXJEOZv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Oct 2007 10:25:51 -0400
Received: from smtp1.netcabo.pt ([212.113.174.28]:24823 "EHLO
	exch01smtp11.hdi.tvcabo" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755242AbXJEOZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2007 10:25:50 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsG1AD7mBUdViow7PGdsb2JhbACBWYVEhxIBAQEBHRg
Date: Fri, 5 Oct 2007 15:25:43 +0100
From: Luciano Rocha <strange@nsk.no-ip.org>
To: linux-kernel@vger.kernel.org
Subject: can't change euid 0 to uid != running user
Message-ID: <20071005142541.GA9224@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <strange@nsk.no-ip.org>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cWoXeonUoKmBZSoM"
Content-Disposition: inline
User-Agent: Mutt/1.5.15 (2007-04-06)
X-OriginalArrivalTime: 05 Oct 2007 14:25:47.0257 (UTC) FILETIME=[9F171E90:01C8075B]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--cWoXeonUoKmBZSoM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello,

I have the following problem:
$ sudo -u ie -s # or sudo su ie
unable to change to runas uid: Resource temporarily unavailable

Works:
$ sudo su, followed by su ie

The first sudo also worked while I had a shell under user ie.

When I exited, it stopped working, but it is now working every time I
trie it.

dmesg shows:

[82602.729330] kobject_add failed for 504 with -EEXIST, don't try to
               register things with the same name in the same directory.
[82602.729365]  [<c04b9195>] kobject_shadow_add+0x16e/0x1a0
[82602.729383]  [<c04b9480>] kobject_set_name+0x29/0x92
[82602.729504]  [<c04238ea>] user_kobject_create+0x6a/0x90
[82602.729520]  [<c0423cce>] alloc_uid+0x18f/0x1d7
[82602.729530]  [<c0427030>] set_user+0x1c/0x8f
[82602.729539]  [<c0428b5f>] sys_setresuid+0xd5/0x162
[82602.729552]  [<c0403e6a>] syscall_call+0x7/0xb
[82602.729575]  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D

$ git describe
v2.6.23-rc9-156-ga95dacb

(Clone of Linus' tree, after rc9, with some patches from
mingo/linux-2.6-sched-devel.git, and a fix for lguest (didn't link due
to kasprintf)).

--=20
lfr
0/0

--cWoXeonUoKmBZSoM
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHBkllinSul6a7oB8RAlAcAJ426gNv58tRZj7aljNSK3dNmkVAWgCcCAsE
qpYOqAw27nBapElLMBQufjw=
=PY6y
-----END PGP SIGNATURE-----

--cWoXeonUoKmBZSoM--
