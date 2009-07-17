Return-Path: <linux-kernel-owner+w=401wt.eu-S934245AbZGQIcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934245AbZGQIcW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 04:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934237AbZGQIcW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 04:32:22 -0400
Received: from mail.open.by ([193.232.92.17]:60429 "EHLO post.open.by"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934235AbZGQIcU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 04:32:20 -0400
X-SpamTest-Envelope-From: sergey.senozhatsky@mail.by
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 9069 [Jul 17 2009]
X-SpamTest-Info: {relay has no DNS name}
X-SpamTest-Method: none
X-SpamTest-Rate: 55
X-SpamTest-SPF: softfail
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Date: Fri, 17 Jul 2009 11:34:33 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@mail.by>
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: possible regression with pty.c commit
Message-ID: <20090717083432.GB3378@localdomain.by>
References: <20090711191556.GA3845@localdomain.by>
 <20090711232452.4dc7c1ba@lxorguk.ukuu.org.uk>
 <20090711235530.GA3231@localdomain.by>
 <20090713124834.5c3ecc5d@lxorguk.ukuu.org.uk>
 <20090714162837.GC3145@localdomain.by>
 <20090715110533.62daf05e@lxorguk.ukuu.org.uk>
 <20090715102733.GA3055@localdomain.by>
 <20090715113042.5dbb5822@lxorguk.ukuu.org.uk>
 <20090715170351.GB3139@localdomain.by>
 <a8e1da0907161751t4c9e40f6k8f1ab27dc7c17291@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="61jdw2sOBCFtR2d/"
Content-Disposition: inline
In-Reply-To: <a8e1da0907161751t4c9e40f6k8f1ab27dc7c17291@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--61jdw2sOBCFtR2d/
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (07/17/09 08:51), Dave Young wrote:
> > =A0d945cb9cce20ac7143c2de8d88b187f62db99bdc "pty: Rework the pty layer =
to use =A0the normal buffering logic"
> > =A0and REVERTED a6540f731d506d9e82444cf0020e716613d4c46c "ppp: Fix thro=
ttling bugs"
> >
> > seems to work.
>=20
> I have same result, the pppoe connection is unstable with the patch.
> Are there better solution for this issue?
>=20

Hello Dave.
The solution is in rc3-git2.
Linus has reverted "throttling" commits.

git log drivers/net/ppp_async.c
git log drivers/net/ppp_synctty.c
4a21b8cb3550f19f838f7c48345fbbf6a0e8536b
Revert "ppp: Fix throttling bugs"

Requested-by: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>


	Sergey
--61jdw2sOBCFtR2d/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iJwEAQECAAYFAkpgN5gACgkQfKHnntdSXjRg0wQAhef6hdvDaOXuQSsxFLH/l9H1
99NtAA8ewJ7Rx6/lNkzLu9n/A8qJtdoZxNP9xQDeBbeMXaH+NA5+FSo48mGbb/jp
ePjb3vIIOzRRqGWsKYFdn0m4JW5Bw/2IvVFbHBPfa9C+ZDBPodiyDHI9gZi8bF99
xc5uyDLAlCksK+WYu+s=
=BLJz
-----END PGP SIGNATURE-----

--61jdw2sOBCFtR2d/--
