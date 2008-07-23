Return-Path: <linux-kernel-owner+w=401wt.eu-S1754288AbYGWNAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbYGWNAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 09:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751363AbYGWNAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 09:00:40 -0400
Received: from server.drzeus.cx ([85.8.24.28]:32819 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751134AbYGWNAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:00:39 -0400
Date: Wed, 23 Jul 2008 15:00:31 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] MMC updates for 2.6.27-rc1
Message-ID: <20080723150031.36e5b85a@mjolnir.drzeus.cx>
In-Reply-To: <20080719015911.02faddf6@mjolnir.drzeus.cx>
References: <20080719015911.02faddf6@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-27184-1216818037-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-27184-1216818037-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 19 Jul 2008 01:59:11 +0200
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> Linus, please pull from
>=20
>         git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-=
linus
>=20

Since you haven't pulled yet, I've updated the list of patches to the
following set:

 MAINTAINERS                 |    5 +-
 drivers/mmc/card/mmc_test.c |  225 +++++++++++++++++++++++++++++++++++++++=
+++-
 drivers/mmc/card/queue.c    |   97 ++++++-------------
 drivers/mmc/host/au1xmmc.c  |   54 ++++++++---
 drivers/mmc/host/pxamci.c   |    2 +-
 drivers/mmc/host/s3cmci.c   |   50 ++++++----
 drivers/mmc/host/sdhci.c    |  167 ++++++++++++++------------------
 drivers/mmc/host/sdhci.h    |    7 +-
 include/linux/scatterlist.h |   38 +++++++
 lib/scatterlist.c           |  176 +++++++++++++++++++++++++---------
 10 files changed, 573 insertions(+), 248 deletions(-)

Ben Dooks (2):
      s3cmci: fixes for section mismatch warnings
      s3cmci: ensure host stopped on machine shutdown

Karl Beldan (1):
      pxamci: trivial fix of DMA alignment register bit clearing

Manuel Lauss (1):
      au1xmmc: suspend/resume implementation

Pierre Ossman (8):
      mmc_test: highmem tests
      mmc_test: test oversized sg lists
      sdhci: add warnings for bad buffers in ADMA path
      sdhci: fix bad warning from commit c8b3e02
      mmc_block: bounce buffer highmem support
      mmc: Remove Russell as primecell mci maintainer
      mmc_test: print message when attaching to card
      sdhci: highmem capable PIO routines

Tejun Heo (1):
      sg: reimplement sg mapping iterator


--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-27184-1216818037-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiHK3MACgkQ7b8eESbyJLibsgCg7sRHnwVjvWX1gOVhAsmHVivP
RJ8AoKW0gbRdTleOSwa5BzJ053tB81xY
=j/Cb
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-27184-1216818037-0001-2--
