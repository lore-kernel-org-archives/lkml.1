Return-Path: <linux-kernel-owner+w=401wt.eu-S1754337Ab0ASEIo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337Ab0ASEIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 23:08:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753021Ab0ASEIn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 23:08:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34144 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822Ab0ASEIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 23:08:43 -0500
Date: Tue, 19 Jan 2010 15:08:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Richard Purdie <rpurdie@rpsys.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alberto Panizzo <maramaopercheseimorto@gmail.com>
Subject: linux-next: backlight tree build warning
Message-Id: <20100119150836.bb975e4b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__19_Jan_2010_15_08_36_+1100_bDH5+UNHYYYozsQR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__19_Jan_2010_15_08_36_+1100_bDH5+UNHYYYozsQR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Richard,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

WARNING: modpost: missing MODULE_LICENSE() in drivers/video/backlight/l4f00=
242t03.o

Introduced by commit 1bb615b563230e690b332dae4fda0067c2f88bbc
("backlight: Add Epson L4F00242T03 LCD driver").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__19_Jan_2010_15_08_36_+1100_bDH5+UNHYYYozsQR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktVMEQACgkQjjKRsyhoI8yqAgCdFczqKF0Y6JIhEbDg+rm+GbvV
w04AnjnCNupDet5ukCsFfqLY8eWR4xeU
=E7UX
-----END PGP SIGNATURE-----

--Signature=_Tue__19_Jan_2010_15_08_36_+1100_bDH5+UNHYYYozsQR--
