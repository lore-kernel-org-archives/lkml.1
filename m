Return-Path: <linux-kernel-owner+w=401wt.eu-S1766628AbXEDUkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766628AbXEDUkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 16:40:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767201AbXEDUkN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 16:40:13 -0400
Received: from lug-owl.de ([195.71.106.12]:51009 "EHLO lug-owl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767019AbXEDUj6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 16:39:58 -0400
Date: Fri, 4 May 2007 22:39:56 +0200
From: Jan-Benedict Glaw <jbglaw@lug-owl.de>
To: Bernd Schubert <bs@q-leap.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: mkfs.ext2 triggerd RAM corruption
Message-ID: <20070504203956.GL25077@lug-owl.de>
Mail-Followup-To: Bernd Schubert <bs@q-leap.de>,
	linux-kernel@vger.kernel.org
References: <200705041659.51675.bs@q-leap.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="g/o8sqaH6XVFI89B"
Content-Disposition: inline
In-Reply-To: <200705041659.51675.bs@q-leap.de>
X-Operating-System: Linux mail 2.6.18-4-686 
X-gpg-fingerprint: 250D 3BCF 7127 0D8C A444  A961 1DBD 5E75 8399 E1BB
X-gpg-key: wwwkeys.de.pgp.net
X-Echelon-Enable: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
X-TKUeV: howto poison arsenous mail psychological biological nuclear warfare test the bombastical terror of flooding the spy listeners explosion sex drugs and rock'n'roll
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--g/o8sqaH6XVFI89B
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-04 16:59:51 +0200, Bernd Schubert <bs@q-leap.de> wrote:
> To see whats going on, I copied the entire / (so the initrd) into a tmpfs=
=20
> root, chrooted into it, also bind mounted the main / into this chroot and=
=20
> compared several times /bin of chroot/bin and the bind-mounted /bin while=
 the=20
> mkfs.ext2 command was running.
>=20
> beo-05:/# diff -r /bin /oldroot/bin/
> beo-05:/# diff -r /bin /oldroot/bin/
> beo-05:/# diff -r /bin /oldroot/bin/
> Binary files /bin/sleep and /oldroot/bin/sleep differ
> beo-05:/# diff -r /bin /oldroot/bin/
> Binary files /bin/bsd-csh and /oldroot/bin/bsd-csh differ
> Binary files /bin/cat and /oldroot/bin/cat differ
> ...
>=20
> Also tested different schedulers, at least happens with deadline and=20
> anticipatory.
>=20
> The corruption does NOT happen on running the mkfs command on /dev/sda1, =
but=20
> happens with sda2, sda3 and sda3. Also doesn't happen with extended=20
> partitions of sda1.

Is sda2 the largest filesystem out of sda2, sda3 (and the logical
partitions within the extended sda1, if these get mkfs'ed, too)?

I'm not too sure that this is a kernel bug, but probably a bad RAM
chip. Did you run memtest86 for a while? ...and can you reproduce this
problem on different machines?

MfG, JBG

--=20
      Jan-Benedict Glaw      jbglaw@lug-owl.de              +49-172-7608481
Signature of:                 Friends are relatives you make for yourself.
the second  :

--g/o8sqaH6XVFI89B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGO5ocHb1edYOZ4bsRAk6EAKCAXzq8o9M1WRGq0f7jO/0RQmWLbACdElk1
zEPBFbBN/qREMp06daKvbZE=
=yjQf
-----END PGP SIGNATURE-----

--g/o8sqaH6XVFI89B--
