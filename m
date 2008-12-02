Return-Path: <linux-kernel-owner+w=401wt.eu-S1754491AbYLBW6c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491AbYLBW6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 17:58:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbYLBW6X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 17:58:23 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43795 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752720AbYLBW6X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 17:58:23 -0500
Date: Wed, 3 Dec 2008 09:58:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nicolas Palix <npalix@diku.dk>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Julia Lawall <julia@diku.dk>,
       kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH linux-next] powerpc/chrp: Add missing of_node_put in
 pci.c
Message-Id: <20081203095805.7d868849.sfr@canb.auug.org.au>
In-Reply-To: <200812021434.47010.npalix@diku.dk>
References: <200812021434.47010.npalix@diku.dk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__3_Dec_2008_09_58_05_+1100_K4GmTslo0ueuSKAi"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Dec_2008_09_58_05_+1100_K4GmTslo0ueuSKAi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Dec 2008 14:34:46 +0100 Nicolas Palix <npalix@diku.dk> wrote:
>
> of_node_put is needed before discarding a value received from
> of_find_node_by_name, eg in error handling code or when the device
> node is no longer used.
>=20
> Signed-off-by: Nicolas Palix <npalix@diku.dk>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__3_Dec_2008_09_58_05_+1100_K4GmTslo0ueuSKAi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk1vX0ACgkQjjKRsyhoI8yhbwCfYgYc3JfXqy2v7+AwOz5eJ7Ao
ZucAnR/MiEicPcKWMzgAChoROL9BjRvl
=6bJ4
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Dec_2008_09_58_05_+1100_K4GmTslo0ueuSKAi--
