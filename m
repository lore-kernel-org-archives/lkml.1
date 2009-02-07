Return-Path: <linux-kernel-owner+w=401wt.eu-S1754700AbZBGVUZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbZBGVUZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Feb 2009 16:20:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753418AbZBGVUK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Feb 2009 16:20:10 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:35445 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752938AbZBGVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Feb 2009 16:20:09 -0500
Date: Sat, 7 Feb 2009 23:23:46 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Garrett <mjg@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_script: rewrite using parse_shell_args()
Message-ID: <20090207212346.GA1120@epbyminw8406h.minsk.epam.com>
References: <1233866864-14422-1-git-send-email-kirill@shutemov.name> <1233866864-14422-2-git-send-email-kirill@shutemov.name> <20090207163306.GB31938@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J2SCkAp4GZ/dPZZf"
Content-Disposition: inline
In-Reply-To: <20090207163306.GB31938@srcf.ucam.org>
User-Agent: Mutt/1.5.18 (2008-10-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J2SCkAp4GZ/dPZZf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Feb 07, 2009 at 04:33:06PM +0000, Matthew Garrett wrote:
> On Thu, Feb 05, 2009 at 10:47:43PM +0200, Kirill A. Shutemov wrote:
> > parse_shell_args() allows to use more than one argument in shebang
>=20
> Surely this changes userspace ABI?

This patch break programs which use shabang like

#!/bin/foo a b

and expect that it will be interpreted as

/bin/foo "a b"

But I don't know a real world program witch use this hack.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.org/

--J2SCkAp4GZ/dPZZf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmN++IACgkQbWYnhzC5v6qzMwCdGBZTCmnJdoIFvewDNoCJ3npo
4DMAni3NSrEqf5oi8Cr8IPK5id+UzAEO
=hu0M
-----END PGP SIGNATURE-----

--J2SCkAp4GZ/dPZZf--
