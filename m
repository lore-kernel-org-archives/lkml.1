Return-Path: <linux-kernel-owner+w=401wt.eu-S1762131AbYAKRa7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762131AbYAKRa7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 12:30:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761290AbYAKRaw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 12:30:52 -0500
Received: from zucker.schokokeks.org ([85.10.204.247]:44899 "EHLO
	zucker.schokokeks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760683AbYAKRav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 12:30:51 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Fri, 11 Jan 2008 12:30:50 EST
From: "Hanno =?utf-8?q?B=C3=B6ck?=" <ml@hboeck.de>
To: linux-kernel@vger.kernel.org
Subject: Assertion failure in journal_next_log_block() at fs/jbd/journal.c:568: "journal->j_free > 1"
Date: Fri, 11 Jan 2008 18:25:45 +0100
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4584907.MNu11A5qWY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801111825.48083.ml@hboeck.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4584907.MNu11A5qWY
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

I got a message about a kernel bug in dmesg. I found only one reference to =
a=20
similar issue, a mail to lkml from 2006, but without any reply.
If this is a bug and not caused by hw failure, it seems to be triggered ver=
y=20
rare.

Gentoo Linux, Kernel is 2.6.23.12 with grsecurity, amd64. It's not=20
reproducible, only appeared once. After that, the system did strange things=
=20
and wasn't able to reboot, I had to reset manually. If there's anything mor=
e=20
I can provide as information, just ask me.

Please CC me on replies, as I'm not reading this list.


Assertion failure in journal_next_log_block() at=20
fs/jbd/journal.c:568: "journal->j_free > 1"
=2D-----------[ cut here ]------------
kernel BUG at fs/jbd/journal.c:568!
invalid opcode: 0000 [1]
CPU 0
Pid: 989, comm: kjournald Not tainted 2.6.23.12-grsec #1
RIP: 0010:[<ffffffff802b6ad6>]  [<ffffffff802b6ad6>]
RSP: 0018:ffff81007ed37e20  EFLAGS: 00010286
RAX: 0000000000000060 RBX: ffff810031a65130 RCX: 0000000000000082
RDX: ffffffff80524a47 RSI: 0000000100000000 RDI: ffffffff804679cd
RBP: ffff8100474c4c70 R08: 0000000000000000 R09: ffffffff8044a9a0
R10: 0000000000000000 R11: ffff81007ed37cbc R12: ffff810066c93bc0
R13: ffff81007e891c00 R14: 00000000000001fb R15: ffff810049ee9c74
=46S:  00002d76dffd7f80(0000) GS:ffffffff804cf000(0000) knlGS:0000000000000=
000
CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
CR2: 00002e036f0fa000 CR3: 000000007b15d000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kjournald (pid: 989, threadinfo ffff81007ed36000, task=20
ffff810037d517e0)
Stack:  ffff810049ee9c6c ffffffff802b381c ffff81007ed3e000 0000018c00001000
 0000038c00000000 0000016300000000 ffff81007ed37ec0 0000000000000046
 ffffffff8022b843 ffff810037d517e0 ffff8100485060c0 ffff8100483e70c0
Call Trace:
 [<ffffffff802b381c>]
 [<ffffffff8022b843>]
 [<ffffffff802b6e42>]
 [<ffffffff8022b843>]
 [<ffffffff802b6d97>]
 [<ffffffff8022b682>]
 [<ffffffff8020bc38>]
 [<ffffffff8035c774>]
 [<ffffffff8022b63b>]
 [<ffffffff8020bc2e>]


Code: 0f 0b eb fe 48 8b b7 d0 00 00 00 48 ff 8f e0 00 00 00 48 8d
RIP  [<ffffffff802b6ad6>]
 RSP <ffff81007ed37e20>

=2D-=20
Hanno B=C3=B6ck		Blog:		http://www.hboeck.de/
GPG: 3DBD3B20		Jabber/Mail:	hanno@hboeck.de

--nextPart4584907.MNu11A5qWY
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.8 (GNU/Linux)

iEYEABECAAYFAkeHppwACgkQr2QksT29OyASywCeNkDGxu8mYKciiENVyiOlcu2q
M1EAoKHAsNFBFy0f1FSCjA70+Roql9MM
=XLRb
-----END PGP SIGNATURE-----

--nextPart4584907.MNu11A5qWY--
