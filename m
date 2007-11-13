Return-Path: <linux-kernel-owner+w=401wt.eu-S1754088AbXKMKj6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbXKMKj6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2007 05:39:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752544AbXKMKjv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Nov 2007 05:39:51 -0500
Received: from mail.gmx.net ([213.165.64.20]:41825 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752144AbXKMKju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2007 05:39:50 -0500
X-Authenticated: #1486292
X-Provags-ID: V01U2FsdGVkX18K3RxOYxoKOR/ozO0ZDp5vqO/cpqqI/dCynwT4iK
	6dJVqQTTx+HtuH
From: Tobias Powalowski <t.powa@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: REGRESSION: 2.6.24 breaks nvidia and amd/ati binary drivers, by exporting paravirt symbols as GPL
User-Agent: KMail/1.9.7
X-Face: $w]%DlUw(l;s7tdQ]'$HF9\L:G+ptn_r?!P\s{Z[*\<VkMhuC*oB<S4`x;u9t7nqpK'>=?utf-8?q?=26E=0A=09-uuk=7D=244TSMiOYm*Qx=7ED=3F+d=7EiZPp=25GWtsC6e=24=23?=>is1`)k>8)|2Cidi(cs5[tr3H-IV"=?utf-8?q?fWf=60=0A=09=5Bp=25O-=5D?=,n56e.a[~I97y1_G)1:?#&HfRp^fDS"e2`,vow}aP'v\O]X1)\VE>-M<=?utf-8?q?=259N!xM0=5F=0A=09A=602=23=5CV?=)t6?7AhTDYNtL(E!D"UkM0["jh#g/^
MIME-Version: 1.0
Date: Tue, 13 Nov 2007 11:39:38 +0100
Content-Type: multipart/signed;
  boundary="nextPart54324035.VJxNjgPBbM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711131139.42791.t.powa@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart54324035.VJxNjgPBbM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi
commit to .24 tree:
http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git;a=3Dcomm=
it;h=3D93b1eab3d29e7ea32ee583de3362da84db06ded8

introduces:
+EXPORT_SYMBOL_GPL(pv_mmu_ops);
+EXPORT_SYMBOL_GPL(pv_cpu_ops);

pv_cpu_ops is for nvidia
pv_mmu_ops' is for amd(ati)

which will break 32bit systems with paravirt enabled and trying to compile
the binary graphic drivers from amd(ati) and nvidia.


is there a chance to see these symbols not exported as GPL?
Or do they have to change their binary drivers?

thanks in advance
greetings
tpowa
=2D-=20
Tobias Powalowski
Archlinux Developer & Package Maintainer (tpowa)
http://www.archlinux.org
tpowa@archlinux.org

--nextPart54324035.VJxNjgPBbM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHOX7q81yYyRqLOvgRArHqAJ4w+pW0fJGEA3JTFrLnOCRsX/LdjQCeOYSH
L57t8Le0qFR4OJQ3XfP7Mz8=
=jbU0
-----END PGP SIGNATURE-----

--nextPart54324035.VJxNjgPBbM--
