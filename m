Return-Path: <linux-kernel-owner+w=401wt.eu-S1754707AbYJLIoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707AbYJLIoV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 04:44:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbYJLIoN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 04:44:13 -0400
Received: from server.drzeus.cx ([85.8.24.28]:47783 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751371AbYJLIoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 04:44:12 -0400
Date: Sun, 12 Oct 2008 10:44:05 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v2 5/7] atmel-mci: Add experimental DMA support
Message-ID: <20081012104405.1ab7551d@mjolnir.drzeus.cx>
In-Reply-To: <1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
References: <1223223690-2637-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-3-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-4-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-5-git-send-email-haavard.skinnemoen@atmel.com>
	<1223223690-2637-6-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-11782-1223801052-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-11782-1223801052-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun,  5 Oct 2008 18:21:28 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> This adds support for DMA transfers through the generic DMA engine
> framework with the DMA slave extensions.
>=20
> The driver has been tested using mmc-block and ext3fs on several SD,
> SDHC and MMC+ cards. Reads and writes work fine, with read transfer
> rates up to 7.5 MiB/s on fast cards with debugging disabled.
>=20
> Unfortunately, the driver has been known to lock up from time to time
> with DMA enabled, so DMA support is currently optional and marked
> EXPERIMENTAL. However, I didn't see any problems while testing 13
> different cards (MMC, SD and SDHC of different brands and sizes), so I
> suspect the "Initialize BLKR before sending data transfer command" fix
> that was posted earlier fixed this as well.
>=20
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> ---

Looks good, but I assume the plan is to remove this Kconfig option once
you're confident it is stable?

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-11782-1223801052-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjxuNkACgkQ7b8eESbyJLh5GACgoIxp1IIt5vIfIkFWH8G8+0Rw
Yb8AnisuBI3rbxTC29eEHYfwf+ET3gbm
=vWzv
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-11782-1223801052-0001-2--
