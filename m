Return-Path: <linux-kernel-owner+w=401wt.eu-S1757665AbXKUSeT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757665AbXKUSeT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 13:34:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbXKUSeK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 13:34:10 -0500
Received: from partizan.velesys.com ([213.184.230.195]:65297 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbXKUSeI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 13:34:08 -0500
Date: Wed, 21 Nov 2007 20:35:13 +0200
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Dave Young <hidave.darkstar@gmail.com>, linux-kernel@vger.kernel.org,
       Avi Kivity <avi@qumranet.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
Message-ID: <20071121183513.GB4280@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <a8e1da0711202151t6c9d52acjf1f876085b95dfce@mail.gmail.com> <20071120220046.db5c8fde.akpm@linux-foundation.org> <a8e1da0711202203v6a2a9945pcfa5cfe67b83b504@mail.gmail.com> <20071120221552.1f42ebfa.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QTprm0S8XgL7H0Dt"
Content-Disposition: inline
In-Reply-To: <20071120221552.1f42ebfa.akpm@linux-foundation.org>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel 2.6.24-kas-alt1)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--QTprm0S8XgL7H0Dt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Tue, 20.11.2007 22:15], Andrew Morton wrote:
> On Wed, 21 Nov 2007 14:03:34 +0800 "Dave Young" <hidave.darkstar@gmail.co=
m> wrote:
>=20
> > On Nov 21, 2007 2:00 PM, Andrew Morton <akpm@linux-foundation.org> wrot=
e:
> > >
> > > On Wed, 21 Nov 2007 13:51:47 +0800 "Dave Young" <hidave.darkstar@gmai=
l.com> wrote:
> > >
> > > > Hi, andrew
> > > >
> > > > modpost failed for me:
> > > >   MODPOST 360 modules
> > > > ERROR: "empty_zero_page" [drivers/kvm/kvm.ko] undefined!
> > > > make[1]: *** [__modpost] Error 1
> > > > make: *** [modules] Error 2
> > > >
> > >
> > > You're a victim of the hasty unexporting fad.  Which architecture?
> > > x86_64 I guess?
> > >
> > Hi,
> > ia32 instead.
> >=20
>=20
> oic.  Like this, I guess.
>=20
> --- a/arch/x86/kernel/i386_ksyms_32.c~git-x86-i386-export-empty_zero_page
> +++ a/arch/x86/kernel/i386_ksyms_32.c
> @@ -2,6 +2,7 @@
>  #include <asm/semaphore.h>
>  #include <asm/checksum.h>
>  #include <asm/desc.h>
> +#include <asm/pgtable.h>
> =20
>  EXPORT_SYMBOL(__down_failed);
>  EXPORT_SYMBOL(__down_failed_interruptible);
> @@ -22,3 +23,4 @@ EXPORT_SYMBOL(__put_user_8);
>  EXPORT_SYMBOL(strstr);
> =20
>  EXPORT_SYMBOL(csum_partial);
> +EXPORT_SYMBOL(empty_zero_page);
> _

Symbol init_level4_pgt is needed by nvidia module. Is it really need to=20
unexport it?

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--QTprm0S8XgL7H0Dt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRHphbWYnhzC5v6oRAkBlAJ45wue5EV6PFDNrVVPiVnt/p3CshwCfbUWm
vMOU/51T/CW4rTjCjMDQFAA=
=wpPH
-----END PGP SIGNATURE-----

--QTprm0S8XgL7H0Dt--
