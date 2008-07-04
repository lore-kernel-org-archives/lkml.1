Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYGDRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYGDRqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2008 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753180AbYGDRqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Jul 2008 13:46:06 -0400
Received: from server.drzeus.cx ([85.8.24.28]:40815 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752260AbYGDRqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2008 13:46:04 -0400
Date: Fri, 4 Jul 2008 19:45:56 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Cc: linux-kernel@vger.kernel.org,
       Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
Subject: Re: [PATCH v2 2/4] mmc: Export internal host state through debugfs
Message-ID: <20080704194556.73061a08@mjolnir.drzeus.cx>
In-Reply-To: <1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
References: <1214843703-13199-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-1-git-send-email-haavard.skinnemoen@atmel.com>
	<1214918094-26758-2-git-send-email-haavard.skinnemoen@atmel.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.3; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-494-1215192874-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-494-1215192874-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue,  1 Jul 2008 15:14:52 +0200
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

I see that this version has no ifdef:s at all. Doesn't that mean a lot
of useless code if DEBUG_FS is not enabled? You embedded guys are
usually rather sensitive about such things. :)

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-494-1215192874-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkhuYdkACgkQ7b8eESbyJLiJQgCeKY+O4Foo9c/MbPNWx69lkmhi
AT4AnifBs9Tu9WqryaQYjdkg7Q1VBgOZ
=A6Rv
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-494-1215192874-0001-2--
