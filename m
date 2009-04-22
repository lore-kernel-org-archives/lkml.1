Return-Path: <linux-kernel-owner+w=401wt.eu-S1754825AbZDVTER@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754825AbZDVTER (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 15:04:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752311AbZDVTED
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 15:04:03 -0400
Received: from systemlinux.org ([83.151.29.59]:50441 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751749AbZDVTEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 15:04:01 -0400
Date: Wed, 22 Apr 2009 20:57:03 +0200
From: Andre Noll <maan@systemlinux.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Matti Aarnio <matti.aarnio@zmailer.org>,
       Jesper Juhl <jj@chaosbits.net>, Prakash Punnoor <prakash@punnoor.de>,
       Michael Tokarev <mjt@tls.msk.ru>, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org, neilb@suse.de
Subject: Re: Proposal: make RAID6 code optional
Message-ID: <20090422185703.GF13280@skl-net.de>
References: <200904180946.27722.prakash@punnoor.de> <49E98AD2.8060601@msgid.tls.msk.ru> <200904181117.03418.prakash@punnoor.de> <alpine.LNX.2.00.0904181551320.16493@swampdragon.chaosbits.net> <20090418145850.GD28512@mea-ext.zmailer.org> <49EDD11E.2030309@tmr.com> <49EE00F9.6090000@zytor.com> <20090422180051.GD13280@skl-net.de> <49EF6457.90505@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="OzxllxdKGCiKxUZM"
Content-Disposition: inline
In-Reply-To: <49EF6457.90505@zytor.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--OzxllxdKGCiKxUZM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 11:39, H. Peter Anvin wrote:
> Yes, I believe it would be easier than having dynamically allocated=20
> arrays.  Dynamically generated arrays using static memory allocations=20
> (bss) is one thing, but that would only reduce size of the module on=20
> disk, which I don't think anyone considers a problem.

We would save 64K of RAM in the raid5-only case if we'd defer the
allocation of the multiplication table until the first raid6 array
is about to be started.


Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--OzxllxdKGCiKxUZM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFJ72h/Wto1QDEAkw8RAr8pAJ4yz2/mn1Dv+c8mTYTOGvXtanDCLwCeJv4t
dPX7eZLkM40f+U7/HokpY/M=
=9it3
-----END PGP SIGNATURE-----

--OzxllxdKGCiKxUZM--
