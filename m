Return-Path: <linux-kernel-owner+w=401wt.eu-S1751475AbZHXEkx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbZHXEkx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 00:40:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751436AbZHXEkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 00:40:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44575 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751375AbZHXEkw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 00:40:52 -0400
Date: Mon, 24 Aug 2009 14:40:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anuj Aggarwal <anuj.aggarwal@ti.com>
Subject: linux-next: voltage tree build failure
Message-Id: <20090824144044.fad8639f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_14_40_44_+1000_8_zPKV8vG04_o8UV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_14_40_44_+1000_8_zPKV8vG04_o8UV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Liam,

Today's linux-next build (x86_64 allmodconfig) failed like this:

drivers/regulator/tps65023-regulator: struct i2c_device_id is 32 bytes.  Th=
e last of 1 is:
0x74 0x70 0x73 0x36 0x35 0x30 0x32 0x33 0x00 0x00 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 0x00 =
0x00 0x00=20
FATAL: drivers/regulator/tps65023-regulator: struct i2c_device_id is not te=
rminated with a NULL entry!

Caused by commit 9cfd343f14bf4bd95f8bfc6a1d411d2002bf94d8 ("Regulator:
Add TPS65023 regulator driver").

I have used the version of the voltage tree from next-20090821 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_14_40_44_+1000_8_zPKV8vG04_o8UV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqSGcwACgkQjjKRsyhoI8zomACeO0YHmRlUkAGj/MAbAhFtImGa
VFsAn06y4cb7+156n6PhBAGVQkIjgJTV
=SvLQ
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_14_40_44_+1000_8_zPKV8vG04_o8UV--
