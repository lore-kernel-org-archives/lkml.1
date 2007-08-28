Return-Path: <linux-kernel-owner+w=401wt.eu-S1757711AbXH2EKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711AbXH2EKn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2007 00:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751976AbXH2EKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Aug 2007 00:10:33 -0400
Received: from kashary.donpac.ru ([80.254.111.37]:36069 "EHLO
	kashary.donpac.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbXH2EKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2007 00:10:32 -0400
X-Greylist: delayed 61686 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Aug 2007 00:10:31 EDT
Date: Tue, 28 Aug 2007 15:01:54 +0400
From: Andrey Panin <pazke@donpac.ru>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, pazke@donpac.ru,
       linux-visws-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] i386 visws: "extern inline" -> "static inline"
Message-ID: <20070828110154.GA5081@pazke.donpac.ru>
Mail-Followup-To: Adrian Bunk <bunk@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, pazke@donpac.ru,
	linux-visws-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <20070827212819.GW4121@stusta.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Content-Disposition: inline
In-Reply-To: <20070827212819.GW4121@stusta.de>
X-Uname: Linux 2.6.23-rc3 x86_64
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 239, 08 27, 2007 at 11:28:19PM +0200, Adrian Bunk wrote:
> "extern inline" will have different semantics with gcc 4.3.
>=20
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Looks good.

Acked-by: Andrey Panin <pazke@donpac.ru>


> ---
>=20
> This patch has been sent on:
> - 14 Aug 2007
>=20
>  include/asm-i386/mach-visws/cobalt.h  |    8 ++++----
>  include/asm-i386/mach-visws/lithium.h |    8 ++++----
>  2 files changed, 8 insertions(+), 8 deletions(-)
>=20
> e12d2e797af72524f53a0ef3a7dd3cf91f58c542=20
> diff --git a/include/asm-i386/mach-visws/cobalt.h b/include/asm-i386/mach=
-visws/cobalt.h
> index 33c3622..9952588 100644
> --- a/include/asm-i386/mach-visws/cobalt.h
> +++ b/include/asm-i386/mach-visws/cobalt.h
> @@ -94,22 +94,22 @@
>  #define	CO_IRQ_8259	CO_IRQ(CO_APIC_8259)
> =20
>  #ifdef CONFIG_X86_VISWS_APIC
> -extern __inline void co_cpu_write(unsigned long reg, unsigned long v)
> +static inline void co_cpu_write(unsigned long reg, unsigned long v)
>  {
>  	*((volatile unsigned long *)(CO_CPU_VADDR+reg))=3Dv;
>  }
> =20
> -extern __inline unsigned long co_cpu_read(unsigned long reg)
> +static inline unsigned long co_cpu_read(unsigned long reg)
>  {
>  	return *((volatile unsigned long *)(CO_CPU_VADDR+reg));
>  }           =20
>              =20
> -extern __inline void co_apic_write(unsigned long reg, unsigned long v)
> +static inline void co_apic_write(unsigned long reg, unsigned long v)
>  {
>  	*((volatile unsigned long *)(CO_APIC_VADDR+reg))=3Dv;
>  }           =20
>              =20
> -extern __inline unsigned long co_apic_read(unsigned long reg)
> +static inline unsigned long co_apic_read(unsigned long reg)
>  {
>  	return *((volatile unsigned long *)(CO_APIC_VADDR+reg));
>  }
> diff --git a/include/asm-i386/mach-visws/lithium.h b/include/asm-i386/mac=
h-visws/lithium.h
> index d443e68..dfcd4f0 100644
> --- a/include/asm-i386/mach-visws/lithium.h
> +++ b/include/asm-i386/mach-visws/lithium.h
> @@ -29,22 +29,22 @@
>  #define	LI_INTD		0x0080
> =20
>  /* More special purpose macros... */
> -extern __inline void li_pcia_write16(unsigned long reg, unsigned short v)
> +static inline void li_pcia_write16(unsigned long reg, unsigned short v)
>  {
>  	*((volatile unsigned short *)(LI_PCIA_VADDR+reg))=3Dv;
>  }
> =20
> -extern __inline unsigned short li_pcia_read16(unsigned long reg)
> +static inline unsigned short li_pcia_read16(unsigned long reg)
>  {
>  	 return *((volatile unsigned short *)(LI_PCIA_VADDR+reg));
>  }
> =20
> -extern __inline void li_pcib_write16(unsigned long reg, unsigned short v)
> +static inline void li_pcib_write16(unsigned long reg, unsigned short v)
>  {
>  	*((volatile unsigned short *)(LI_PCIB_VADDR+reg))=3Dv;
>  }
> =20
> -extern __inline unsigned short li_pcib_read16(unsigned long reg)
> +static inline unsigned short li_pcib_read16(unsigned long reg)
>  {
>  	return *((volatile unsigned short *)(LI_PCIB_VADDR+reg));
>  }
>=20
>=20

--=20
Andrey Panin		| Linux and UNIX system administrator
pazke@donpac.ru		| PGP key: wwwkeys.pgp.net

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1ACiIWZCBzwS8mkRAkdqAJ0RnrUSQcdvQE9byvGHUD2qeUxnoACcCjXQ
hRfBRHFGJOyT1BLFj/Eq/A8=
=TuuO
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
