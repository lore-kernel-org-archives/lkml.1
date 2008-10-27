Return-Path: <linux-kernel-owner+w=401wt.eu-S1752185AbYJ0TRV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbYJ0TRV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2008 15:17:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752083AbYJ0TRM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Oct 2008 15:17:12 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60061 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbYJ0TRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2008 15:17:11 -0400
Subject: Re: Suspend to RAM regression in 2.6.28-rc2 (bisected)
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Soeren Sonnenburg <kernel@nn7.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
       tomas.winkler@intel.com, "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org
In-Reply-To: <20081027191307.GI22217@kernel.dk>
References: <20081027162054.GA4015@localhost.aei.mpg.de>
	 <200810271832.40717.rjw@sisk.pl> <1225130844.4466.0.camel@localhost>
	 <1225132278.3796.32.camel@johannes.berg>
	 <1225133082.3796.35.camel@johannes.berg>
	 <20081027190011.GA3951@localhost.aei.mpg.de>
	 <20081027190631.GG22217@kernel.dk> <1225134571.3796.41.camel@johannes.berg>
	 <20081027191307.GI22217@kernel.dk>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-C/fJRfY0ZfhKpyzAoRwj"
Date: Mon, 27 Oct 2008 20:16:58 +0100
Message-Id: <1225135018.3796.49.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C/fJRfY0ZfhKpyzAoRwj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-27 at 20:13 +0100, Jens Axboe wrote:

> If you want something else tested, just let me know. I don't care a
> whole lot about how it gets fixed, as long as it does :-). I use STR
> heavily, so it's quite a burden to have it broken.

I don't really know. Like I said to Carlos, figuring out which of the
functions called from set_disassoc hangs would be useful, but you'd
probably want to coordinate with him so you don't both do it. Or if you
both do, it'd confirm it twice ;)

johannes

--=-C/fJRfY0ZfhKpyzAoRwj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJBhOmAAoJEKVg1VMiehFYRrIP/0Noz/ekFExzkBXk1pxnMS6Q
tsUWD91pWxBPKJQIJNz9OHlVxrwGQQpAULDV0rT7pDYPdlq2Y5/SKLr3y2axGNC1
00o9XlTqb5OITngYZObbgHp+DOqEJiiNWoFzmih87FgApk3H9hjM7sg99cKIxWEB
X/xmmW0D6YqYZaSZUxnygb2KCciV6CZEipSMYaDWVgWRg5Z07jv0A4jHhCeQ+tDx
GZDAJFap/S6c9qhbQBJ3dpPW3w9/vYzSzk2zNSrn+nifiQwq0V9ZRE/cZdQFKWHZ
tYqedG78Nkw9I8gupnm4Kp3DbCOevcpMuf84/ebGt1xuhksPyF4OOq3oul1LSQLI
iHwkz7V+rpmgn/qff10M/zKWl8uaSOKWKC0IIXHwb8W8WuZGAKoBqYqF6I8Smuhm
c3WeDAxfZi9jqpSu+NXzH4zYF3CCWdQmaA8r6TDNuIWU6wvXETC2QueqUBz4MnRf
4QcIaXMaHlgikg+G+O7zsl+nsVSf4pI+26sSaEiZWNAymRjKgg7pNgIc5dw0Ue7F
Es/ZaqRAYzj6dPgzj1Eo+ItKXA4fWxGduBqptn4AbuVstDwSHXbYVgXbqlEQebF4
L19Sr+uN173jNdjpKa38g/EP/yPSvKmop1ifE/dj+8Nw+fn/2vTPnEVZrbSHQJUj
QKSuO1HvEbFsVXIpLEKx
=x8bT
-----END PGP SIGNATURE-----

--=-C/fJRfY0ZfhKpyzAoRwj--

