Return-Path: <linux-kernel-owner+w=401wt.eu-S1753847AbXFZCUp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753847AbXFZCUp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:20:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753552AbXFZCU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:20:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbXFZCU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:20:28 -0400
Date: Tue, 26 Jun 2007 12:20:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Zippel <zippel@linux-m68k.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, John Stultz <johnstul@us.ibm.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch, v2.6.22-rc6] sys_time() speedup
Message-Id: <20070626122006.c94cb2c4.sfr@canb.auug.org.au>
In-Reply-To: <20070625151508.86fa3778.akpm@linux-foundation.org>
References: <20070625200601.GA18980@elte.hu>
	<200706252309.47467.zippel@linux-m68k.org>
	<20070625151508.86fa3778.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_Jun_2007_12_20_06_+1000_3WGq+LFO2_s7osbG"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_Jun_2007_12_20_06_+1000_3WGq+LFO2_s7osbG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 Jun 2007 15:15:08 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Mon, 25 Jun 2007 23:09:46 +0200
> Roman Zippel <zippel@linux-m68k.org> wrote:
>=20
> > On Monday 25 June 2007, Ingo Molnar wrote:
> >=20
> > > the patch improves the sysbench OLTP macrobenchmark significantly:
> >=20
> > Has that any real practical relevance?
>=20
> Interesting question.  The patch adds a new test-n-branch to gettimeofday=
()
> so if gettimeofday() is used much more frequently than time(), we lose.

Isn't gettimeofday() called *lots* by the X server and programs - one of
the reasons we bother putting it in the VDSO.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_Jun_2007_12_20_06_+1000_3WGq+LFO2_s7osbG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGgHfbFdBgD/zoJvwRAjGVAJsFv6a6Yel25R/lRCRmq/keaksh/QCeImKs
8Y+c93xy1Oy4E4O+rbxIDrg=
=HJSt
-----END PGP SIGNATURE-----

--Signature=_Tue__26_Jun_2007_12_20_06_+1000_3WGq+LFO2_s7osbG--
