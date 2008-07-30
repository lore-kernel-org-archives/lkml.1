Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYG3WSQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYG3WSQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2008 18:18:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752436AbYG3WSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Jul 2008 18:18:03 -0400
Received: from server.drzeus.cx ([85.8.24.28]:43742 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752087AbYG3WSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2008 18:18:01 -0400
Date: Thu, 31 Jul 2008 00:17:51 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Nicolas Pitre <nico@cam.org>, Bridge Wu <mingqiao.wu@gmail.com>
Cc: akpm@linux-foundation.org, rifx@o2.pl, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/1] mmc: fix clock-off in PXA255/270
Message-ID: <20080731001751.48f2e0f8@mjolnir.drzeus.cx>
In-Reply-To: <200807301933.m6UJXnQB012166@imap1.linux-foundation.org>
References: <200807301933.m6UJXnQB012166@imap1.linux-foundation.org>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-26970-1217456278-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-26970-1217456278-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jul 2008 12:33:49 -0700
akpm@linux-foundation.org wrote:

> From: rifx <rifx@o2.pl>
>=20
> It solves the problems with clock-off in the PXA255/270 MMC/SD hardware. =
 This
> solution was tested with our devices and works good.
>=20
> Cc: Pierre Ossman <drzeus-list@drzeus.cx>
>=20
> On Tue, 10 Jun 2008 08:42:01 +0200 Pierre Ossman <drzeus@drzeus.cx> wrote:
> >=20
> > This version was NAK:ed. I'm waiting for a new patch that removes the
> > original clock fiddling instead.
>=20
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---

Oh, unmaintained driver, how do I love thee? Let me count the ways...

Seriously, could someone with access to pxa hardware find a sane
solution to this?

You can find the original thread (which isn't being pieced together
correctly for some reason, but still) here:

http://marc.info/?w=3D2&r=3D1&s=3Dfix+clock+problem+in+PXA255%2F270&q=3Dt

And _please_ find someone that can step up as maintainer before I get
inclined to take this driver out back...

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-26970-1217456278-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiQ6JMACgkQ7b8eESbyJLhfvACcDiM5+4e/K6IGVuXVzYn64RJs
TtcAn0dZ/H4y96E1cm7ygHO7tXVl75jy
=S/+b
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-26970-1217456278-0001-2--
