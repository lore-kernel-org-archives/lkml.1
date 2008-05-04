Return-Path: <linux-kernel-owner+w=401wt.eu-S1755777AbYEDK5K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777AbYEDK5K (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2008 06:57:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754497AbYEDK44
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 May 2008 06:56:56 -0400
Received: from mail.gmx.net ([213.165.64.20]:48566 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754029AbYEDK4z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2008 06:56:55 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX18MtlxbTTEM1oekO2/Kf+ZDvD7g3QiJ9J/9gJrG2K
	i1Xi4PKZ+J/wII
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: build issue #479 for v2.6.26-rc1-6-gafa26be :redefinition of 'sysfs_update_group'
Date: Sun, 4 May 2008 12:56:48 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200805041053.43284.toralf.foerster@gmx.de> <20080504104127.GD17276@uranus.ravnborg.org>
In-Reply-To: <20080504104127.GD17276@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2162252.SMSbc9kJfJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200805041256.52514.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2162252.SMSbc9kJfJ
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Sunday 04 May 2008 12:41:27 Sam Ravnborg wrote :
> On Sun, May 04, 2008 at 10:53:40AM +0200, Toralf F=F6rster wrote:
> > include/linux/sysfs.h:195: error: previous definition of 'sysfs_update_=
group' was here
> > make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1
> > make: *** [prepare0] Error 2
> >=20
> > The build was made with :
> > $> make mrproper && make randconfig && make
>=20
> Why do you need the "make mrproper" in the first place?
>=20
> kbuild should build what is needed when the config changes.
>=20
> 	Sam
>=20

Hhm,

when I wrote the script one or two years ago for automated build tests I got
sometimes false positives w/o "make mrproper" - IIRC.
Maybe it's time to remove it to see whether kbuild works as expected  ?

:-)

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart2162252.SMSbc9kJfJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkgdlnQACgkQhyrlCH22naO3pACfRyM8brPfInhry7ZbSgJon7xv
lfwAnjLV9htkmcqcEunSw9zKHaAH+TTr
=ZRDr
-----END PGP SIGNATURE-----

--nextPart2162252.SMSbc9kJfJ--
