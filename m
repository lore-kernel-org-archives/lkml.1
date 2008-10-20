Return-Path: <linux-kernel-owner+w=401wt.eu-S1753320AbYJTM6d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320AbYJTM6d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2008 08:58:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751569AbYJTM6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Oct 2008 08:58:24 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:42063 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbYJTM6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2008 08:58:24 -0400
Subject: Re: [PATCH] x86, ioremap: use %pR in printk
From: Johannes Berg <johannes@sipsolutions.net>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@osdl.org>, linux-kernel@vger.kernel.org,
       David Miller <davem@davemloft.net>, linux-pci@vger.kernel.org,
       yhlu.kernel@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20081020113602.GA2697@elte.hu>
References: <20081020040823.871BDDDDEC@ozlabs.org>
	 <20081020071203.GB12131@elte.hu> <1224491682.7654.135.camel@pasglop>
	 <20081020090502.GB31710@elte.hu> <20081020110018.GA24579@elte.hu>
	 <1224501352.7654.141.camel@pasglop> <1224501768.7654.144.camel@pasglop>
	 <2008102  <20081020113602.GA2697@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-oJ1YbGKKo1H6GZ47p+JL"
Date: Mon, 20 Oct 2008 14:58:06 +0200
Message-Id: <1224507486.27899.31.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-oJ1YbGKKo1H6GZ47p+JL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-10-20 at 13:36 +0200, Ingo Molnar wrote:

> +	/* room for the actual number, the "0x" and the final zero */
> +	char sym[2*sizeof(phys_addr_t) + 2];

Buffer overflow.

johannes

--=-oJ1YbGKKo1H6GZ47p+JL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJI/IBbAAoJEKVg1VMiehFY7KgP/1FVB7epsiKR+CjLPmtRKjvK
gtpkBfes5COvdRNJ4dwHv8zXvhC/gwWDMTJfixZoPrIEdBiC2FT4oIlEhdoBT9My
v3T4LCqRPTOM9iWfgaE/16x855EZLvR12sDYGJiKcjixs2Tju2lBnDSZoZMJGmdx
hLE41nsr1NmXwnV1Kc6i/IMZhLxGk4Ofr6d8kS9gzidaRgd8kYs06JSk8Ko6EBxM
7QETMiFuHCsoJUtTikowtB/CN9yNrrZtSR1rmVM/k9m3D7mSLBukErujVpcG1Tuu
ZEmOG0T5ofo0c4ZVyjHY3zU9svxp53TbfYlZPcuph+v5as3BnmQzV0mVIHLg6JXE
Gz95A0jWWkfdxBG6h/mMPPG1DsGJ8DPd95VBZoXX2YDajzfoWTwqCZXZ0QR3uXO0
i3kPmBkV+bbCcgAgRyCRTVec+fMHhKRUKlBGq9NGR8KiPmCyHYrRxymO8dT+2DZF
Zhw8uSb7DNaRFKWrHKWs1Y7+E6vhWSgs5jq/NTVH0iJQLmfATpU4s/+754ARRGBe
FPwu+7u/HwX8/cO8GrcaVl0Xv4YFXtVv7t1b6Cittf8wNJWj5SvzuxThBwaplpGl
K0D5uqiCoxh55keYuB5GeAvQGAYLgoVMPCZNJ1Ve6/jpBamFKPbZoF5wBHFQPK/N
F0+eRoEhhiHrnIH0G8lx
=HApQ
-----END PGP SIGNATURE-----

--=-oJ1YbGKKo1H6GZ47p+JL--

