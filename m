Return-Path: <linux-kernel-owner+w=401wt.eu-S932505AbXG2PxN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932505AbXG2PxN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2007 11:53:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759502AbXG2Pw7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jul 2007 11:52:59 -0400
Received: from piware.de ([213.9.79.162]:54675 "EHLO box79162.elkhouse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761972AbXG2Pw6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2007 11:52:58 -0400
Date: Sun, 29 Jul 2007 17:53:00 +0200
From: Martin Pitt <martin.pitt@ubuntu.com>
To: Eugene Teo <eteo@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, jeremy@goop.org, martin.pitt@ubuntu.com,
       wwoods@redhat.com
Subject: Re: [PATCH 0/3] core_pattern: cleaned up repost/continuing post of
	core_pattern enhancements
Message-ID: <20070729155300.GC5794@piware.de>
References: <20070727200050.GA18946@hmsreliant.homelinux.net> <46AC6EAB.7000502@redhat.com> <20070729121444.GA9644@hmsreliant.homelinux.net> <46AC900E.9090405@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FkmkrVfFsRoUs1wW"
Content-Disposition: inline
In-Reply-To: <46AC900E.9090405@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FkmkrVfFsRoUs1wW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eugene,

Eugene Teo [2007-07-29 21:03 +0800]:
> >> Also, it is probably good to think how we can "drop privileges" while =
piping
> >> the core dump output to an external program. A malicious user can pote=
ntially
> >> use it as a possible backdoor since anything that is executed by "|pro=
gram" will
> >> be executed with root privileges.
> >>
> > It was my understanding that apport already did this.
>=20
> I haven't looked at apport yet, but are you talking about the userspace p=
ortion of
> apport or the kernel changes in the Ubuntu kernel?

Similarly to Neil's patches, the Ubuntu kernel calls the userspace
helper as root, too. Apport drops privileges to the target process as
soon as possible (there are a few things it needs to do before, like
opening an fd to the crash file in /var/crash/ if that is only
writeable by root).

Martin

--=20
Martin Pitt        http://www.piware.de
Ubuntu Developer   http://www.ubuntu.com
Debian Developer   http://www.debian.org

--FkmkrVfFsRoUs1wW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGrLfcDecnbV4Fd/IRAvD5AJ96KeQwaPSQpYOPCPDGw5/51M5pNgCfW3V4
KW5NCc/vtt6Ttd9igGBt+HE=
=bEtV
-----END PGP SIGNATURE-----

--FkmkrVfFsRoUs1wW--
