Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab0BDEDB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 23:03:01 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36978 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756280Ab0BDEDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 23:03:00 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: stable@kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, stable-review@kernel.org
In-Reply-To: <1265245849.3362.1.camel@localhost>
References: <1265245849.3362.1.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f78/sQfqZZH8GJdlwgHG"
Date: Thu, 04 Feb 2010 04:02:54 +0000
Message-ID: <1265256174.2952.11.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] Fix 'flush_old_exec()/setup_new_exec()' split
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f78/sQfqZZH8GJdlwgHG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-02-04 at 01:10 +0000, Ben Hutchings wrote:
> Commit 7ab02af428c2d312c0cf8fb0b01cc1eb21131a3d upstream fixes a
> regression caused by 221af7f87b97431e3ee21ce4b0e77d5411cf1549.

Having said that, it doesn't really fix it for me.

I'm using Debian i386 (i.e. 32-bit userland) with a 64-bit kernel.
After applying commit 221af7f to Debian's kernel source (approximately
equivalent to 2.6.32.7), the kernel fails to exec init.  After commit
7ab02af it can exec init but that immediately segfaults:

[    0.684493] init[1]: segfault at 6d241850 ip 000000006d241850 sp 0000000=
0403fca30 error 14                                                         =
         =20
[    0.686204] Kernel panic - not syncing: Attempted to kill init!         =
    =20
[    0.687081] Pid: 1, comm: init Not tainted 2.6.32-2-amd64 #1            =
    =20
[    0.687968] Call Trace:                                                 =
    =20
[    0.688716]  [<ffffffff812e8c21>] ? panic+0x86/0x141                    =
    =20
[    0.689540]  [<ffffffff8104a63a>] ? __cond_resched+0x1d/0x26            =
    =20
[    0.690390]  [<ffffffff81056aed>] ? exit_ptrace+0x30/0x126              =
    =20
[    0.692344]  [<ffffffff81050cd3>] ? do_exit+0x72/0x6b5                  =
    =20
[    0.693261]  [<ffffffff8105138c>] ? do_group_exit+0x76/0x9d             =
    =20
[    0.694203]  [<ffffffff8105da4c>] ? get_signal_to_deliver+0x310/0x33c   =
    =20
[    0.695719]  [<ffffffff8101000f>] ? do_notify_resume+0x87/0x73f         =
    =20
[    0.696754]  [<ffffffff81188de8>] ? __down_read_trylock+0x3e/0x44       =
    =20
[    0.697717]  [<ffffffff81188f75>] ? __up_read+0x13/0x8e                 =
    =20
[    0.698748]  [<ffffffff8101159c>] ? retint_signal+0x48/0x8c             =
    =20

Ben.
                                                  =20
--=20
Ben Hutchings
friends: People who know you well, but like you anyway.

--=-f78/sQfqZZH8GJdlwgHG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS2pG5Oe/yOyVhhEJAQI5ohAAjX4sIya2eDto8jEyoFIWwVEg8hcsI7nx
I8WG46owmF+UQZ83g1/MI0cWYjfV5TNvHCLzpv0KLLCtvkt3zMHvP332uxtmlP0t
AxeTZrk9u2sj8B+5/A9ixQWN23tVvxEWbn6jD7O3KBOcj5tyFlmLCXOhNvMG1YG/
X57OvG7/pe8VziCsBCv0wTXiKa3tN+/JuxnE7rq7+zUdFAmuo4LUtgI38EYLzu2f
hjmho52SGk6DlmJF56vMoZddJWePxXjJekifXnhzxmT3zK0djALD9dbEuvH5Rh6Y
XsdU/OagP34nlhUf6NImQPqBPDbSNUlGEe34fddVDnSp/zT2d6hXsU56WndzGCsG
B/c9rIFIbz9+V4ScNQIM8lIkDJ9Jrz0/7+oBVVE5AAjCvTOw9uDDwssxsBqdFQCk
bEt3+k0/aF+nvF5DQgVUf/5hgH4ZSxi2GaxkGEDDl2zXGTqGGO1Uu3UxPXBk/wXS
mPKWTbclvoYqSNQtQl/HiCrEvJ1FLpYjiO0mmTrRJOoQddUIV2vwSKQ5VBkS/Szi
JaEGptel0rP0flRxRYdAmLy9nJhqKeTTauE4BIEeEsYKHMgYYcvNuJjP/HdvsUgd
wE081K9QR46tnSqweRRaG5ACj8iYU725KFQCIz/TrOCApIo4D7WdGe9xlEZJDtfJ
rVgyhbgP/Cc=
=MDOR
-----END PGP SIGNATURE-----

--=-f78/sQfqZZH8GJdlwgHG--
