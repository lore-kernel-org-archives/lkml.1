Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbZGNEKQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbZGNEKQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:10:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750815AbZGNEKP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:10:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34527 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750699AbZGNEKO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:10:14 -0400
Date: Tue, 14 Jul 2009 14:10:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build failure
Message-Id: <20090714141003.cdc11a47.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Jul_2009_14_10_03_+1000_H1g4u5vlQYvQycxb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Jul_2009_14_10_03_+1000_H1g4u5vlQYvQycxb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/serial/serial_core.c: In function 'uart_close':
drivers/serial/serial_core.c:1341: error: 'struct tty_port' has no member n=
amed 'cons'
drivers/serial/serial_core.c:1341: error: 'struct tty_port' has no member n=
amed 'cons'
drivers/serial/serial_core.c:1341: error: 'struct tty_port' has no member n=
amed 'line'

Caused by commit 85325e93e9473dd779e8378c1365f9d8a11f9b9e
("serial-port-portptr").

I have used the version of the ttydev tree from next-20090713 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Jul_2009_14_10_03_+1000_H1g4u5vlQYvQycxb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpcBRsACgkQjjKRsyhoI8xH6gCeNmIoAcoEsa4yk/OHdxCWgpsu
h+oAnRBdxWTrx52cw54PL6OP7eJ11MSs
=/jHI
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Jul_2009_14_10_03_+1000_H1g4u5vlQYvQycxb--
