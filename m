Return-Path: <linux-kernel-owner+w=401wt.eu-S1756874AbZFJBxI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756874AbZFJBxI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 21:53:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754280AbZFJBxA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 21:53:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60480 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751797AbZFJBw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 21:52:59 -0400
Date: Wed, 10 Jun 2009 11:52:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: kbuild tree build warning
Message-Id: <20090610115255.035da856.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_11_52_55_+1000_HSWxJqSoQj9VQ7A_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_11_52_55_+1000_HSWxJqSoQj9VQ7A_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

In file included from arch/x86/kernel/vmlinux.lds.S:23:
include/asm-generic/vmlinux.lds.h:726:47: warning: backslash-newline at end=
 of file

Caused by commit ef53dae8658cf0e93d380983824a661067948d87 ("Improve
vmlinux.lds.h support for arch specific linker scripts").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_11_52_55_+1000_HSWxJqSoQj9VQ7A_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkovEfgACgkQjjKRsyhoI8wuIQCgtJ4A8kA5MMg5eRNzGRWnGliV
OR8An1bo8rL7z1inpoLTOnfD5TxO0rRk
=378b
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_11_52_55_+1000_HSWxJqSoQj9VQ7A_--
