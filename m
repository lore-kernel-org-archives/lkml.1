Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYJGLW3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYJGLW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 07:22:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752832AbYJGLWT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 07:22:19 -0400
Received: from ey-out-2122.google.com ([74.125.78.26]:52594 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbYJGLWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 07:22:18 -0400
Date: Tue, 7 Oct 2008 14:23:23 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Ingo Molnar <mingo@redhat.com>, Arjan van de Ven <arjan@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH, RFC, v2] shmat: introduce flag SHM_MAP_HINT
Message-ID: <20081007112322.GB5126@localhost.localdomain>
References: <20081006192923.GJ3180@one.firstfloor.org> <1223362670-5187-1-git-send-email-kirill@shutemov.name> <20081007082030.GD20740@one.firstfloor.org> <20081007100854.GA5039@localhost.localdomain> <20081007112631.GH20740@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <20081007112631.GH20740@one.firstfloor.org>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 07, 2008 at 01:26:31PM +0200, Andi Kleen wrote:
> > I want say that we shouldn't do this check if shmaddr is a search hint.
> > I'm not sure that check is unneeded if shmadd is the exact address.
>=20
> mmap should fail in this case because it does the same check for=20
> MAP_FIXED. Obviously it cannot succeed when there is already something
> else there.

We can do it in separate patch, I think.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjrRqoACgkQbWYnhzC5v6q8ggCfXxRCGEVKzNzwBmGkgyXivVPf
8VIAn1GVBWH3QRPfIzEF3MIV5s1I1BOV
=mdMV
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
