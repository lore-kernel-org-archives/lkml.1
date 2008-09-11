Return-Path: <linux-kernel-owner+w=401wt.eu-S1756249AbYIKP3B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756249AbYIKP3B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2008 11:29:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756032AbYIKP2q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Sep 2008 11:28:46 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:30632 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756000AbYIKP2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2008 11:28:45 -0400
Date: Thu, 11 Sep 2008 18:29:18 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Miller <davem@davemloft.net>
Cc: adobriyan@gmail.com, linux-kernel@vger.kernel.org, caulfie@redhat.com,
       teigland@redhat.com, dwmw2@infradead.org, akpm@linux-foundation.org
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
Message-ID: <20080911152916.GE4933@localhost.localdomain>
References: <20080910125503.GG3757@localhost.localdomain> <20080910131158.GB3468@x200.localdomain> <20080910131512.GH3757@localhost.localdomain> <20080910.131824.244309370.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bi5JUZtvcfApsciF"
Content-Disposition: inline
In-Reply-To: <20080910.131824.244309370.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bi5JUZtvcfApsciF
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 01:18:24PM -0700, David Miller wrote:
> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> Date: Wed, 10 Sep 2008 16:15:13 +0300
>=20
> > $ make headers_install
> > ...
> > $ gcc usr/include/linux/dlm_plock.h
> > usr/include/linux/dlm_plock.h:25: error: expected specifier-qualifier-l=
ist
> > before =E2=80=98__u32=E2=80=99
>=20
> That's not how this file is used by real applications.
> Anybody can cook up contrived cases like this.
>=20
> Please show a real application or kernel compilation which breaks
> because of the lack of types.h include here.

Any application which include this header before linux/types.h (directly or=
=20
indirectly) will get the error. It's dependence on the order of inclusion.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--bi5JUZtvcfApsciF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjJOUwACgkQbWYnhzC5v6pITACeJUB2b9OlNBmLk4+e7Fli9InJ
20UAn0p48O4YpZlHIW9pGVp51ue5mXKY
=6dGE
-----END PGP SIGNATURE-----

--bi5JUZtvcfApsciF--
