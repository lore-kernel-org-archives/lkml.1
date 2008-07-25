Return-Path: <linux-kernel-owner+w=401wt.eu-S1755668AbYGYKF3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755668AbYGYKF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:05:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753382AbYGYKFV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:05:21 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52316 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750934AbYGYKFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:05:20 -0400
Date: Fri, 25 Jul 2008 12:05:14 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/3] mmc: Add per-card debugfs support
Message-ID: <20080725120514.7bccd746@mjolnir.drzeus.cx>
In-Reply-To: <20080725110503.5be65b71@siona.local>
References: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1216901939-4187-2-git-send-email-haavard.skinnemoen@atmel.com>
	<20080725082424.GD8301@fluff.org.uk>
	<20080725110503.5be65b71@siona.local>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-19032-1216980318-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-19032-1216980318-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 25 Jul 2008 11:05:03 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> On Fri, 25 Jul 2008 09:24:24 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
>=20
> > out of interest, why not have an standard sysfs node for the
> > current voltage setting?
>=20
> Dunno. Because nobody has added it? ;-)
>=20

It is also a stable userspace ABI at that point, so it needs to be done
a lot more carefully.

> >=20
> > why not make mmc_add_card_debugfs() an empty function
> > in the header if there is no debugfs support?
>=20
> Because Pierre didn't like it.
>=20

If it's just in core.h, then I can live with it. I did not like it when
it added even more noise to the core .c files.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-19032-1216980318-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiJpV0ACgkQ7b8eESbyJLjEqACg/Q6dFtb2q6WNPecFaFQ/4BHn
4KwAnR1AqNP/sPtVnuYAjQqMIfun/9oj
=sPd/
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-19032-1216980318-0001-2--
