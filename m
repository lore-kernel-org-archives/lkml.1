Return-Path: <linux-kernel-owner+w=401wt.eu-S1758462AbYGPWlo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462AbYGPWlo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2008 18:41:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753662AbYGPWlg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jul 2008 18:41:36 -0400
Received: from server.drzeus.cx ([85.8.24.28]:55952 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751944AbYGPWlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2008 18:41:35 -0400
Date: Thu, 17 Jul 2008 00:41:27 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates for 2.6.26
Message-ID: <20080717004127.388aa574@mjolnir.drzeus.cx>
In-Reply-To: <alpine.LFD.1.10.0807161512030.2835@woody.linux-foundation.org>
References: <20080715160436.0f6ac19e@mjolnir.drzeus.cx>
	<alpine.LFD.1.10.0807161512030.2835@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-32181-1216248092-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-32181-1216248092-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Jul 2008 15:16:26 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

>=20
>=20
> On Tue, 15 Jul 2008, Pierre Ossman wrote:
> >
> >  45 files changed, 6054 insertions(+), 1320 deletions(-)
>=20
> If you had done the "--summary", you'd also have seen these bogus:
>=20
> 	 mode change 100644 =3D> 100755 drivers/mmc/core/sdio_io.c
> 	 mode change 100644 =3D> 100755 include/linux/mmc/sdio_func.h
>=20
> entries.
>=20
> I have no idea why you think those things should be executable, but it=20
> happened in commit 6d37333163025b46afbcad434ec9a5f2e88e7254 ("mmc: fix=20
> sdio_io sparse errors").
>=20

Ouch. It was in the patch submitted to me, but I overlooked the mode
changes there. I wasn't fully aware git could express such things in
the patches. :)

> Anyway, there's a reason why I ask people to use
>=20
> 	--diffstat --summary -M
>=20
> when generating the report. This is just part of it.
>=20
> I fixed it up in the merge, so it's ok in my tree, but I thought I'd poin=
t=20
> it out.
>=20

Thanks. I have changed my scripts and hopefully I'll notice such
silliness in the future.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-32181-1216248092-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkh+eRsACgkQ7b8eESbyJLj7VgCg4kPO/Tqk2xYs5zd557cBZVKJ
44IAoJoN2nLUm+DU5q4kZdvQKdVp4GYi
=CjMp
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-32181-1216248092-0001-2--
