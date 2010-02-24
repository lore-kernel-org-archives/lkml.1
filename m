Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755478Ab0BXHZw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 02:25:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58554 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755422Ab0BXHZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 02:25:51 -0500
Date: Wed, 24 Feb 2010 18:25:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next requirements
Message-Id: <20100224182540.918b48b0.sfr@canb.auug.org.au>
In-Reply-To: <20100223084552.GB17617@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
	<20100222203319.8bd497a2.sfr@canb.auug.org.au>
	<20100222102745.GJ20844@elte.hu>
	<20100222224752.0cbd5807.sfr@canb.auug.org.au>
	<20100223084552.GB17617@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__24_Feb_2010_18_25_40_+1100_gl3s4g2eJ6gHaGNY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Feb_2010_18_25_40_+1100_gl3s4g2eJ6gHaGNY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[I have removed linux-tip-commits from the cc list]

Hi Ingo,

On Tue, 23 Feb 2010 09:45:52 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> Developers simply cannot be expected to build for 22 architectures, and t=
hey=20
> shouldnt be.

I have agreed with this point of yours several times.  Why do you keep
stating it?

> The thing is, last i checked you didnt even _test_ x86 as the first step =
in=20
> your linux-next build tests. Most of your generic build bug reports are=20
> against PowerPC. They create the appearance that x86 is a second class ci=
tizen=20
> in linux-next.

Lets see.  Over the last 60 days, I have reported 37 build errors.  Of
these, 16 were reported against x86, 14 against ppc, 7 against other
archs.  Of the ppc reports, 10 would not affect x86 builds (due to being
ppc specific problems or dependencies on implicit includes that do happen on
x86).  None of the reports against other arches would affect x86 builds.

I also reported 31 warnings.  15 against x86, 15 against ppc and 1 against
both.  Of those only reported against ppc, 13 did not affect x86.

So of my "generic" reports, 4 errors and 2 warnings were reported against
ppc, 16 errors and 15 warnings again x86.

Also, I am not sure how reports of 37 build errors and 32 warnings over
60 days can tax the resources of our developer base.  Most of these are
fairly trivial to fix (as is shown by how quick they are fixed.  Usually
the developer has just forgotten to test the !CONFIG_SOMETHING case or
used some function without explicitly including the file that declares it.

As to my perceived pro-PowerPC and anti-x86 bias, you are the only one who
has even mentioned it to me.

Anyway, I sick of these discussions.  If people see the way I do
linux-next as a problem, then they can find someone else.  That is not
the impression I gained at the Kernel Summit and (apart from these
occasional "discussions") I am quite happy to continue.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__24_Feb_2010_18_25_40_+1100_gl3s4g2eJ6gHaGNY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuE1HQACgkQjjKRsyhoI8x1pACglYmuV96kubBTzaIHKfOOQH3p
UzYAnjUPiYowTnV5nLWGKVQsY7WTAFc/
=3vJQ
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Feb_2010_18_25_40_+1100_gl3s4g2eJ6gHaGNY--
