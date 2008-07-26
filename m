Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYGZX1B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYGZX1B (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2008 19:27:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752835AbYGZX0x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Jul 2008 19:26:53 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44010 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752182AbYGZX0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2008 19:26:52 -0400
Date: Sun, 27 Jul 2008 01:26:46 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v3 1/3] mmc: Export internal host state through debugfs
Message-ID: <20080727012646.352d8c09@mjolnir.drzeus.cx>
In-Reply-To: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
References: <1216901939-4187-1-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-3599-1217114810-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-3599-1217114810-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 14:18:57 +0200
Haavard Skinnemoen <haavard.skinnemoen@atmel.com> wrote:

> When CONFIG_DEBUG_FS is set, create a few files under /sys/kernel/debug
> containing information about an mmc host's internal state. Currently,
> just a single file is created, "ios", which contains information about
> the current operating parameters for the bus (clock speed, bus width,
> etc.)
>=20
> Host drivers can add additional files and directories under the host's
> root directory by passing the debugfs_root field in struct mmc_host as
> the 'parent' parameter to debugfs_create_*.
>=20
> Signed-off-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
>=20

All three patches applied.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-3599-1217114810-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiLsrgACgkQ7b8eESbyJLhP4QCeIctorn84o+SIrcasBOpTIpBt
ZaQAmgJqQKtCD9mOkAuY82Hb/rgCzezG
=nmpo
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-3599-1217114810-0001-2--
