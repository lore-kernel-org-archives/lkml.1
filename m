Return-Path: <linux-kernel-owner+w=401wt.eu-S933154AbYBMTEz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbYBMTEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 14:04:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYBMTEr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 14:04:47 -0500
Received: from ip-58-28-152-52.static-xdsl.xnet.co.nz ([58.28.152.52]:36207
	"EHLO sol.unix.geek.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754325AbYBMTEq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 14:04:46 -0500
Subject: Re: 2.6.25-rc1 on Sun Ultra 40
From: Jasper Bryant-Greene <jasper@unix.geek.nz>
To: linux-kernel@vger.kernel.org
In-Reply-To: <1202901908.11100.8.camel@phobos.jasper.bg>
References: <1202901908.11100.8.camel@phobos.jasper.bg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RU3e8lYpM9BOsDKPs5j4"
Date: Thu, 14 Feb 2008 08:04:44 +1300
Message-Id: <1202929484.10687.1.camel@phobos.jasper.bg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RU3e8lYpM9BOsDKPs5j4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I can confirm neither the boot hang with HPET enabled nor the other
unexplained boot hang after "NET: Registered protocol family 2" occur on
2.6.24.2 on the same hardware. I still don't have an appropriate way to
debug the issue on 2.6.25-rc1, though...

-j


On Thu, 2008-02-14 at 00:25 +1300, Jasper Bryant-Greene wrote:
> I have been attempting to test 2.6.25-rc1 on my Sun Ultra 40 (two
> dual-core Opteron 2222 CPUs).
>=20
> There is some issue with the HPET clocksource which causes it to hang
> the boot process if enabled, which I will look into in due course (the
> HPET works fine on at least 2.6.19).
>=20
> More pressing is that the system will not boot at all even with HPET
> disabled - kernel gets no further than "NET: Registered protocol family
> 2".
>=20
> I cannot think of a way to find out what the problem is, because the
> system has only USB ports, and the USB keyboard is not working at this
> stage, either because the system has locked up hard, or because the USB
> support has not yet loaded (I tried both standard USB-HID and boot
> protocol keyboard support, both compiled in). Thus I cannot use
> magic-sysrq, or even scrollback to look at boot messages. There is also
> no serial port to assist with the latter...
>=20
> Any thoughts on a procedure for debugging this would be much
> appreciated.
>=20
> -j

--=-RU3e8lYpM9BOsDKPs5j4
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHsz9MJdSFNCc4WA0RAuTqAJ43B85fFrSgIP+fW+h85LJqXbNEeQCaAha4
2oCCMHh7MFfusc+eYdjfamE=
=Lar2
-----END PGP SIGNATURE-----

--=-RU3e8lYpM9BOsDKPs5j4--

