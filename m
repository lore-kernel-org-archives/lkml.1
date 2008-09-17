Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbYIQJcR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbYIQJcR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 05:32:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751214AbYIQJcD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 05:32:03 -0400
Received: from ug-out-1314.google.com ([66.249.92.174]:57680 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbYIQJcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 05:32:01 -0400
Date: Wed, 17 Sep 2008 12:32:41 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080917093240.GB4984@localhost.localdomain>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain> <48CFBE51.1060200@redhat.com> <20080916160902.GF1400@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ADZbWkCsHQ7r3kzd"
Content-Disposition: inline
In-Reply-To: <20080916160902.GF1400@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ADZbWkCsHQ7r3kzd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 16, 2008 at 07:09:02PM +0300, Adrian Bunk wrote:
> On Tue, Sep 16, 2008 at 07:10:25AM -0700, Ulrich Drepper wrote:
> > Kirill A. Shutemov wrote:
> > >> What is the error message?
> > >=20
> > > /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> > > flock'
> >=20
> > And?  None of these programs should use <linux/inotify.h>.  There has
> > for the longest time been a <sys/inotify.h> header which doesn't need
> > any kernel headers.  In fact, <linux/inotify.h> should not be exported.
>=20
> Even if userspace applications shouldn't use it directly this doesn't=20
> sound right:
>=20
> We shouldn't force all libc implementations to copy the contents into a=
=20
> private header.

glibc and dietlibc provide <sys/inotify.h>. newlib and uclibc don't. klibc
provides <sys/inotify.h> but it depends on <linux/inotify.h>

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--ADZbWkCsHQ7r3kzd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjQzrgACgkQbWYnhzC5v6rexgCeOX71hr0PMBVcyHR6q5Ull6/F
BM8An3hqbUS7BymlyCO+MHaIzKIrL3xf
=4dw1
-----END PGP SIGNATURE-----

--ADZbWkCsHQ7r3kzd--
