Return-Path: <linux-kernel-owner+w=401wt.eu-S1758720AbZKYLfJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758720AbZKYLfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 06:35:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758700AbZKYLfI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 06:35:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51106 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758681AbZKYLfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 06:35:08 -0500
Date: Wed, 25 Nov 2009 22:35:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: linux-next: usb tree build warning
Message-Id: <20091125223508.c0924e2d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_22_35_08_+1100_PQCrLoFNtk0SG.cn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_22_35_08_+1100_PQCrLoFNtk0SG.cn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/usb/gadget/multi.c:30:1: warning: "CONFIG_USB_ETH_RNDIS" redefined
In file included from <command-line>:0:
./include/generated/autoconf.h:185:1: warning: this is the location of the =
previous definition

Introduced by commit a8e2db2fc35a9c4599181730ef5772376232e881 ("USB: g_mult=
i: Multifunction Composite Gadget added").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Nov_2009_22_35_08_+1100_PQCrLoFNtk0SG.cn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNFmwACgkQjjKRsyhoI8wQjgCbBFVD+MynrRghLqCfMK1TFq38
HzsAn0A+tKe1AaCzCNehK0xmam1PY7hS
=Np71
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_22_35_08_+1100_PQCrLoFNtk0SG.cn--
