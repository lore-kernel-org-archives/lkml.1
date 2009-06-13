Return-Path: <linux-kernel-owner+w=401wt.eu-S1756126AbZFMFGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756126AbZFMFGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jun 2009 01:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbZFMFGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Jun 2009 01:06:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32818 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755123AbZFMFGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jun 2009 01:06:38 -0400
Date: Sat, 13 Jun 2009 15:06:34 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
       linux-next@vger.kernel.org, paulus@samba.org,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: origin tree build failure
Message-Id: <20090613150634.3221d74a.sfr@canb.auug.org.au>
In-Reply-To: <20090612141118.GK32105@elte.hu>
References: <20090612102427.32582baa.sfr@canb.auug.org.au>
	<1244768406.7172.1.camel@pasglop>
	<20090612092054.GB32052@elte.hu>
	<1244799197.7172.106.camel@pasglop>
	<20090612125335.GH31845@elte.hu>
	<1244812224.7172.146.camel@pasglop>
	<1244813397.7172.156.camel@pasglop>
	<20090612134940.GD32105@elte.hu>
	<1244815574.7172.171.camel@pasglop>
	<20090612141118.GK32105@elte.hu>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__13_Jun_2009_15_06_34_+1000_2EUVha+RtjHgWiRz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__13_Jun_2009_15_06_34_+1000_2EUVha+RtjHgWiRz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, 12 Jun 2009 16:11:18 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> But that's axiomatic, isnt it? linux-next build-tests PowerPC as the=20
> first in the row of tests - so no change that was in linux-next can=20
> ever cause a build failure on PowerPC, right?

Not really.  I build a powerpc ppc64_defconfig and an x86_64 allmodconfig
between merging most trees.  At the end of the day, I do the following
builds before releasing linux-next:

powerpc allnoconfig
powerpc64 allnoconfig
powerpc ppc44x_defconfig
powerpc allyesconfig
i386 defconfig
sparc64 defconfig
sparc defconfig

Which clearly doesn't cover all possible configs, but is a start and
catches a lot (the powerpc allyesconfig is only 64 bit).

Then after release, linux-next gets built for a lot of architectures and
configs (see http://kisskb.ellerman.id.au/kisskb/branch/9/).  A couple of
people also do randconfig builds which find all sorts of things.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__13_Jun_2009_15_06_34_+1000_2EUVha+RtjHgWiRz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkozM9oACgkQjjKRsyhoI8xBVwCeNVCbILrnRv1ZNcEBWJwr2lbO
3pwAn0PmPtwU7KAQ2sXl8NNi3bYnjxhY
=bu6d
-----END PGP SIGNATURE-----

--Signature=_Sat__13_Jun_2009_15_06_34_+1000_2EUVha+RtjHgWiRz--
