Return-Path: <linux-kernel-owner+w=401wt.eu-S1755426AbYKULmx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbYKULmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2008 06:42:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753050AbYKULmp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Nov 2008 06:42:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46799 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752865AbYKULmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2008 06:42:44 -0500
Date: Fri, 21 Nov 2008 22:41:59 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 5/8] cpumask: powerpc: Introduce
 cpumask_of_{node,pcibus} to replace {node,pcibus}_to_cpumask
Message-Id: <20081121224159.3bc54524.sfr@canb.auug.org.au>
In-Reply-To: <20081121104446.A45F1DDEE8@ozlabs.org>
References: <20081121104446.A45F1DDEE8@ozlabs.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__21_Nov_2008_22_41_59_+1100_ERoSjOftgr9452RN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__21_Nov_2008_22_41_59_+1100_ERoSjOftgr9452RN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Fri, 21 Nov 2008 21:12:13 +1030 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> Impact: New APIs
>=20
> The old node_to_cpumask/node_to_pcibus returned a cpumask_t: these
> return a pointer to a struct cpumask.  Part of removing cpumasks from
> the stack.
>=20
> (Also replaces powerpc internal uses of node_to_cpumask).
>=20
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>

Sending powerpc patches to linuxppc-dev@ozlabs.org and paulus@samba.org
is a good idea (the first because it gets put into patchwork (and so
doesn't get lost) and the second because Paul and Ben are currently
juggling the maintainership between them.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__21_Nov_2008_22_41_59_+1100_ERoSjOftgr9452RN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkmnocACgkQjjKRsyhoI8wl0ACfW6/LEBMaiTR7/whz1hAJiUEd
+S4AoKGDUTBg4wWqwbvwL8pCjR54uiTC
=W+fy
-----END PGP SIGNATURE-----

--Signature=_Fri__21_Nov_2008_22_41_59_+1100_ERoSjOftgr9452RN--
