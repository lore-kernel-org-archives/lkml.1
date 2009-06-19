Return-Path: <linux-kernel-owner+w=401wt.eu-S1754078AbZFSAKc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbZFSAKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jun 2009 20:10:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751075AbZFSAKX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Jun 2009 20:10:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53453 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750910AbZFSAKW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jun 2009 20:10:22 -0400
Date: Fri, 19 Jun 2009 10:10:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: import of i2c series failed
Message-Id: <20090619101020.9b1f5054.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Jun_2009_10_10_20_+1000_K2I80XSOrqU4KLzd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Jun_2009_10_10_20_+1000_K2I80XSOrqU4KLzd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

I got this error import the i2c quilt series:

i2c-core-07-limit-locking.patch
error: patch failed: drivers/i2c/i2c-core.c:418
error: drivers/i2c/i2c-core.c: patch does not apply

I noticed that the BASE changed from 3.6.30-git11 yesterday to just
2.6.30 today, so I tried again against 2.6.30-git11 and it all applied.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Jun_2009_10_10_20_+1000_K2I80XSOrqU4KLzd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko612wACgkQjjKRsyhoI8w14QCeLYSwDGTQV9K4gyJ9UplnQIcA
87gAn3xBfdrW0ePXAyVYqSu0f8G9QAuv
=cM+0
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Jun_2009_10_10_20_+1000_K2I80XSOrqU4KLzd--
