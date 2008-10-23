Return-Path: <linux-kernel-owner+w=401wt.eu-S1754740AbYJWG1F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754740AbYJWG1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 02:27:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752132AbYJWG0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 02:26:53 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39523 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751868AbYJWG0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 02:26:53 -0400
Subject: Re: [PATCH] fix WARN() for PPC
From: Johannes Berg <johannes@sipsolutions.net>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Arjan van de Ven <arjan@infradead.org>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, davem@davemloft.net,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
In-Reply-To: <48FF8BB9.7050506@goop.org>
References: <20081020145056.24d84992@infradead.org>
	 <48FF8BB9.7050506@goop.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5OlgSomVJQu3LHSxCNBR"
Date: Thu, 23 Oct 2008 08:26:33 +0200
Message-Id: <1224743193.5865.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5OlgSomVJQu3LHSxCNBR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-10-22 at 13:23 -0700, Jeremy Fitzhardinge wrote:
> Arjan van de Ven wrote:
> > From: Arjan van de Ven <arjan@linux.intel.com>
> > Date: Mon, 20 Oct 2008 14:41:03 -0700
> > Subject: [PATCH] fix WARN() for PPC
> >
> > powerpc doesn't use the generic WARN_ON infrastructure.
>=20
> Hm, why's that now?  The generic infrastructure was taken from powerpc,=20
> and I thought I'd converted it...

The definition of "generic" changed midway. When you did the "generic"
infrastructure, it was written to use traps for both WARN and BUG. But
then somebody didn't like that and added new "generic" infrastructure
(the one Arjan is talking about) which doesn't use traps for WARN but
rather an unlikely() and an actual function call etc. Then Arjan
improved the latter "generic" infrastructure without regard for the
original one.

johannes

--=-5OlgSomVJQu3LHSxCNBR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJABkWAAoJEKVg1VMiehFYuLoP/iewj2IzyAYS67KpaHyHHLYn
8IS38oB9x8q0Q3nGUaziAblaXQyo64tYJI3zhQdqtkvzxMZb7viR23DS5xlC7brU
lMkXT8OnPBDS3K+aIDKmXBFxsxwyIZiVxpGZTHVkrI6RXj5kX1KfZvtB2fhQ4cJc
Q7oK9xgrbPQAoeEg2wS0g/SGEFWUXUQwgE/oWUg0EjmwECw0RQm1x8/4jn4RoWkH
R2umWHxpzQVkqbeAK5lUk/crtnAdvwYyHzZ2w8Iks23/vKttjPG/9ewoxkZeG496
xXFNDzr3MPEEXyD5t5gRvTe6t2doUOP9y0mOr/YcZ1HqMbifT6UaV72z98b/8qnR
ksENupNf4kRtajl3y29qXf2kO2AHUL8rJZREv6cI7t4pMCx3Chtoctk0/Bp5Rfy2
gsgII7eyZa4d2HABmkQ4rLtYDNVau61Af4M3f942Ao1z6e1vKqjolbHuuMz/knKU
WXkPe7BdbRDt2i+6OlJvpwPOBketXBoo4SS454TH4xokH69r9W1+1yNSkGIFtVuy
DnyBVS/1qwa5ia8RSlqMrnm6Wm35QpxsBTkqdixQPuTmNK6NcenUkE9EV46G96sk
Hu120uzQg3uKsNOXUyQhCLjIvcgBxvMGWSIuG95DMbVcH5B8JifvZhgz2sThQOJB
GcC2mEnmLRfwBd5xu7TD
=GlFU
-----END PGP SIGNATURE-----

--=-5OlgSomVJQu3LHSxCNBR--

