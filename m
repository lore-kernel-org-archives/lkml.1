Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0BVJdb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Feb 2010 04:33:31 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41660 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab0BVJda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Feb 2010 04:33:30 -0500
Date: Mon, 22 Feb 2010 20:33:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       roland@redhat.com, suresh.b.siddha@intel.com, tglx@linutronix.de,
       hjl.tools@gmail.com, linux-tip-commits@vger.kernel.org
Subject: linux-next requiements (Was: Re: [tip:x86/ptrace] ptrace: Add
 support for generic PTRACE_GETREGSET/PTRACE_SETREGSET)
Message-Id: <20100222203319.8bd497a2.sfr@canb.auug.org.au>
In-Reply-To: <20100222090710.GA31357@elte.hu>
References: <20100211195614.886724710@sbs-t61.sc.intel.com>
	<tip-2225a122ae26d542bdce523d9d87a4a7ba10e07b@git.kernel.org>
	<20100222090710.GA31357@elte.hu>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Feb_2010_20_33_19_+1100_N5YSiwMVWfv1sCJ0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Feb_2010_20_33_19_+1100_N5YSiwMVWfv1sCJ0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Mon, 22 Feb 2010 10:07:10 +0100 Ingo Molnar <mingo@elte.hu> wrote:
>
> I'll keep them in tip:master to get them tested, but note that i cannot p=
ush=20
> any of these patches into linux-next until this is fixed, as linux-next=20
> requires all architectures to build, with no regard to which architecture=
s are=20
> tested by kernel testers in practice.

I merely expect people not to push known broken code into linux-next.
linux-next breaks on all sorts of architectures all the time (check
http://kisskb.ellerman.id.au/kisskb/branch/9/).  One of the reasons
linux-next exists is so that all kernel developers don't have to build
test on all architectures all the time.  (And, yes, I know that linux-next
doesn't build all architectures or all configs.)

That being said, I will complain about breakages on some architectures
more than others since they are in my personal builds (as opposed to the
over night builds).

That being said (:-)), I am sure that the PARISC guys would appreciate
the original problem being fixed.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Feb_2010_20_33_19_+1100_N5YSiwMVWfv1sCJ0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuCT18ACgkQjjKRsyhoI8zvngCeLq6wtpA2Jh85DcFbLMktDgm7
6skAoJfZ+GslAE6f21SCP5Rl2dXzrr/T
=oOdT
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Feb_2010_20_33_19_+1100_N5YSiwMVWfv1sCJ0--
