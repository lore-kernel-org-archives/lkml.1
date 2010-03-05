Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755858Ab0CEXRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Mar 2010 18:17:50 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60616 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753336Ab0CEXRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Mar 2010 18:17:48 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Ken Kawasaki <ken_kawasaki@spring.nifty.jp>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20100305203317.c4aa5b5c.ken_kawasaki@spring.nifty.jp>
References: <1267763815.2819.297.camel@localhost>
	 <20100305203317.c4aa5b5c.ken_kawasaki@spring.nifty.jp>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-eo8GxZd0FFsXTWc6k6S9"
Date: Fri, 05 Mar 2010 23:17:43 +0000
Message-ID: <1267831063.2819.361.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH 1/2] firmware: Correct attribution of Sierra Wireless
 CIS files
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-eo8GxZd0FFsXTWc6k6S9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-03-05 at 20:33 +0900, Ken Kawasaki wrote:
>=20
> > The only source I can find for these files is
> > <http://www.sierrawireless.com/resources/faq/PC_Card/AirCard555/Aircard=
_Linux.tar> linked from <https://sierrawireless.custhelp.com/app/answers/de=
tail/a_id/179/kw/linux>.
> >=20
>=20
> SierraWireless provides the CIS by GPL (see URL below).
>
> http://sierrawireless.custhelp.com/app/answers/detail/a_id/203/related/1/=
sno/0

The text 'GNU General Public License' links to GPL version *3*, and
would also have done so in 2008 when that page was apparently first
published.

> Yes. The files below are not developed by the pcmcia-cs project
> but provided by SierraWireless.

So, assuming that these files are copyrightable, your patch to add them
violated the conditions of the licence on at least three grounds:

1. The Linux source tree does not include a copy of the GPL version 3
2. These files are identified as licenced under 'GPL' which in the
context of Linux implies version 2
3. The copyright holder is not identified correctly

To avoid confusing people, I do not think we should add a copy of GPLv3
to the tree.  I will therefore submit a patch to remove these files.  I
will submit a separate patch for linux-firmware to fix copyright
information there.

Ben.

--=20
Ben Hutchings
Q.  Which is the greater problem in the world today, ignorance or apathy?
A.  I don't know and I couldn't care less.

--=-eo8GxZd0FFsXTWc6k6S9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS5GREee/yOyVhhEJAQJsQg//QEL7/4atu9n1N6XjtGlMX9grhabTKoRK
5Gv/gTHb+GZwlynD3+gvP19qxHF6NK3EdAww7rUESoJ2lyZVNrB7FuKkA+aowsSJ
ZyGdiWso3k8rCvY8XDf79KeXzRvkBJLJv3KDe9zQT+jW523rulyCuPZxWQFE0JpN
bJwEpDMgKNSzOFMsNpDPTZUUvHADOApiNVdZO7r2Mr6cFWHDzqQU1kpMsO7xROQo
0dNLcarhoPv0sn7w2QT9dRcrrkQjY+g4dGEOm3vjX+7Tvjc9GpuHjQlIO6teN2HA
CGVGBoSMrnc6vDrp1TnWrBaQUZTKa8OlKp0MbiLfuuECcq7dR+jnEKRFLM2L3qX2
2DS612F/cgkEHx0ms7ajgYLXiWKAO1CezXkSbwyvER5cjgRwR7Ct2hMQ39WsYXHM
vS/YGP9LaZkbws2FRi9KbVEe3OaZ3h58MT7K1rbBJq+GVDocZS8RnWjEMU7JPKWC
nj+q7uaHOMh7HI+bkbCq520HR6LaYydxy6TZ9SqY08GlaFQasd3corWq5vYurNa5
j+V6T99r76q+QeBPUpgwRWL/o+9yIUrCbLsfJ0yVkdBuzUtyq7s7+UnWc+/1Xqty
5MYxB0Fx3vas8qycp4a+BnLmYVQajUcUoBwCFuWVxGLKVGn9apLAIOqiFobyW6JM
1F9/7wxA6Gw=
=crqT
-----END PGP SIGNATURE-----

--=-eo8GxZd0FFsXTWc6k6S9--
