Return-Path: <linux-kernel-owner+w=401wt.eu-S1765693AbYETMos@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765693AbYETMos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 08:44:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756974AbYETMok
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 08:44:40 -0400
Received: from ozlabs.org ([203.10.76.45]:52572 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756136AbYETMok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 08:44:40 -0400
Subject: Re: [BUILD_FAILURE] linux-next: Tree for May 20 - build failure on
	powerpc
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linuxppc-dev@ozlabs.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Paul Mackerras <paulus@samba.org>
In-Reply-To: <4832AE2B.2060208@linux.vnet.ibm.com>
References: <20080520202706.58791923.sfr@canb.auug.org.au>
	 <4832AE2B.2060208@linux.vnet.ibm.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LLFHNlZaP4xOX1zKXEa+"
Date: Tue, 20 May 2008 22:44:37 +1000
Message-Id: <1211287477.7960.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LLFHNlZaP4xOX1zKXEa+
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-05-20 at 16:25 +0530, Kamalesh Babulal wrote:
> Hi Stephen,
>=20
> The next-20080520 kernel build fails on powerpc, when build the randconfi=
g with
> build error message

>   CC      arch/powerpc/kernel/prom_init.o
>   CALL    arch/powerpc/kernel/prom_init_check.sh
> Error: External symbol 'kernstart_addr' referenced from prom_init.c
> make[1]: *** [prom_init_check] Error 1
> make: *** [arch/powerpc/kernel] Error 2

It's broken in upstream actually, for RELOCATABLE && FLATMEM.

Patch on the way.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-LLFHNlZaP4xOX1zKXEa+
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIMse1dSjSd0sB4dIRAsJJAJ0bhuE4VKu6SoIC/KnVad/0DrzUIwCcCw8d
uHZwZIlAg6VikNCmCg1jWdo=
=gDK1
-----END PGP SIGNATURE-----

--=-LLFHNlZaP4xOX1zKXEa+--

