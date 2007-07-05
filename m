Return-Path: <linux-kernel-owner+w=401wt.eu-S1760872AbXGEJS5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760872AbXGEJS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 05:18:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759133AbXGEJSt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 05:18:49 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:35804 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758876AbXGEJSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 05:18:48 -0400
Subject: Re: [PATCH] debug work struct cancel deadlocks with lockdep
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@tv-sign.ru>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Sattler <tsattler@gmx.de>
In-Reply-To: <1183626647.7054.61.camel@twins>
References: <1183583529.9662.34.camel@johannes.berg>
	 <20070705085304.GC3476@elte.hu>  <1183625889.3818.14.camel@johannes.berg>
	 <1183626070.7054.54.camel@twins>  <1183626507.3818.19.camel@johannes.berg>
	 <1183626647.7054.61.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-E8xaJItvihe9GlF2uGZ7"
Date: Thu, 05 Jul 2007 11:19:46 +0200
Message-Id: <1183627186.3818.24.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-E8xaJItvihe9GlF2uGZ7
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-07-05 at 11:10 +0200, Peter Zijlstra wrote:

> > +/* both _name and _key must not be NULL */

Heh actually I got confused. The requirement that _key is not NULL comes
from the fact that I need to copy it for the workqueue stuff, not from
lockdep. Hence, only _name must be non-NULL, I'll change the comment to
reflect that.

> > +#define STATIC_LOCKDEP_MAP_INIT(_name, _key) \
> > +	{ .name =3D (_name), .key =3D (_key), }
>=20
> looks sane enough :-)

:)

I'll repost with these minor changes directly to akpm tomorrow then; no
lockdep support on my powerbook that I'm using right now so I can't even
compile-test.

johannes

--=-E8xaJItvihe9GlF2uGZ7
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGjLey/ETPhpq3jKURAjGSAJ9o2W0Q1vCdseXvh1kTW8L75e5R8QCcDdar
DaD7vepPNsPj9HWEsMvchsQ=
=rUec
-----END PGP SIGNATURE-----

--=-E8xaJItvihe9GlF2uGZ7--

