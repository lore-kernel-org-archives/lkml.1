Return-Path: <linux-kernel-owner+w=401wt.eu-S1754479AbZJRMhw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754479AbZJRMhw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Oct 2009 08:37:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZJRMhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Oct 2009 08:37:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59183 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753303AbZJRMhv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Oct 2009 08:37:51 -0400
Date: Sun, 18 Oct 2009 23:37:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Blanchard <anton@samba.org>
Cc: benh@kernel.crashing.org, mingo@elte.hu, paulus@samba.org,
       a.p.zijlstra@chello.nl, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] powerpc: Create PPC_WARN_ALIGNMENT to match
 PPC_WARN_EMULATED
Message-Id: <20091018233749.0a17ff78.sfr@canb.auug.org.au>
In-Reply-To: <20091018111126.GL4808@kryten>
References: <20091018110929.GK4808@kryten>
	<20091018111126.GL4808@kryten>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__18_Oct_2009_23_37_49_+1100_hhor9XLfdVfYPguI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__18_Oct_2009_23_37_49_+1100_hhor9XLfdVfYPguI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

On Sun, 18 Oct 2009 22:11:26 +1100 Anton Blanchard <anton@samba.org> wrote:
>
> @@ -66,8 +66,12 @@ extern void ppc_warn_emulated_print(cons
> =20
>  #else /* !CONFIG_PPC_EMULATED_STATS */
> =20
> -#define PPC_WARN_EMULATED(type)	do { } while (0)
> +#define __PPC_WARN_EMULATED(type)	do { } while (0)
> +#define __PPC_WARN_ALIGNMENT(type)	do { } while (0)

I think this last line is not needed?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__18_Oct_2009_23_37_49_+1100_hhor9XLfdVfYPguI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrbDB0ACgkQjjKRsyhoI8xEIQCggsBJxLWjQl03PpJo4bGUJZOl
1WMAn3KZuaX751h1SrDhXxiJBnDmY/l9
=TRv2
-----END PGP SIGNATURE-----

--Signature=_Sun__18_Oct_2009_23_37_49_+1100_hhor9XLfdVfYPguI--
