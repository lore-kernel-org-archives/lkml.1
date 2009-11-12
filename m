Return-Path: <linux-kernel-owner+w=401wt.eu-S1752407AbZKLIVO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbZKLIVO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Nov 2009 03:21:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZKLIVO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Nov 2009 03:21:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbZKLIVN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Nov 2009 03:21:13 -0500
Date: Thu, 12 Nov 2009 19:21:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: linux-next: rr tree build warning
Message-Id: <20091112192114.dcf32d16.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Nov_2009_19_21_14_+1100_cJWyQ+6=qBawfFOx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Nov_2009_19_21_14_+1100_cJWyQ+6=qBawfFOx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (i386 defconfig) produced this warning:

kernel/module.c:1953: warning: 'crc_section_names' defined but not used

Introduced by commit 67260d90118a2394df528fe4e37e814d950ca5b5 ("module:
refactor symbol tables and try to reduce code size of each_symbol()").
This build has CONFIG_MODVERSIONS disabled.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Nov_2009_19_21_14_+1100_cJWyQ+6=qBawfFOx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr7xXoACgkQjjKRsyhoI8ymqQCgp+5annnFeJ9gCEtcu5O5jBLI
lk0AnRW9Gr295P3OtXqEsWsWmXEloAov
=oFjH
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Nov_2009_19_21_14_+1100_cJWyQ+6=qBawfFOx--
