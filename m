Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757985Ab0BQXvC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 18:51:02 -0500
Received: from clegg.madduck.net ([193.242.105.96]:40874 "EHLO
	clegg.madduck.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab0BQXu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 18:50:59 -0500
Date: Thu, 18 Feb 2010 12:50:13 +1300
From: martin f krafft <madduck@madduck.net>
To: Neil Brown <neilb@suse.de>
Cc: david@lang.hm, Nick Bowler <nbowler@elliptictech.com>,
       Volker Armin Hemmann <volkerarmin@googlemail.com>,
       Kyle Moffett <kyle@moffetthome.net>,
       Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
       "Mr. James W. Laferriere" <babydr@baby-dragons.com>,
       Bill Davidsen <davidsen@tmr.com>, Michael Evans <mjevans1983@gmail.com>,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: (boot time consequences of) Linux mdadm superblock question.
Message-ID: <20100217235013.GB2628@lapse.rw.madduck.net>
Mail-Followup-To: Neil Brown <neilb@suse.de>, david@lang.hm,
	Nick Bowler <nbowler@elliptictech.com>,
	Volker Armin Hemmann <volkerarmin@googlemail.com>,
	Kyle Moffett <kyle@moffetthome.net>,
	Rudy Zijlstra <rudy@grumpydevil.homelinux.org>,
	"Mr. James W. Laferriere" <babydr@baby-dragons.com>,
	Bill Davidsen <davidsen@tmr.com>,
	Michael Evans <mjevans1983@gmail.com>, linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org
References: <201002140251.59668.volkerarmin@googlemail.com>
 <alpine.DEB.2.00.1002170932010.4721@asgard.lang.hm>
 <20100217181016.GA14983@emergent.ellipticsemi.com>
 <201002171927.07051.volkerarmin@googlemail.com>
 <20100217183703.GA15446@emergent.ellipticsemi.com>
 <alpine.DEB.2.00.1002171040350.4721@asgard.lang.hm>
 <20100218102407.49f73d67@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-ripemd160;
	protocol="application/pgp-signature"; boundary="JYK4vJDZwFMowpUq"
Content-Disposition: inline
In-Reply-To: <20100218102407.49f73d67@notabene.brown>
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux squeeze/sid kernel 2.6.32-1-686 i686
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JYK4vJDZwFMowpUq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

also sprach Neil Brown <neilb@suse.de> [2010.02.18.1224 +1300]:
> Using user-space autodetection, you can plug "mdadm -I" into udev,
> and have arrays assembled as they are found, and filesystems
> mounted as arrays are assembled, and then you just have to wait
> for the root filesystem to appear, not for "all devices".

The mdadm experimental package offers this via debconf (default off
for now). I would appreciate testers =E2=80=94 I literally whacked this up
on a rainy Sunday with an hangover, and while it seems to work fine,
it's probably got warts.

If you don't run Debian or a derivative, you can get the files from
debian/initramfs/* in git://git.debian.org/pkg-mdadm/mdadm.git or

  http://git.debian.org/?p=3Dpkg-mdadm/mdadm.git;a=3Dtree;f=3Ddebian/initra=
mfs;hb=3DHEAD

don't be scared off by the complexity, incremental assembly actually
bypasses most of the (shell) code in both scripts.

> Yes, you could make the in-kernel autodetection smarter so it
> doesn't have to wait quite so long, but that would make it quite
> a bit more complex, and it is harder to maintain the complexity in
> the kernel.

It is definitely a user-space task, if you ask me.

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
windows 2000: designed for the internet.
the internet: designed for unix.
=20
spamtraps: madduck.bogus@madduck.net

--JYK4vJDZwFMowpUq
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEAREDAAYFAkt8gLQACgkQIgvIgzMMSnX31gCgy6xXKt/qdAtOcEfl5uFHQ2wH
KRQAmgJlYtZvetg1fvKAHVr3Vlhv5rOe
=g9Sp
-----END PGP SIGNATURE-----

--JYK4vJDZwFMowpUq--
