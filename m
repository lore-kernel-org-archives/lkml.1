Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbYHARJS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbYHARJS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 13:09:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYHARJE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 13:09:04 -0400
Received: from server.drzeus.cx ([85.8.24.28]:58593 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751776AbYHARJD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 13:09:03 -0400
Date: Fri, 1 Aug 2008 19:08:55 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] MMC fixes for v2.6.27-rc2
Message-ID: <20080801190855.71023311@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-18224-1217610540-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-18224-1217610540-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/card/block.c     |   17 +++++---
 drivers/mmc/card/mmc_test.c  |   85 +-------------------------------------=
---
 drivers/mmc/core/core.c      |    5 +-
 drivers/mmc/host/au1xmmc.c   |    8 +++-
 drivers/mmc/host/sdhci-pci.c |    3 +-
 drivers/mmc/host/sdhci.c     |   15 ++++++-
 drivers/mmc/host/sdhci.h     |    2 +
 7 files changed, 40 insertions(+), 95 deletions(-)

Manuel Lauss (1):
      au1xmmc: raise segment size limit.

Pierre Ossman (6):
      sdhci: handle bug in JMB38x for sizes < 4 bytes
      sdhci: disable DMA for req, not completely
      sdhci: check correct return value
      mmc_test: Revert "mmc_test: test oversized sg lists"
      mmc: properly iterate over sg list in debug check
      mmc_block: use proper sg iterators

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-18224-1217610540-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiTQysACgkQ7b8eESbyJLjZdgCeOnwgHvIp/4ztEEXHweBqhUs9
/ssAoJy2CT7VqJWPtOfscAnYQnRHxNXz
=SqUC
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-18224-1217610540-0001-2--
