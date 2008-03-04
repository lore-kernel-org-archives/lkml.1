Return-Path: <linux-kernel-owner+w=401wt.eu-S1758922AbYCDKUb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922AbYCDKUb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 05:20:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754586AbYCDKUV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 05:20:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41335 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752777AbYCDKUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 05:20:20 -0500
Date: Tue, 4 Mar 2008 21:20:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Zhang Wei <wei.zhang@freescale.com>
Cc: mporter@kernel.crashing.org, galak@kernel.crashing.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/17] Change the kernel configurated RapidIO system
 size to auto-probing.
Message-Id: <20080304212012.9ea2d3b5.sfr@canb.auug.org.au>
In-Reply-To: <1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
References: <1204648202-5495-1-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-2-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-3-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-4-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-5-git-send-email-wei.zhang@freescale.com>
	<1204648202-5495-6-git-send-email-wei.zhang@freescale.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Mar_2008_21_20_12_+1100_lcnUNoje9gdeyq90"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Mar_2008_21_20_12_+1100_lcnUNoje9gdeyq90
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed,  5 Mar 2008 00:29:51 +0800 Zhang Wei <wei.zhang@freescale.com> wrot=
e:
>
> +	if (!(rionet_active =3D (struct rio_dev **)__get_free_pages(GFP_KERNEL,
> +				mport->sys_size ? __ilog2(sizeof(void *)) + 4
> +				: 0))) {

Please separate the assignment from the test.

> +		if (!(rswitch->route_table =3D kzalloc(sizeof(u8)*
> +					RIO_MAX_ROUTE_ENTRIES(port->sys_size),
> +					GFP_KERNEL))) {

Again.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Mar_2008_21_20_12_+1100_lcnUNoje9gdeyq90
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzSJjTgG2atn1QN8RAh0CAJ49UjbcwrxRmhDK6R6+teCUKLzYsACfQclf
ZDGIjwK8GnOfgT19A1MUgZU=
=47pJ
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Mar_2008_21_20_12_+1100_lcnUNoje9gdeyq90--
