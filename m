Return-Path: <linux-kernel-owner+w=401wt.eu-S1756447AbYGWVoJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447AbYGWVoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 17:44:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754916AbYGWVn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 17:43:57 -0400
Received: from server.drzeus.cx ([85.8.24.28]:47721 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754555AbYGWVn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 17:43:56 -0400
Date: Wed, 23 Jul 2008 23:43:50 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@HansenPartnership.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [GIT PULL] MMC updates for 2.6.27-rc1
Message-ID: <20080723234350.3acad60d@mjolnir.drzeus.cx>
In-Reply-To: <alpine.LFD.1.10.0807231206230.4754@woody.linux-foundation.org>
References: <20080719015911.02faddf6@mjolnir.drzeus.cx>
	<20080723150031.36e5b85a@mjolnir.drzeus.cx>
	<alpine.LFD.1.10.0807231206230.4754@woody.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-31041-1216849435-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-31041-1216849435-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Jul 2008 12:08:01 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

>=20
>=20
> On Wed, 23 Jul 2008, Pierre Ossman wrote:
> >
> >  include/linux/scatterlist.h |   38 +++++++
> >  lib/scatterlist.c           |  176 +++++++++++++++++++++++++---------
> >=20
> > Tejun Heo (1):
> >       sg: reimplement sg mapping iterator
>=20
> I'd really have been a lot happier about this one if it had had a few=20
> Acked-by's from people like Jens and James.
>=20
> But I pulled, and pushed out. I think Jens is on vacation, but I'm adding=
=20
> him to the cc anyway.

Yeah, I was hoping to get Jens' input on this aswell, but this fixes
problems in the sdhci driver so it was pushed in the hope that he won't
NAK it too badly when he gets back.

(James just got casually poked, but I wasn't even aware he was a
suitable person for this. lib/ and kernel/ are generally a bit
problematic when it comes to determining maintainer :/)

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-31041-1216849435-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiHphkACgkQ7b8eESbyJLjmsACgrqw8/pUIMP6Hdo0oSTmKif03
B7oAoNOL6lvF0R5OoXLZ+R+ciQ0B8LhE
=P9/e
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-31041-1216849435-0001-2--
