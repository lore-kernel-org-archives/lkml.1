Return-Path: <linux-kernel-owner+w=401wt.eu-S1753241AbZFEA6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241AbZFEA6y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jun 2009 20:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZFEA6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Jun 2009 20:58:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45228 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751364AbZFEA6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jun 2009 20:58:45 -0400
Date: Fri, 5 Jun 2009 10:58:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem.Bityutskiy@nokia.com
Cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Dmitry Pervushin <dpervushin@embeddedalley.com>
Subject: Re: linux-next: ubi tree build failure
Message-Id: <20090605105842.de948d0b.sfr@canb.auug.org.au>
In-Reply-To: <4A265DF6.3070602@nokia.com>
References: <20090603184408.49c7fb1f.sfr@canb.auug.org.au>
	<4A265DF6.3070602@nokia.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Jun_2009_10_58_42_+1000_C28lS8+=phlo8GoO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Jun_2009_10_58_42_+1000_C28lS8+=phlo8GoO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

On Wed, 03 Jun 2009 14:26:46 +0300 Artem Bityutskiy <Artem.Bityutskiy@nokia=
.com> wrote:
>
> Stephen Rothwell wrote:
> > Today's linux-next build (powerpc ppc44x_defconfig) failed like this:
> >=20
> > drivers/mtd/ubi/gluebi.c: In function 'gluebi_get_device':
> > drivers/mtd/ubi/gluebi.c:126: error: implicit declaration of function '=
IS_ERR'
> > drivers/mtd/ubi/gluebi.c:129: error: implicit declaration of function '=
PTR_ERR'
>=20
> It is strange that I do not see these errors on my x86_86

The above was a build for a 32 bit powerpc platform.  This is an instance
of a general issue when an API is used without explicitly including the
header files that define the API.  The needed header file may be included
by some convoluted path that depends on the architecture being built or
even the particular configuration.

> Any suggestions what I could do to reproduce the build issues?
> I'll try at least now to build this on x86 (32-bit).=20

Always directly include the header files for APIs you use ...

I see that this particular problem is now fixed, thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Jun_2009_10_58_42_+1000_C28lS8+=phlo8GoO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoobcIACgkQjjKRsyhoI8wQSwCgqpoTK7xf/oZmBv8vm0yorBLB
vhwAnignMO+1LPpU1xWqwNUAM+Tl7eLp
=Gg+Y
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Jun_2009_10_58_42_+1000_C28lS8+=phlo8GoO--
