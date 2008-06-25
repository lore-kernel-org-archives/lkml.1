Return-Path: <linux-kernel-owner+w=401wt.eu-S1756786AbYFYDbb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786AbYFYDbb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2008 23:31:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752216AbYFYDbV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Jun 2008 23:31:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54739 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbYFYDbU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2008 23:31:20 -0400
Date: Wed, 25 Jun 2008 13:31:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, kernel-testers@vger.kernel.org,
       v4l-dvb-maintainer@linuxtv.org, Andy Whitcroft <apw@shadowen.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [BUILD-FAILURE] linux-next: Tree for June 24 - missing files in
 drivers/media/dvb/
Message-Id: <20080625133107.4d680f34.sfr@canb.auug.org.au>
In-Reply-To: <486134B4.4050400@linux.vnet.ibm.com>
References: <20080624175612.cdf29651.sfr@canb.auug.org.au>
	<486134B4.4050400@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Jun_2008_13_31_07_+1000_zO13MBqHpkM6.c7."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jun_2008_13_31_07_+1000_zO13MBqHpkM6.c7.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Tue, 24 Jun 2008 23:23:56 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> allyesconfig kernel build on next-20080624, fails due to missing files
>=20
>   CHK     include/linux/compile.h
> make[4]: *** No rule to make target `drivers/media/dvb/dvb-usb/anysee.o',=
 needed by `drivers/media/dvb/dvb-usb/dvb-usb.o'.  Stop.
>=20
>   CC      drivers/media/dvb/frontends/cx22702.o
> make[4]: *** No rule to make target `drivers/media/dvb/frontends/drx397xD=
.o', needed by `drivers/media/dvb/frontends/built-in.o'.  Stop.

I am pretty sure that these were caused by me stuffing up the merging of
the v4l-dvb tree yesterday.  It should be OK today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Jun_2008_13_31_07_+1000_zO13MBqHpkM6.c7.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhhu/sACgkQTgG2atn1QN8FggCcC5T4JN1w8WnAdi741fPc1Cj8
ggkAnR42mCkPhpkIISa0BX9qF9Gv4YBa
=DM6b
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jun_2008_13_31_07_+1000_zO13MBqHpkM6.c7.--
