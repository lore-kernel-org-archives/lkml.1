Return-Path: <linux-kernel-owner+w=401wt.eu-S1754681AbXKWGFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754681AbXKWGFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2007 01:05:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752289AbXKWGFE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Nov 2007 01:05:04 -0500
Received: from partizan.velesys.com ([213.184.230.195]:50544 "EHLO
	partizan.velesys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691AbXKWGFD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2007 01:05:03 -0500
Date: Fri, 23 Nov 2007 08:05:44 +0200
From: "Kirill A. Shutemov" <k.shutemov@velesys.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
       Andreas Herrmann <aherrman@arcor.de>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.24-rc3-mm1
Message-ID: <20071123060544.GB28946@localhost.localdomain>
References: <20071120204525.ff27ac98.akpm@linux-foundation.org> <20071122102205.GD7085@localhost.localdomain> <20071122161826.61515a6d.akpm@linux-foundation.org> <alpine.LFD.0.9999.0711230146190.25057@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.0.9999.0711230146190.25057@localhost.localdomain>
X-Operating-System: ALT Linux Sisyphus (20070101) (Kernel
	2.6.18-std-smp-alt8)
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On [Fri, 23.11.2007 01:48], Thomas Gleixner wrote:
> On Thu, 22 Nov 2007, Andrew Morton wrote:
>=20
> > On Thu, 22 Nov 2007 12:22:05 +0200 "Kirill A. Shutemov" <k.shutemov@vel=
esys.com> wrote:
> >=20
> > > On x86_64 'uname -m' return 'x86'.  It break many userspace programs.=
 apt
> > > and rpm for example.
> > >=20
> >=20
> > Yes, there have been various discussions about this.  I think Sam is co=
oking up
> > a fix?
>=20
> http://lkml.org/lkml/2007/11/19/323
>=20
> I push it Linus wards ASAP.
diff --git a/arch/x86/Makefile b/arch/x86/Makefile
index 116b03a..7aa1dc6 100644
--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -11,10 +11,9 @@ endif
 $(srctree)/arch/x86/Makefile%: ;
=20
 ifeq ($(CONFIG_X86_32),y)
+        UTS_MACHINE :=3D i386
         include $(srctree)/arch/x86/Makefile_32
 else
+        UTS_MACHINE :=3D x86_64
         include $(srctree)/arch/x86/Makefile_64
 endif

Many programs expect i686 on Pentium II.

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + Velesys LLC, http://www.velesys.com/
 + ALT Linux Team, http://www.altlinux.com/

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHRm24bWYnhzC5v6oRAiaOAJ9tSNpgDMmK3EaQEAn8hR08lqfjhwCffRnA
jPYzgJVYGudymmv2ecfTZSA=
=GOPU
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
