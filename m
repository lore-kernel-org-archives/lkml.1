Return-Path: <linux-kernel-owner+w=401wt.eu-S1759067AbZC0QTn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759067AbZC0QTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 12:19:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755881AbZC0QTd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 12:19:33 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:45105 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305AbZC0QTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 12:19:32 -0400
Subject: Re: DRM lock ordering fix series
From: Eric Anholt <eric@anholt.net>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.sourceforge.net
In-Reply-To: <87ocvnmhqx.fsf@basil.nowhere.org>
References: <1238017510-26784-1-git-send-email-eric@anholt.net>
	 <87ocvnmhqx.fsf@basil.nowhere.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-g4/ZdNEWH3u3uuMdlhiz"
Date: Fri, 27 Mar 2009 09:19:27 -0700
Message-Id: <1238170767.8275.2397.camel@gaiman.anholt.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g4/ZdNEWH3u3uuMdlhiz
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-03-27 at 10:34 +0100, Andi Kleen wrote:
> Eric Anholt <eric@anholt.net> writes:
>=20
> > Here's hopefully the final attempt at the lock ordering fix for GEM.  T=
he
> > problem was introduced in .29 with the GTT mapping support.  We hashed =
out
> > a few potential fixes on the mailing list and at OSTS.  Peter's plan wa=
s
> > to use get_user_pages, but it has significant CPU overhead (10% cost to=
 text
> > rendering, though part of that is due to some dumb userland code.  But =
it's
> > dumb userland code we're all running).
>=20
>=20
> You are aware that there is a fast path now (get_user_pages_fast) which
> is significantly faster? (but has some limitations)

In the code I have, get_user_pages_fast is just a wrapper that calls the
get_user_pages in the way that I'm calling it from the DRM.

I'm assuming that that's changing.  Can you explain what the "some
limitations" is?  (Though, of course, in a comment in mm/util.c would be
better than email).

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-g4/ZdNEWH3u3uuMdlhiz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknM/I8ACgkQHUdvYGzw6vdi+QCdFKCxPdsYv7Yf30xW8rrvPss/
/uMAn1/HTgWqeIpiemrRO2YOR2H7ncdz
=rFKm
-----END PGP SIGNATURE-----

--=-g4/ZdNEWH3u3uuMdlhiz--
