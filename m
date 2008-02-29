Return-Path: <linux-kernel-owner+w=401wt.eu-S1760095AbYB2MqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760095AbYB2MqR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Feb 2008 07:46:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756200AbYB2Mp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Feb 2008 07:45:59 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46167 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756133AbYB2Mp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:45:58 -0500
Date: Fri, 29 Feb 2008 23:45:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk+lkml@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
       linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: Announce: Linux-next (Or Andrew's dream  :-))
Message-Id: <20080229234551.d8023f5c.sfr@canb.auug.org.au>
In-Reply-To: <20080226145418.59f6f35f.sfr@canb.auug.org.au>
References: <20080212120208.f7168a91.sfr@canb.auug.org.au>
	<20080216000943.GD31474@flint.arm.linux.org.uk>
	<20080226145418.59f6f35f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_23_45_51_+1100_o.PBsxuu6TWn4Lhc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_23_45_51_+1100_o.PBsxuu6TWn4Lhc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

On Tue, 26 Feb 2008 14:54:18 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Sat, 16 Feb 2008 00:09:43 +0000 Russell King <rmk+lkml@arm.linux.org.u=
k> wrote:
> >
> > As mentioned elsewhere, what we need for ARM is to extend the kautobuild
> > infrastructure (see armlinux.simtec.co.uk) so that we can have more tre=
es
> > at least compile tested regularly - but that requires the folk there to
> > have additional compute power (which isn't going to happen unless folk
> > stamp up some machines _or_ funding).
>=20
> I now have an arm cross compiler (gcc-4.0.2-glibc-2.3.6
> arm-unknown-linux-gnu).  (See the results page at
> http://kisskb.ellerman.id.au/kisskb/branch/9/ - I must get a better
> name/place :-(.)  Is this sufficient to help you out?  What configs would
> be useful to build (as Andrew said, they don't take very long each).
>=20
> I really want as many subsystems as possible in the linux-next tree in an
> attempt to avoid some of the merge/conflict problems we have had in the
> past.  What can we do to help?

OK, I tried this out:  I built all 75 arm defconfigs with the cross
compiler above (the resulting log file is at
http://ozlabs.org/~sfr/armall.log.bz2). 17 failed (I don't know why - I
didn't even really look).  If this is useful, I can get this added to our
infrastructure so that every linux-next kernel (and others as well, maybe)
will be built for all these.

Would that help, Russell?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

P.S. From the timestamps in the log file you can see that this would take
around an hour each time.

--Signature=_Fri__29_Feb_2008_23_45_51_+1100_o.PBsxuu6TWn4Lhc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx/6FTgG2atn1QN8RAuyGAJ40XK0RD5z7FspuH1nQ3R/OyVKZPwCdFdC4
CRVi1Je22fRu5t9WwChYzZQ=
=qmpE
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_23_45_51_+1100_o.PBsxuu6TWn4Lhc--
