Return-Path: <linux-kernel-owner+w=401wt.eu-S1758442AbYABAS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758442AbYABAS0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2008 19:18:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755244AbYABASQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Jan 2008 19:18:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55087 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755031AbYABASP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2008 19:18:15 -0500
Date: Wed, 2 Jan 2008 11:18:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Julia Lawall <julia@diku.dk>
Cc: paulus@au.ibm.com, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/3] arch/powerpc/platforms/pseries: Add missing
 of_node_put
Message-Id: <20080102111808.3e358093.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0801012202040.19803@ask.diku.dk>
References: <Pine.LNX.4.64.0801012202040.19803@ask.diku.dk>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__2_Jan_2008_11_18_08_+1100_Gb_ViJ98z6KoLqW6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__2_Jan_2008_11_18_08_+1100_Gb_ViJ98z6KoLqW6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 1 Jan 2008 22:02:49 +0100 (CET) Julia Lawall <julia@diku.dk> wrote:
>
> From: Julia Lawall <julia@diku.dk>
>=20
> Of_get_parent and of_find_compatible_node do an of_node_get, and thus a
> corresponding of_code_put is needed in the error case.

Thanks for these.

In the future, any patch that touches arch/powerpc (or
include/asm-powerpc) should be (at least) cc'd to linuxppc-dev@ozlabs.org
(where the PowerPC developers lurk).  That way they will also be saved in
Patchwork (http://patchwork.ozlabs.org/) and not lost.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__2_Jan_2008_11_18_08_+1100_Gb_ViJ98z6KoLqW6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHethFTgG2atn1QN8RAgpXAJ0bbZQvWovvFZrZF89BttepRaRk7QCeM6yH
vRuwKIsu7m8XW8N5BuFLbxY=
=6KpH
-----END PGP SIGNATURE-----

--Signature=_Wed__2_Jan_2008_11_18_08_+1100_Gb_ViJ98z6KoLqW6--
