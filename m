Return-Path: <linux-kernel-owner+w=401wt.eu-S1752515AbYJTQWg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515AbYJTQWg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 12:22:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751424AbYJTQW2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 12:22:28 -0400
Received: from server.drzeus.cx ([85.8.24.28]:44340 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751352AbYJTQW1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 12:22:27 -0400
Date: Mon, 20 Oct 2008 18:22:17 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] Second set of MMC updates for v2.6.28-rc1
Message-ID: <20081020182217.1648a02a@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-18903-1224519746-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-18903-1224519746-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Linus, please pull from

        git://git.kernel.org/pub/scm/linux/kernel/git/drzeus/mmc.git for-li=
nus

to receive the following updates:

 drivers/mmc/card/queue.c  |    1 +
 drivers/mmc/host/s3cmci.c |  210 ++++++++++++++++++++++++++++++++++-------=
----
 drivers/mmc/host/s3cmci.h |    6 +-
 3 files changed, 165 insertions(+), 52 deletions(-)

Christer Weinigel (1):
      s3cmci: Support transfers which are not multiple of 32 bits.

Pierre Ossman (1):
      mmc_block: tell block layer there is no seek penalty

ben@fluff.org.uk (4):
      s3cmci: Make general protocol errors less noisy
      s3cmci: cpufreq support
      s3cmci: fix continual accesses to host->pio_ptr
      s3cmci: Add Ben Dooks/Simtec Electronics to header & copyright

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-18903-1224519746-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkj8sEAACgkQ7b8eESbyJLgGsgCggNpLDG+YH23gYgItUszJyMt8
x3AAnjoB1O/iIRKyjEl0J8ztg2BeIIj3
=8Qv5
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-18903-1224519746-0001-2--
