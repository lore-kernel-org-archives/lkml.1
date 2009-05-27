Return-Path: <linux-kernel-owner+w=401wt.eu-S1760591AbZE0HBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760591AbZE0HBd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 03:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760843AbZE0HBZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 03:01:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42913 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760581AbZE0HBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 03:01:24 -0400
Date: Wed, 27 May 2009 17:01:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Doug Thompson <dougthompson@xmission.com>
Subject: linux-next: edac-amd tree build warning
Message-Id: <20090527170119.c1d6b221.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__27_May_2009_17_01_19_+1000_kIoJ=6n7ckPqLAmO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__27_May_2009_17_01_19_+1000_kIoJ=6n7ckPqLAmO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Borislav,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/edac/amd64_edac.c: In function 'f10_get_base_addr_offset':
drivers/edac/amd64_edac.c:1466: warning: suggest parentheses around operand=
 of '!' or change '&' to '&&' or '!' to '~'

Introduced by commit c266e41c0ca15d5df65e42d07608fbfb51ff32e3
("amd64_edac: add F10h-and-later methods-p2").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__27_May_2009_17_01_19_+1000_kIoJ=6n7ckPqLAmO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoc5T8ACgkQjjKRsyhoI8zV4QCfXR40BfhxGPF02H66Gku1y8pX
3DoAoLiRYg+T7ypeZ8scNiDbqjFSftJh
=+sBt
-----END PGP SIGNATURE-----

--Signature=_Wed__27_May_2009_17_01_19_+1000_kIoJ=6n7ckPqLAmO--
