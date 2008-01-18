Return-Path: <linux-kernel-owner+w=401wt.eu-S1764787AbYARTbY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764787AbYARTbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 14:31:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761728AbYARTbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 14:31:16 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33379 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761639AbYARTbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 14:31:16 -0500
Subject: Re: Why is the kfree() argument const?
From: Zan Lynx <zlynx@acm.org>
To: Vadim Lobanov <vlobanov@speakeasy.net>
Cc: Andy Lutomirski <luto@myrealbox.com>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Schwartz <davids@webmaster.com>,
       Johannes Weiner <hannes@saeurebad.de>, clameter@sgi.com,
       penberg@cs.helsinki.fi
In-Reply-To: <200801181114.33513.vlobanov@speakeasy.net>
References: <MDEHLPKNGKAHNMBLJOLKOEIPJJAC.davids@webmaster.com>
	 <47906133.6010301@cateee.net> <4790AF84.2020000@myrealbox.com>
	 <200801181114.33513.vlobanov@speakeasy.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-nu+E8wWgMOcvn6WUSJ3f"
Date: Fri, 18 Jan 2008 12:31:05 -0700
Message-Id: <1200684666.7735.22.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080118/1JFwvj-0005ib-EF-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-nu+E8wWgMOcvn6WUSJ3f
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-01-18 at 11:14 -0800, Vadim Lobanov wrote:
[cut]
> Second, even if const did have stronger semantics that forbade the value =
of x=20
> from being modified during execution of foo, the compiler still could not=
=20
> reorder the two function calls, before it cannot assume that the two=20
> functions (in their internal implementations) do not touch some other,=20
> unknown to this code, global variable.

This is why GCC has the pure and const function attributes.  These
attributes are more powerful than the "const" keyword, and do allow
optimizations with assumptions about global state.
--=20
Zan Lynx <zlynx@acm.org>

--=-nu+E8wWgMOcvn6WUSJ3f
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHkP55G8fHaOLTWwgRAq1+AJ9lWIB6gzHEI1PF9z5gd3ck8bx+6QCggx/G
6uk0qgdAKWbPqblLAf9GcPQ=
=V6Mi
-----END PGP SIGNATURE-----

--=-nu+E8wWgMOcvn6WUSJ3f--

