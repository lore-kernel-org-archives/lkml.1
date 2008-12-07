Return-Path: <linux-kernel-owner+w=401wt.eu-S1753721AbYLGFnx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721AbYLGFnx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 00:43:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751262AbYLGFnm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 00:43:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41239 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751151AbYLGFnl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 00:43:41 -0500
Date: Sun, 7 Dec 2008 16:43:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nicolas Palix <npalix@diku.dk>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
       linuxppc-dev@ozlabs.org, Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH linux-next] powerpc/powermac: Add missing of_node_put
Message-Id: <20081207164333.78b69d16.sfr@canb.auug.org.au>
In-Reply-To: <18747.13668.304923.709761@cargo.ozlabs.ibm.com>
References: <200812021445.18670.npalix@diku.dk>
	<20081206163449.60757c4a.akpm@linux-foundation.org>
	<18747.13668.304923.709761@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__7_Dec_2008_16_43_33_+1100_9cAgL=Z0Rx4qNG1v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__7_Dec_2008_16_43_33_+1100_9cAgL=Z0Rx4qNG1v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

On Sun, 7 Dec 2008 13:31:00 +1100 Paul Mackerras <paulus@samba.org> wrote:
>
> I'm really in two minds about applying any of the of_node_put patches
> that only affect powermacs.  The reference counts only matter on
> platforms where we update the OF device tree at runtime, which is
> currently only IBM pSeries machines.  Since we don't have any hotplug
> on powermacs, and never will have, the OF device tree is completely
> static and we don't actually need refcounts on the nodes at all, so
> who cares if they're a bit higher than they might be?
>=20
> In particular, the VIA whose node we're looking for here is built-in
> on the motherboard, and there can never be more than one, and it can
> never be removed.

I my mind it is about consistent use of the API and good examples for
people to copy.  Also, in about a year you will be presented with the
same set of patches when a new pair of eyes looks at the same code and
notices the discrepancy ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__7_Dec_2008_16_43_33_+1100_9cAgL=Z0Rx4qNG1v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk7YoUACgkQjjKRsyhoI8yITgCgqhiy2EiAy7rT/UeREir6DnDl
DFQAoJazqJL2ZCW+NMAj8s8iWyhmdOPV
=p+Ht
-----END PGP SIGNATURE-----

--Signature=_Sun__7_Dec_2008_16_43_33_+1100_9cAgL=Z0Rx4qNG1v--
