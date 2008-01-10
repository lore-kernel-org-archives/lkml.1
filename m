Return-Path: <linux-kernel-owner+w=401wt.eu-S1756100AbYAJKCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756100AbYAJKCa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2008 05:02:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752788AbYAJKCU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jan 2008 05:02:20 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:56291 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560AbYAJKCT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2008 05:02:19 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [JANITOR PROPOSAL] Switch ioctl functions to ->unlocked_ioctl
Date: Thu, 10 Jan 2008 11:02:11 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       paolo.ciarrocchi@gmail.com, gorcunov@gmail.com
References: <20080108164015.GC31504@one.firstfloor.org> <200801100952.55039.eike-kernel@sf-tec.de> <20080110092528.GA25076@one.firstfloor.org>
In-Reply-To: <20080110092528.GA25076@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1917247.SFkLrUkPMR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801101102.16971.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1917247.SFkLrUkPMR
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Andi Kleen wrote:
> > Can you explain the rationale behind that running on the BKL? What type
> > of
>
> It used to always run with the BKL because everything used to
> and originally nobody wanted to review all ioctl handlers in tree to see =
if
> they can run with more fine grained locking. A lot probably can though.
>
> > things needs to be protected so that this huge hammer is needed? What
> > would be an earlier point to release the BKL?
>
> That depends on the driver. A lot don't need BKL at all and
> in others it can be easily eliminated. But it needs case-by-case
> review of the locking situation.
>
> The goal of the proposal here is just to make it more visible.

So if I write my own driver and have never heard of ioctls running on BKL=20
before I can rather be sure that I just can change the interface of the ioc=
tl=20
function, put it in unlocked_ioctl and are fine? Cool.

Eike

--nextPart1917247.SFkLrUkPMR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)

iD8DBQBHhe0oXKSJPmm5/E4RAq3uAJsFlnx+08+XJY9BBJtHkg4VexHQ+ACeLPrG
U5WoilQvBD9/qfJ9EF+K0w0=
=e7EC
-----END PGP SIGNATURE-----

--nextPart1917247.SFkLrUkPMR--
