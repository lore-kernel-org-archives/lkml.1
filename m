Return-Path: <linux-kernel-owner+w=401wt.eu-S1764435AbZDHS4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764435AbZDHS4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 14:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755892AbZDHS42
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 14:56:28 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:34543 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754682AbZDHS41 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 14:56:27 -0400
Date: Wed, 8 Apr 2009 20:56:11 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for v2.6.30-rc2
Message-ID: <20090408205611.117b54e2@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-26094-1239216973-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-26094-1239216973-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive some minor fixes and some workarounds for buggy hardware:

 MAINTAINERS                   |    6 +-
 drivers/mmc/core/mmc.c        |    2 +-
 drivers/mmc/core/sd.c         |   21 +++--
 drivers/mmc/host/imxmmc.c     |   19 ++---
 drivers/mmc/host/mmc_spi.c    |  188 +++++++++++++++++++++++++++++--------=
----
 drivers/mmc/host/omap_hsmmc.c |    7 +-
 drivers/mmc/host/sdhci-pci.c  |    2 +-
 drivers/mmc/host/sdhci.c      |    2 +-
 drivers/mmc/host/wbsd.c       |    2 +-
 9 files changed, 164 insertions(+), 85 deletions(-)

Jarkko Lavinen (2):
      mmc: Accept EXT_CSD rev 1.3 since it is backwards compatible with 1.2
      omap_hsmmc: Do not expect cmd/data to be non-null when CC/TC occurs

Kevin Hilman (1):
      omap_hsmmc: Flush posted write to IRQ

Paulius Zaleckas (2):
      imxmmc: init-exit rework
      imxmmc: move RSSR BLR

Pierre Ossman (1):
      New mail address for Pierre Ossman

Tony Lindgren (1):
      mmc: Fix compile for omap_hsmmc.c

Wolfgang Muees (3):
      mmc_spi: do not check CID and CSD blocks with CRC16
      mmc_spi: convert timeout handling to jiffies and avoid busy waiting
      mmc_spi: support for non-byte-aligned cards

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org
  TigerVNC, core developer          http://www.tigervnc.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-26094-1239216973-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAknc804ACgkQ7b8eESbyJLhmTwCg704hgdemhV1WRWtci6Mvmi5R
uVYAn1cgQuVbP2DX2o3b7qRO5POda70e
=m7wr
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-26094-1239216973-0001-2--
