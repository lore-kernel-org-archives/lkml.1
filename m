Return-Path: <linux-kernel-owner+w=401wt.eu-S1758003AbYA1J60@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758003AbYA1J60 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 04:58:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751622AbYA1J6S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 04:58:18 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59836 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751006AbYA1J6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 04:58:17 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] drop linux/ufs_fs.h from userspace export and relocate it to fs/ufs/ufs_fs.h
Date: Mon, 28 Jan 2008 04:58:15 -0500
User-Agent: KMail/1.9.7
Cc: LKML <linux-kernel@vger.kernel.org>
References: <200801260409.53276.vapier@gentoo.org> <200801280241.51654.vapier@gentoo.org> <20080128011845.641b2c89.akpm@linux-foundation.org>
In-Reply-To: <20080128011845.641b2c89.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4713200.2X6UGKA2Xa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801280458.16431.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4713200.2X6UGKA2Xa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Monday 28 January 2008, Andrew Morton wrote:
> On Mon, 28 Jan 2008 02:41:51 -0500 Mike Frysinger <vapier@gentoo.org> wro=
te:
> > blah, you're right.  combo patch here we come.
> > ---
> > Per previous discussions about cleaning up ufs_fs.h, people just want
> > this straight up dropped from userspace export.  The only remaining
> > consumer (silo) has been fixed a while ago to not rely on this header.=
=20
> > This allows use to move it completely from include/linux/ to fs/ufs/
> > seeing as how the only in-kernel consumer is fs/ufs/.
>
> I see you're not a big fan of scripts/checkpatch.pl.

i'm a big fan of doing what i need to do and getting the hell out ;)

in this case:
mv include/linux/ufs_fs.h fs/ufs/
git rm include/linux/ufs_fs.h
git add fs/ufs/ufs_fs.h

if the ufs_fs.h threw complaints from checkpatch.pl, it did so originally=20
before i touched it, and i leave it up to the maintainer and/or someone who=
=20
wants to look at it.
=2Dmike

--nextPart4713200.2X6UGKA2Xa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iQIVAwUAR52nOEFjO5/oN/WBAQIPTg//T5Rar5781f/tWH6dB9IXiTZw7eOmarzh
17xuJbTvHfI9a+Vdc6v9ZrgInwrL9hcbdcdRbvUhTw9NndQLlns2mlq2QJRw5AJp
Vw31uEFaiSoAeBLWIBxLAPKwXNrZz7CrhWXwU4KhQ5A+fFTvebizZ/rtjby0rAtP
+b3uFc9vNxFzJVkzDabdu04F5h3x1jjgi+Jg4wO2YAlXi+NoXHrSfeezC7mdE0zm
OybvwLs5fAJVCcO0z2HH5DmvBJ3/nUxT0QIItLK/dTS+Z948lcqdNCG6B3qNTk9P
LQ9Pfdwo2wLQGfBCr7bHLycnGshSNrqyi7aBPFSCNbMTSHH/pSXu45ajIaPAQGXQ
n8LFCm5Kv144ZZTVBkAH16ST9BgVHC2xbIBQaxn+Ra9muGqxBZaGpv7NGhiNOQp/
2ixubYDYTCh96AE+OVSNzuAOGW2Tuqv2bb57EChyGorKS+nHO74CQxWs2ZNf+QpF
ZzPB5oWj1Ak7/NFh9NTNUROYCZ+LkDQV9X0sK7h8AoEkBNCtR2q+ms4JgFcxs+dc
97F4MSig+GNOWM2RnoDU+FgZQqkgmaVcQNtpd1VyvG5CmMgUz0zNbc4/w8hWFWYV
lWYsm3leCjprZHQHthH2iPJwlkJ/Hbzh8zu6+LTlkOI2ke8GLEZ49/K+46UYs2Um
rLGGa7IXG3c=
=UzX7
-----END PGP SIGNATURE-----

--nextPart4713200.2X6UGKA2Xa--
