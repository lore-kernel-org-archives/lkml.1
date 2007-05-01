Return-Path: <linux-kernel-owner+w=401wt.eu-S1754256AbXEAAAz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256AbXEAAAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 20:00:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754250AbXEAAAy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 20:00:54 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:35600 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750985AbXEAAAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 20:00:07 -0400
From: Ismail =?iso-8859-1?q?D=F6nmez?= <ismail@pardus.org.tr>
Organization: TUBITAK/UEKAE
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: old buffer overflow in moxa driver
Date: Tue, 1 May 2007 03:01:29 +0300
User-Agent: KMail/1.9.6
Cc: dann frazier <dannf@hp.com>, linux-kernel@vger.kernel.org,
       Jiri Slaby <jirislaby@gmail.com>, support@moxa.com.tw,
       dilinger@debian.org
References: <20070430224829.GI31283@krebs.dannf> <20070501000455.2173b1e2@the-village.bc.nu>
In-Reply-To: <20070501000455.2173b1e2@the-village.bc.nu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2133767.ZXf0kH3kNX";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705010301.34571.ismail@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2133767.ZXf0kH3kNX
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 01 May 2007 02:04:55 Alan Cox wrote:
> >   I noticed that the moxa input checking security bug described by
> > CVE-2005-0504 appears to remain unfixed upstream.
> >
> > The issue is described here:
> >   http://cve.mitre.org/cgi-bin/cvename.cgi?name=3DCVE-2005-0504
> >
> > Debian has been shipping the following patch from Andres Salomon. I
> > tried contacting the listed maintainer a few months ago but received
> > no response.
>
>        case MOXA_LOAD_BIOS:
>         case MOXA_FIND_BOARD:
>         case MOXA_LOAD_C320B:
>         case MOXA_LOAD_CODE:
>                 if (!capable(CAP_SYS_RAWIO))
>                         return -EPERM;
>                 break;
>
> At the point you abuse these calls you can already just load arbitary
> data from userspace anyway.

So the possible exploit will only work when run by root, is that what you=20
mean? If so isn't that still a security problem?

Sorry if I misunderstood what you said.

Regards,
ismail


--nextPart2133767.ZXf0kH3kNX
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGNoNeGp0leluI9UwRAkaMAJ99PYoMcKDfV0nIEAc3h5+jTdLqhgCfYG5d
KoRhtqrJcmJDcFRKZJpebUA=
=k1Hc
-----END PGP SIGNATURE-----

--nextPart2133767.ZXf0kH3kNX--
