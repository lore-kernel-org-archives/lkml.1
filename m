Return-Path: <linux-kernel-owner+w=401wt.eu-S1755966AbYGIHl5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbYGIHl5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 03:41:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752192AbYGIHlt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 03:41:49 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51871 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbYGIHlt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 03:41:49 -0400
Subject: Re: [RFC 00/11] CONFIG_KMOD removal
From: Johannes Berg <johannes@sipsolutions.net>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
In-Reply-To: <200807091204.59755.rusty@rustcorp.com.au>
References: <20080708170015.470877000@sipsolutions.net>
	 <200807091204.59755.rusty@rustcorp.com.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-rM6f5auI9e1PvLnoeFmI"
Date: Wed, 09 Jul 2008 09:41:05 +0200
Message-Id: <1215589265.3670.27.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rM6f5auI9e1PvLnoeFmI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-09 at 12:04 +1000, Rusty Russell wrote:
> On Wednesday 09 July 2008 03:00:15 Johannes Berg wrote:
> > Some place with some code or conditional I just converted to use
> > CONFIG_MODULES, other places can invoke request_module unconditionally
> > because it compiles out when the kernel is not modular, and one place
> > (so far) converted to try_then_request_module.
>=20
> Applied 1, 2, 3, 5, 9, 10 and 11.  The others had comments.

What to? I took akpm's advice and rebased them against linux-next, a few
had minor conflicts. Nothing changed _much_, I only addressed the
comments and fixed those small conflicts.

I'll send the updated set.

> I added a help comment to the KMOD Kconfig, pointing out that it is=20
> deprecated.

Good point.

Thanks,
johannes

--=-rM6f5auI9e1PvLnoeFmI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIdGuMAAoJEKVg1VMiehFYw/QP/2IeMxmues7z42ZMITXzP/W1
ZutU2yTUdBg+6qfAZajpR3wXtY769Abq/IlpCGhJbigX6wlQA6S5Mt4gjjoMd5tA
zRJQAcB87wvJUmB5eAARNouwg8CB7D9K4SWg3oTFp5t/5VSTEFmTI0zyGu6Fa3Kw
oRzTfw3KndB0CuN40acbIBHKbtEwCiEfri9DkcKdPWfLqnPiUY0CFFA1+1tZ5hJC
GCBy55QJQMeee+QW68jZYExwGKtZk3t5Ry1HvDJrMlKnAiUB9FQFwtyDiWBt7EB5
lwDF7Gg/C/Id5nIIqvLsIGBFy1C0N2ijG/PR/o/9iGZ0AV3RoSDHKNV4+p19Ow/n
X2Xqv9dmfI+lmlfMy3EniWmIt6XJd6/noAIpNvSzjWjXXPDszFz/eF+zFffYNGPH
bI0y5ALubXfsI9oe5F0l3FQznWe2PwXdbveh/R8YAamA7VXYMylbExKlhX00K5ZE
i1KjZXKC1Y3tYmsIg1iXfSXtvIJUfLBKTabZRCktUhFxDu3jD8AR4ibkQz7Yf3yV
MJ84mwNKwWV596I2IVd0WCeMzM+7jc47lqjW6ADNAGnfG+RAntj9zPW57I0rZaQR
KqmxaNhB3io0bUab6CloCEDBH3B5QEu6bFnz9esnQd62KJjdU8IOxOuXly9WuAOS
gZ5u/5jbHq6lohwPlQN0
=kGoo
-----END PGP SIGNATURE-----

--=-rM6f5auI9e1PvLnoeFmI--

