Return-Path: <linux-kernel-owner+w=401wt.eu-S1755396AbYH0XVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755396AbYH0XVp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 19:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753563AbYH0XVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 19:21:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:38423 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346AbYH0XVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 19:21:34 -0400
Date: Thu, 28 Aug 2008 09:21:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Howells <dhowells@redhat.com>
Cc: Artem Bityutskiy <dedekind@yandex.ru>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       Tony Luck <tony.luck@intel.com>, linux-ia64@vger.kernel.org
Subject: Re: [PATCH 01/59] CRED: Wrap task credential accesses in the IA64
 arch
Message-Id: <20080828092120.b9b198bb.sfr@canb.auug.org.au>
In-Reply-To: <25475.1219850678@redhat.com>
References: <48B56ADA.8010808@yandex.ru>
	<20080827134541.19980.61042.stgit@warthog.procyon.org.uk>
	<20080827134547.19980.38813.stgit@warthog.procyon.org.uk>
	<25475.1219850678@redhat.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Aug_2008_09_21_20_+1000_X_XPTG5ZPJHlSZRb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Aug_2008_09_21_20_+1000_X_XPTG5ZPJHlSZRb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David, Artem,

On Wed, 27 Aug 2008 16:24:38 +0100 David Howells <dhowells@redhat.com> wrot=
e:
>
> Artem Bityutskiy <dedekind@yandex.ru> wrote:
>=20
> > Fine with me.
>=20
> Can I count that as an Acked-by?
>=20
> > Do you want us to put this patch to ubifs-2.6.git or you
> > prefer to make it go together with the rest of the CRED patches?
>=20
> Ummm...  I'll check.  I'm not sure exactly how Stephen wanted to play thi=
s.

I am happy for these patches to go into both the subsystem and creds
trees (the mess - if any - will be on my head).  I do expect this to
reduce conflicts in the longer term.

It is much better for that to happen than for a subsystem maintainer to
apply a slightly different fixup when I find a conflict.  If there is not
conflict between the subsystem tree and the creds tree, then it doesn't
matter if the patch is in both trees or not.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Aug_2008_09_21_20_+1000_X_XPTG5ZPJHlSZRb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki14XAACgkQjjKRsyhoI8zPDwCfZJgXfWVihB1ZyDKMmnzfmyQi
JzAAoJjY/iI3TWx9UAkKoRzvU4NVrSpX
=2qhH
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Aug_2008_09_21_20_+1000_X_XPTG5ZPJHlSZRb--
