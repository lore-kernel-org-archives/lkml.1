Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BTLAp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:00:45 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:43930 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab0BTLAn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:00:43 -0500
Subject: Re: Firmware versioning best practices II
From: Johannes Berg <johannes@sipsolutions.net>
To: David Woodhouse <dwmw2@infradead.org>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, linux-kernel@vger.kernel.org,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Marcel Holtmann <marcel@holtmann.org>,
       Vipin Mehta <Vipin.Mehta@atheros.com>
In-Reply-To: <1266662106.1820.4034.camel@macbook.infradead.org>
References: <43e72e891002191823h3245bc0cn7a8745ae77409aa8@mail.gmail.com>
	 <1266662106.1820.4034.camel@macbook.infradead.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-XsApjHBGNRbz3ScUgUP6"
Date: Sat, 20 Feb 2010 12:00:39 +0100
Message-ID: <1266663639.10357.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XsApjHBGNRbz3ScUgUP6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 10:35 +0000, David Woodhouse wrote:

> That doesn't prevent some people from using foo-$APIVER-$CODEVER if
> they really have to, of course -- if they have firmware which can be
> conditionally compiled for both old and new APIs, for example. But I
> don't think it should be recommended.

That doesn't make much sense anyway. If the firmware filename is
foo-$APIVER-$CODEVER every code change would need a corresponding driver
change. If it is just foo-$APIVER then the $CODEVER can be embedded in
the firmware file and printed so you know which code you're using, but
if it doesn't influence the API I don't see why it should be part of the
filename?

johannes

--=-XsApjHBGNRbz3ScUgUP6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf8DUAAoJEODzc/N7+Qma6EwQAJvCIYhILFChqOrUc+hKT4N2
kHly0JsgnsHdho6DI0HBn0asW+r/ig4JI623gzOMUoxhoz5WYBLhHV0snSkPCOd4
eCCHDGgtlfL5Eqyvv1sPhw/3Ibhtq73IJIDG9A0Y/6uNJ8NATX672njNyEM1/doK
1fcCawiVQr8m7InIUzjGk1UgmIXYzP1HSFJx8Cyx4Na+Hy4jHOkV/dtDEGigMnQH
Bgg1igVAY7LNidvguMNO/UubUbcY6MYQJujTzFMgMUMYkL9oILN4K27GWgVhZ6/R
XWRwYrSlB5HIk92cYcYFqkaQ+zn7XDYjGP0R+ivtTKN2slO4krp2Ll+vJhUjBqTT
xhTaNctC4BTtsrS3ECASLbWtC0bIkvKCBMdXbd3GUcmUimeyA1QkT3RhovjzAPiC
Ka7fr/4y7NSmORaMpb9uC4Iyd+dR8QRsw/8rz5RUE954UNxITfGm/CSD2bdI/9Pc
GX5OFbWwMttp+7JtEY2PTq2Vd4xfcWyrbYk9MmpmXCQNzdFqLc/6LlhvXVaBbTYN
EhCuTEhjfEQelujcnglNJQ2ZIkTw7IZ2m5InOJP5rf63Q8nUm3ABxGQmukyM5cyJ
84SCRhALx4KgzNN1x4bfLeFnuW1lcL3YeJ8+gjsdso19hw7fqgUfJkmRwBuoaIaw
JzrQEzLG1E0r8sdAPqym
=8m5Q
-----END PGP SIGNATURE-----

--=-XsApjHBGNRbz3ScUgUP6--

