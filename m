Return-Path: <linux-kernel-owner+w=401wt.eu-S1753172AbYJ1I01@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753172AbYJ1I01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 04:26:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbYJ1I0U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 04:26:20 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:33799 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbYJ1I0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 04:26:19 -0400
Subject: Re: [RFC PATCH 3/5] net/ipv4, net/ipv6: use %#p6, %p6 format
	strings
From: Johannes Berg <johannes@sipsolutions.net>
To: Joe Perches <joe@perches.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1225172877.5269.139.camel@localhost>
References: <1225166718.5526.18.camel@brick>
	 <1225170338.5269.127.camel@localhost>  <1225172104.5526.28.camel@brick>
	 <1225172877.5269.139.camel@localhost>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-i0oMi+xqyuUzTJEXui3l"
Date: Tue, 28 Oct 2008 09:26:14 +0100
Message-Id: <1225182374.3796.81.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i0oMi+xqyuUzTJEXui3l
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 22:47 -0700, Joe Perches wrote:
> On Mon, 2008-10-27 at 22:35 -0700, Harvey Harrison wrote:
> > I thought about this, and it will work if the one place that passes
> > NIP6_FMT into sscanf gets changed at the same time.  Otherwise,
> > doing it in-place is probably safer.
>=20
> Maybe sscanf should be updated to support these new %p<foo> types.

That would be an interesting thing too, though it makes little sense for
F, S and R.

I, however, just wanted to get rid of DECLARE_MAC_BUF :)

johannes

--=-i0oMi+xqyuUzTJEXui3l
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBsyjAAoJEKVg1VMiehFYxYYQAKeGlqdONEcgpIqxjuXpuwto
bLGsIYWnIZlFH0Myd/hnTIZZ0M8LeO21PFMTZyeBTz826pZcuxMw3Y361+6/zO0/
3K8mrKPhzBkobEP0XNHelOU3trmUN++chFfkaeeukrrEmckLHrrZyxMh8tCDaW4E
gjc4b7/LWvjDuEBzG2v10S09TwfzN8c/vVOJlZX/DRUuhEW4P5E0PSL8KoBu0fJD
C574nhd3GpmWOfiKr2VJwfzWxjNCXYp9nkd0FRpBktW76cWi12czqi1xL7Wc6Gk4
R7YwQCWhNpARfufnIGmTmx8lNjb3gSpjtOjEeQPFDfmvWAnkPsTJJuqyjqObUuMK
NvoKtiOwZDotUOol+4RL7FEqBaxIWbPGikNuhj0eCr+T0Sj29Aaa5z0xB2XjdDl1
yhJz1jD//JKk7TOR+B++Q9aViS60JKKole0r80kqK/aj1qbrcpiw6bPKgpQ273+u
5lmHFD/sTbVPhB0L3V0bwjd6hn6oYF/HldJPm2Cr5VIZLfsYl0IHvcGHPoHk5ELv
AKQAufPdbNnSlmkgyV7Kgg1KUfQrX5H36Xaxf6Jt35+4zQuQPqZ3d7PyZyUgR1nW
++IjrPk8cbwrfbOoI0YJnHdAgsQCnewPH1z1etj6R/i9LInLxZAMPd2z/xprvQFZ
nXexfAz5Swrqvt+IBxkY
=kLJq
-----END PGP SIGNATURE-----

--=-i0oMi+xqyuUzTJEXui3l--

