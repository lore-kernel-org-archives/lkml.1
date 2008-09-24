Return-Path: <linux-kernel-owner+w=401wt.eu-S1752656AbYIXHNq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbYIXHNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 03:13:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIXHNh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 03:13:37 -0400
Received: from postman.teamix.net ([194.150.191.120]:45831 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751151AbYIXHNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 03:13:35 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: util-linux-ng@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Support for CFS SCHED_IDLE priority in chrt
Date: Wed, 24 Sep 2008 09:13:11 +0200
User-Agent: KMail/1.9.9
References: <200809231435.54985.ms@teamix.de> <20080923213913.GP28147@nb.net.home>
In-Reply-To: <20080923213913.GP28147@nb.net.home>
Cc: Karel Zak <kzak@redhat.com>, Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1970213.zdeAuH8BSc";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809240913.27106.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1970213.zdeAuH8BSc
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 23. September 2008 schrieben Sie:
> On Tue, Sep 23, 2008 at 02:35:49PM +0200, Martin Steigerwald wrote:
> > ms@mango> autoconf      ~/lokal/Kernel/Dokumentation/util-linux-ng
> > configure.ac:7: error: possibly undefined macro: AM_INIT_AUTOMAKE
> >       If this token and others are legitimate, please use
> > m4_pattern_allow. See the Autoconf documentation.
> > configure.ac:37: error: possibly undefined macro: AM_CONDITIONAL
> > configure.ac:190: error: possibly undefined macro: AM_GNU_GETTEXT_VERSI=
ON
> > configure.ac:191: error: possibly undefined macro: AM_GNU_GETTEXT
> > ms@mango> ./configure      ~/lokal/Kernel/Dokumentation/util-linux-ng
> > configure: error: cannot find install-sh or install.sh in config
> > "."/config
> >
> > when trying to compile util-linux-ng from GIT. (Note: I have no glue
> > about autoconf, I only ever started an pre-existing ./configure script).
> > I tried with autoconf 2.61-8 from Debian Lenny.
>
>  ./autogen.sh

Thanks.

> > I will test this commit if someone gives me a hint on how to compile
> > util-linux-ng.
>
>  see README.devel

Ok, was a RTFM, sorry... I read INSTALL and didn't notice README.devel.

>  Applied with minor changes, thanks.

Do you know in which util-linux-ng version it will appear? Then I could sen=
d=20
Ingo another sched-design-CFS.txt update patch.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1970213.zdeAuH8BSc
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjZ6IcACgkQHhDFkwOZrpA7SwCePD4EBuconP5MklNzR5nD1xsd
dZUAnRd/wqVT2wggseb+d647bt2mIBGk
=0jcD
-----END PGP SIGNATURE-----

--nextPart1970213.zdeAuH8BSc--
