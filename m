Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412AbZHJJlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412AbZHJJlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753316AbZHJJlQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:41:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39569 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753300AbZHJJlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:41:16 -0400
Date: Mon, 10 Aug 2009 19:41:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Luciano Coelho <luciano.coelho@nokia.com>
Subject: linux-next: wireless tree build warnings
Message-Id: <20090810194110.fa3eef11.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_19_41_10_+1000_/3ZZ0dso.HfeA1P."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_19_41_10_+1000_/3ZZ0dso.HfeA1P.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/net/wireless/wl12xx/wl1271_main.c: In function 'wl1271_irq_work':
drivers/net/wireless/wl12xx/wl1271_main.c:184: warning: large integer impli=
citly truncated to unsigned type
drivers/net/wireless/wl12xx/wl1271_boot.c: In function 'wl1271_boot_upload_=
firmware_chunk':
drivers/net/wireless/wl12xx/wl1271_boot.c:103: warning: format '%d' expects=
 type 'int', but argument 2 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_boot.c:150: warning: format '%d' expects=
 type 'int', but argument 2 has type 'size_t'
drivers/net/wireless/wl12xx/wl1271_boot.c: In function 'wl1271_boot_enable_=
interrupts':
drivers/net/wireless/wl12xx/wl1271_boot.c:278: warning: large integer impli=
citly truncated to unsigned type

Introduced by commit 4749c814b34dfe02cf08da34a2a2a32f55fbd9bc ("wl1271:
add wl1271 driver files").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_19_41_10_+1000_/3ZZ0dso.HfeA1P.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/6zYACgkQjjKRsyhoI8w4xwCfes0pVhZn2dgPFrgkWCv98uKr
ioYAoJRBhisUmhem1RkY+oGYcAbzxu22
=EZEM
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_19_41_10_+1000_/3ZZ0dso.HfeA1P.--
