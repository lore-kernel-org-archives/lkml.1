Return-Path: <linux-kernel-owner+w=401wt.eu-S1753982AbZJYTEW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982AbZJYTEW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 15:04:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753963AbZJYTEU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 15:04:20 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:57439 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753959AbZJYTES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 15:04:18 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: udev in kernel source?
Date: Sun, 25 Oct 2009 20:04:15 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-tp42-toi-3.0.1-04850-g4eddd0d; KDE/4.3.2; i686; ; )
References: <200910251834.06321.Martin@lichtvoll.de> <200910251930.36658.elendil@planet.nl> (sfid-20091025_193150_551994_B4237D8E)
In-Reply-To: <200910251930.36658.elendil@planet.nl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart27925075.GDqgsQhPcf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200910252004.21546.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart27925075.GDqgsQhPcf
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Sonntag 25 Oktober 2009 schrieb Frans Pop:
> Martin Steigerwald wrote:
> > Would that qualify as a reason to put it there and have make-kpkg /
> > make deb / make rpm spit out a udev package as well?
>=20
> How would that help?

That udev and kernel match each other. But you are right, rest of=20
userspace that uses udev might not necessarily match.

And there is another issue: AFAIK distributors handle at least parts of=20
the udev configuration including rules.

Well other solution would be to guarentee that SYSFS_DEPRECATED works=20
correctly in udev until it will be deprecated and remove in kernel source.=
=20
But then you suggest it the other way around:

> Sure, there will be cut-off points (one of which you seem to have hit
> here), but in general it's a lot easier to ensure a kernel is
>  compatible with your current version of udev than ensuring random
>  upstream versions of udev are compatible with your userland
>  (especially if you're running the stable version of a distro).

I am running a mixture of Debian testing/unstable/experimental.

martin@shambhala:~> apt-show-versions | grep udev
libgudev-1.0-0/squeeze uptodate 146-5
libudev0/squeeze uptodate 146-5
udev/squeeze uptodate 146-5

martin@shambhala:~> cat /proc/version
Linux version 2.6.31.5-tp42-toi-3.0.1-04850-g4eddd0d (martin@shambhala)=20
(gcc version 4.3.4 (Debian 4.3.4-5) ) #5 PREEMPT Sun Oct 25 18:39:35 CET=20
2009

Anyway, I disabled CONFIG_SYSFS_DEPRECATED now.

Maybe its more about the discoverability of such issue: I don't look into=20
the boot log / syslog every day. ;)

Hopefully upward incompatible changes in SysFS could be avoided in the=20
future.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart27925075.GDqgsQhPcf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrkoS8ACgkQmRvqrKWZhMfO/QCfTGwKLw2pqH/0gZYBFLLItg4M
9xUAn0YFJDMOJ0cei+KZzA2nb2RXtJkL
=yZi3
-----END PGP SIGNATURE-----

--nextPart27925075.GDqgsQhPcf--
