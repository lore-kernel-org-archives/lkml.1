Return-Path: <linux-kernel-owner+w=401wt.eu-S1756609AbZASSnq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609AbZASSnq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2009 13:43:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752556AbZASSnd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Jan 2009 13:43:33 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:41503 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752253AbZASSnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2009 13:43:32 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Subject: Re: [2.6.29-rc2 regression] e100: netconsole not functional because of missing firmware
Date: Mon, 19 Jan 2009 21:43:00 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: e1000-devel@lists.soutceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <200901171908.28533.arvidjaar@mail.ru> <4807377b0901191030g27efac79rbd39501eb2eea4cb@mail.gmail.com>
In-Reply-To: <4807377b0901191030g27efac79rbd39501eb2eea4cb@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2377820.Mrk3YsPs4E";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901192143.02853.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2377820.Mrk3YsPs4E
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On 19 =D1=8F=D0=BD=D0=B2=D0=B0=D1=80=D1=8F 2009 21:30:01 Jesse Brandeburg w=
rote:
> On Sat, Jan 17, 2009 at 8:08 AM, Andrey Borzenkov <arvidjaar@mail.ru>=20
wrote:
> > [    2.008509] e100: eth0: e100_request_firmware: Failed to load
> > firmware "e100/d101m_ucode.bin": -22
> > [    2.010461] netconsole: failed to open eth0
> > [    2.010996] netconsole: cleaning up
> >
> > This has been working all the time without requiring any external
> > firmware to be present. Why it suddenly refuses to work now?
>
> to use netconsole you probably need to set config option
> CONFIG_FIRMWARE_IN_KERNEL=3Dy
>

Yes, I already figured that much :) Unfortunately, there seems to be a=20
bug that prevents compiling firmware if src !=3D obj. At least it does not=
=20
work for me.

> Hm, I wonder if we couldn't have netconsole=3Dy select
> CONFIG_FIRMWARE_IN_KERNEL in Kconfig
>

That probably is overkill; unfortunately I am afraid there is no way to=20
make kconfig automatically select correct firmware in case e100 is built=20
in. =20

Thank you!

--nextPart2377820.Mrk3YsPs4E
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl0ybYACgkQR6LMutpd94wfvgCbBNZlgCDYBpBLAawXQ2eCSsrR
DtsAoKslTI/pnkPKRj/djHLbiYEJCojY
=6fdT
-----END PGP SIGNATURE-----

--nextPart2377820.Mrk3YsPs4E--
