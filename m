Return-Path: <linux-kernel-owner+w=401wt.eu-S1758256AbZBFUsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758256AbZBFUsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 15:48:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752825AbZBFUrz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 15:47:55 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:55184 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880AbZBFUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 15:47:54 -0500
Date: Fri, 6 Feb 2009 22:51:29 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_script: rewrite using parse_shell_args()
Message-ID: <20090206205129.GA4394@epbyminw8406h.minsk.epam.com>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name> <1233866864-14422-2-git-send-email-kirill@shutemov.name> <20090206122556.00290967.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
In-Reply-To: <20090206122556.00290967.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-10-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 06, 2009 at 12:25:56PM -0800, Andrew Morton wrote:
> On Thu,  5 Feb 2009 22:47:43 +0200
> "Kirill A. Shutemov" <kirill@shutemov.name> wrote:
>=20
> > parse_shell_args() allows to use more than one argument in shebang
>=20
> What is the benefit in all of this?  Why should we merge it??

Now, we have to write wrapper if we need to pass more than one argument
to the interpreter.

For example, now we can't write something like

#!/usr/bin/env python -c

in shebang. It will be interpreted as /usr/bin/env "python -c" and we will
get ENOENT.

With the patch it will be interpreted according to shell syntax.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.org/

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmMotEACgkQbWYnhzC5v6qPwQCZAUieRYjNhBVbLOKM8sGZI3To
/AIAn1+VOxx3szkGvP30ClGCEsu4YIzu
=81fJ
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
