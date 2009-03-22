Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbZCVJUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbZCVJUy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 05:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752949AbZCVJUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 05:20:43 -0400
Received: from clegg.madduck.net ([193.242.105.96]:54026 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355AbZCVJUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 05:20:43 -0400
Date: Sun, 22 Mar 2009 10:20:25 +0100
From: martin f krafft <madduck@madduck.net>
To: roma1390 <roma1390@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: raid6 grow "hangs" on 2.6.27 with mounted FS
Message-ID: <20090322092025.GA4500@piper.oerlikon.madduck.net>
Mail-Followup-To: roma1390 <roma1390@gmail.com>,
	linux-kernel@vger.kernel.org
References: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yrj/dFKFPuw6o+aM"
Content-Disposition: inline
In-Reply-To: <b410963b0903211329v3c4d787ep2f7a0587bee77789@mail.gmail.com>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.26-1-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yrj/dFKFPuw6o+aM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach roma1390 <roma1390@gmail.com> [2009.03.21.2129 +0100]:
> # add block device and grow, wait for resync
> mdadm --add /dev/md2  /dev/loop5
> mdadm --grow /dev/md2 --raid-devices=3D5
> sleep 3
>=20
> # dmesg prints: VFS: busy inodes on changed media.
> # umount hangs ...
> umount /dev/md2

I suggest unmounting before growing?

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
infinite loop: see 'loop, infinite'.
loop, infinite: see 'infinite loop'.
=20
spamtraps: madduck.bogus@madduck.net

--yrj/dFKFPuw6o+aM
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknGAtQACgkQIgvIgzMMSnV4/ACgtbL2R54yNDQUpHMZgakd+550
pgoAnjjExhw1ChA/Wa/O7r13DXbMnPDu
=MJHK
-----END PGP SIGNATURE-----

--yrj/dFKFPuw6o+aM--
