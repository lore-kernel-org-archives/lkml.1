Return-Path: <linux-kernel-owner+w=401wt.eu-S1755440AbYEPKvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440AbYEPKvR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2008 06:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752444AbYEPKvA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 May 2008 06:51:00 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:46234 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752386AbYEPKu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2008 06:50:59 -0400
Subject: Re: [PATCH 2/2] lguest: virtio-rng support
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: virtualization@lists.linux-foundation.org, Jeff Garzik <jeff@garzik.org>,
       Herbert Xu <herbert@gondor.apana.org.au>,
       Christian Borntraeger <borntraeger@de.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Anvin" <hpa@zytor.com>
In-Reply-To: <200805161539.59739.rusty@rustcorp.com.au>
References: <482C8595.5030509@garzik.org>
	 <200805160943.08788.rusty@rustcorp.com.au>
	 <200805161531.44725.rusty@rustcorp.com.au>
	 <200805161539.59739.rusty@rustcorp.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NK9f9znuTheOv8uVV1Mn"
Date: Fri, 16 May 2008 12:49:41 +0200
Message-Id: <1210934981.6381.1.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NK9f9znuTheOv8uVV1Mn
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> +
> +/* Our random number generator device reads from /dev/urandom into the G=
uest's
> + * input buffers.  The usual case is that the Guest doesn't want random =
numbers
> + * and so has no buffers although /dev/urandom is still readable, wherea=
s
> + * console is the reverse.

Is it really a good idea to use the hosts /dev/urandom to fill the
guests /dev/random?

johannes

--=-NK9f9znuTheOv8uVV1Mn
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASC1mxKVg1VMiehFYAQLyFQ/8DYZdGFEzvFitft6kv4HOi0zMlJe9irfa
liNn2pusNjPm4bdFUtU77ItiKTrv2Q3lK0ejW0dgfZ080WJ4Nt+j0B5ue0TpzZFe
jcE2AR3kmNPMmp7kLkW6udFCJbQiVDozVs2pqj+oY+ITilT2f1dEamE6i6cQM+WL
j/0+q/CHCHro4Ll1Y1rryvbugjEEzJkeGWDO4AywPOaXGs+/nNG8/ddkAm+m6jXf
l5g/ZOdqC+pU4p2dEvYdI7vx3B40aRLo17BRni2tDn/ENJSeD1aUurwMdvFNhouF
pdbnX0bid1CP0uzKvZ83ZkAN18/CHSCBKH9HhTLzQXNSwp8fM+AdGMK92jDxPZvv
iM3KJntOhGMy2nqC7ZqM9F7J/bwoq6TtFbp0gWEKG44OVWdUY+tpi6MIzSuoTSo0
FIOS3T+xdjyJW75vbhJH6VXuQQmvy02ObNCBd4wEQNilrV+TfvJtnjPDLMKdIeva
xsYwzOohtA4dld5pexI7tZazI0rzNs8ZHJ7sCdhGSkWDWp1T6P9C/AZl3J947WrB
w3TSukkzr4Vr8TGGrMrrIIEvStUCojOvoSPaRsW9qAviBS/VJwsQi4zHrBrLPrBJ
d0+7sNHKpyzkoi3SG1edIFUtuSiWkHAmfuTUGG+P+v7AVSJ3rhM5kvSbojjoMhaA
DaQrNM6OM/o=
=ACgM
-----END PGP SIGNATURE-----

--=-NK9f9znuTheOv8uVV1Mn--

