Return-Path: <linux-kernel-owner+w=401wt.eu-S1759903AbXEKLn1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903AbXEKLn1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:43:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755986AbXEKLnR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:43:17 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:44202 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877AbXEKLnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:43:16 -0400
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
In-Reply-To: <20070511012216.GB10715@verge.net.au>
References: <200705080004.14570.ismail@pardus.org.tr>
	 <20070508143127.38fafa3c.kim.phillips@freescale.com>
	 <4640D988.1040504@freescale.com> <20070510051042.GA16812@verge.net.au>
	 <1178811570.3806.18.camel@johannes.berg>
	 <20070511012216.GB10715@verge.net.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-PdvKfbZgsucLWOxdr9MV"
Date: Fri, 11 May 2007 13:45:37 +0200
Message-Id: <1178883937.8896.11.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-PdvKfbZgsucLWOxdr9MV
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2007-05-11 at 10:22 +0900, Simon Horman wrote:

> Actually, it was with ARCH=3Dia64. I have a feeling that you can get
> it to show up quite easily with anything other than ARCH=3Dpowerpc.

Ick, I didn't know that drivers/macintosh was now included for all
arches! Hmm. That's a bit of a problem.

I could do

config PMAC_APM_EMU
        tristate "APM emulation"
        depends on SYS_SUPPORTS_APM_EMULATION
        select APM_EMULATION
        depends on ADB_PMU && PM

and then

config SYS_SUPPORTS_APM_EMULATION
	bool
	default y
	depends on PPC_PMAC

I'll have to run test that.

johannes

--=-PdvKfbZgsucLWOxdr9MV
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iD8DBQBGRFdh/ETPhpq3jKURAgDVAJ46WmVLjJ59f9KSP65cVxnFFFFnqgCaAkmG
UbBUeoejP0SBnGF0DhTIwX4=
=KVJL
-----END PGP SIGNATURE-----

--=-PdvKfbZgsucLWOxdr9MV--

