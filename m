Return-Path: <linux-kernel-owner+w=401wt.eu-S1752301AbZGGFoH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752301AbZGGFoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:44:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751253AbZGGFn5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:43:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34479 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751223AbZGGFn4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:43:56 -0400
Date: Tue, 7 Jul 2009 15:43:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: sfi-devel@simplefirmware.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: linux-next: sfi tree build failure
Message-Id: <20090707154353.628365ac.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
References: <20090630171937.75f64662.sfr@canb.auug.org.au>
	<20090706161432.111a42ee.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.0907062348130.32467@localhost.localdomain>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__7_Jul_2009_15_43_53_+1000_NjajdOm_5Qw/XF/N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__7_Jul_2009_15_43_53_+1000_NjajdOm_5Qw/XF/N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 07 Jul 2009 00:01:13 -0400 (EDT) Len Brown <lenb@kernel.org> wrote:
>=20
> > On Tue, 30 Jun 2009 17:19:37 +1000 Stephen Rothwell <sfr@canb.auug.org.=
au> wrote:
> > >
> > > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> > >=20
> > > In file included from include/acpi/platform/acenv.h:141,
> > >                  from include/acpi/acpi.h:56,
> > >                  from include/linux/acpi.h:38,
> > >                  from init/main.c:27:
> > > include/acpi/platform/aclinux.h:64:22: error: asm/acpi.h: No such fil=
e or directory
> ...
> > > I have dropped the sfi tree for today.
> >=20
> > And the sfi tree has still not made it into linux-next as the above err=
or
> > still exists.
>=20
> Sorry about breaking the PPC build, Stephen.
>=20
> I screwed up in my hack attempt to support CONFIG_SFI=3Dy && CONFIG_ACPI=
=3Dn.
>=20
> Let me know if you have any trouble with the latest SFI test tree.

I still get the same error.  Note that asm/acpi.h is being included from
include/acpi/platform/aclinux.h
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__7_Jul_2009_15_43_53_+1000_NjajdOm_5Qw/XF/N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpS4JkACgkQjjKRsyhoI8w+zgCeKUvr0GD9PpzhXGZdSLOP+OPP
pg0AnippiBYYwlpucx1lEEm2DOgEBaZM
=jMR7
-----END PGP SIGNATURE-----

--Signature=_Tue__7_Jul_2009_15_43_53_+1000_NjajdOm_5Qw/XF/N--
