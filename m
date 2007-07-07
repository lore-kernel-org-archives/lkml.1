Return-Path: <linux-kernel-owner+w=401wt.eu-S1755135AbXGGXCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755135AbXGGXCr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 19:02:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751950AbXGGXCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 19:02:39 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:39681 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751900AbXGGXCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 19:02:39 -0400
X-Sasl-enc: ic2Jl8W8RXBQ1LHtJ9bs3R7Lgvkyk5Yc0K3p1fsCT4XQ 1183849357
Message-ID: <46901C8E.5050103@imap.cc>
Date: Sun, 08 Jul 2007 01:06:54 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: yoann padioleau <padator@wanadoo.fr>
CC: kernel-janitors@lists.osdl.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH] some kmalloc/memset ->kzalloc (tree wide)
References: <878x9ta320.fsf@wanadoo.fr> <468F901B.2000000@imap.cc> <0BE121C2-D115-4A9A-A557-E65F0F8CBA26@wanadoo.fr>
In-Reply-To: <0BE121C2-D115-4A9A-A557-E65F0F8CBA26@wanadoo.fr>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2C6F90DC9C6038B6DF6CDDAF"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2C6F90DC9C6038B6DF6CDDAF
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 07.07.2007 15:36 schrieb yoann padioleau:
> On 7 juil. 07, at 15:07, Tilman Schmidt wrote:
>=20
>> This misses the semantic distinction between the first and second
>> arguments of kcalloc(). The first argument is supposed to be the
>> number of elements to allocate and the second their size. As a
>> consequence, the following hunks in your pathc are wrong:
>=20
> Yes you are right. Andrew Morton fixed the problem in a
> subsequent patch.

That's ok then. Andrew is doing an awesome job.

> I should have written a more precise semantic patch such as
>=20
> @@
> expression E;
> constant c;
> type T;
> @@
>=20
> - kzalloc(sizeof(T) * c, E)
> + kcalloc(c, sizeof(T), E)
>=20
> Note that sometimes the code is written as  kzalloc(c * sizeof(T), E)
> as in   kzalloc(2 * sizeof(struct resource), GFP_KERNEL)  but
> our transformation engine can handle the commutativity of '*' and still=

> performs the right transformation.

Cool. That transformation engine sure sounds like an interesting
piece of code.

Regards,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig2C6F90DC9C6038B6DF6CDDAF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGkByYMdB4Whm86/kRAupNAJ9yElL3YpzfQw8w8zkiqUsg1Gn2NACfSYNB
2+PnxZ69HAMztfvmUGvIAAU=
=31zb
-----END PGP SIGNATURE-----

--------------enig2C6F90DC9C6038B6DF6CDDAF--
