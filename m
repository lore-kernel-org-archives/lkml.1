Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbXKTOxl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbXKTOxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 09:53:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759101AbXKTOxW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 09:53:22 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:57567 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758961AbXKTOxV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 09:53:21 -0500
Date: Tue, 20 Nov 2007 15:53:03 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Mikael =?UTF-8?B?U3TDpWxkYWw=?= 
	<mikael.staldal-ingen-reklam@univits.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
 limit
Message-ID: <20071120155303.76f234ec@astralstorm.puszkin.org>
In-Reply-To: <4742B3A3.2050103@univits.com>
References: <4742B3A3.2050103@univits.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/E0/R==wuB.TGhqzWimeEhxA";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/E0/R==wuB.TGhqzWimeEhxA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2007 11:14:59 +0100
Mikael St=C3=A5ldal  <mikael.staldal-ingen-reklam@univits.com> wrote:

> In Linux you have to be root in order to listen to TCP or UDP ports below=
 1024 (the=20
> well-known ports). As far as I know, this limit is hardcoded in the kerne=
l.
>=20
> In some cases, this limit do more harm than good, so it would be nice to =
be able to adjust it.

The proper way to enable port <=3D 1024 binding support is adding CAP_NET_B=
IND_SERVICE to the process capability set, e.g. by using file-system capabi=
lities.

--Sig_/E0/R==wuB.TGhqzWimeEhxA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFHQvTcBlhXA0ALOYMRAmX5AJ9OFhYGm/T56Ede5UTtf35MQrlZvACcCFdA
lm5ZDCeiKekWZQZgBfaz/ao=
=RgpL
-----END PGP SIGNATURE-----

--Sig_/E0/R==wuB.TGhqzWimeEhxA--
