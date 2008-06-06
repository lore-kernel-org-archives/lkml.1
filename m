Return-Path: <linux-kernel-owner+w=401wt.eu-S1764522AbYFFI3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764522AbYFFI3b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 04:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759556AbYFFI3I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 04:29:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48156 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568AbYFFI3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 04:29:05 -0400
Date: Fri, 6 Jun 2008 18:28:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606182858.60490e47.sfr@canb.auug.org.au>
In-Reply-To: <20080606082325.GA10826@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
	<20080606072536.GA19334@elte.hu>
	<20080606003327.9ac0e91b.akpm@linux-foundation.org>
	<20080606074137.GA28962@elte.hu>
	<20080606004743.a78180c3.akpm@linux-foundation.org>
	<20080606082325.GA10826@elte.hu>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Jun_2008_18_28_58_+1000_dDSE69frW00/Ecm8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jun_2008_18_28_58_+1000_dDSE69frW00/Ecm8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jun 2008 10:23:25 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> hm, which commit is this exactly? I've never hit it myself in bisection=20
> (and there are days when i bisect -tip several times). We'll respin=20
> tip/tracing/mmiotrace if it's bisection-hostile. You can probably nudge=20
> it into building via "git-bisect next".

See my other email.  This is because the ftrace tree does not merge well
with the rcu tree.

I may start merging such build breakage fixes into the actual merge
commits that cause them.  That will make linux-next more bisectable, but
means I have to remember that I did it for Linus' sake.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jun_2008_18_28_58_+1000_dDSE69frW00/Ecm8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhI9UoACgkQTgG2atn1QN8TsgCdHa5kJFDPfB+pID6L+a0TWSjX
PUQAnjvR/aa/6RqBPLRWJWVb7HMNNuxN
=pDow
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jun_2008_18_28_58_+1000_dDSE69frW00/Ecm8--
