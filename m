Return-Path: <linux-kernel-owner+w=401wt.eu-S1756899AbYGWAVG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756899AbYGWAVG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 20:21:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756195AbYGWAUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 20:20:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41327 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755965AbYGWAUk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 20:20:40 -0400
Date: Wed, 23 Jul 2008 10:20:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: airprime.c resurrected. Bad merge?
Message-Id: <20080723102032.48126b29.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jul_2008_10_20_32_+1000_5ssKUsiPZdupPPZX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jul_2008_10_20_32_+1000_5ssKUsiPZdupPPZX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

We have in your tree today:

commit 640c1bce86d1e11ee6a1263fdf6170d3210b1684 "USB: delete airprime
driver" which removes (among other things) drivers/usb/serial/airprime.c.

followed later by:

commit 95da310e66ee8090119596c70ca8432e57f9a97f "usb_serial: API all
change" which seems to have completely resurrected the same file (but
none of the other bit removed by the above commit).

In linux-next I had resolved that conflict by removing the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jul_2008_10_20_32_+1000_5ssKUsiPZdupPPZX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiGeVAACgkQjjKRsyhoI8yuFgCaAiSgt2iMSRa9asDz7ObUvhHS
2hoAn1w1e8pmoGBZ/SYj+9sGWIYiamFb
=GDgm
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jul_2008_10_20_32_+1000_5ssKUsiPZdupPPZX--
