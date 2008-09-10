Return-Path: <linux-kernel-owner+w=401wt.eu-S1754492AbYIJNPJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492AbYIJNPJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 09:15:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752768AbYIJNOo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 09:14:44 -0400
Received: from ug-out-1314.google.com ([66.249.92.175]:32174 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbYIJNOm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 09:14:42 -0400
Date: Wed, 10 Sep 2008 16:15:13 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christine Caulfield <caulfie@redhat.com>,
       David Teigland <teigland@redhat.com>,
       David Woodhouse <dwmw2@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] include <linux/types.h> into linux/dlm_plock.h for
	__u* typedef
Message-ID: <20080910131512.GH3757@localhost.localdomain>
References: <1221045726-5674-1-git-send-email-kirill@shutemov.name> <1221045726-5674-2-git-send-email-kirill@shutemov.name> <20080910121450.GA3468@x200.localdomain> <20080910125503.GG3757@localhost.localdomain> <20080910131158.GB3468@x200.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="J/zg8ciPNcraoWb6"
Content-Disposition: inline
In-Reply-To: <20080910131158.GB3468@x200.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--J/zg8ciPNcraoWb6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 10, 2008 at 05:11:58PM +0400, Alexey Dobriyan wrote:
> On Wed, Sep 10, 2008 at 03:55:04PM +0300, Kirill A. Shutemov wrote:
> > On Wed, Sep 10, 2008 at 04:14:50PM +0400, Alexey Dobriyan wrote:
> > > On Wed, Sep 10, 2008 at 02:22:04PM +0300, Kirill A. Shutemov wrote:
> > > > --- a/include/linux/dlm_plock.h
> > > > +++ b/include/linux/dlm_plock.h
> > >=20
> > > > +#include <linux/types.h>
> > >=20
> > > I'd say that unless you can demonstrate compilation breakage, these w=
ill
> > > only slow down compilation.
> >=20
> > Do you think that minor slow down is worse than dependence on the order=
 of
> > inclusion?
>=20
> Since it compiles fine there is no such dependency.

It doesn't compiles:

$ make headers_install
=2E..
$ gcc usr/include/linux/dlm_plock.h
usr/include/linux/dlm_plock.h:25: error: expected specifier-qualifier-list
before =E2=80=98__u32=E2=80=99

> Just removing externs from function prototypes makes compiles go faster f=
or
> _seconds_.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--J/zg8ciPNcraoWb6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjHyGAACgkQbWYnhzC5v6o+wQCdF422uv0k4cHyhURzYOFDMf1j
kDsAn0l9nYGgRcX79beleb6gSHfH4xJ4
=Io2I
-----END PGP SIGNATURE-----

--J/zg8ciPNcraoWb6--
