Return-Path: <linux-kernel-owner+w=401wt.eu-S932690AbXBWUZM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932690AbXBWUZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Feb 2007 15:25:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932718AbXBWUZL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Feb 2007 15:25:11 -0500
Received: from crystal.sipsolutions.net ([195.210.38.204]:34563 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932690AbXBWUZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Feb 2007 15:25:10 -0500
Subject: Re: rtc suspend()/resume() restores system clock
From: Johannes Berg <johannes@sipsolutions.net>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linuxppc-dev@ozlabs.org,
       rtc-linux@googlegroups.com, linux-pm@lists.osdl.org,
       Torrance <torrance123@gmail.com>,
       Alessandro Zummo <alessandro.zummo@towertech.it>,
       john stultz <johnstul@us.ibm.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.60.0702231927220.8712@poirot.grange>
References: <200702211929.17203.david-b@pacbell.net>
	 <200702211950.22422.david-b@pacbell.net>
	 <Pine.LNX.4.60.0702222352460.6771@poirot.grange>
	 <1172229450.3870.5.camel@johannes.berg>
	 <Pine.LNX.4.60.0702231927220.8712@poirot.grange>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-JjbS1zQ0owr6QPZ/V+s1"
Date: Fri, 23 Feb 2007 21:24:35 +0100
Message-Id: <1172262275.3870.65.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JjbS1zQ0owr6QPZ/V+s1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-02-23 at 19:31 +0100, Guennadi Liakhovetski wrote:

> Johannes, is there any special meaning in "migrate all of powerpc to=20
> genrtc"? Or is it just porting every single rtc driver to the generic rtc=
=20
> API, moving it under drivers/rtc and adjusting its users or are there any=
=20
> global changes required to arch/powerpc?

I don't know. powerpc has some platform-specific rtc hooks that will
want conversion (or deletion?), I think.

johannes

--=-JjbS1zQ0owr6QPZ/V+s1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBF302D/ETPhpq3jKURAo4sAKCFgLQ4ijCOpAuiNu9f8FhP0h/IzgCfTJYH
HgAnaJqH7UX5RnEWy+kV9zE=
=Fm8Y
-----END PGP SIGNATURE-----

--=-JjbS1zQ0owr6QPZ/V+s1--

