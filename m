Return-Path: <linux-kernel-owner+w=401wt.eu-S1758928AbYFLAFj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928AbYFLAFj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 20:05:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYFLAFc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 20:05:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771AbYFLAFb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 20:05:31 -0400
Date: Thu, 12 Jun 2008 10:05:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: ldp/staging/driver-core (Was: Re: linux-next: Tree for June 11)
Message-Id: <20080612100520.43c39e3d.sfr@canb.auug.org.au>
In-Reply-To: <20080611185527.GB5516@kroah.com>
References: <20080611193840.08a35b14.sfr@canb.auug.org.au>
	<20080611185527.GB5516@kroah.com>
X-Mailer: Sylpheed 2.5.0rc2 (GTK+ 2.12.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Jun_2008_10_05_20_+1000_ortR5Z5nq5gn0HaG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Jun_2008_10_05_20_+1000_ortR5Z5nq5gn0HaG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Wed, 11 Jun 2008 11:55:27 -0700 Greg KH <greg@kroah.com> wrote:
>
> On Wed, Jun 11, 2008 at 07:38:40PM +1000, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Changes since next-20080610:
> >=20
> > Dropped trees (temporary): ldp (it is unfetchable - probably something =
to
> > do with the new Staging tree), block (it just has too many conflicts and
> > breaks the powerpc build).
>=20
> Yes, I've dropped "ldp" from my 'gregkh' set of patches/trees, they
> should be pulled in from the -staging tree, which would be great if you
> could add to the end of the -next tree.

I was under the impression that the stuff in the ldp tree was for
inclusion in 2.6.27.  If so, then that tree should still exist (for
inclusion in linux-next) or the drivers that were in the ldp tree should
be included in some other tree(s) that is (are) included in linux-next
(Staging is for stuff that isn't ready yet, right?).

I will try to figure out what I think about Staging today.

> I've also removed some of the larger patches in the driver-core tree
> that were causing you merge/build errors, they should be all resolved
> now.

Thanks, but a better plan (which I hope you and Kay have considered) is
to break up the ones that only depeneded on dev_name and dev_set_name and
send the parts to the appropriate subsystems (since dev_name and
dev_set_name) are both in upstream now).

/me teaches grandma how to suck eggs :-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Jun_2008_10_05_20_+1000_ortR5Z5nq5gn0HaG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhQaEAACgkQTgG2atn1QN9HKgCeIjHfq0vDX58aznhwu875RkeU
2wEAn04Prnc0Gfx76JsTz35LVDeXgaCG
=769z
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Jun_2008_10_05_20_+1000_ortR5Z5nq5gn0HaG--
