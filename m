Return-Path: <linux-kernel-owner+w=401wt.eu-S1755550AbXD0KJW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550AbXD0KJW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 06:09:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755553AbXD0KJW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 06:09:22 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:59833 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755550AbXD0KJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 06:09:20 -0400
Subject: Re: [linux-pm] Re: suspend2 merge (was Re: [Suspend2-devel] Re:
	CFS and suspend2: hang in atomic copy)
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Nick Piggin <npiggin@suse.de>, Nigel Cunningham <nigel@nigel.suspend2.net>,
       Ingo Molnar <mingo@elte.hu>, Pavel Machek <pavel@ucw.cz>,
       Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, suspend2-devel@lists.suspend2.net,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <1177666915.7828.35.camel@johannes.berg>
References: <20070425072350.GA6866@ucw.cz> <200704262040.31760.rjw@sisk.pl>
	 <1177612802.6814.121.camel@johannes.berg> <200704262102.38568.rjw@sisk.pl>
	 <1177666915.7828.35.camel@johannes.berg>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q/W2ajiTTplPeOUo2Gnm"
Date: Fri, 27 Apr 2007 12:09:17 +0200
Message-Id: <1177668558.7828.38.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q/W2ajiTTplPeOUo2Gnm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-04-27 at 11:41 +0200, Johannes Berg wrote:

> No, because acpi doesn't know at build time whether it can actually do
> S4 or not.

Actually, you could probably do it by making some weak symbol for it
that only ACPI overrides, and then check in the ACPI code if S4 is
possible, otherwise somehow invoke the old symbol or copy the code or
something. Seems a bit more fragile though.

johannes

--=-q/W2ajiTTplPeOUo2Gnm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGMcvN/ETPhpq3jKURAjB1AJwKJgM+u+zMsDr5gD5gz1tK1VbKBwCfan6P
h/sBaTT+2rgQ88cVHtxR4oU=
=jLsN
-----END PGP SIGNATURE-----

--=-q/W2ajiTTplPeOUo2Gnm--

