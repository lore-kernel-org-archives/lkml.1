Return-Path: <linux-kernel-owner+w=401wt.eu-S1754563AbYIQKDw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbYIQKDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 06:03:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYIQKDo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 06:03:44 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:11057 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698AbYIQKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 06:03:44 -0400
Date: Wed, 17 Sep 2008 13:04:23 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Adrian Bunk <bunk@kernel.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       Davide Libenzi <davidel@xmailserver.org>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>, klibc@zytor.com
Subject: Re: [PATCH] linux/inotify.h: do not include <linux/fcntl.h> in
	userspace
Message-ID: <20080917100422.GC4984@localhost.localdomain>
References: <1221567763-17060-1-git-send-email-kirill@shutemov.name> <20080916125802.GA15951@cs181140183.pp.htv.fi> <20080916130234.GA17082@localhost.localdomain> <48CFBE51.1060200@redhat.com> <20080916160902.GF1400@cs181140183.pp.htv.fi> <20080917093240.GB4984@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YD3LsXFS42OYHhNZ"
Content-Disposition: inline
In-Reply-To: <20080917093240.GB4984@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YD3LsXFS42OYHhNZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2008 at 12:32:40PM +0300, Kirill A. Shutemov wrote:
> On Tue, Sep 16, 2008 at 07:09:02PM +0300, Adrian Bunk wrote:
> > On Tue, Sep 16, 2008 at 07:10:25AM -0700, Ulrich Drepper wrote:
> > > Kirill A. Shutemov wrote:
> > > >> What is the error message?
> > > >=20
> > > > /usr/include/asm-generic/fcntl.h:117: error: redefinition of 'struct
> > > > flock'
> > >=20
> > > And?  None of these programs should use <linux/inotify.h>.  There has
> > > for the longest time been a <sys/inotify.h> header which doesn't need
> > > any kernel headers.  In fact, <linux/inotify.h> should not be exporte=
d.
> >=20
> > Even if userspace applications shouldn't use it directly this doesn't=
=20
> > sound right:
> >=20
> > We shouldn't force all libc implementations to copy the contents into a=
=20
> > private header.
>=20
> glibc and dietlibc provide <sys/inotify.h>. newlib and uclibc don't. klibc
> provides <sys/inotify.h> but it depends on <linux/inotify.h>

Oh.. Sorry. uclibc provides <sys/inotify.h>.

So unexporting <linux/inotify.h> breaks only klibc.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--YD3LsXFS42OYHhNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjQ1iYACgkQbWYnhzC5v6pENgCgicRtGvHc8vnsItMnIVqYAXF3
gO0AoI0F92rknKAdxC6h2c23885Q0wVN
=nxTm
-----END PGP SIGNATURE-----

--YD3LsXFS42OYHhNZ--
