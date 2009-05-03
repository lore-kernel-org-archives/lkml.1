Return-Path: <linux-kernel-owner+w=401wt.eu-S1757014AbZECUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014AbZECUbU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 May 2009 16:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754932AbZECUbK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 May 2009 16:31:10 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:43211 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186AbZECUbJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 May 2009 16:31:09 -0400
Date: Sun, 3 May 2009 22:31:01 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for next rc
Message-ID: <20090503223101.06c20067@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-10958-1241382664-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-10958-1241382664-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive assorted minor fixes:

 drivers/mmc/card/block.c     |    8 ++++++++
 drivers/mmc/core/core.c      |    4 ++--
 drivers/mmc/host/mmci.c      |    2 +-
 drivers/mmc/host/mvsdio.c    |   11 +++++------
 drivers/mmc/host/sdhci-pci.c |    8 +++++---
 drivers/mmc/host/sdhci.h     |    2 +-
 6 files changed, 22 insertions(+), 13 deletions(-)

Dan Carpenter (1):
      sdhci-pci: bad error handling in probe function

Jos=C3=A9 M. Fern=C3=A1ndez (1):
      mmc: increase power up delay

Pierre Ossman (2):
      mmc_block: be prepared for oversized requests
      sdhci: catch ADMA errors

Rabin Vincent (2):
      mmci: fix crash with debug enabled
      mvsdio: fix CONFIG_PM=3Dy build


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-10958-1241382664-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkn9/wcACgkQ7b8eESbyJLhIkgCeL3UP0s7dzQXzZ516XmmcE8xe
U1AAnRRRUPIaUfvr9MdPalncPGdJ/MGL
=H4TM
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-10958-1241382664-0001-2--
