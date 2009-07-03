Return-Path: <linux-kernel-owner+w=401wt.eu-S1757720AbZGCOsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720AbZGCOsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jul 2009 10:48:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZGCOsh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Jul 2009 10:48:37 -0400
Received: from mx3.schottelius.org ([77.109.138.221]:35468 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753490AbZGCOsg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jul 2009 10:48:36 -0400
Date: Fri, 3 Jul 2009 16:46:42 +0200
From: Nico Schottelius <nico-linux-20090703@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: How to reliable rebuild different kernel versions with the same
	config?
Message-ID: <20090703144640.GA24922@ikn.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090703@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://www.nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.30-rc7 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

We encounter very strange delays here in a test application
on different kernels. To debug it a bit better, we would like to

- start the application, store results
- build the next older kernel
- install it
- boot it
- goto 1 (*)

The problem is, that after changing the version, make all or make oldconfig
prompt us to fillout some values, which is problematic, because we
want to run it automatically.

Is there a way to use a base config, that includes support for the
hardware (ibm x3550 m2) and all the other values are adopted from
default values?

make defconfig && cat myconfig >> .config does not do the trick :-)

Sincerly,

Nico

(*): This is so far already automated, have a look at
  http://git.schottelius.org/?p=3Dnsbin;a=3Dcommit;h=3D31461434cbda96bfb71c=
741c9510b1d92dcbb161

--=20
Currently moving *.schottelius.org to http://www.nico.schottelius.org/ ...

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpOGcsACgkQuL75KpiFGIw9/wCg2ZDx9ZOS3hJW/6RaF3rA2043
A6IAnREXlf8u/DP2BRSmh/L0x58YcJwM
=PdYR
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
