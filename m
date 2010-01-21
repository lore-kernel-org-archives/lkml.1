Return-Path: <linux-kernel-owner+w=401wt.eu-S1753194Ab0AUD6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab0AUD6K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 22:58:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752143Ab0AUD6I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 22:58:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42261 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418Ab0AUD6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 22:58:06 -0500
Date: Thu, 21 Jan 2010 14:57:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>
Subject: linux-next: spi tree build failure
Message-Id: <20100121145757.f9d76da7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jan_2010_14_57_57_+1100_6RHufuf9dxMnQ=/A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jan_2010_14_57_57_+1100_6RHufuf9dxMnQ=/A
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "dw_spi_remove_host" [drivers/spi/dw_spi_pci.ko] undefined!

Caused by commit 51f921c1eb1124fb99ab0728c19e8e14c82c81be ("spi/dw_spi:
add a missed dw_spi_remove_host() in exit sequence").

I have used the spi tree from next-20100120 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Jan_2010_14_57_57_+1100_6RHufuf9dxMnQ=/A
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktX0MUACgkQjjKRsyhoI8z/ZACdGnmnTORybG6JzE71mma0LACv
ijUAn16U3jLC80P8024VofQNlze6pSWN
=JF3c
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jan_2010_14_57_57_+1100_6RHufuf9dxMnQ=/A--
