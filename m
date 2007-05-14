Return-Path: <linux-kernel-owner+w=401wt.eu-S1754649AbXENMzW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754649AbXENMzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 08:55:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXENMzO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 08:55:14 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40192 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722AbXENMzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 08:55:12 -0400
Subject: Re: Kconfig warnings on latest GIT
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Horman <horms@verge.net.au>
Cc: Timur Tabi <timur@freescale.com>,
       Kim Phillips <kim.phillips@freescale.com>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org,
       Ismail =?ISO-8859-1?Q?D=F6nmez?= <ismail@pardus.org.tr>,
       Kumar Gala <galak@kernel.crashing.org>,
       Michael Schmitz <schmitz@debian.org>,
       Roman Zippel <zippel@linux-m68k.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, Ralf Baechle <ralf@linux-mips.org>
In-Reply-To: <20070514013230.GJ3588@verge.net.au>
References: <200705080004.14570.ismail@pardus.org.tr>
	 <20070508143127.38fafa3c.kim.phillips@freescale.com>
	 <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au>
	 <1178811570.3806.18.camel@johannes.berg>
	 <20070511012216.GB10715@verge.net.au>
	 <1178883937.8896.11.camel@johannes.berg>
	 <20070514013230.GJ3588@verge.net.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5P+EYyVURQ7J7npE4dYy"
Date: Mon, 14 May 2007 14:55:11 +0200
Message-Id: <1179147311.2647.47.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5P+EYyVURQ7J7npE4dYy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Simon,

> I don't think that this is quite right, or at least it isn't quite the
> same as before.

Yeah, I think you're right.

>  I think that was is below will toggle
> SYS_SUPPORTS_APM_EMULATION when PMAC_APM_EMU is selected,
> which I think is what you want. Is it also neccessary to
> add a dependancy on PPC_PMAC to PMAC_APM_EMU ?

No, it depends on ADB_PMU which depends on PPC_PMAC.

> config PMAC_APM_EMU
> 	tristate "APM emulation"
> 	select APM_EMULATION
> 	depends on ADB_PMU && PM
>=20
> config SYS_SUPPORTS_APM_EMULATION
> 	bool
> 	default y if PMAC_APM_EMU

I still have to try it, I haven't been yet seen Kumar's fix that he said
he'd done.

johannes

--=-5P+EYyVURQ7J7npE4dYy
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGSFwv/ETPhpq3jKURAqXLAJ98DinaxgHifKcKt2xKl2yvicMmAACggf/Q
CrKZ4jnkCezTufQlGoUQ49E=
=BdyT
-----END PGP SIGNATURE-----

--=-5P+EYyVURQ7J7npE4dYy--

