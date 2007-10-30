Return-Path: <linux-kernel-owner+w=401wt.eu-S1754181AbXJ3Ntf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181AbXJ3Ntf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 09:49:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbXJ3Nt1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 09:49:27 -0400
Received: from partizan.velesys.com ([213.184.230.195]:57694 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751011AbXJ3Nt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 09:49:26 -0400
Date: Tue, 30 Oct 2007 15:50:38 +0200
From: "Kirill A. Shutemov" <k.shutemov@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Mike Frysinger <vapier.adi@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Unexport several headers and cleanup
Message-ID: <20071030135038.GA2429@localhost.localdomain>
References: <1193742139-29738-1-git-send-email-k.shutemov@gmail.com> <1193748457.2915.163.camel@shinybook.infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FL5UXtIhxfXey3p5"
Content-Disposition: inline
In-Reply-To: <1193748457.2915.163.camel@shinybook.infradead.org>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel 2.6.24-kas-alt1)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--FL5UXtIhxfXey3p5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Tue, 30.10.2007 08:47], David Woodhouse wrote:
> On Tue, 2007-10-30 at 13:02 +0200, Kirill A. Shutemov wrote:
> > This series of patches unexport several unneeded(I guess) headers from=
=20
> > userspace. Patches based on patch posted to linux-kernel@ by Mike Frysi=
nger
> > in July.
>=20
> Looks OK to me, in general. How much userspace have you tested building
> with this? Does it include stuff like gdb?

I have rebuilt gdb-6.6 on x86_64. Ok.

Also, it fix building directfb on ARM. ;)
=20
> Not that I necessarily care about the answer in the normal way -- it's
> just that if userspace will need to adapt, I'd like to get them moving
> ASAP. One option for easing that might be to export stuff like page.h
> but _empty_.

It's bad idea. Taken from directfb:

#if HAVE_ASM_PAGE_H
#include <asm/page.h>
#else
#define PAGE_SIZE   sysconf( _SC_PAGESIZE )
#endif

Other application can use something like this. I think we should drop
empty headers.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--FL5UXtIhxfXey3p5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHJzaubWYnhzC5v6oRAs6FAJ92jjekriYQcfEpkhmgyJYSDSp2VwCfTv3Q
61f1vOU1x+efSF4wlWQFSEo=
=C6kN
-----END PGP SIGNATURE-----

--FL5UXtIhxfXey3p5--
