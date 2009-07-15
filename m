Return-Path: <linux-kernel-owner+w=401wt.eu-S1751733AbZGODOD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbZGODOD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 23:14:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750879AbZGODOC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 23:14:02 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58873 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbZGODOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 23:14:01 -0400
Date: Wed, 15 Jul 2009 13:13:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: sound tree build warning
Message-Id: <20090715131354.da512c72.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__15_Jul_2009_13_13_54_+1000_qkKNd_KA=040OxRv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__15_Jul_2009_13_13_54_+1000_qkKNd_KA=040OxRv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

sound/soc/codecs/wm8993.c: In function 'wm8993_hw_params':
sound/soc/codecs/wm8993.c:1799: warning: array subscript is above array bou=
nds

Introduced by commit 942c435ba79fd263a922bb114d56eccab6250662 ("ASoC: Add
WM8993 CODEC driver").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__15_Jul_2009_13_13_54_+1000_qkKNd_KA=040OxRv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpdSXMACgkQjjKRsyhoI8wkXwCfSBK3xP0o75j45HDFvoF8t8jL
3bkAnjT9uuc1+ovPElQzonAWd8xPjKEb
=+/hx
-----END PGP SIGNATURE-----

--Signature=_Wed__15_Jul_2009_13_13_54_+1000_qkKNd_KA=040OxRv--
