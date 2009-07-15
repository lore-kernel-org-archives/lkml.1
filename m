Return-Path: <linux-kernel-owner+w=401wt.eu-S1750986AbZGOBpT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbZGOBpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 21:45:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbZGOBpS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 21:45:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36790 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750763AbZGOBpR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 21:45:17 -0400
Date: Wed, 15 Jul 2009 11:45:10 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>,
       Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: linux-next: pci tree build failure
Message-Id: <20090715114510.ebba4bd0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jul_2009_11_45_10_+1000_0opqhqOzP4ZeePHF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jul_2009_11_45_10_+1000_0opqhqOzP4ZeePHF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/pci/common.c:619: error: expected '}' before ';' token

Caused by commit 1c6804b093f5753c2a23aa36f31f66966035bd32 ("x86/PCI:
initialize PCI bus node numbers early").  This could not have been built
with CONFIG_NUMA set ...

I have used the version of the pci tree from next-20090714 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jul_2009_11_45_10_+1000_0opqhqOzP4ZeePHF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEUEARECAAYFAkpdNKYACgkQjjKRsyhoI8xhdQCdEo1Xc3pwjj6KjmY2ZjrViFSH
cJgAmI03dlF+T4+isxt6KiD19eR9woc=
=8tkg
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jul_2009_11_45_10_+1000_0opqhqOzP4ZeePHF--
