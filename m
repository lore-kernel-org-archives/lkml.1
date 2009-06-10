Return-Path: <linux-kernel-owner+w=401wt.eu-S1755887AbZFJFNa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755887AbZFJFNa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 01:13:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbZFJFNW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 01:13:22 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753613AbZFJFNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 01:13:21 -0400
Date: Wed, 10 Jun 2009 15:13:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build warning
Message-Id: <20090610151303.b7d020b5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_15_13_03_+1000_XZZ0nC2SRRzUOP6M"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_15_13_03_+1000_XZZ0nC2SRRzUOP6M
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/char/tty_ioctl.c: In function 'tty_mode_ioctl':
drivers/char/tty_ioctl.c:950: warning: unused variable 'ktermx'

Introduced by commit 726c4346f5be00e0e48149ebe81026dcc3c9578e
("tty-mutex-untangle").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_15_13_03_+1000_XZZ0nC2SRRzUOP6M
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkovQN8ACgkQjjKRsyhoI8x31QCff8jq9d2+AtDqgLIgHi37rByH
c7kAl0HuW4J6nZvJ+zYxXfNGjohaDwQ=
=/mkI
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_15_13_03_+1000_XZZ0nC2SRRzUOP6M--
