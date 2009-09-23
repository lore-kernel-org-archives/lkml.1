Return-Path: <linux-kernel-owner+w=401wt.eu-S1754186AbZIWGjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754186AbZIWGjK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:39:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754120AbZIWGjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:39:09 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:38992 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793AbZIWGjJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:39:09 -0400
Subject: Re: v2.6.31-7381-g7fa0772: new build warnings: kmemcheck,
 __deprecated, hugetlb, radeon
From: Johannes Berg <johannes@sipsolutions.net>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-kernel@vger.kernel.org, Vegard Nossum <vegard.nossum@gmail.com>,
       Eric B Munson <ebmunson@us.ibm.com>, Dave Airlie <airlied@linux.ie>
In-Reply-To: <4AB8FC88.8020608@s5r6.in-berlin.de>
References: <4AB8FC88.8020608@s5r6.in-berlin.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TyIC4eT/qHOJahbYnw2K"
Date: Wed, 23 Sep 2009 08:39:08 +0200
Message-Id: <1253687948.4458.20.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.27.92 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TyIC4eT/qHOJahbYnw2K
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-22 at 18:34 +0200, Stefan Richter wrote:

> This one is older:
>=20
>    CC      net/ethernet/eth.o
> [...kmemcheck noise from inet_sock.h:208, and then...:]
> net/ethernet/eth.c: At top level:
> net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at=20
> net/ethernet/eth.c:398)
> net/ethernet/eth.c:402: warning: 'print_mac' is deprecated (declared at=20
> net/ethernet/eth.c:398)
>=20
> Obviously added by b5eb0589937eae2d58fca17fa45ed44152e772ed.
> Johannes, can't the __deprecated logic be suppressed when print_mac is=20
> used in EXPORT_SYMBOL?

Not easily. But then we've already removed it completely by now afaik.

johannes

--=-TyIC4eT/qHOJahbYnw2K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKucKIAAoJEODzc/N7+QmaUrMP/A8ZHp03cvh9DNgr8kwiCXQj
iOmdUtvb7L4vAZtiHeprZhB4CafSKSVTeTX+ULmW74fB9egT9yIqi08IaL+rpaEp
jth56Ml5twBmmuicG4rqvIaEqZ62eC8VhAxDmzhhJ44RjzuRg/sPB65GbSlU5hrI
TnYYN5E7c5wLN7tZpbXjj3OOTs0JAxWO7YIg6ZU9aYNlST0LhME6IyG17VFG661x
XAM7nuAjhCdkZXBu3rD6DBCDE6w8rowdVV2k9QGp0WsDNPW2FDdMOeOHMbhGeEyu
7rg5Kz9HQc29/bL0abKYqFpgkbX1nKHHTsRymDzyh1Eha6ZHgOBJ5PYoFzw+DR+9
UijjO0EAJY2FkLK69Lwo9pX+nHLURXzK/alI5hbKsEat6dTwF4jda8K59soYa/bO
wfxJPm7pb5/O4Ss0r3xbb5ThHPoDQcy78uH/CFyei6Bup6+0qKEXBZloEdTqEumW
ZwYjNaPjfl6/62AZZA8QQM+Du5rxZpL3xUXcHvtbYjkfwhsiSpAHHQ/u8cE8cPsV
O9O1W6rN75NxaIui+KBpgpetWQTj+IWKNsVQy5nEFzw9g6Pzt9sXiuobpIpegAq2
jB78X3VoH6ieahg48T5Wb5IkKoxWYsTEu4iV9Iz09ySQlc6yWGYma+MDOJxLzcbi
5NHxMZxYneyxvBAJjfZt
=YuAT
-----END PGP SIGNATURE-----

--=-TyIC4eT/qHOJahbYnw2K--

