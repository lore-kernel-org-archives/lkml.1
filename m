Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914Ab0BTL3A (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 06:29:00 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:48448 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab0BTL27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 06:28:59 -0500
Subject: Re: [2.6.33-rc5] Weird deadlock when shutting down
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?Am=E9rico?= Wang <xiyou.wangcong@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
References: <1264740107.20211.53.camel@pasglop>
	 <1266485775.6539.6.camel@jlt3.sipsolutions.net>
	 <alpine.LFD.2.00.1002180825000.4141@localhost.localdomain>
	 <1266518735.3829.4.camel@jlt3.sipsolutions.net>
	 <2375c9f91002192313j3fb84acje4c286c4f86457f3@mail.gmail.com>
	 <1266656213.5347.0.camel@jlt3.sipsolutions.net>
	 <2375c9f91002200106j56b0298ds1a425fde8983d988@mail.gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-EkZ56L4UtQO8Q9AYGVop"
Date: Sat, 20 Feb 2010 12:28:51 +0100
Message-ID: <1266665331.12525.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.3.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EkZ56L4UtQO8Q9AYGVop
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2010-02-20 at 17:06 +0800, Am=C3=A9rico Wang wrote:
> On Sat, Feb 20, 2010 at 4:56 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
> > On Sat, 2010-02-20 at 15:13 +0800, Am=C3=A9rico Wang wrote:
> >
> >> Does my following untested patch help?
> >
> > Sorry, no. I'll hook up a screen to the box after I return from the
> > fresh market.
> >
>=20
> Are you sure there is no difference? :-/

It deadlocks after

Disabling non-boot CPUs ...

Not sure if that counts as a difference...

johannes

--=-EkZ56L4UtQO8Q9AYGVop
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLf8dwAAoJEODzc/N7+QmagBEP/iN3gnvWlCfR3iem0SQV3zkT
alKux1yIZA13iwEQ9gS1ZZfa3jrMwhp+eXYKeIwXU/3d+CWeyix2df7ZVHlQuNjB
zW08xRD2QzO4XwB7nST4k0dnyzOu8wJAuTfcPcXzJKla0x5DWcqMQVNYHW5MdhbB
4giKITKYgw4t2fFnL2BxKA38msiXvlAD0rVGB0nnv1E8RjnQw/3JHc4vTqVrfcAA
L2kZJP6SKhx9EvUoVH2sn76xky3VSzypKEIRSX4a3HLzYFqf2O/+zkYhbnWPoprV
n+5ulA2i/ARXhHmXpX9OfjUJnc0TVZO5t3uUyuCdRJsRm+pyjEu9RcENrLjzu+GM
LvdCQHnkfKIc8lsEYleen2oBNpNHkmX00x/ZK63TlRqsBoK7TQCgx8rrzoqGUgxb
5dJP0A/Ps1vF6pD4rVxnyQuADErhUZE9XDflKbsUXiaCY2sXcQrjwEBpdvYk812e
4fNlu6mjWDec0ogPv3PizluyLfFUyH/f5FizQPGXapMOMmq9+w31o10sZG1+B12A
Wa+osngrJ/ql+gmUmGAh32t8XLplPE0w/gDhByaYqh1tjfiNyGcB/S2lWDYU8h6X
uqbMcvePUgJOyGCO9ZhG9puEObozdI+ct/AnXWUhykNiyRMKZUdt4/tf6B7OpoMa
BidL9t6mhg3LObMuWSsa
=QSVJ
-----END PGP SIGNATURE-----

--=-EkZ56L4UtQO8Q9AYGVop--

