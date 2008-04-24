Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYDXJWX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYDXJWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:22:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751056AbYDXJWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:22:15 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:39725 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbYDXJWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:22:14 -0400
Subject: Re: cpu_clock confusion (was: printk time confusion?)
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@ozlabs.org>,
       linuxppc-dev list <linuxppc-dev@ozlabs.org>,
       Arnd Bergmann <arndb@de.ibm.com>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20080404144641.GA15844@elte.hu>
References: <1207146186.3957.11.camel@johannes.berg>
	 <1207219724.10388.319.camel@pasglop>
	 <1207240450.3797.22.camel@johannes.berg>  <20080404144641.GA15844@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Qqig41e2ATLZLDa/j1zw"
Date: Thu, 24 Apr 2008 11:21:52 +0200
Message-Id: <1209028912.3357.52.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qqig41e2ATLZLDa/j1zw
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > [    2.764009 (3/3)]
> > [    4.272241 (2/2)]
> > [    4.272322 (2/2)]
> > [    4.272375 (2/2)]
> > [    2.948002 (3/3)]
> >=20
> > As you can see, I added printk_cpu and smp_processor_id() to the=20
> > printk timestamp output and thus it is obvious that the different=20
> > times come from different CPUs.
>=20
> the fixes are queued for v2.6.26. You can pick them up from=20
> sched-devel/latest as well:
>=20
>   http://people.redhat.com/mingo/sched-devel.git/README

Hmm. Why is that whole cpu_clock stuff in place anyway? powerpc has
perfectly synchronised time across processors with dirt cheap access to
it as well, so why build all this code that only messes it up on top of
it?

johannes

--=-Qqig41e2ATLZLDa/j1zw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBBRL6Vg1VMiehFYAQKOCA/9GV98wfgFp/4xMkbPay4pYo5WWKWwg2Oo
p10Z4iCXYH/MEWsvP5lLxYt3rTW8qeoYidxH0utGoZfG2NV490KP8NAuKkc64mUa
IeT+ctRebaUHGI6o8UJRf/4Z/4dCrGFeyueTF1RGLnffTaXHooE24DkaGgDQ6GqV
RRAdb2OpUhUniAT/MJwGSR/lvGAoGMr8wrBTrZzpA0YrsFX3Pd0r//9A1OmCqTiH
qjNrsMNQiSaG5VPXIe2tb2QxufCxfQJa6332ay5qr/NGfSO3ilk/MzXPFGZPiv8K
ue26TXmIFtJgFZQxl93O/KQMgi2YEbGfVVZJXhnI/vVGvHFn5o6aOVEX1ed9Zvsh
qSgPgqSfbXBpWff5sXG3cOL0gL5Jb+QxDEBB9liczi2lnXNqQmjbXkSMfx9j5bRG
QzGY/rAa+jBJQnXiscTR9a4jXTLDeOKx5xdvn9ajeohEfOCZz6YFhfDG/C4lWSf7
E1pvxbQ0TeZoWIRCTLXhimxhUFbiK/ouDu063o40bQis6ICz4ofgoMqWtdBnjcAI
N9mb3Rdit/UomdlqsTbJQo4EalNN5CF0IwDoYeE1BN4o3kYcFRB5+hbIzEcm7zp4
a1IT16eLsMO2WmZRFv2qq0A38SX6S+ERGD54/eKK1T/2+GCI1HUeMCCvwiwgClSr
F2uJBDvaIAA=
=wywX
-----END PGP SIGNATURE-----

--=-Qqig41e2ATLZLDa/j1zw--

