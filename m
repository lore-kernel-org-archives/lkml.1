Return-Path: <linux-kernel-owner+w=401wt.eu-S1753384AbZDHD2V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753384AbZDHD2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 23:28:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZDHD2L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 23:28:11 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45238 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646AbZDHD2K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 23:28:10 -0400
Date: Wed, 8 Apr 2009 13:28:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: linux-next@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090408132803.ba6f347a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Apr_2009_13_28_03_+1000_FbxT/PoWtspeIL0e"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Apr_2009_13_28_03_+1000_FbxT/PoWtspeIL0e
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Today's linux-next build (powerpc allyesconfig) failed like this:

arch/powerpc/include/asm/parport.h: In function 'parport_pc_find_nonpci_por=
ts':
arch/powerpc/include/asm/parport.h:32: error: too few arguments to function=
 'parport_pc_probe_port'

Caused by commit 51dcdfec6a274afc1c6fce180d582add9ff512c0 ("parport: Use
the PCI IRQ if offered").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Apr_2009_13_28_03_+1000_FbxT/PoWtspeIL0e
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkncGcMACgkQjjKRsyhoI8wQRwCeOJkbHWOk1QLTc6oOAbYQwRB8
rY0An1FW5NHE3RrHSA/eYGaXZpzgwkCS
=dayp
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Apr_2009_13_28_03_+1000_FbxT/PoWtspeIL0e--
