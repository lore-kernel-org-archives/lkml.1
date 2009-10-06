Return-Path: <linux-kernel-owner+w=401wt.eu-S932728AbZJFSia@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932728AbZJFSia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 14:38:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932373AbZJFSi3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 14:38:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48645 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932339AbZJFSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 14:38:29 -0400
Subject: Re: [patch] kbuild: Improve version string logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Dirk Hohndel <hohndel@infradead.org>, Len Brown <lenb@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20091006173508.GA4786@elte.hu>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <20091006144449.  <20091006173508.GA4786@elte.hu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-xHP38xe6DP4f1fW0MBIZ"
Date: Tue, 06 Oct 2009 20:37:07 +0200
Message-Id: <1254854227.22426.37.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xHP38xe6DP4f1fW0MBIZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 19:35 +0200, Ingo Molnar wrote:

> It changes how CONFIG_LOCALVERSION_AUTO works, in the following trivial
> way:
>=20
>  - if it is set, things work the way they always have, and you get a
>    extended kernel release like:
>=20
> 	2.6.32-rc3+00052-g0eca52a-dirty
>=20
>    ( with the difference that the extra version string is separated via
>      '+' not via '-'. This improves visibility when we have additional
>      changes over a vanilla tag. )

I really don't see how it improves visibility (unless you're oblivious
to the difference between long and short strings), but I do know that I
have a few parsers that this will break.

I think adding the + unconditionally will also break things like
debian's make-kpkg, for instance, since the + would get propagated into
the package version which reserves the + for something else.

Etc. Can we please make this stuff optional?

johannes

--=-xHP38xe6DP4f1fW0MBIZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy45NAAoJEODzc/N7+QmaOuIP/1IL9PoW5CcHlky0IQLON2Mf
F52UExkaRe+hwNr1NDrEN0z+uf/Vz8JyfRJasWaHJLiwZ3T3VAyZ6lEhIhTJGfXB
IrgnCrX/17BxHZgsujw+nyEsjRhJWXdH4XZhUbKFlCWeFZ6UhqLPUurNlTV/PWOC
s32q9rJ6HfjzcbWZOPPn+AnKtvebDUsgN1BNieDcgx4qNYBMisO7UA+r+0PaeXZS
KZDi9cqAOtAvRN+qtpCf1bgFRZXvSPhetaRVUu2XL67c9I6GhZ/I5/ncxWUBKQqy
EnRPVU8UK/5aXuvau0C09nSq1bXD+hO2I66qP6j1rwyDD8qJMbDuQE2lKAn/JVq9
EKGIV8D2iLY2Gazw0rl7U8f6TmOpNWc+rFyXhtuHquNTH4cWpk3RJ98vSHymiL9v
HDlxU6qjxddKxj5JecESZuMoXgOZjW34dqdpiFxTFehDZVfCrFnFCmv3Nu2ZG7Kl
P3EPkRHX+3CawojCwjEnE2Gmzp+XhCK+XVmZPvFgQimizz0i5eVQiyibQUiT9Bli
pMO3fopxi6jehzkHGtou4YmYNsNQr2yYx6Tx0PB0gmiruoGlLLyg1mz3ZxPB49mG
6S7aBN+mpw8fXK3VehYpxHyr1103MhJy5/yko3bUTnwhz6xMLtMUEPJnrF7ZDIcp
QLD2S2JwYpD7MGezLZWP
=ytFk
-----END PGP SIGNATURE-----

--=-xHP38xe6DP4f1fW0MBIZ--

