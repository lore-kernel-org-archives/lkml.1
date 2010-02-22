Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054Ab0BVWvc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 17:51:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37280 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754951Ab0BVWva (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 17:51:30 -0500
Date: Tue, 23 Feb 2010 09:51:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, monstr@monstr.eu,
       linux-kernel@vger.kernel.org, jeremy.kerr@canonical.com
Subject: Re: [PATCH 2/2] of/flattree: Make unflatten_device_tree() safe to
 call from any arch
Message-Id: <20100223095118.bed93bac.sfr@canb.auug.org.au>
In-Reply-To: <20100222155059.3604.39718.stgit@angua>
References: <20100222154816.3604.67114.stgit@angua>
	<20100222155059.3604.39718.stgit@angua>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Feb_2010_09_51_18_+1100_A6Y9ntPsHTviplAx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Feb_2010_09_51_18_+1100_A6Y9ntPsHTviplAx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Mon, 22 Feb 2010 08:50:59 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> - If CONFIG_OF_FLATTREE is not set, then make unflatten_device_tree()
>   an empty #define.

Any reason not to make this a static inline?

> +#define unflatten_device_tree() do {} while(0)

static inline void unflatten_device_tree(void) {}

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Feb_2010_09_51_18_+1100_A6Y9ntPsHTviplAx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuDCmYACgkQjjKRsyhoI8yz3QCdF3W500UskKk8Dr5TaZyBwdLv
j6gAmgMpa3hZ1wTvPIN/LIM9HwRxFKKH
=VgF8
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Feb_2010_09_51_18_+1100_A6Y9ntPsHTviplAx--
