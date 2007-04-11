Return-Path: <linux-kernel-owner+w=401wt.eu-S1030413AbXDKEvS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030413AbXDKEvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2007 00:51:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030781AbXDKEvS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Apr 2007 00:51:18 -0400
Received: from 202-47-55-78.adsl.gil.com.au ([202.47.55.78]:41146 "EHLO
	longlandclan.hopto.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030413AbXDKEvR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2007 00:51:17 -0400
X-Greylist: delayed 402 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Apr 2007 00:51:13 EDT
Message-ID: <461C67D2.1050301@gentoo.org>
Date: Wed, 11 Apr 2007 14:45:06 +1000
From: Stuart Longland <redhatter@gentoo.org>
Organization: Gentoo Foundation
User-Agent: Thunderbird 1.5.0.10 (X11/20070310)
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-mips@linux-mips.org,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc6-mm1 build error with mips
References: <20070411004341.GB15262@Krystal>
In-Reply-To: <20070411004341.GB15262@Krystal>
X-Enigmail-Version: 0.94.0.0
OpenPGP: id=63264AB9;
	url=http://dev.gentoo.org/~redhatter/gpgkey.asc
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCE94A3094E41841476C4EB83"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCE94A3094E41841476C4EB83
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Mathieu Desnoyers wrote:
> Hi Andrew,
>=20
> I get the following error when compiling 2.6.21-rc6-mm1 for MIPS :
>=20
>=20
>   /opt/crosstool/gcc-3.4.5-glibc-2.3.6/mips-unknown-linux-gnu/bin/mips-=
unknown-linux-gnu-gcc -Wp,-MD,arch/mips/sgi-ip22/.ip22-time.o.d  -nostdin=
c -isystem /opt/crosstool/gcc-3.4.5-glibc-2.3.6/mips-unknown-linux-gnu/li=
b/gcc/mips-unknown-linux-gnu/3.4.5/include -D__KERNEL__ -Iinclude -Iinclu=
de2 -I/home/compudj/git/linux-2.6-lttng/include -include include/linux/au=
toconf.h -I/home/compudj/git/linux-2.6-lttng/arch/mips/sgi-ip22 -Iarch/mi=
ps/sgi-ip22 -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs -fno-strict-=
aliasing -fno-common -Os -mabi=3D32 -G 0 -mno-abicalls -fno-pic -pipe -ms=
oft-float -ffreestanding -march=3Dr5000 -Wa,--trap -I/home/compudj/git/li=
nux-2.6-lttng/include/asm-mips/mach-ip22 -Iinclude/asm-mips/mach-ip22 -I/=
home/compudj/git/linux-2.6-lttng/include/asm-mips/mach-generic -Iinclude/=
asm-mips/mach-generic -fomit-frame-pointer -Wdeclaration-after-statement =
 -D"KBUILD_STR(s)=3D#s" -D"KBUILD_BASENAME=3DKBUILD_STR(ip22_time)"  -D"K=
BUILD_MODNAME=3DKBUILD_STR(ip22_time)" -c -o arch/m
ips/sgi-ip22/ip22-time.o /home/compudj/git/linux-2.6-lttng/arch/mips/sgi-=
ip22/ip22-time.c
> In file included from include2/asm/time.h:21,
>                  from /home/compudj/git/linux-2.6-lttng/arch/mips/sgi-i=
p22/ip22-time.c:25:
> /home/compudj/git/linux-2.6-lttng/include/linux/ptrace.h:64:27: asm/tra=
cehook.h: No such file or directory

Last I checked... only sources from linux-mips.org's git repository
work.  Other source trees need to be specially patched to build for MIPS.=


Regards,
--=20
Stuart Longland (aka Redhatter)              .'''.
Gentoo Linux/MIPS Cobalt and Docs Developer  '.'` :
=2E . . . . . . . . . . . . . . . . . . . . .   .'.'
http://dev.gentoo.org/~redhatter             :.'

I haven't lost my mind...
  ...it's backed up on a tape somewhere.


--------------enigCE94A3094E41841476C4EB83
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5-ecc0.1.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGHGfSuarJ1mMmSrkRAqV3AJ9hpbmPAQicWUjAFf6P/z0eNsWFAgCeJYmi
wk9IghTdzfZO2TqCefrBPdo=
=QHfn
-----END PGP SIGNATURE-----

--------------enigCE94A3094E41841476C4EB83--
