Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbXIYKOS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbXIYKOS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 06:14:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751528AbXIYKOI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 06:14:08 -0400
Received: from pc175e.fzu.cz ([147.231.127.175]:42306 "EHLO postak-1.fzu.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbXIYKOH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 06:14:07 -0400
Message-ID: <46F8DF55.2030905@gentoo.org>
Date: Tue, 25 Sep 2007 12:13:41 +0200
From: =?UTF-8?B?SmFuIEt1bmRyw6F0?= <jkt@gentoo.org>
Organization: Gentoo
User-Agent: Thunderbird 2.0.0.6 (X11/20070812)
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: kswapd high CPU usage with no swap
References: <46F852B6.7030207@gentoo.org> <20070924223444.62f0622d@bree.surriel.com>
In-Reply-To: <20070924223444.62f0622d@bree.surriel.com>
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig7D9DD5916D1830FD264DDEE6"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig7D9DD5916D1830FD264DDEE6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Rik van Riel wrote:
> How much memory did you have in "cached" when you looked
> with top (and no swap enabled) ?

Hi Rik,
it was pretty low number (several thousands, or maybe tens of thousands).=


In the meanwhile, I've come across your patch [1] ("prevent kswapd from
freeing excessive amounts of lowmem") and applied it locally. I'll see
if it fixes my problem, but at a first glance, it seems that it might
actually slow other things down -- when I switch windows, konqueror's
screen redrawing seems to be pretty slow and I can see it progressing
from top to bottom...

[1] http://lkml.org/lkml/2007/9/5/289

Cheers,
-jkt

--=20
cd /local/pub && more beer > /dev/mouth


--------------enig7D9DD5916D1830FD264DDEE6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFG+N9bamXfqERyJRcRAgOdAJ9Yqmx80/ebQA3rsuJ56syEWBcp7wCfVLS5
TiP890hUwzhNyJzCM6Q++KE=
=XW4h
-----END PGP SIGNATURE-----

--------------enig7D9DD5916D1830FD264DDEE6--
