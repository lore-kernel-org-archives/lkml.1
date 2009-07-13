Return-Path: <linux-kernel-owner+w=401wt.eu-S1757555AbZGMVuW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbZGMVuW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 17:50:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756737AbZGMVuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 17:50:22 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39351 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196AbZGMVuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 17:50:21 -0400
Subject: Re: [PATCH] wireless: wl12xx, fix lock imbalance
From: Johannes Berg <johannes@sipsolutions.net>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4A5BAABF.9020708@gmail.com>
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com>
	 <1247521235.7178.1.camel@johannes.local>  <4A5BAABF.9020708@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-HY1yIggbYFRVe2sOKxGi"
Date: Mon, 13 Jul 2009 23:49:49 +0200
Message-Id: <1247521789.7178.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HY1yIggbYFRVe2sOKxGi
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-13 at 23:44 +0200, Jiri Slaby wrote:

> > I've had local hacks
> > many times to make sparse aware of mutexes, is there a reason they are
> > not annotated with __acquire(s)/__release(s) like spinlocks etc.?
>=20
> Mutexes are often locked/unlocked interprocedural which I think sparse
> can't do much about.

Well, you annotate those functions too, of course.

johannes

--=-HY1yIggbYFRVe2sOKxGi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKW6v6AAoJEODzc/N7+Qma+N0QAJOukofKxwMxY8C4WvWXVffs
kqU1EUXRpKhv6jecdC85XMNBmRU7TPrppgYzysruREpgEYPwxkz7gPLbllLXz+X/
4wsZuaXBRBGaLPVxFAZm7rzMxinqLPMHAWEcjCb+REm8iCV+CQfICAQc2v14Zcej
cjTBDzfKnORtlqagYYOOFS0ISgEQle65YnlKHLHS0XjrSXZ8ca2BFLONLYQo5I9J
zxUYbH+YzBhniJbbrMagbEOV0W9xjy988CPwAXDRjRZBk/Fr/AqIbc0yMBRzZ3ck
8DmpVAzKLfM3EXJLbXFUh9MPM1afbHeznN7HsQyY3ROG1wuQci8VLwcffqOGQMxX
uZop+lechGW5vn895Ku0Zc4Uy3dJopEsFdPnjml/EQ3NkKJfC6HhquO0Frfg3mG6
aPId3uYbwa3ECIUkh23I4Dg+pr+A/DqmW/pMtmhp2zds67+cuWMWVK+XknIPEOLV
gebyCh+aJFarEUGwYP1KhUvwyWs4dUZzNALsTumZEB8Km56y0gZ4YCvOvmL92fil
jg04jBjma9vdSlu+Qk7WTiunDcGd759G+/S6VLujFndZt2oDpp/dFWGuF+fO1YXy
rz1otZY3Xuvqo88EL7eyck5sS16Npqp/jICZxXu97FqCaM10uIpnES58YtZenyhe
kxS7eoNSC6ogrF99qxsH
=Jt+X
-----END PGP SIGNATURE-----

--=-HY1yIggbYFRVe2sOKxGi--

