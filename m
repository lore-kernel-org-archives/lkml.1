Return-Path: <linux-kernel-owner+w=401wt.eu-S1762902AbYEFF5j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762902AbYEFF5j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 01:57:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754270AbYEFF5b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 01:57:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50781 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084AbYEFF5b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 01:57:31 -0400
Date: Tue, 6 May 2008 15:57:23 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, andi@lisas.de,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       mchehab@infradead.org
Subject: Re: Linux 2.6.26-rc1
Message-Id: <20080506155723.df6bdcf9.sfr@canb.auug.org.au>
In-Reply-To: <20080505171657.64386de7.akpm@linux-foundation.org>
References: <20080505053935.GA15734@rhlx01.hs-esslingen.de>
	<20080505073030.GI3350@elte.hu>
	<20080506095122.860796f6.sfr@canb.auug.org.au>
	<20080505.165501.62584352.davem@davemloft.net>
	<20080505171657.64386de7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_May_2008_15_57_23_+1000_AGpG81/PGwv1RE6="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_May_2008_15_57_23_+1000_AGpG81/PGwv1RE6=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 5 May 2008 17:16:57 -0700 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Mon, 05 May 2008 16:55:01 -0700 (PDT) David Miller <davem@davemloft.ne=
t> wrote:
>=20
> As we discussed last week, I won't carry these patches because they're
> already upstream.  It turns out that "upstream" in this case is linux-next
> itself, which is an unexpected place for patches to be mastered.

Yeah, true.

> So I suggest that Stephen send patches such as this into Linus sooner
> rather than later.  Because nobody else will.

Right, I know that now :-)

> Well.  They _might_.  In this case Len could merge the patch in which case
> Stephen would drop it and the fix would dawdle around in the acpi tree for
> a while.

I guess that was my hope ...

> Ho hum, hopefully this isn't a common case.  Often Linus or I will just do
> a maintainer bypass on things like this, but my ability to do that is now
> much reduced because a) I can't merge the patch and b) when I _do_ try to
> do that, it's "huh, we already fixed it".

This is an uncommon case because normally I would just revert the
patch/tree that caused the problem.  In this case, the problem didn't
show up until after the linux-tree had been released so when the fix
patches turned up the next day I added them in the hope that someone else
would pick them up soon i.e. before they were needed in Linus' tree.  I
now know better.  :-)

> So... I hereby appoint Stephen random-build-fix-monkey.

Rats! :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_May_2008_15_57_23_+1000_AGpG81/PGwv1RE6=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIH/NHTgG2atn1QN8RAsHWAJ95mncnbxtzKALix/1ZJ3qF2wlp1wCfT9ZR
PxL6GoGM7nU4DRXSg0BGeao=
=sD+1
-----END PGP SIGNATURE-----

--Signature=_Tue__6_May_2008_15_57_23_+1000_AGpG81/PGwv1RE6=--
