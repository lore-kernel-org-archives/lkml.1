Return-Path: <linux-kernel-owner+w=401wt.eu-S1757837AbXKASgw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757837AbXKASgw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2007 14:36:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753757AbXKASgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Nov 2007 14:36:44 -0400
Received: from mail.gmx.net ([213.165.64.20]:40793 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753632AbXKASgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2007 14:36:42 -0400
X-Authenticated: #1486292
X-Provags-ID: V01U2FsdGVkX1+5Yud/95W56rZpTXEx2quEL2z4F2WfzINoc3fA6J
	UWPcy5PPa9VZnF
From: Tobias Powalowski <t.powa@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 breaks nvidia and amd/ati binary drivers, by exporting paravirt symbols as GPL
Date: Thu, 1 Nov 2007 19:36:29 +0100
User-Agent: KMail/1.9.7
X-Face: $w]%DlUw(l;s7tdQ]'$HF9\L:G+ptn_r?!P\s{Z[*\<VkMhuC*oB<S4`x;u9t7nqpK'>&E
	-uuk}$4TSMiOYm*Qx~D?+d~iZPp%GWtsC6e$#>is1`)k>8)|2Cidi(cs5[tr3H-IV"fWf`
	[p%O-],n56e.a[~I97y1_G)1:?#&HfRp^fDS"e2`,vow}aP'v\O]X1)\VE>-M<%9N!xM0_
	A`2#\V)t6?7AhTDYNtL(E!D"UkM0["jh#g/^
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3447176.cIeY7ngGAf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200711011936.33296.t.powa@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3447176.cIeY7ngGAf
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

--nextPart3447176.cIeY7ngGAf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHKhyt81yYyRqLOvgRAimFAJsHOlytUhKyg9Wnv+4myjxy3UQWDwCeKcuK
AILKkyl/mNgbDl9u9UuVJxI=
=yFAm
-----END PGP SIGNATURE-----

--nextPart3447176.cIeY7ngGAf--
