Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163Ab0BAD7i (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 22:59:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54651 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0BAD7g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 22:59:36 -0500
Date: Mon, 1 Feb 2010 14:59:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Hamish Guthrie <hamish.guthrie@sonycom.com>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Subject: linux-next: wireless tree build warning
Message-Id: <20100201145923.0ab9787b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Feb_2010_14_59_23_+1100_JYaLbXiJ7oGX8giO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Feb_2010_14_59_23_+1100_JYaLbXiJ7oGX8giO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/net/ps3_gelic_wireless.c: In function 'gelic_wl_start_scan':
drivers/net/ps3_gelic_wireless.c:1452: warning: format '%d' expects type 'i=
nt', but argument 4 has type 'size_t'

Introduced by commit f276586a8af410d2b79733daf52471605b6559e9
("ps3_gelic_wireless: fix directed ssid scan").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Feb_2010_14_59_23_+1100_JYaLbXiJ7oGX8giO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktmUZsACgkQjjKRsyhoI8yRJgCfZZEWntRTcZKSX8BWefvzvtCc
rggAn2v4kZfM0Fyi45iPz0TfQ767z14Q
=+m4j
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Feb_2010_14_59_23_+1100_JYaLbXiJ7oGX8giO--
