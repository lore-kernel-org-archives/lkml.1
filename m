Return-Path: <linux-kernel-owner+w=401wt.eu-S1762465AbYFFIW2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762465AbYFFIW2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:22:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753166AbYFFIWP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:22:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52639 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751267AbYFFIWM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:22:12 -0400
Date: Fri, 6 Jun 2008 18:22:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606182206.8bc36f71.sfr@canb.auug.org.au>
In-Reply-To: <20080606010149.4d757b92.akpm@linux-foundation.org>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606175358.a439d1bb.sfr@canb.auug.org.au>
	<20080606010149.4d757b92.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Jun_2008_18_22_06_+1000_3vgIWoBuzzSr00/U"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jun_2008_18_22_06_+1000_3vgIWoBuzzSr00/U
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 6 Jun 2008 01:01:49 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> Well yes - I just bodged it by hand then unbodged it later.  But we
> have a bisection break there.  Admittedly a minor one, unless the bug
> you're bisecting for requires that kprobes be configured.  But it would
> be nice to squish it.
>=20
> I hope Ingo isn't following this
> once-you've-checked-it-in-you-can't-fix-it stupidity :(

Its a break caused by the merge of the ftrace tree into the linux-next
tree (because at the point I merge the ftrace tree, linux-next contains
the rcu tree which has moves stuff into rculist.h), so logically that
patch should become part of the merge commit.  If it was part of the
merge, you could never bisect to a point where you got this build
breakage.

Each tree is fine on its own if you go one step back from the merge.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jun_2008_18_22_06_+1000_3vgIWoBuzzSr00/U
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhI864ACgkQTgG2atn1QN+GzwCcDsddpCjLGZ/+JupcwRk3Kulm
RmoAn3YKNPSQOrkX3XSGXfluJEODEQ5E
=8Ux3
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jun_2008_18_22_06_+1000_3vgIWoBuzzSr00/U--
