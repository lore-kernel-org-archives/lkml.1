Return-Path: <linux-kernel-owner+w=401wt.eu-S1752557Ab0AYCNx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab0AYCNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jan 2010 21:13:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009Ab0AYCNw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jan 2010 21:13:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37299 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab0AYCNv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jan 2010 21:13:51 -0500
Date: Mon, 25 Jan 2010 13:13:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: pcmcia tree build failure
Message-Id: <20100125131343.9934da5f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Jan_2010_13_13_43_+1100_AWIerRkYbhIM3Rd3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jan_2010_13_13_43_+1100_AWIerRkYbhIM3Rd3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/built-in.o:(.toc1+0xd118): undefined reference to `pcmcia_dev_list_=
lock'

Caused by commit fc53c3482805cb3281dbeb0bd29dd892aaa53303 ("pcmcia:
simplify locking").

I have used the pcmcia tree from next-20100122 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jan_2010_13_13_43_+1100_AWIerRkYbhIM3Rd3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktc/lcACgkQjjKRsyhoI8zzGQCZAQTv94/evtKbp92FXE4dsFgg
qlcAoLBe3ep6OofXOHbbiISiz7/YCDin
=J/Hz
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jan_2010_13_13_43_+1100_AWIerRkYbhIM3Rd3--
