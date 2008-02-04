Return-Path: <linux-kernel-owner+w=401wt.eu-S1753471AbYBDPKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbYBDPKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2008 10:10:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750858AbYBDPKY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Feb 2008 10:10:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54908 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbYBDPKX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2008 10:10:23 -0500
Date: Tue, 5 Feb 2008 02:10:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Adrian Bunk <bunk@kernel.org>
Cc: paulus@samba.org, linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] powerpc: free_property() mustn't be __init
Message-Id: <20080205021005.6bbf8559.sfr@canb.auug.org.au>
In-Reply-To: <20080130200313.GG29368@does.not.exist>
References: <20080130200313.GG29368@does.not.exist>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Feb_2008_02_10_05_+1100_ElOxRJDe4UQZi5f9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Feb_2008_02_10_05_+1100_ElOxRJDe4UQZi5f9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 30 Jan 2008 22:03:13 +0200 Adrian Bunk <bunk@kernel.org> wrote:
>
> This patch fixes the following section mismatch:
>=20
> <--  snip  -->
>=20
> ...
> WARNING: vmlinux.o(.text+0x55648): Section mismatch in reference from the=
 function .free_node() to the function .init.text:.free_property()
> ...
>=20
> <--  snip  -->
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Feb_2008_02_10_05_+1100_ElOxRJDe4UQZi5f9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHpyrTTgG2atn1QN8RAoVwAKCVJpcm9sf2B/ydDvczvOYQNQhitgCgir4X
gakVv7jd7vpG9GRDA9dSkZc=
=n0eB
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Feb_2008_02_10_05_+1100_ElOxRJDe4UQZi5f9--
