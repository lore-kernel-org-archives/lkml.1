Return-Path: <linux-kernel-owner+w=401wt.eu-S1755680AbZGFD06@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbZGFD06 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 23:26:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbZGFD0s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 23:26:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41311 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752139AbZGFD0s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 23:26:48 -0400
Date: Mon, 6 Jul 2009 13:26:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: ttydev tree build failure
Message-Id: <20090706132643.44128b93.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jul_2009_13_26_43_+1000_XZ24TpBTcabFOAji"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jul_2009_13_26_43_+1000_XZ24TpBTcabFOAji
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "pm_set_vt_switch" [drivers/video/geode/lxfb.ko] undefined!
ERROR: "pm_set_vt_switch" [drivers/video/geode/gxfb.ko] undefined!

Caused by commit 2da31885ce1c33ac1bed80857ad5c9de2b95a189
("vt-pm-extract") which renamed pm_set_vt_switch to pm_vt_set_switch.

I have used the version of the ttydev tree from next-20090703 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jul_2009_13_26_43_+1000_XZ24TpBTcabFOAji
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRbvMACgkQjjKRsyhoI8wjyACaA1PBgQX/gvFkmRnQt5lrJuS7
CPEAnjeB2AUGoGTtl8uxU6zHZvYp8OyE
=lqk4
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jul_2009_13_26_43_+1000_XZ24TpBTcabFOAji--
