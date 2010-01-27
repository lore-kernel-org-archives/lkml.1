Return-Path: <linux-kernel-owner+w=401wt.eu-S1755852Ab0A0AJs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755852Ab0A0AJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jan 2010 19:09:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755845Ab0A0AJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Jan 2010 19:09:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41155 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754329Ab0A0AJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jan 2010 19:09:44 -0500
Date: Wed, 27 Jan 2010 11:09:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jerome Glisse <jglisse@redhat.com>
Subject: linux-next: origin tree build warning
Message-Id: <20100127110937.e606616d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_Jan_2010_11_09_37_+1100_GmD8HSpnBG8Zn0Gp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_Jan_2010_11_09_37_+1100_GmD8HSpnBG8Zn0Gp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/gpu/drm/radeon/radeon_agp.c: In function 'radeon_agp_init':
drivers/gpu/drm/radeon/radeon_agp.c:137: warning: format '%d' expects type =
'int', but argument 4 has type 'size_t'

Introduced by commit 0a3f316370da07fcdb11fde4f5a683d60713b7fd
("drm/radeon/kms: Disable AGP is aperture size < 32M").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_Jan_2010_11_09_37_+1100_GmD8HSpnBG8Zn0Gp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktfhEEACgkQjjKRsyhoI8yHdACfUzkzugOGYCXaEt2unlJ9gFop
gaIAn2xBchw2TMBurm/9lw9620nCGmU+
=DAHN
-----END PGP SIGNATURE-----

--Signature=_Wed__27_Jan_2010_11_09_37_+1100_GmD8HSpnBG8Zn0Gp--
