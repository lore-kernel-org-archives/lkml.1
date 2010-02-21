Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab0BUKR4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 05:17:56 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:56343 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab0BUKRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 05:17:55 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
	 <1266665331.12525.0.camel@jlt3.sipsolutions.net>
	 <20100220134447.GA3000@hack>
	 <1266674268.18465.6.camel@jlt3.sipsolutions.net>
	 <2375c9f91002210151i6fe3f769k72a8a6a3485d8cf5@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ylc1HwIbIjBPiIn2nPun"
Date: Sun, 21 Feb 2010 11:17:20 +0100
Message-ID: <1266747440.5468.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ylc1HwIbIjBPiIn2nPun
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2010-02-21 at 17:51 +0800, Am=C3=A9rico Wang wrote:
> On Sat, Feb 20, 2010 at 9:57 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2010-02-20 at 21:44 +0800, Am=C3=A9rico Wang wrote:
> >
> >> That message is displayed before shutting down the devices.
> >>
> >> To verify, you can add some printk() in the end of
> >> __cpufreq_remove_dev(), or enable CONFIG_CPU_FREQ_DEBUG.
> >
> > That is already enabled.
> >
>=20
> Ok, I got it.
>=20
> Could you test the patch below? Thanks!

No change, sorry, still hangs right after "Disabling non-boot CPUs ..."
before the machine turns off.

johannes

--=-Ylc1HwIbIjBPiIn2nPun
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLgQgtAAoJEODzc/N7+QmatbMQAI9XvCRczZOtSI9SA7ha5fxB
/WQQlCIlXGOHgZWmNFKfGE6PblQRLsdRxGy/am5BTGD7ogyt1q4bozdgJYsgX/PM
7S6a9vRu11/Mj2TbqWWkL0P7bLcqjyNNLaEif1ArLitM3yndZZX47xDeY8ThRxKQ
j3T49UQx4vkFOTxbGfjGTS0uCNWQYYIXTeZdmxcXnYAwTnJ6S4ZBMh4P3gZCKUKL
+12wuNAElwaoGumXJHDze6C5CQFOep9XaNtXWY+9qooTeOziNoLh3KS0KG6Er3L4
DLOLQinG/wDC/jMMjtMVts6jRF0kNuyNJ2PRbBqzJVYx6VS5rlh3Y1vp6d6Grn4V
BU3S6MuLqUrbFY3spqdc1CB/YffzKZ/DED6VCpcjxKye9lJscPiM3qSXheqho1Cz
4nS++SofsCOV/3zsovBI7pigDbF6Qj7tojYBxl84di8PsTiZ0PTx+QcnRlpg+HlC
gv0JKtpjHh9GE98H6USo4nHGATjCF1SpOdo+6U7OZlaXCd9eh8zrOXMOxbVrxgDI
D0f0GNRWkN36LDQycN8LUYN6iKDjHscgJpwz5P7soMFkGfTFdthwGmt35MOvKk8U
HTAnp57kVIa2oOFa9cMvhyK59eG+y8Ua1jg5AJ1wLwfQECaaCjgm6erq5ESGgfaF
x6z2vl/KwD6pEhUpkZ/l
=v0WM
-----END PGP SIGNATURE-----

--=-Ylc1HwIbIjBPiIn2nPun--

