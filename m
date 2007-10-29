Return-Path: <linux-kernel-owner+w=401wt.eu-S1757305AbXJ2Iaf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757305AbXJ2Iaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 04:30:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752149AbXJ2Ia1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 04:30:27 -0400
Received: from mail.gmx.net ([213.165.64.20]:59085 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752212AbXJ2Ia0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 04:30:26 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/rciovyuPrUsHIP116qMeEN7U8otb1TmlJeUa1w3
	inX6bdZwNKwWzU
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: cpu governor ondemand issue
Date: Mon, 29 Oct 2007 09:30:18 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, cpufreq@www.linux.org.uk
References: <200710211316.14955.toralf.foerster@gmx.de> <20071029000243.9101d363.akpm@linux-foundation.org>
In-Reply-To: <20071029000243.9101d363.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1556381.PV3mO3gBx5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200710290930.19449.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1556381.PV3mO3gBx5
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 29. Oktober 2007 schrieb Andrew Morton:
> On Sun, 21 Oct 2007 13:16:14 +0200 Toralf F=F6rster <toralf.foerster@gmx.=
de> wrote:
>=20
> > I use the following one liner for regression tests of the cpufreq gover=
nor and
> > friends:
> >=20
> > tfoerste@n22 ~ $ time factor 819734028463158891
> >=20
> > which usually needs 5.5 secs to complete at 1.7 GHz of my pentium M pro=
cessor.
> >=20
> > With the  current git sources (commit cfa76f0 at Sat Oct 20 20:19:15 20=
07 -0700)
> > instead this command needs 3 times longer if I run the "distributed.net=
 client"
> > as a background process with nice level 19 b/c the cpu frequency still =
stays
> > at 600 MHz.
> > After stopping dnetc the cpu frequency governor ondemand works as expec=
ted again.
> >=20
> > Tested at my ThinkPad T41 with stable Gentoo:
> >=20
> > tfoerste@n22 ~ $ grep -e ^CONFIG_ACPI -e ^CONFIG_CPU_FREQ_GOV_ ~/devel/=
linux-2.6/.config
> > CONFIG_ACPI=3Dy
> > CONFIG_ACPI_SLEEP=3Dy
> > CONFIG_ACPI_PROCFS=3Dy
> > CONFIG_ACPI_PROC_EVENT=3Dy
> > CONFIG_ACPI_AC=3Dm
> > CONFIG_ACPI_BATTERY=3Dm
> > CONFIG_ACPI_BUTTON=3Dm
> > CONFIG_ACPI_VIDEO=3Dm
> > CONFIG_ACPI_FAN=3Dm
> > CONFIG_ACPI_PROCESSOR=3Dm
> > CONFIG_ACPI_THERMAL=3Dm
> > CONFIG_ACPI_BLACKLIST_YEAR=3D0
> > CONFIG_ACPI_EC=3Dy
> > CONFIG_ACPI_POWER=3Dy
> > CONFIG_ACPI_SYSTEM=3Dy
> > CONFIG_CPU_FREQ_GOV_PERFORMANCE=3Dy
> > CONFIG_CPU_FREQ_GOV_POWERSAVE=3Dm
> > CONFIG_CPU_FREQ_GOV_ONDEMAND=3Dy
> >=20
>=20
> And 2.6.23 was OK?
>=20
> Is this problem still present in Linus's current tree?
>=20
> Thanks.
>=20
Hello,
with -rc1 the problem went away :-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart1556381.PV3mO3gBx5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJZobhyrlCH22naMRArIeAKC9qg+zT1LdfXIlepELPzGJlJyYTgCeLHAO
4Ake8WKp4nl1lo8pE82JBno=
=6oOK
-----END PGP SIGNATURE-----

--nextPart1556381.PV3mO3gBx5--
