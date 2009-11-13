Return-Path: <linux-kernel-owner+w=401wt.eu-S1754036AbZKMNcv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbZKMNcv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 08:32:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbZKMNcp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 08:32:45 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:57882 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbZKMNcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 08:32:45 -0500
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
From: Johannes Berg <johannes@sipsolutions.net>
To: Andreas Schwab <schwab@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258118966.6167.21.camel@johannes.local>
References: <1258115870.6167.4.camel@johannes.local>
	 <m3y6mazhij.fsf@hase.home>  <1258118966.6167.21.camel@johannes.local>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-f0zWwdYdNU7L87uTiQ4H"
Date: Fri, 13 Nov 2009 14:32:48 +0100
Message-ID: <1258119168.6167.23.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-f0zWwdYdNU7L87uTiQ4H
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 14:29 +0100, Johannes Berg wrote:

> > > -#define TP_printk(fmt, args...) "%s, %s\n", #fmt, __stringify(args)
> > > +#define TP_printk(fmt, args...) "\"%s\", %s\n", fmt, __stringify(arg=
s)
> >=20
> > Would using __stringify(fmt) work?  If there are double quote character=
s
> > in fmt your solution would produce output that is ambiguous.

> However, isn't it already ambiguous that way? I fail to see why %s, #fmt
> would preserve inside " properly.

Never mind, I missed one indirection, so yes, it would preserve that. I
guess I'll have to somehow escape the quotes when copying them out to
userspace.

johannes

--=-f0zWwdYdNU7L87uTiQ4H
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/V/7AAoJEODzc/N7+QmaPwEP/iJsSVEM2tDO7A8hA0dQzKZ9
JBtCrNVa0GoprxtSmwLIWYnJ3yKRRJ5GYubO74djONop2+be42Bvs3GZ4VXOaqbd
WCOOYb71gydzIh56ARnb4LLXVmAQSg0FE4I9JddvRJlZBP/kR8n95P5Mcm75esbH
lX3pOpu5Jk8a6aKIGizpoju8i3aNcjIc6byiNT+V/VgOqXM6BsGt2AaqSL1z0h90
95yrDXrWNyTCK1AU3SM38qoLciEs+wZHtyKDBBJGZeTXpWTaUhlkAGGRXI0QNfl0
/zcm5ydOyYwBPqFvyf044I96l7b30h3+QRv9UP5k1kMbfTvqd0MM3FJhDRzmQ1H0
gWrA0OENDtrrKNrPlpztvMTlAqdItAdZh3Adp+74LQuEoug5x2XbPowOdQx2ZMmx
fPtkCy15GPUcnqiDdeeON4WbjOmwLU4imx6DkbIFRR4dRN1Q4raNAi6Huf4Nqn70
VpqAXbr1jdu3+0G+J9FjJIrbir8C+gFkKOt1XCwDt5eQJ17BewrCp7rVzHF1ek81
yljQAtDccJUwGlyJMoPjXyMjR6yV3O07TNDYLJpESX+bSs4WFnuNqqI0zmujih5G
QPyHvSklGMv+7J2Et9qCuNSgikDaGy1MNFHZdVfkWH3zZUUd5CUW9N2IOeFVz3SA
UoY6R3wA1RZy1cJ/yxKv
=QNgx
-----END PGP SIGNATURE-----

--=-f0zWwdYdNU7L87uTiQ4H--

