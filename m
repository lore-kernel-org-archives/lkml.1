Return-Path: <linux-kernel-owner+w=401wt.eu-S1751842AbZGaJoz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751842AbZGaJoz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 05:44:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751315AbZGaJoy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 05:44:54 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:58992 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751766AbZGaJoy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 05:44:54 -0400
Date: Fri, 31 Jul 2009 11:44:47 +0200
From: Pierre Ossman <pierre@ossman.eu>
To: Nicolas Pitre <nico@cam.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mvsdio: fix handling of partial word at the end of PIO
 transfer
Message-ID: <20090731114447.26c6414f@mjolnir.ossman.eu>
In-Reply-To: <alpine.LFD.2.00.0907101348210.3138@xanadu.home>
References: <alpine.LFD.2.00.0907101348210.3138@xanadu.home>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-2023-1249033491-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-2023-1249033491-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Jul 2009 14:19:42 -0400 (EDT)
Nicolas Pitre <nico@cam.org> wrote:

> Standard data flow for MMC/SD/SDIO cards requires that the mvsdio=20
> controller be set for big endian operation.  This is causing problems=20
> with buffers which length is not a multiple of 4 bytes as the last=20
> partial word doesn't get shifted all the way and stored properly in=20
> memory.  Let's compensate for this.
>=20
> Signed-off-by: Nicolas Pitre <nico@marvell.com>
> CC: stable@kernel.org
> ---

Queued.

--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-2023-1249033491-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpyvRIACgkQ7b8eESbyJLhM9wCginNq8Fogjq6n7oZ5GWtwoyeO
B40AniZ8ltMti1ZGqgUnfxYMfHqvsB/f
=+M+H
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-2023-1249033491-0001-2--
