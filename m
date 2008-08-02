Return-Path: <linux-kernel-owner+w=401wt.eu-S1755816AbYHBCjQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816AbYHBCjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 22:39:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752460AbYHBCjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 22:39:00 -0400
Received: from ozlabs.org ([203.10.76.45]:42588 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752224AbYHBCi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 22:38:59 -0400
Subject: Re: [PATCH 01/10] powerpc: Remove use of CONFIG_PPC_MERGE
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Kumar Gala <galak@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
References: <1217609060-6381-1-git-send-email-galak@kernel.crashing.org>
	 <1217609060-6381-2-git-send-email-galak@kernel.crashing.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-gte7aeuhcvy2dDoq8wmW"
Date: Sat, 02 Aug 2008 12:38:55 +1000
Message-Id: <1217644735.7471.21.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-gte7aeuhcvy2dDoq8wmW
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2008-08-01 at 11:44 -0500, Kumar Gala wrote:
> Now that arch/ppc is gone we don't need CONFIG_PPC_MERGE anymore remove
> the dead code associated with !CONFIG_PPC_MERGE out of arch/powerpc
> and include/asm-powerpc.
...

> diff --git a/include/asm-powerpc/irq.h b/include/asm-powerpc/irq.h
> index 1ef8e30..a372f76 100644
> --- a/include/asm-powerpc/irq.h
> +++ b/include/asm-powerpc/irq.h
...
> -#define	SIU_INT_PC4		((uint)0x3b + CPM_IRQ_OFFSET)
> -#define	SIU_INT_PC3		((uint)0x3c + CPM_IRQ_OFFSET)
> -#define	SIU_INT_PC2		((uint)0x3d + CPM_IRQ_OFFSET)
> -#define	SIU_INT_PC1		((uint)0x3e + CPM_IRQ_OFFSET)
> -#define	SIU_INT_PC0		((uint)0x3f + CPM_IRQ_OFFSET)
> -
> -#endif /* CONFIG_8260 */
> -
> -#endif /* Whatever way too big #ifdef */

I'll miss that one, it made me laugh once.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-gte7aeuhcvy2dDoq8wmW
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIk8i/dSjSd0sB4dIRAjeYAKCU1v8vtlSf7QByuH4UIS5miqlj1wCfQqdT
N9GPVyPZpispBPWwV5Bc178=
=YVPV
-----END PGP SIGNATURE-----

--=-gte7aeuhcvy2dDoq8wmW--

