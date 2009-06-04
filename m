Return-Path: <linux-kernel-owner+w=401wt.eu-S1756733AbZFDCEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733AbZFDCEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 22:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755343AbZFDCEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 22:04:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58511 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223AbZFDCEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 22:04:40 -0400
Date: Thu, 4 Jun 2009 12:04:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: linux-next: mmc tree build failure
Message-Id: <20090604120435.bc32b890.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__4_Jun_2009_12_04_35_+1000_GGWK8lL6ZkW_1Kdu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__4_Jun_2009_12_04_35_+1000_GGWK8lL6ZkW_1Kdu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Pierre,

Today's linux-next build (powerpc_ppc64_defconfig) failed like this:

drivers/misc/Kconfig:238: can't open file "drivers/misc/cb710/Kconfig"

Caused by commit f8d1918a2e7adbfdde0efc1a9a22cca3d5c5cae9 ("mmc: Driver
for CB710/720 memory card reader (MMC part)").

I have used the version of the mmc tree from next-20090603 for today.

Please build test what you are submitting to linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__4_Jun_2009_12_04_35_+1000_GGWK8lL6ZkW_1Kdu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkonK7MACgkQjjKRsyhoI8ypGwCaAwAw4zjm4lxi2IA2olaA2M60
Tr0AoJqpq4tWmpoDvJiidB3qx98MZWh8
=ccfx
-----END PGP SIGNATURE-----

--Signature=_Thu__4_Jun_2009_12_04_35_+1000_GGWK8lL6ZkW_1Kdu--
