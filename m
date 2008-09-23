Return-Path: <linux-kernel-owner+w=401wt.eu-S1754075AbYIWRkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754075AbYIWRkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 13:40:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751822AbYIWRkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 13:40:24 -0400
Received: from server.drzeus.cx ([85.8.24.28]:52043 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751912AbYIWRkX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 13:40:23 -0400
Date: Tue, 23 Sep 2008 19:40:12 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: kernel@avr32linux.org, linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH 2/4] atmel-mci: Platform code for supporting multiple
 mmc slots
Message-ID: <20080923194012.3907c677@mjolnir.drzeus.cx>
In-Reply-To: <1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
References: <1222101497-21183-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-2-git-send-email-haavard.skinnemoen@atmel.com>
	<1222101497-21183-3-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.5.0cvs92 (GTK+ 2.14.0; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-22675-1222191621-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-22675-1222191621-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Sep 2008 18:38:15 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> +/**
> + * struct mci_platform_data - board-specific MMC/SDcard configuration
> + * @dma_slave: DMA slave interface to use in data transfers, or NULL.
> + * @slot: Per-slot configuration data.
> + */
> +struct mci_platform_data {
> +	struct mci_slot_pdata	slot[2];
> +};

Comment doesn't match code.

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-22675-1222191621-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkjZKgIACgkQ7b8eESbyJLgAxwCeN9QpfEMnud8ST1mkP4CJ7VJ/
X14AoLYmFytYR9U6bZyxHbIXNpaH9+CR
=hr4R
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-22675-1222191621-0001-2--
