Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYAPPqp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYAPPqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 10:46:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751222AbYAPPqh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 10:46:37 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:50780 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986AbYAPPqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 10:46:35 -0500
Subject: Re: 2.6.24-rc7 lockdep warning when poweroff
From: Johannes Berg <johannes@sipsolutions.net>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Young <hidave.darkstar@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Oleg Nesterov <oleg@tv-sign.ru>
In-Reply-To: <1200399661.26045.13.camel@twins>
References: <a8e1da0801140104m2d8dceaayd8cf85466659bbf@mail.gmail.com>
	 <1200302644.7415.6.camel@twins>  <1200306902.5887.39.camel@johannes.berg>
	 <1200307288.7415.11.camel@twins>  <1200307896.5887.42.camel@johannes.berg>
	 <1200393685.5887.113.camel@johannes.berg> <1200399661.26045.13.camel@twins>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g4KsQ4ktY+zrfYQioE7w"
Date: Wed, 16 Jan 2008 00:54:53 +0100
Message-Id: <1200441293.5887.158.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g4KsQ4ktY+zrfYQioE7w
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Turns out that there are many users that give a dynamic string as the
> > workqueue name (only the first three are relevant for the problem at
> > hand because the others are single-threaded):
>=20
> I'm not sure the single threadedness of a workqueue matters here.

Oh I should have explained this, missed it earlier. No, the
single-threadedness doesn't really matter for the problem, but the
warning Dave got couldn't possibly have triggered for a single-threaded
workqueue because it was from the CPU up/down code that spawns/stops the
new workqueue thread on a new/dying CPU.

johannes

--=-g4KsQ4ktY+zrfYQioE7w
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR41HzKVg1VMiehFYAQK/fg/6AiPNOzPp5pyivaoQZIHByGNd1GxN3DzQ
AsYVV4R7PqEqB55XtFQGbOjAxrmai7PJtpv8c8ZhpDm02TN5OJsoU2aBJD2tsOkR
1K2/30B6qjvqBXrXFe5aZ9JjAwNmCAPGJGIv+e32u8tk3kEKlKJoQZQQE0Vf/hR3
/YOBQctNJG6nFLB2NNi6p/jXCYYf4rzWPra5e2dhoOs/OrjJsCroO4M1TlBTI4YM
kClZt8W1J7vVZ4rw4QQSrpCpwUtLoAVxwbSspQ1tNgsLWu09aFayadOPjyHPDUGz
TsTiFhmREkYJYlwmdJ06SWVpKz8jMnPztWd9t5pTzAE7ACdmEnmucof96PNoO3ok
CzamJX6VOfiSiEmcOoTmzG+unK7+qZdnUQhwGTQ6+guy1w7ONSLlBl4e4gOI4zRv
rMcBwdcRDxn8fCihl/sK6H6VI2saGmXRa7swc71/kYQxaESlvujQLdHQLivwa6Ou
bx+9ANCojSNSI/bC+Hf9Qtyy+7jXTsKSeIUyJ66EoBtmeS7lkKOXAt21WmOpAQWT
/eoK+/OPcDKeBiO9C6cm3AIzAISlV0w6k9QxYpj1VI1zZX8sCIl/zHWy/jATscQQ
fr2wnhl04GV+z3HiqcVLGWNRIL/nIcTtIuFK1urHiA8EBhfnRLo2lMx4VuS2MCy2
MBH65sf6Sak=
=Uq5I
-----END PGP SIGNATURE-----

--=-g4KsQ4ktY+zrfYQioE7w--

