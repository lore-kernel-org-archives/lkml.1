Return-Path: <linux-kernel-owner+w=401wt.eu-S1754323AbXLHFBt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754323AbXLHFBt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Dec 2007 00:01:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751001AbXLHFBl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Dec 2007 00:01:41 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34622 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750704AbXLHFBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Dec 2007 00:01:40 -0500
Subject: Re: 2.6.24-rc4-mm1 and Very Slow PCMCIA Compact Flash
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org,
       linux-ide@vger.kernel.org
In-Reply-To: <20071207152249.360af326.akpm@linux-foundation.org>
References: <1197059904.15428.15.camel@localhost>
	 <20071207150251.a0dbae23.akpm@linux-foundation.org>
	 <1197068983.15428.29.camel@localhost>
	 <20071207152249.360af326.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jUQX9/2rFOmL7uJYwmRG"
Date: Fri, 07 Dec 2007 22:01:33 -0700
Message-Id: <1197090093.7157.2.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0ron-0004S8-MB-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jUQX9/2rFOmL7uJYwmRG
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2007-12-07 at 15:22 -0800, Andrew Morton wrote:
> On Fri, 07 Dec 2007 23:09:43 +0000
> Zan Lynx <zlynx@acm.org> wrote:
[cut]=20
> > > > Now with MM kernels 2.6.24 rc1-4 the PCMCIA adapter works again, bu=
t I
> > > > only get read rates of 1.6 MB/s.  When it used to work in 2.6.20 I =
got
> > > > at least 16 MB/s.  The card itself is capable of 30+ in the USB-2
> > > > reader.
[cut]
> Maybe pata_pcmcia-minor-cleanups-and-support-for-dual-channel-cards.patch=
?
>=20
> Could you try a `patch -R' of the below?
>=20
>=20
> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
>=20
> Signed-off-by: Alan Cox <alan@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
>=20
>  drivers/ata/pata_pcmcia.c |   31 +++++++++++++++++--------------
>  1 file changed, 17 insertions(+), 14 deletions(-)
>=20
> diff -puN drivers/ata/pata_pcmcia.c~pata_pcmcia-minor-cleanups-and-suppor=
t-for-dual-channel-cards drivers/ata/pata_pcmcia.c
[cut]

Nope, that did not change anything.  It still detects as PIO0 and still
runs at 1.6 MB/s.
--=20
Zan Lynx <zlynx@acm.org>

--=-jUQX9/2rFOmL7uJYwmRG
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWiUtG8fHaOLTWwgRAmP/AJ9LGH/D5PUnqQ4fS9//cy+dSiUKbACgq/H9
MwJ/SNhvPo50Z3SAnVU+HIk=
=LeMM
-----END PGP SIGNATURE-----

--=-jUQX9/2rFOmL7uJYwmRG--

