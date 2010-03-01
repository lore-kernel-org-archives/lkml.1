Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750932Ab0CAIzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:55:43 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40900 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750716Ab0CAIzk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:55:40 -0500
Date: Mon, 1 Mar 2010 19:55:32 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus <torvalds@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>,
       linux-next@vger.kernel.org, Len Brown <lenb@kernel.org>,
       Dave Jones <davej@redhat.com>, Jean Delvare <khali@linux-fr.org>,
       Greg KH <greg@kroah.com>, "J. Bruce Fields" <bfields@fieldses.org>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Sage Weil <sage@newdream.net>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Al Viro <viro@ZenIV.linux.org.uk>, "\"J??rn Engel\"" <joern@logfs.org>
Subject: Re: linux-next: current pending merge fix patches
Message-Id: <20100301195532.d9e5ae64.sfr@canb.auug.org.au>
In-Reply-To: <20100301081021.GB8049@elte.hu>
References: <20100301160445.5e281f11.sfr@canb.auug.org.au>
	<20100301081021.GB8049@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_19_55_32_+1100_p7_lJAmauz8xutPN"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_19_55_32_+1100_p7_lJAmauz8xutPN
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 1 Mar 2010 09:10:21 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> > This could also be taken as a reminder to the respective maintiners tha=
t=20
> > they may want to do a merge of your tree before asking you to pull thei=
rs.
>=20
> I dont think that's generally correct for trivial conflicts: it's better =
if=20
> Linus does the merge of a tree that is based in some stable tree.

In general I agree.  I have singled out these conflict resolutions
because they involve either files not obvious from the conflicts (newly
introduced or chunks of code moved between files), or chunks of code that
are introduced in one tree but need to be modified after the otheris
merged.  So in that sense they are a heads up to Linus because they are
only found after you do the merge and then get a build failure (if you do
the right builds).

So they can be resolved by Linus after he merges the second tree or by
the original maintainer of one of the trees merging/cherrypicking (part
of) the other tree or waiting for Linus to merge the other tree and then
do a merge with Linus' tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_19_55_32_+1100_p7_lJAmauz8xutPN
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLgQQACgkQjjKRsyhoI8z+xACfVinbPfM+8eG3pr2biLHv4TVU
RNEAn1HZLKS7bCitBa6tALXJIGhtRtKU
=zkW7
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_19_55_32_+1100_p7_lJAmauz8xutPN--
