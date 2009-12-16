Return-Path: <linux-kernel-owner+w=401wt.eu-S1759432AbZLPEKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759432AbZLPEKE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 23:10:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756363AbZLPEKA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 23:10:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54947 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755707AbZLPEJ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 23:09:59 -0500
Date: Wed, 16 Dec 2009 15:09:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: suspend tree build warning
Message-Id: <20091216150953.efd4f7f5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_15_09_53_+1100_Q2Hvo354Uv7DYgnf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_15_09_53_+1100_Q2Hvo354Uv7DYgnf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/base/power/main.c: In function 'dpm_show_time':
drivers/base/power/main.c:398: warning: format '%Lu' expects type 'long lon=
g unsigned int', but argument 5 has type 'long int'
drivers/base/power/main.c:398: warning: format '%03Lu' expects type 'long l=
ong unsigned int', but argument 6 has type 'long int'

Introduced by commit 1858acb45d95224d14f741ebd961788c80ba340a ("PM:
Measure device suspend and resume times").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_15_09_53_+1100_Q2Hvo354Uv7DYgnf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoXZEACgkQjjKRsyhoI8yIOgCfaX96wbEsmH1kIt2Hbn0DuYlQ
i74An2ZS3MsihLnEWf+nkLwadg30vRof
=iXpn
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_15_09_53_+1100_Q2Hvo354Uv7DYgnf--
