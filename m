Return-Path: <linux-kernel-owner+w=401wt.eu-S1760875AbYECHqR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760875AbYECHqR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 03:46:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751812AbYECHqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 03:46:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47629 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751623AbYECHqF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 03:46:05 -0400
Date: Sat, 3 May 2008 17:45:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080503174557.faf67525.sfr@canb.auug.org.au>
In-Reply-To: <20080502233519.a988b552.akpm@linux-foundation.org>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
	<20080502233519.a988b552.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_May_2008_17_45_57_+1000_nTQAOwtezoV8Y43q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_May_2008_17_45_57_+1000_nTQAOwtezoV8Y43q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 2 May 2008 23:35:19 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Sat, 3 May 2008 15:45:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
>=20
> > The following architectures are not in linux-next (and should be):
> >=20
> > alpha		cris		frv
> > h8300		m32r		m68knommu
> > mips		mn10300		parisc
> > um		v850		xtensa
>=20
> mips, m32r, parisc and xtensa do have git trees.  The rest are mastered as
> discrete patches in -mm.

So, I was wondering if it would be worth while having subsections to a
series file like:

# NEXT_PATCHES_START [<label> [<base>]]

# NEXT_PATCHES_END

With <label> sections being logically separate enough that we can talk
about them/drop them/merge them at different places etc.

Or am I over engineering? :-)

> Except for m68knommu, which pops unexpectedly out of the woodwork during
> the merge window.  I've asked that this be altered ;)

Yeah, I saw that, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_May_2008_17_45_57_+1000_nTQAOwtezoV8Y43q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHBg6TgG2atn1QN8RAtXZAJ9OkwicH3DoDCYCBUBaME9E/ez1OgCfdcpr
QLnGzt7tlRVt2NsOnu4J9y8=
=HFFl
-----END PGP SIGNATURE-----

--Signature=_Sat__3_May_2008_17_45_57_+1000_nTQAOwtezoV8Y43q--
