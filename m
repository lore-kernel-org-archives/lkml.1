Return-Path: <linux-kernel-owner+w=401wt.eu-S1757362AbZANOB6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbZANOB6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2009 09:01:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751486AbZANOBu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Jan 2009 09:01:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39611 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243AbZANOBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2009 09:01:49 -0500
Date: Thu, 15 Jan 2009 01:01:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] Kernel memory leak detector
Message-Id: <20090115010141.42e1dfc5.sfr@canb.auug.org.au>
In-Reply-To: <1231936220.24082.11.camel@pc1117.cambridge.arm.com>
References: <20081219181255.7778.52219.stgit@pc1117.cambridge.arm.com>
	<20090108144538.e5195575.akpm@linux-foundation.org>
	<1231753866.10982.11.camel@pc1117.cambridge.arm.com>
	<20090112022138.bd2e6ce4.akpm@linux-foundation.org>
	<20090112213339.feefdd02.sfr@canb.auug.org.au>
	<1231936220.24082.11.camel@pc1117.cambridge.arm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Jan_2009_01_01_41_+1100_BvryWY3BzLdrJtey"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Jan_2009_01_01_41_+1100_BvryWY3BzLdrJtey
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catalin,

On Wed, 14 Jan 2009 12:30:20 +0000 Catalin Marinas <catalin.marinas@arm.com=
> wrote:
>
> I updated the git://linux-arm.org/linux-2.6.git kmemleak branch to the
> latest mainline and it works fine. However, I tried to merge it with the
> linux-next tree and there are many conflicts with kmemtrace as they both
> modify similar areas of the kernel. The conflicts are relatively simple
> but they still need manual fixing.

I just did a test merge with today's linux-next and though thee are a few
conflicts, it is not to much for me to handle - I have had worse :-)

> Are you OK with applying patches to linux-next (git am) rather than
> using git merge? This way I can rebase kmemleak on top of linux-next.

I would much prefer a few conflicts to carrying a post linux-next patch
because linux-next can change radically day to day - especially since we
know there will be clashes in the areas of files you would be patching.

So lets use the above git tree and see how we go. OK?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Jan_2009_01_01_41_+1100_BvryWY3BzLdrJtey
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklt8EUACgkQjjKRsyhoI8xaOgCguj4CoGb/APooVBLXFJjUAw+y
cJ0AoK0BAIKOAgmka+d7qtEd16Xi/eCE
=YmkC
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Jan_2009_01_01_41_+1100_BvryWY3BzLdrJtey--
