Return-Path: <linux-kernel-owner+w=401wt.eu-S1751139AbZGIXO3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139AbZGIXO3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jul 2009 19:14:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750794AbZGIXOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Jul 2009 19:14:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51924 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750782AbZGIXOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jul 2009 19:14:18 -0400
Date: Fri, 10 Jul 2009 09:14:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree import failure
Message-Id: <20090710091408.67c4da53.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__10_Jul_2009_09_14_08_+1000_Z_8JuwtUjmyE_2D6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__10_Jul_2009_09_14_08_+1000_Z_8JuwtUjmyE_2D6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next import of the ttydev tree failed like this:

tty-usb-mos7720-modem
error: usb/serial/mos7720.c: does not exist in index

It looks like a -p0 patch was included in the comments?  I removed the
-p0 patch (hopefully that was the correct one).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__10_Jul_2009_09_14_08_+1000_Z_8JuwtUjmyE_2D6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpWecAACgkQjjKRsyhoI8xhZACgqA+SQox7cbPtkst118KlTlYd
La0AoLH/j5XJ+9g9pnVAGTapu6trJIPx
=qzYm
-----END PGP SIGNATURE-----

--Signature=_Fri__10_Jul_2009_09_14_08_+1000_Z_8JuwtUjmyE_2D6--
