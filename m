Return-Path: <linux-kernel-owner+w=401wt.eu-S1762350AbXKTTXY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762350AbXKTTXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 14:23:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757211AbXKTTXR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 14:23:17 -0500
Received: from chello089077114002.chello.pl ([89.77.114.2]:56224 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757171AbXKTTXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 14:23:16 -0500
Date: Tue, 20 Nov 2007 20:23:06 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Mikael =?UTF-8?B?U3TDpWxkYWw=?= <mikael.staldal@univits.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Possibility to adjust the only-root-can-bind-to-port-under-1024
 limit
Message-ID: <20071120202306.65e6036c@astralstorm.puszkin.org>
In-Reply-To: <474306BF.4010207@univits.com>
References: <4742B3A3.2050103@univits.com>
	<20071120155303.76f234ec@astralstorm.puszkin.org>
	<474306BF.4010207@univits.com>
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/jqbiGe6.9GJWz=v8mB7jxDy";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/jqbiGe6.9GJWz=v8mB7jxDy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Nov 2007 17:09:35 +0100
Mikael St=C3=A5ldal <mikael.staldal@univits.com> wrote:

> Hello.
>=20
> > The proper way to enable port <=3D 1024 binding support is adding CAP_N=
ET_BIND_SERVICE=20
>  > to the process capability set, e.g. by using file-system capabilities.
>=20
> Is file-system capabilites part of the stable official Linux kernel? From=
 which version?
> How do I use it?
>=20

They were recently added in 2.6.24-rc1.
(mostly commit b53767719b6cd8789392ea3e7e2eb7b8906898f0)
The patch should be easy to backport, I've seen it in various
distro kernels.

According to the commit, documentation is at
http://www.friedhoff.org/fscaps.html

Some programs already have capability support - they
drop all permissions they don't need.

--Sig_/jqbiGe6.9GJWz=v8mB7jxDy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)

iD8DBQFHQzQgBlhXA0ALOYMRAjAYAJ4s7rI+ESD8zMq1DILy+LiH2B920ACfUX0T
rAVi4dMlNM2mJmtAtnwNMeA=
=sWnj
-----END PGP SIGNATURE-----

--Sig_/jqbiGe6.9GJWz=v8mB7jxDy--
