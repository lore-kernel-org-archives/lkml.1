Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0B1Fwx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Feb 2010 00:52:53 -0500
Received: from mail.gmx.net ([213.165.64.20]:34963 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751825Ab0B1Fww (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Feb 2010 00:52:52 -0500
X-Authenticated: #25574588
X-Provags-ID: V01U2FsdGVkX1/2vestuTH2tROPPZLz1pZk8FzG8YNDmhF8NCmtUo
	BUFuUTKvwVOIs9
Date: Sun, 28 Feb 2010 18:52:52 +1300
From: Johannes Buchner <buchner.johannes@gmx.at>
To: linux-kernel@vger.kernel.org
Subject: Ordering FS dir entries
Message-Id: <20100228185252.e4d4258c.buchner.johannes@gmx.at>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__28_Feb_2010_18_52_52_+1300_VdFPXBc4rwLRrGgp"
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__28_Feb_2010_18_52_52_+1300_VdFPXBc4rwLRrGgp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

Without knowing the implementation, according to my knowledge, the
entries of an unix directory are just a plain unsorted list, right?
Would it make sense to sort the whole / tree at some point by
alphabetic order or by lookup frequency to speed up lookups?

Just an idea, I have no idea if it's worth pursuing. Probably each FS
implementation has its own tree balancing method anyways.

Best regards,
Johannes

--Signature=_Sun__28_Feb_2010_18_52_52_+1300_VdFPXBc4rwLRrGgp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAkuKBLcACgkQ7X1+MfqVcr0tzgCfREzH5ta4hOtxphfI4TQr7+gH
udAAn09JT0ekFXOampUlOrbOFLafONEL
=Rmdx
-----END PGP SIGNATURE-----

--Signature=_Sun__28_Feb_2010_18_52_52_+1300_VdFPXBc4rwLRrGgp--
