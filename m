Return-Path: <linux-kernel-owner+w=401wt.eu-S1752022AbXE3Cky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022AbXE3Cky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2007 22:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750955AbXE3Ckr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 May 2007 22:40:47 -0400
Received: from mx33.mail.ru ([194.67.23.194]:21448 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750839AbXE3Ckq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2007 22:40:46 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 2.6.22-rc3: regression: make M=$PWD modules_install does nothing
Date: Wed, 30 May 2007 06:40:36 +0400
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <200705280634.37420.arvidjaar@mail.ru> <20070529204228.GA7738@uranus.ravnborg.org>
In-Reply-To: <20070529204228.GA7738@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2399418.YVD89Teszy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705300640.42775.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2399418.YVD89Teszy
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 30 May 2007, Sam Ravnborg wrote:
> Hi Andrey
>
> > This has been working up and including -rc2:
>
> I have tried to reproduce here - but it just works.
>
> I then took a second look at your excellent bug-report and noticed:
> > {pts/1}% sudo make -C ~/src/linux-git O=3D$HOME/build/linux-2.6.22 M=3D=
PWD
> > V=3D1
>
> that in this commandline you say M=3DPWD
>
> > modules_install
> > make: Entering directory `/home/bor/src/linux-git'
> > make -C /home/bor/build/linux-2.6.22 \
> >         KBUILD_SRC=3D/home/bor/src/linux-git \
> >         KBUILD_EXTMOD=3D"PWD" -f /home/bor/src/linux-git/Makefile
>
> which tell kbuild that module is in a directory named 'PWD' as seen in the
> assignment to KBUILD_EXTMOD in the above line.
>
> Could it be that you by accident omitted a '$' in front of PWD?
> This would then tell kbuild that module are in the directory pointed to by
> $PWD.
>

You are right, I am sorry for false alarm. One should not do these things l=
ate=20
night.

ashamed ...

=2Dandrey

--nextPart2399418.YVD89Teszy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGXOQlR6LMutpd94wRAoyEAJ9PcBH2NZfoxfjtH0C6HdTdXHaLNACgp3vK
zH5PPYErlaLLo/Z13F2zLdA=
=2uum
-----END PGP SIGNATURE-----

--nextPart2399418.YVD89Teszy--
