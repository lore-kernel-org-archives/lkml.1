Return-Path: <linux-kernel-owner+w=401wt.eu-S1754164AbZHCBbE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbZHCBbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 21:31:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754119AbZHCBbE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 21:31:04 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53272 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754059AbZHCBbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 21:31:03 -0400
Date: Mon, 3 Aug 2009 11:30:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "NeilBrown" <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Andre Noll" <maan@systemlinux.org>
Subject: Re: linux-next:  tree build failure
Message-Id: <20090803113058.3b6b59cf.sfr@canb.auug.org.au>
In-Reply-To: <7f7d2d5828c15f1fe8221554f661903e.squirrel@neil.brown.name>
References: <20090803103550.9b28900a.sfr@canb.auug.org.au>
	<7f7d2d5828c15f1fe8221554f661903e.squirrel@neil.brown.name>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__3_Aug_2009_11_30_58_+1000_suSjTqgHdJiY6SxG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__3_Aug_2009_11_30_58_+1000_suSjTqgHdJiY6SxG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

On Mon, 3 Aug 2009 11:01:24 +1000 (EST) "NeilBrown" <neilb@suse.de> wrote:
>
> On Mon, August 3, 2009 10:35 am, Stephen Rothwell wrote:
> >
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> >
> > ERROR: ".md_integrity_add_rdev" [drivers/md/multipath.ko] undefined!
> >
> > Caused by commit 66f4f3f41f5c334f399e920b2aaad9b82514acda ("md: Push do=
wn
> > data integrity code to personalities") from the md-current and md trees.
> > Looks like md_integrity_add_rdev needs an EXPORT_SYMBOL.
>=20
> Yes, of course...
> Thanks!
> Fixed.

OK, so I refetched the md tree and will use it today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__3_Aug_2009_11_30_58_+1000_suSjTqgHdJiY6SxG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp2PdIACgkQjjKRsyhoI8yoqgCcCkcjlK+RpREGY7jZr4ktGfH2
KgoAn2jbX2tYD1XxbsFROGg99qD1scP4
=f9aQ
-----END PGP SIGNATURE-----

--Signature=_Mon__3_Aug_2009_11_30_58_+1000_suSjTqgHdJiY6SxG--
