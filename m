Return-Path: <linux-kernel-owner+w=401wt.eu-S1753774AbZFQGbc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774AbZFQGbc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 02:31:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752640AbZFQGbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 02:31:24 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37356 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbZFQGbX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 02:31:23 -0400
Date: Wed, 17 Jun 2009 16:31:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>,
       Geert Uytterhoeven <geert@linux-m68k.org>
Subject: linux-next: net tree build failure
Message-Id: <20090617163112.e14e064d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Jun_2009_16_31_12_+1000_Ao7fQ6E.Qf3dSLw4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Jun_2009_16_31_12_+1000_Ao7fQ6E.Qf3dSLw4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (m68k defconfig) failed like this:

drivers/net/sonic.c: In function 'sonic_send_packet':
drivers/net/sonic.c:227: error: expected ';' before '}' token

Caused by commit 5b548140225c6bbbbd560551dd1048b2c0ce58be ("net: use
symbolic values for ndo_start_xmit() return codes") which lost a
semicolon in drivers/net/sonic.c.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Jun_2009_16_31_12_+1000_Ao7fQ6E.Qf3dSLw4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko4jbAACgkQjjKRsyhoI8zDlQCgha84GeYsuURS0fqN7Ykj/rFm
KtUAn0eM9TUWWnrGXwJioPH7ALEfT/EX
=+4rG
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Jun_2009_16_31_12_+1000_Ao7fQ6E.Qf3dSLw4--
