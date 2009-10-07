Return-Path: <linux-kernel-owner+w=401wt.eu-S933868AbZJGBjI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933868AbZJGBjI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 21:39:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932923AbZJGBjI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 21:39:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45636 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933067AbZJGBjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 21:39:07 -0400
Date: Wed, 7 Oct 2009 12:38:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>
Subject: linux-next: pci tree build failure
Message-Id: <20091007123821.043465c6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_Oct_2009_12_38_21_+1100_PZKP670RRusRXtA."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_Oct_2009_12_38_21_+1100_PZKP670RRusRXtA.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "pci_set_cacheline_size" [drivers/pcmcia/pcmcia_core.ko] undefined!

Caused by commit 018bc96e8e27bfcafec9357ff370bf51241a7ea7 ("pccard:
configure CLS on attach") which neglected to EXPORT_SYMBOL
pci_set_cacheline_size.

I have used the version of the pci tree from next-20091006 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_Oct_2009_12_38_21_+1100_PZKP670RRusRXtA.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrL8Q0ACgkQjjKRsyhoI8x81ACfSwL+80+AfzH5EA+Ka+DNXOT2
+rwAnRe7tXmfpu7GW7e29/kWAK8Xlr/H
=cmtg
-----END PGP SIGNATURE-----

--Signature=_Wed__7_Oct_2009_12_38_21_+1100_PZKP670RRusRXtA.--
