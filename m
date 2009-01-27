Return-Path: <linux-kernel-owner+w=401wt.eu-S1756585AbZA0SHa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756585AbZA0SHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2009 13:07:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbZA0SHW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Jan 2009 13:07:22 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:46318 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232AbZA0SHV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2009 13:07:21 -0500
Subject: Re: [PATCH v2] timer: implement lockdep deadlock detection
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <20090127134128.GA24965@elte.hu>
References: <1233010786.4344.1.camel@johannes.local>
	 <20090126230721.GA6556@elte.hu> <1233046009.4012.3.camel@johannes.local>
	 <20090127132759.GI23121@elte.hu>  <20090127134128.GA24965@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7feMW6ARJe40uwoTEtbx"
Date: Tue, 27 Jan 2009 19:06:37 +0100
Message-Id: <1233079597.4755.2.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7feMW6ARJe40uwoTEtbx
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-01-27 at 14:41 +0100, Ingo Molnar wrote:
> -tip testing found this build failure with your patch:
>=20
>  arch/x86/kernel/hpet.c:631: error: too few arguments to function =E2=80=
=98init_timer_on_stack_key=E2=80=99

Odd, I'll look into this.

Meanwhile, I'd appreciate comments on
http://bugzilla.kernel.org/show_bug.cgi?id=3D12552

johannes

--=-7feMW6ARJe40uwoTEtbx
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJf00qAAoJEKVg1VMiehFY21sP+gMgWrmV9Ysy6C1BdJ8e5NhF
trpkckwrG40gyKyEGN4XJWz4VOolmkiXYNqogKfDMxb8nvhTIKDfVAEOu76LIfet
AI1rwjSAZKv/8qT11N3bbv+ZmeqNXdwE14+LXg58CqdkR4v2FKV9HtLU8CpGXVXx
cLsyD50JUP1npLn1bZOkHk7FKoUo56hinW4rFiv9TVuGi2CKpnbRcx2SmB9Ha2lF
mwuIPTvk6wVgpoHayVwnpxgrCgQtFdI1eNHJEI8ZjeXG9Z2FCY5Cu3uegIS9YsqP
LvjL3928Xi7tkp2cOSKnAPhT3xs+HhesG3/FRWl0Z6SWUxR7zCQkF7ZIwlUVuLHO
h51ngpHlPS0Tgp86HdoN88BfFfalvK5vqnsNlkCGhMlWiOjIqgoXiaUXWyHKERhG
YNzP3qCHGhk78vETcYm/ZF/MtXmXsbhCbSqdAGv/2QQzEmuBp/uw9BCKKzRCgmrs
QJi3qtKYKIP1id/Ab1CpdnuX9x/8OqFZqTWs1dcrJWD0Nn9n/5p3cg9mhpRXV7uA
dZpF8LfhJkPuRonq6GFVyhV/fyrZ6SLK7sHSL1xH8N2Ml8bsnOFW4FUoimUOPBW/
8La2i3qk2iFnVJf8H+k+wcyFRfSLjZpic+WWFDfRn1GTpTicEDgF4AoSCPhLJxNM
x/CHOxHIBUq7fvUlYrDj
=wcIE
-----END PGP SIGNATURE-----

--=-7feMW6ARJe40uwoTEtbx--

