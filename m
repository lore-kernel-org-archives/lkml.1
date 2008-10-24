Return-Path: <linux-kernel-owner+w=401wt.eu-S1755314AbYJXJvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314AbYJXJvr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 05:51:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752096AbYJXJvj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 05:51:39 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42580 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbYJXJvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 05:51:38 -0400
Subject: Re: How do I printk <type> correctly?
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <20081023.134005.83296775.davem@davemloft.net>
References: <20081023114133.GA30187@x200.localdomain>
	 <1224774806.6002.42.camel@johannes.berg>
	 <20081023.134005.83296775.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Cgv49wpmGTSZ/BfoCSdB"
Date: Fri, 24 Oct 2008 10:41:43 +0200
Message-Id: <1224837703.6002.86.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Cgv49wpmGTSZ/BfoCSdB
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-10-23 at 13:40 -0700, David Miller wrote:

> > An "unsigned long long" is 64-bits too even on 64-bit platforms, so
> > why the difference? Are there any differences like alignment on some
> > platforms?
>=20
> I invite you to go make that change and then try to fixup all the
> resulting build warnings.  Some of us already made an attempt at
> some point in the past. :-/

Heh, ok. I was just curious really. I think that answers it well
enough :)

> But it's just papering over the core problem, that we can't extend
> gcc's automatic printf format type checking easily.
>=20
> Even if we make u64 the same type everywhere, things like sector_t
> and other types which do have to vary by architecture will need
> to be casted.

Indeed, it doesn't really help that much.

johannes

--=-Cgv49wpmGTSZ/BfoCSdB
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAYpAAAoJEKVg1VMiehFYrCMP/15UxkwK1XppG6zHZ0R8AFw4
TK9FWiUTlcbgI34iWnbq7ybtMI8M3TlqklRTuj8PBh02tImmZdQxCTM3wXC8FzA4
X7SFwFvM8nMDBVu00LOUda+3+kL9d3ck/IbB9+1raivYl3XEGvFrEUQj9xWagtlI
H3wwjEu0jk64JFcyQZVbJvp3XbBsXhyvVDURMiWZKuSzmGLNzUZL/NvYp2qyNAYt
3D6UxB/OEk+1YoUw/waCLTTjrjLpX1h7SYrmvwj3Fv2l8wkkw1GRaqt+Ond7r2QS
kOUAnewyA9LIlRdc39eC0QvMee6gCiImNmlwuP7eksi+uLnU7LsCCFhGLPFG7lnF
RM/rAw1lq8Xt8hkd8tlKqRJ1OvbvUwHJV0PYsZ/2kCan70JOMDupU+jiofxykqHR
eQd3yqIL2+2/kmJgsjBMNvLm9B3PSWot115VSd03C4te7cgl/mS4MhpESj7lxM4v
U9q6P19Uw3il6vlQVtrbZ0GkPAugNi5vhuRgwwEb3eQz9ve9vsem4hR4k0PxE7PO
EqELxuS7GmolaZ7WtRgdXtksDOsYFxp37yjRoP2ub2/V2Ws7p9XcKWFWqdqxx6eR
IPfBhgRZoNmjuTY7xJ5El6Ra5cFzfqKTLOLR1QCOcJF3qvXAHFUPZRImoTWrIJtM
+2VcWlPZ9CV86KT3CGI7
=NSF3
-----END PGP SIGNATURE-----

--=-Cgv49wpmGTSZ/BfoCSdB--

