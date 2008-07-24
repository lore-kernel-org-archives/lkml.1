Return-Path: <linux-kernel-owner+w=401wt.eu-S1753547AbYGXJ6W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547AbYGXJ6W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 05:58:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751104AbYGXJ6O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 05:58:14 -0400
Received: from server.drzeus.cx ([85.8.24.28]:35840 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYGXJ6O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 05:58:14 -0400
Date: Thu, 24 Jul 2008 11:58:05 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Cc: Jean Tourrilhes <jt@hpl.hp.com>, LKML <linux-kernel@vger.kernel.org>
Subject: 22bb1be4d27... breaks hal (and NM)
Message-ID: <20080724115805.5466c217@mjolnir.drzeus.cx>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-5464-1216893492-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-5464-1216893492-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

=46rom commit 22bb1be4d27...:

"The /sys/class/net/*/wireless/ direcory is, as far as I know, not used
by anyone."

Can't have been much of an investigation as HAL uses these to determine
if a card is a wireless one. Without this option, you cannot get
wireless support in NetworkManager, stranding most laptops.

Change the default and mark it for future deprecation if you want to
get rid of it.

--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-5464-1216893492-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiIUjAACgkQ7b8eESbyJLgfYgCguKna1rLwwWUFArNTpHzkYwEE
wWYAoIW6oLc7pE/ulaq1RKr63BLjbI5M
=j/he
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-5464-1216893492-0001-2--
