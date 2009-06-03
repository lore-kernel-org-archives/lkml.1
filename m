Return-Path: <linux-kernel-owner+w=401wt.eu-S1756053AbZFCUDf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756053AbZFCUDf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 16:03:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755456AbZFCUD2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 16:03:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:47749 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755404AbZFCUD1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 16:03:27 -0400
Date: Wed, 3 Jun 2009 22:03:21 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Late MMC fixes
Message-ID: <20090603220321.03917c47@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-31175-1244059407-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-31175-1244059407-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive some important fixes, primarily for the new host drivers.

I'm sorry this comes so late in the development cycle. I haven't had time
to put a tree together until now. :/

 drivers/mmc/host/mvsdio.c     |   35 ++++++++++++++++++++++++++++++
 drivers/mmc/host/mxcmmc.c     |   47 ++++++++++++++++++++++++++++++-------=
---
 drivers/mmc/host/omap.c       |    2 +-
 drivers/mmc/host/omap_hsmmc.c |    2 +-
 drivers/mmc/host/sdhci-of.c   |    9 +++++++-
 5 files changed, 80 insertions(+), 15 deletions(-)

Anand Gadiyar (1):
      omap_hsmmc: Trivial fix for a typo in comment

Ben Nizette (1):
      mmc/omap: Use disable_irq_nosync() from within irq handlers.

Dave Liu (1):
      sdhci-of: Fix the wrong accessor to HOSTVER register

Kumar Gala (1):
      sdhci-of: Add fsl,esdhc as a valid compatible to bind against

Martin Fuzzey (2):
      mxcmmc : Reset the SDHC hardware if software timeout occurs.
      mxcmmc: Fix missing return value checking in DMA setup code.

Nicolas Pitre (3):
      mvsdio: allow automatic loading when modular
      mvsdio: ignore high speed timing requests from the core
      mvsdio: fix config failure with some high speed SDHC cards

Sascha Hauer (1):
      mxcmmc: decrease minimum frequency to make MMC cards work

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-31175-1244059407-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkom1w8ACgkQ7b8eESbyJLhM/QCdExr/YVdC9nnDgWWsFQtM6F6+
lOcAmgP4PkSKaIzBrcZpJ6RO7EaP9bCm
=Arpj
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-31175-1244059407-0001-2--
