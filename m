Return-Path: <linux-kernel-owner+w=401wt.eu-S933112AbZJFTuB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933112AbZJFTuB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 15:50:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932893AbZJFTuA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 15:50:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:53872 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885AbZJFTuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 15:50:00 -0400
Subject: Re: [patch] kbuild: Improve version string logic
From: Johannes Berg <johannes@sipsolutions.net>
To: Frans Pop <elendil@planet.nl>
Cc: mingo@elte.hu, torvalds@linux-foundation.org, hohndel@infradead.org,
       lenb@kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <200910062146.00298.elendil@planet.nl>
References: <alpine.LFD.2.01.0910041727310.3432@localhost.localdomain>
	 <alpine.LFD.2.00.0910052140100.309@localhost.localdomain>
	 <1254797502.14122.146.camel@dhohndel-mobl.amr.corp.intel.com>
	 <alpine.LFD.2.01.0910060705240.3432@localhost.localdomain>
	 <20091006173508.GA4786@elte.hu> <20091006173508.GA4786@elte.hu>
	 <1254854227.22426.37.camel@johannes.local>
	 <200910062146.00298.elendil@planet.nl>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-DuoDyvyFLtl4Og4PLnZr"
Date: Tue, 06 Oct 2009 21:48:18 +0200
Message-Id: <1254858498.22426.41.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-DuoDyvyFLtl4Og4PLnZr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-10-06 at 21:45 +0200, Frans Pop wrote:
> Johannes Berg wrote:
> > I think adding the + unconditionally will also break things like
> > debian's make-kpkg, for instance, since the + would get propagated into
> > the package version which reserves the + for something else.
>=20
> Are you sure?=20

No, I'm not.

> AFAIK it would be propagated into the package _name_, where=20
> it is allowed. And even if it were part of the package version, it would=20
> be in the "upstream" part of the version number, where it is also allowed=
.
>=20
> The only reserved use of "+" I'm aware of is in the Debian part of the=20
> package version.
>=20
> But I have not used make-kpkg in ages, so I'm not 100% sure how that buil=
ds=20
> the package version. I could be that it duplicates the kernel version in=20
> both the package name and the upstream part of the package version, but=20
> that should still be OK.

That may all well be true. I wasn't even aware of the distinction
between debian and upstream part of the version :)

I do, however, remember no end to trouble with autoversion and make-kpkg
so eventually gave up on using it entirely.

johannes

--=-DuoDyvyFLtl4Og4PLnZr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKy579AAoJEODzc/N7+QmaP+MP/0sAEhbSiqFT6v0orsdFY2JL
M51EkDNTh0ltflpPWoSimhBEBpfffMnTSEfC3uHwEn6VnhPXoxGiOFOp9N+Ja5PK
8nI/vEUZutGTPJM/Kj+3fnLNFXBq4/k9yQbRzIgPWBz2WaUSKdpPvmRKDudrYFeC
J6ljTnodRi6iFSTjAwoT3GX7+HUdbvjYaKzJrvGT/BIaipUDhegW3At875rFUg/G
ZRchWZjWOxqu7LyTGhLV+vxHEJ/j8MO8GuffNk0bPbnV0DH9R02r1rYkSk82BeNm
4zSJLskv4Zol4DvSVeTpEvUbT7y4iRwe0itqirOdkqDlw8X1eVM5Lpx+DhdXDTNb
OVLhEm6EKIne9pCqqRvf6Md2K/LI+7jwfdoGH7z96FtNFtgPTUON3lDK6nC9ko6+
sKGV9QejvyyM3gZS4ez7V1gT1T9qEjvNyZ9insw3VPJzsYS+A1OY66GjKclihctQ
50vzxqCBhxeRTZ485zBwzsadHCJEJ0GvIyc+2OVOr1eSpdXFd31BVP0Fv1j4wHzu
MK2AxcNfHnDjcL/fsvqTTj2mWf4rcQhEtZqHeNARY4jVeLQtKdgKNAR/3Z+TMQpp
kZ+6X3a4NXg/DeQh3kYEPoYri39yzS6Qd+Qzg+smAfa91UUeS9mkORMBdHMpfadv
rD2pwf8tcsUG2s05Ls/V
=ndDf
-----END PGP SIGNATURE-----

--=-DuoDyvyFLtl4Og4PLnZr--

