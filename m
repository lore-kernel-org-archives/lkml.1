Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbZHYOhb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbZHYOhb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Aug 2009 10:37:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755196AbZHYOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Aug 2009 10:37:30 -0400
Received: from smurf.noris.de ([192.109.102.42]:39216 "EHLO
	smurf.intern.smurf.noris.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755142AbZHYOhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Aug 2009 10:37:23 -0400
Subject: Re: [PATCH v2] scripts: add typdef removal tool
From: Matthias Urlichs <matthias@urlichs.de>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Nicolas Palix <npalix@diku.dk>, linux-kernel@vger.kernel.org,
       Yoann Padioleau <yoann.padioleau@gmail.com>,
       Julia Lawall <julia@diku.dk>, devel@driverdev.osuosl.org,
       Joe Perches <joe@perches.com>, Amerigo Wang <xiyou.wangcong@gmail.com>,
       akpm@linux-foundation.org
In-Reply-To: <4A918389.8050301@gmail.com>
References: <1250228384-19823-1-git-send-email-lrodriguez@atheros.com>
	 <20090817060203.GL5039@cr0.nay.redhat.com>
	 <1251033773.10339.1105.camel@kiste>  <4A918389.8050301@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-TT71uDqX7gznItjHXAc3"
Organization: {M:U} IT Design
Date: Tue, 25 Aug 2009 14:35:52 +0000
Message-Id: <1251210952.10339.1331.camel@kiste>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
X-Smurf-Spam-Score: -2.6 (--)
X-Smurf-Whitelist: +relay_from_hosts
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-TT71uDqX7gznItjHXAc3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2009-08-23 at 19:59 +0200, Jiri Slaby wrote:
> -type f excludes directories.

Yes, but -o binds more loosely.

$ mkdir bar
$ find . -type f -name foo -o -name bar
bar
$

I like to pay attention to correct idioms. There is no problem in this
case because there are no directories named *.h in the kernel tree =E2=80=
=94 but
people read code like that, and then apply it to situations where it
_does_ matter.

--=-TT71uDqX7gznItjHXAc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkqT9sQACgkQ8+hUANcKr/ltGwCfal0BXzUpOWyEuHhJ+GV+TTFz
HKQAoKeoClhQ8jKID0gkP+hKe8V9mG3t
=zgwB
-----END PGP SIGNATURE-----

--=-TT71uDqX7gznItjHXAc3--

