Return-Path: <linux-kernel-owner+w=401wt.eu-S935418AbXGMHok@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935418AbXGMHok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2007 03:44:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750870AbXGMHoc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Jul 2007 03:44:32 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:39633 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755817AbXGMHoc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2007 03:44:32 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: Tejun Heo <htejun@gmail.com>
Subject: Re: SATA exceptions
Date: Fri, 13 Jul 2007 10:44:11 +0300
User-Agent: KMail/1.9.7
Cc: Pavel Machek <pavel@ucw.cz>, Robert Hancock <hancockr@shaw.ca>,
       LKML <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>
References: <fa.hBFih6KVHDFsBf6Qfg6XispiIuY@ifi.uio.no> <20070712195255.GA6015@ucw.cz> <4696EDAB.10404@gmail.com>
In-Reply-To: <4696EDAB.10404@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1401051.kBylDPtYgq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707131044.20466.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1401051.kBylDPtYgq
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

13 Tem 2007 Cum tarihinde, Tejun Heo =C5=9Funlar=C4=B1 yazm=C4=B1=C5=9Ft=C4=
=B1:=20
> >> OS and driver can't really do much about the reallocation event.  Some
> >> number of reallocations is okay but if you it going up constantly, you
> >> probably have a dying disk.
> >
> > Hmm... cut the power while writing is doable from OS and might force
> > reallocations?
>
> Hmmm... We don't have any pending write when power goes out and I don't
> emergency unload can directly increase reallocation count.  It can
> shorten lifespan of the head tho.
>
> > You might want to check if number of reallocated sectors increases
> > with shutdowns/reboots.
>
> I'm curious too.

It seems reboot/shutdown has no effect on reallocated sectors. After 5 rebo=
t/5=20
shutdown it didn't change at all.

zangetsu ~ # smartctl -a /dev/sda | grep Reall
  5 Reallocated_Sector_Ct   0x0033   067   067   010    Pre-fail =20
Always       -       314
196 Reallocated_Event_Count 0x0032   067   067   000    Old_age  =20
Always       -       314

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1401051.kBylDPtYgq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGly1Uy7E6i0LKo6YRAguNAKCEL31lrW376LEZdjBzUEmEa3vhRQCgvH/v
qkiULk3rdjoV/gelZEbKt80=
=zZ9E
-----END PGP SIGNATURE-----

--nextPart1401051.kBylDPtYgq--
