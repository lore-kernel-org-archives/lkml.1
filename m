Return-Path: <linux-kernel-owner+w=401wt.eu-S1757265AbYJHART@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757265AbYJHART (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 20:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754629AbYJHARK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 20:17:10 -0400
Received: from b01.ext.isohunt.com ([208.71.112.51]:32802 "EHLO
	mail.isohunt.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754260AbYJHARK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 20:17:10 -0400
X-Greylist: delayed 401 seconds by postgrey-1.27 at vger.kernel.org; Tue, 07 Oct 2008 20:17:09 EDT
Date: Tue, 7 Oct 2008 16:53:31 -0700
From: "Robin H. Johnson" <robbat2@gentoo.org>
To: linux-kernel@vger.kernel.org
Subject: kernel/acct.c and testing for accounting still running?
Message-ID: <20081007235331.GT9967@curie-int.orbis-terrarum.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JvUS8mwutKMHKosv"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JvUS8mwutKMHKosv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I ran into a bit of flapping with my init.d acct lately, and in tracing
why, I noticed that there seems to be absolutely no way that the kernel
exposes to show that it's running any accounting.

Could we expose acct_list in sysfs or procfs, as uid:0, gid:0, perms
0600?

--=20
Robin Hugh Johnson
Gentoo Linux Developer & Infra Guy
E-Mail     : robbat2@gentoo.org
GnuPG FP   : 11AC BA4F 4778 E3F6 E4ED  F38E B27B 944E 3488 4E85

--JvUS8mwutKMHKosv
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Robbat2 @ Orbis-Terrarum Networks - The text below is a digital signature. If it doesn't make any sense to you, ignore it.

iEYEARECAAYFAkjr9nsACgkQPpIsIjIzwizUOgCg59nzGdU1b5VHskbUhd8K/KG3
rDMAoJLf8teyb1RdkJJC6lyAHkUJOwBx
=p1r/
-----END PGP SIGNATURE-----

--JvUS8mwutKMHKosv--
