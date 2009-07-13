Return-Path: <linux-kernel-owner+w=401wt.eu-S932078AbZGMVXq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932078AbZGMVXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:23:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757155AbZGMVXq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:23:46 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:50944 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756819AbZGMVXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:23:45 -0400
Subject: binary ftrace buffer format
From: Johannes Berg <johannes@sipsolutions.net>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-3Y58Qez1YHSSnNFl+v6y"
Date: Mon, 13 Jul 2009 23:23:09 +0200
Message-Id: <1247520189.4071.4.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3Y58Qez1YHSSnNFl+v6y
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi!

For the past hour or so I've been trying to make Steven's rb-read.pl
script [1] work, but not only is it endian-challenged, working only on
LE, but also does it seems to have a different idea of the ring buffer
format, so even with fixes I can't get it to print proper data.

I'm convinced that it would be trivial to write a program to parse the
binary trace buffer, but I can't find a format description. Can somebody
point me to one please?

Oh and a tangential question -- that thing seems to work on pages, does
that mean I can't trace something larger than a page?

johannes

[1] http://lwn.net/Articles/321777/

--=-3Y58Qez1YHSSnNFl+v6y
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW6W5AAoJEODzc/N7+QmazUUQAJNA/2IYNNXHC6dxiFyiCVjH
JHFEpTLJXtzR/gywygHpQOACZ0yjT7E5rv/DrcPoHu1orST2/Uxz5bQBjaesJrMS
FR1mEIyTcKGHfOPIlkf3NsBkHuMTstRdKa8BxZT0Q7jshF6CTgHcH24TbagJWRrr
9AHTNY3XSBFXzSRMTc3TOQvIf4LiWZs9L36ANtfnBJVGo8qMVwXD7CsClLbvWBMY
Z9wuF/+Av0gU6In0h2C3wDfIlu3vkJ0hAMnX85PDUgjO265do6ITndT8vspb9/nl
6qjyUzrYHB0iPp4JWTJtz73X6gqvxjRgoR/C1e1Jukmd4kPIK3jVDHEn6aA6pOKV
MLIDfxLZi+5aj+kmQ50PA23H7xIPiTnMKUtsr7rpsJvgz9U1XAs8vayInzpjaSpI
h0HOPuK7aXNNelVdcE2Zrq5sBdtQduqZQCt1RxgBs8EqWPkquNHOob53354NsGcz
EtYwc6AzzlDs3qGrQ0NjK1KrqhUwvC52JqyvZMqUOan21FhW4XF61OST72Iu6Mkj
5eITTYi2OjybIV4ogiwaIu/yx7nEIYiynup+ZIuxRmNHABiUECoTg15XIFbPIIsD
Jo1bnQWMCviIokAPYo9fZdNFCa+4r4wBao/t6J2JCI19Hs3jBADa88wQGTZTQI6Y
R9chLfhS1kYPpBI54ZrN
=aqIR
-----END PGP SIGNATURE-----

--=-3Y58Qez1YHSSnNFl+v6y--

