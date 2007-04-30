Return-Path: <linux-kernel-owner+w=401wt.eu-S1030503AbXD3LHh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030503AbXD3LHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 07:07:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030678AbXD3LHh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 07:07:37 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:44138 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030503AbXD3LHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 07:07:35 -0400
Subject: Re: [patches] [PATCH] [19/40] i386: fix paravirt-documentation
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Andi Kleen <ak@suse.de>
Cc: jeremy@goop.org, patches@x86-64.org, linux-kernel@vger.kernel.org
In-Reply-To: <20070430102752.F2EFE151CA@wotan.suse.de>
References: <200704301227.598020000@suse.de>
	 <20070430102752.F2EFE151CA@wotan.suse.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-wNOK9IKXukTo/uOZKU5z"
Date: Mon, 30 Apr 2007 21:07:38 +1000
Message-Id: <1177931258.7652.262.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-wNOK9IKXukTo/uOZKU5z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Mon, 2007-04-30 at 12:27 +0200, Andi Kleen wrote:
> From: Jeremy Fitzhardinge <jeremy@goop.org>
> Remove #defines, add enum for PARAVIRT_LAZY_FLUSH.
>=20
> Signed-off-by: Jeremy Fitzhardinge <jeremy@xensource.com>
> Signed-off-by: Andi Kleen <ak@suse.de>
>=20
> ---
>  include/asm-i386/paravirt.h |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> Index: linux/include/asm-i386/paravirt.h
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux.orig/include/asm-i386/paravirt.h
> +++ linux/include/asm-i386/paravirt.h
> @@ -30,6 +30,7 @@ enum paravirt_lazy_mode {
>  	PARAVIRT_LAZY_NONE =3D 0,
>  	PARAVIRT_LAZY_MMU =3D 1,
>  	PARAVIRT_LAZY_CPU =3D 2,
> +	PARAVIRT_LAZY_FLUSH =3D 3,
>  };
> =20
>  struct paravirt_ops
> @@ -1036,12 +1037,6 @@ static inline pte_t raw_ptep_get_and_cle
>  }
>  #endif	/* CONFIG_X86_PAE */
> =20
> -/* Lazy mode for batching updates / context switch */
> -#define PARAVIRT_LAZY_NONE 0
> -#define PARAVIRT_LAZY_MMU  1
> -#define PARAVIRT_LAZY_CPU  2
> -#define PARAVIRT_LAZY_FLUSH 3
> -
>  #define  __HAVE_ARCH_ENTER_LAZY_CPU_MODE
>  static inline void arch_enter_lazy_cpu_mode(void)
>  {

Is the subject for this right?

Regards,

Nigel

--=-wNOK9IKXukTo/uOZKU5z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGNc36N0y+n1M3mo0RAjLBAKDt0xOz9Th1NCZ/lI/p5cvdlkxHmgCfbBmJ
6V9bXGXzXz68ml1aD8xi8kI=
=1+xE
-----END PGP SIGNATURE-----

--=-wNOK9IKXukTo/uOZKU5z--

