Return-Path: <linux-kernel-owner+w=401wt.eu-S1752601Ab0A2Gc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0A2Gc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 01:32:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752342Ab0A2Gc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 01:32:27 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48990 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752042Ab0A2Gc0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 01:32:26 -0500
Date: Fri, 29 Jan 2010 17:32:20 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
Message-Id: <20100129173220.abdd823d.sfr@canb.auug.org.au>
In-Reply-To: <20100128.201206.257650090.davem@davemloft.net>
References: <20100128184423.40ce38fb.sfr@canb.auug.org.au>
	<20100128.052432.251700168.davem@davemloft.net>
	<20100129102543.7af32673.sfr@canb.auug.org.au>
	<20100128.201206.257650090.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jan_2010_17_32_20_+1100_e_oqV=GMz4WaUxDR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jan_2010_17_32_20_+1100_e_oqV=GMz4WaUxDR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 28 Jan 2010 20:12:06 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> Simply ignore the warning then, I thought you were reporting
> a build failure.

No worries, I just report warnings in case noone else notices them.  And
in case they are important.

> Looking at the specific case of net/core/pktgen.c:867
>=20
> "len" is variable in the net/core/pktgen.c line that emits the
> warning
>=20
> Even though it is limited to "sizeof(name) - 1" via strn_len()'s
> third argument, that's a lot to expect the compiler to dig into
> and be able to conclude invariants from.

Yeah, indeed.  We need an intuitive compiler :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jan_2010_17_32_20_+1100_e_oqV=GMz4WaUxDR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktigPQACgkQjjKRsyhoI8xHuQCfSnN6BPWqEAOg99839p/lypEU
ux4An3vebG6u7geiGrQhyg92QI+Pt5xl
=514x
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jan_2010_17_32_20_+1100_e_oqV=GMz4WaUxDR--
