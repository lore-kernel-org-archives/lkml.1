Return-Path: <linux-kernel-owner+w=401wt.eu-S1757964AbZBBUPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964AbZBBUPn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 15:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753719AbZBBUPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 15:15:35 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:46983 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753564AbZBBUPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 15:15:34 -0500
X-Greylist: delayed 334 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Feb 2009 15:15:34 EST
Date: Mon, 2 Feb 2009 21:09:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for 2.6.29-rc4
Message-ID: <20090202210932.36bf9e05@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-6779-1233605397-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6779-1233605397-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive one new driver, a fix to make ricoh controllers work after
suspend and a few workarounds for certain hardware.

 arch/arm/plat-mxc/include/mach/mmc.h |   36 ++
 drivers/mmc/host/Kconfig             |   10 +
 drivers/mmc/host/Makefile            |    1 +
 drivers/mmc/host/mmci.c              |   37 ++-
 drivers/mmc/host/mmci.h              |   28 ++
 drivers/mmc/host/mxcmmc.c            |  880 ++++++++++++++++++++++++++++++=
++++
 drivers/mmc/host/pxamci.c            |   25 +-
 drivers/mmc/host/ricoh_mmc.c         |    8 +-
 8 files changed, 1011 insertions(+), 14 deletions(-)
 create mode 100644 arch/arm/plat-mxc/include/mach/mmc.h
 create mode 100644 drivers/mmc/host/mxcmmc.c

Cliff Brake (2):
      pxamci: replace #ifdef CONFIG_PXA27x with if (cpu_is_pxa27x())
      pxamci: enable DMA for write ops after CMD/RESP

Linus Walleij (1):
      mmci: Add support for ST Micro derivate

Sascha Hauer (1):
      mmc: Add a MX2/MX3 specific SDHC driver

philipl@overt.org (1):
      ricoh_mmc: Use suspend_late/resume_early


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6779-1233605397-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkmHUxUACgkQ7b8eESbyJLiSRACfYxcZNgUTjB07KTwd0J7QY3sV
3qgAoK1xuWAGPXF9C5tqJHg61n8stQTt
=og89
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6779-1233605397-0001-2--
