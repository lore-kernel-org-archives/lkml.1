Return-Path: <linux-kernel-owner+w=401wt.eu-S1751791AbXEXQbh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751791AbXEXQbh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 12:31:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750733AbXEXQba
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 12:31:30 -0400
Received: from mail.gmx.net ([213.165.64.20]:56600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750771AbXEXQb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 12:31:29 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19z/8NZP+dzD5Ei2hcV6Il/IsFZG379nRj9aSuHu4
	4hpTfflS8xAmn2
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Alexey Dobriyan <adobriyan@sw.ru>
Subject: Re: [PATCH] Fix vmi.c compilation
Date: Thu, 24 May 2007 18:31:26 +0200
User-Agent: KMail/1.9.5
Cc: akpm@osdl.org, linux-kernel@vger.kernel.org
References: <20070524135432.GA32643@localhost.sw.ru>
In-Reply-To: <20070524135432.GA32643@localhost.sw.ru>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1608022.PSzeAdSzHO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705241831.26605.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1608022.PSzeAdSzHO
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

That change solves the issue :-)

Am Donnerstag, 24. Mai 2007 15:54 schrieb Alexey Dobriyan:
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> ---
>=20
>  arch/i386/kernel/vmi.c |    1 +
>  1 file changed, 1 insertion(+)
>=20
> --- a/arch/i386/kernel/vmi.c
> +++ b/arch/i386/kernel/vmi.c
> @@ -27,6 +27,7 @@ #include <linux/cpu.h>
>  #include <linux/bootmem.h>
>  #include <linux/mm.h>
>  #include <linux/highmem.h>
> +#include <linux/sched.h>
>  #include <asm/vmi.h>
>  #include <asm/io.h>
>  #include <asm/fixmap.h>
>=20

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart1608022.PSzeAdSzHO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGVb3ehyrlCH22naMRAoB9AJwKu99zQeEiqBSYvb/2zsv9hTYUMACePL8R
1UI2VmyyA1+elgdstmEDAx8=
=40zq
-----END PGP SIGNATURE-----

--nextPart1608022.PSzeAdSzHO--
