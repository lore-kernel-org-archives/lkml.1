Return-Path: <linux-kernel-owner+w=401wt.eu-S1755935AbZFLHFr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935AbZFLHFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 03:05:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757727AbZFLHFj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 03:05:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44146 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549AbZFLHFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 03:05:38 -0400
Date: Fri, 12 Jun 2009 17:05:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Tero Saarni <tero.saarni@gmail.com>
Subject: linux-next: input tree build warnings
Message-Id: <20090612170536.109df1d8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__12_Jun_2009_17_05_36_+1000_GrzHdYXBG3+fEV.0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Jun_2009_17_05_36_+1000_GrzHdYXBG3+fEV.0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

Today's linux-next build (x86_64 allmodconfig) produced these warnings:

drivers/input/evdev.c: In function 'evdev_do_ioctl':
drivers/input/evdev.c:632: warning: comparison of distinct pointer types la=
cks a cast
drivers/input/evdev.c:660: warning: comparison of distinct pointer types la=
cks a cast

Introduced by commit 61c7bfcdf5acee06f58b246d6615989134719d19 ("Input:
synaptics - add support for reporting x/y resolution").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__12_Jun_2009_17_05_36_+1000_GrzHdYXBG3+fEV.0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkox/kAACgkQjjKRsyhoI8xOzACcCJvugscpF3EqCfB1P1EM9+Dw
M0UAoLfWM5DBE/9TSDnvQJfhRKu3606T
=RFrJ
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Jun_2009_17_05_36_+1000_GrzHdYXBG3+fEV.0--
