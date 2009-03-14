Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbZCNKg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbZCNKg2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Mar 2009 06:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751242AbZCNKgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Mar 2009 06:36:19 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:46406 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbZCNKgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Mar 2009 06:36:18 -0400
Subject: Re: [PATCH 01/31] bridge: Auto-load bridge module when socket
 opened.
From: Scott James Remnant <scott@canonical.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, shemminger@linux-foundation.org,
       bridge@lists.linux-foundation.org
In-Reply-To: <20090313.142718.21189207.davem@davemloft.net>
References: <cover.1236702228.git.scott@canonical.com>
	 <74b87ec3359e6e65d59cd6fb62a83fb469e6c8ae.1236702228.git.scott@canonical.com>
	 <20090313.142718.21189207.davem@davemloft.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-dDC1ANfaqXwhvNJEzGrz"
Date: Sat, 14 Mar 2009 10:36:34 +0000
Message-Id: <1237026994.29975.19.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dDC1ANfaqXwhvNJEzGrz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-13 at 14:27 -0700, David Miller wrote:

> Did you verify that these changes actually do something?
> Or did you blindly run around peppering source files with
> these annotations?
>=20
I converted existing modprobe aliases that most distributions are
carrying around into the one-line kernel patches.

I tested the important ones such as the floppy and ch changes.

If the patches are wrong, which I personally suspected many of them
were, then it's a good example as to why distributions shouldn't hack
around the kernel in userspace, or keep their own patches.

So yes, they're a bit stinky (hell, I even fluffed up the covering mail
subject line <g>) - but distros including Ubuntu were trying to do these
aliases in modprobe rules, so it's a good thing to find out that they're
wrong; no?

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-dDC1ANfaqXwhvNJEzGrz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm7iLIACgkQSnQiFMl4yK75vQCfbMVoqidrsrcITKItzKaAc5SC
1OoAnioB4Tjlo9IBrxphSw/1wFq/h+D8
=yi2y
-----END PGP SIGNATURE-----

--=-dDC1ANfaqXwhvNJEzGrz--

