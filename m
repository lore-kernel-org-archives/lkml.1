Return-Path: <linux-kernel-owner+w=401wt.eu-S1755447AbXH0KqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbXH0KqT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 06:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753688AbXH0KqF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 06:46:05 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:36386 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753663AbXH0KqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 06:46:02 -0400
Subject: Re: [linux-pm] Re: [PATCH -mm 2/2] Hibernation: Arbitrary boot
	kernel support on x86_64
From: Johannes Berg <johannes@sipsolutions.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Pavel@smtp2.linux-foundation.org, Andi Kleen <ak@suse.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20070824162346.ec57f508.akpm@linux-foundation.org>
References: <200708241206.57178.rjw@sisk.pl>
	 <200708241211.55319.rjw@sisk.pl>
	 <20070824162346.ec57f508.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wJSHVUyaVAuIrbmy6XH6"
Date: Sat, 25 Aug 2007 21:13:45 +0200
Message-Id: <1188069225.9529.23.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wJSHVUyaVAuIrbmy6XH6
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-08-24 at 16:23 -0700, Andrew Morton wrote:

> The preferred way of doing this is via Kconfig, please.  ie: add a
> CONFIG_HIBERNATION_HEADER to arch/x86_64/Kconfig.

> It would be better to do something like this in (say) suspend.h:
>=20
> #ifdef CONFIG_HIBERNATION_HEADER
> extern int arch_hibernation_header_save(void *addr, unsigned int max_size=
);
> extern int arch_hibernation_header_restore(void *addr);
> #else
> static inline int arch_hibernation_header_save(void *addr,

In fact, I guess we don't need to bother with this at all. The generic
code for doing this (via the utsname based header) is tiny, so as far as
I can tell it could just be made weak symbols (by this I mean
init_header_complete() and check_image_kernel()), and then all the
#ifdefs can just go.

johannes

--=-wJSHVUyaVAuIrbmy6XH6
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBG0H9p/ETPhpq3jKURAtukAJ4+6B+DDFXEDbvWoSCyXK9NnvhNSwCdH5xh
XdKnvLouZSJox6fwcdu22Bo=
=FZHb
-----END PGP SIGNATURE-----

--=-wJSHVUyaVAuIrbmy6XH6--

