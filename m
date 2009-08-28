Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZH1AQx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZH1AQx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Aug 2009 20:16:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752212AbZH1AQw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Aug 2009 20:16:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55092 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748AbZH1AQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Aug 2009 20:16:52 -0400
Date: Fri, 28 Aug 2009 10:16:47 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: linux-next: v4l-dvb tree build warnings
Message-Id: <20090828101647.f453859a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__28_Aug_2009_10_16_47_+1000_L2SazQfeLP3aZJH1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__28_Aug_2009_10_16_47_+1000_L2SazQfeLP3aZJH1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/media/video/soc_camera.c: In function 'soc_camera_init_i2c':
drivers/media/video/soc_camera.c:859: warning: cast from pointer to integer=
 of different size
drivers/media/video/soc_camera_platform.c: In function 'soc_camera_platform=
_probe':
drivers/media/video/soc_camera_platform.c:140: warning: cast from pointer t=
o integer of different size

Introduced by commit 7d2d23b9101115774c2b6ce5891235a4ba38ed53 ("V4L/DVB
(12510): soc-camera: (partially) convert to v4l2-(sub)dev API").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__28_Aug_2009_10_16_47_+1000_L2SazQfeLP3aZJH1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqXIe8ACgkQjjKRsyhoI8y9tgCfY45si/eux9ddqHo/uklL6JBL
2K4AoJ6c9oi7eHW+vpOXemlbL4hHemAh
=rV5G
-----END PGP SIGNATURE-----

--Signature=_Fri__28_Aug_2009_10_16_47_+1000_L2SazQfeLP3aZJH1--
