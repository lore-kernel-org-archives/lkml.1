Return-Path: <linux-kernel-owner+w=401wt.eu-S1753346Ab0ADM7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab0ADM7l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jan 2010 07:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051Ab0ADM7k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jan 2010 07:59:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752755Ab0ADM7j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jan 2010 07:59:39 -0500
Date: Mon, 4 Jan 2010 23:59:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thiago Farina <tfransosi@gmail.com>
Subject: linux-next: tip tree build failure
Message-Id: <20100104235931.abcf2bc5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__4_Jan_2010_23_59_31_+1100_zxbaEksRRp1jxJ+G"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__4_Jan_2010_23_59_31_+1100_zxbaEksRRp1jxJ+G
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (s390x defconfig) failed like this:

kernel/panic.c:134: error: 'CALLER_ADDR0' undeclared (first use in this fun=
ction)

Caused by commit eba3fe4416f3cc2ce043fb304b6c35a69dca3bdb ("kernel: Use
CALLER_ADDR0 macro").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__4_Jan_2010_23_59_31_+1100_zxbaEksRRp1jxJ+G
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktB5jMACgkQjjKRsyhoI8yqjgCfa1f9WbkZmwQ7i41E6pFHNq1I
5GoAn3kNgT8mBiy0qq3auaTlVcFruGuZ
=vOED
-----END PGP SIGNATURE-----

--Signature=_Mon__4_Jan_2010_23_59_31_+1100_zxbaEksRRp1jxJ+G--
