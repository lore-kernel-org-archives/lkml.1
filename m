Return-Path: <linux-kernel-owner+w=401wt.eu-S1752328AbZGaKgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbZGaKgf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jul 2009 06:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752099AbZGaKge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Jul 2009 06:36:34 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:36337 "EHLO
	smtp.ossman.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752009AbZGaKge (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jul 2009 06:36:34 -0400
Date: Fri, 31 Jul 2009 12:36:28 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] MMC fixes
Message-ID: <20090731123628.1fc4dfc6@mjolnir.ossman.eu>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.2; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.ossman.eu-2553-1249036592-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.ossman.eu-2553-1249036592-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive some small fixes and a bigger fix to handle cache aliasing
when doing PIO.

This pull request will also be my last as I'm stepping down as MMC
maintainer. Andrew will be handling the patches for now until a proper
maintainer structure is in place.

 MAINTAINERS                  |    3 +--
 drivers/misc/cb710/sgbuf2.c  |    4 ----
 drivers/mmc/host/cb710-mmc.c |    6 +++---
 drivers/mmc/host/imxmmc.c    |    2 +-
 drivers/mmc/host/sdhci.c     |   10 ++++++++--
 include/linux/cb710.h        |   29 +++--------------------------
 include/linux/scatterlist.h  |    2 ++
 lib/scatterlist.c            |   16 ++++++++++++----
 8 files changed, 30 insertions(+), 42 deletions(-)

Joe Perches (1):
      imxmmc: Remove unnecessary semicolons

Pierre Ossman (1):
      mmc: orphan subsystem

Sebastian Andrzej Siewior (3):
      lib/scatterlist: add a flags to signalize mapping direction
      sdhci: use SG_MITER_TO_SG/SG_MITER_FROM_SG
      cb710: use SG_MITER_TO_SG/SG_MITER_FROM_SG

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.ossman.eu-2553-1249036592-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkpyyTAACgkQ7b8eESbyJLgmIQCfbthSv70pPVv4b3EEiHxu0xce
7zMAn0n17uUaAGLGTQmO2ME74llgd6x+
=yCVe
-----END PGP SIGNATURE-----

--=_freyr.ossman.eu-2553-1249036592-0001-2--
