Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbZKECd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbZKECd6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 21:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753989AbZKECd5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 21:33:57 -0500
Received: from lennier.cc.vt.edu ([198.82.162.213]:55513 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751956AbZKECd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 21:33:56 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Gilad Ben-Yossef <gilad@codefidence.com>
Cc: =?windows-1252?Q?Ilpo_J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org, Ori Finkelman <ori@comsleep.com>
Subject: Re: 2.6.32-rc5-mmotm1101 - kernel BUG at net/ipv4/tcp_input.c:3707!
In-Reply-To: Your message of "Wed, 04 Nov 2009 18:43:20 +0200."
             <4AF1AF28.2030106@codefidence.com>
From: Valdis.Kletnieks@vt.edu
References: <5765.1257270611@turing-police.cc.vt.edu> <4AF07024.80103@gmail.com> <4AF08292.7090102@codefidence.com> <Pine.LNX.4.64.0911032330090.3488@melkinkari.cs.Helsinki.FI> <7916.1257300093@turing-police.cc.vt.edu>
            <4AF1AF28.2030106@codefidence.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1257388392_4430P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Wed, 04 Nov 2009 21:33:12 -0500
Message-ID: <6025.1257388392@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 128.173.34.98 turing-police.cc.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Info: (0) 
X-Junkmail-Status: score=10/50, host=vivi.cc.vt.edu
X-Junkmail-SD-Raw: score=unknown,
	refid=str=0001.0A020206.4AF2396A.00B7,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2009-07-29 21:33:33,
	dmn=2009-09-10 00:05:08,
	mode=multiengine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1257388392_4430P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 04 Nov 2009 18:43:20 +0200, Gilad Ben-Yossef said:

> OK, I thing I've got it.
>=20
> Kindly try the next patch. It goes on top (in addition to) the previous=
=20
> one. This should fix the crash.

OK. much better.  Have been up for about 25 minutes now, and fetchmail ha=
s
pulled down e-mail several times, and no proboems seen.

> There is still some small cruft in the handling of the per route TCP
> options for IPv6 left, which means that the per route options might get=
=20
> ignored for
> incoming IPv6 connections right now. I will fix this if this works.

Yell if you want something tested. ;)

--==_Exmh_1257388392_4430P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFK8jlocC3lWbTT17ARAksWAJ44jUJb0L8DbE4WmHfOIJs6AU89IQCg7W1u
Z8LT0ZYlWPucVQe8d5ps5bg=
=H/XB
-----END PGP SIGNATURE-----

--==_Exmh_1257388392_4430P--

