Return-Path: <linux-kernel-owner+w=401wt.eu-S1756925AbZBRVEp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756925AbZBRVEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 16:04:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751615AbZBRVEg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 16:04:36 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43770 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751425AbZBRVEg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 16:04:36 -0500
Date: Wed, 18 Feb 2009 22:04:28 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.29-rc6
Message-ID: <20090218220428.1d3f50e2@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.3; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-32287-1234991073-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-32287-1234991073-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive:

 - userspace interface fixes, one which was causing hald to crash

 - revert of commit a4b7619 as it caused problems on some machines

 - a lockdep fix

 - a fix to s3cmci where it could hang on some transfer sizes

and two minor fixes.

 drivers/mmc/card/block.c      |    2 +-
 drivers/mmc/card/mmc_test.c   |    2 +-
 drivers/mmc/host/omap_hsmmc.c |    4 +++-
 drivers/mmc/host/s3cmci.c     |    2 +-
 drivers/mmc/host/sdhci-pci.c  |    3 +--
 drivers/mmc/host/sdhci.c      |    7 ++++---
 drivers/mmc/host/sdhci.h      |    3 +--
 7 files changed, 12 insertions(+), 11 deletions(-)

David Brownell (1):
      omap_hsmmc: card detect irq bugfix

Helmut Schaa (1):
      sdhci: fix led naming

Pierre Ossman (1):
      Revert "sdhci: force high speed capability on some controllers"

Rabin Vincent (1):
      mmc_test: fix basic read test

Yauhen Kharuzhy (1):
      s3cmci: Fix hangup in do_pio_write()

Yi Li (1):
      MMC: fix bug - SDHC card capacity not correct

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-32287-1234991073-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.10 (GNU/Linux)

iEYEARECAAYFAkmcd+AACgkQ7b8eESbyJLj7FACePb4VN8OgFPcKmHTllZ5csFM8
EhoAoJJebLmJ6TMwvAkQ4m1Vg2HGT/XU
=xfYy
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-32287-1234991073-0001-2--
