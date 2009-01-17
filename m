Return-Path: <linux-kernel-owner+w=401wt.eu-S1765615AbZAQWRP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765615AbZAQWRP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 17:17:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758745AbZAQWQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 17:16:58 -0500
Received: from mail.gmx.net ([213.165.64.20]:54396 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757760AbZAQWQ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 17:16:57 -0500
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX18VB70g4tsVby8Ho7xNK98vT6BRoM4gKCf8KmfRzZ
	nYFqColq1KmoqX
Date: Sat, 17 Jan 2009 23:16:51 +0100
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
       stable@kernel.org
Subject: ext4-stable build failure (Re: Ext4 tree backports for 2.6.27.10
 and 2.6.28)
Message-ID: <20090117231651.78b2cce5@highlander.home.lan>
In-Reply-To: <E1LOG9D-0006h4-7R@closure.thunk.org>
References: <E1LOG9D-0006h4-7R@closure.thunk.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fbmCJe6QILaJEzIoBW9xfC1";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/fbmCJe6QILaJEzIoBW9xfC1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello,

On Sat, 17 Jan 2009 13:43:55 -0500
"Theodore Ts'o" <tytso@mit.edu> wrote:

>=20
> I've created a couple of ext4 backport branches which have been uploaded
> to the ext4 git tree:
>=20
>    git://git.kernel.org/pub/scm/linux/kernel/git/tytso/ext4.git=20
>    http://git.kernel.org/?p=3Dlinux/kernel/git/tytso/ext4.git
>=20

kernel 2.6.28 with ext4-stable fails to build for SMP on AMD64.

Building modules, stage 2.
MODPOST 905 modules
ERROR: "inode_lock" [fs/ext4/ext4.ko] undefined!

I had to revert 5cb8613e44b6e6c77dcf231d691b96c91a5adeab (ext4: Add a
delayed allocation debugging ioctl), after that it works.

Regards
Malte Schr=C3=B6der

--Sig_/fbmCJe6QILaJEzIoBW9xfC1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklyWNMACgkQ4q3E2oMjYtUxlACgzjK+7pVjiEI6Ju3zSHE8r1/t
kRcAn3JrdpLOvDBpQGtlq4XbcCGT01DI
=mfUA
-----END PGP SIGNATURE-----

--Sig_/fbmCJe6QILaJEzIoBW9xfC1--
