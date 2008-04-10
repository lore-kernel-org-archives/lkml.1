Return-Path: <linux-kernel-owner+w=401wt.eu-S1756105AbYDJAqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756105AbYDJAqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 20:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752898AbYDJAp5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 20:45:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46716 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996AbYDJAp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 20:45:56 -0400
Date: Thu, 10 Apr 2008 10:45:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Tree for April 9
Message-Id: <20080410104549.c2e1b645.sfr@canb.auug.org.au>
In-Reply-To: <47FCF50E.9090703@s5r6.in-berlin.de>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
	<47FCF50E.9090703@s5r6.in-berlin.de>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Apr_2008_10_45_49_+1000_DLVG.IBeQWeZ1dqJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Apr_2008_10_45_49_+1000_DLVG.IBeQWeZ1dqJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stefan,

On Wed, 09 Apr 2008 18:55:42 +0200 Stefan Richter <stefanr@s5r6.in-berlin.d=
e> wrote:
>
> Stephen Rothwell wrote:
> > There were a few merge conflicts (fairly trivial) and couple of build
> > failures (notified).  There is a know build failure with powerpc
> > allyesconfig.  Below is a summary of the state of the merge.
> ...
> > Merging ieee1394/for-next
> > CONFLICT (content): Merge conflict in lib/Kconfig.debug
>=20
> Would it be safe for me (and preferred by you) to merge sched/for-akpm
> into ieee1394/for-next to resolve this conflict until next mainline merge?

Actually, no, as sched/for-akpm gets rebased sometimes.  I only have to
fix these trivial conflicts once as "git rerere" remembers the fix for me
and they are so trivial that Linus will probably fix them the same way
when he finally merges your tree.  Also, there is the possibility that he
will merge your tree before sched/for-akpm ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Apr_2008_10_45_49_+1000_DLVG.IBeQWeZ1dqJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/WNBTgG2atn1QN8RAg1pAKCMzaR4XquHP6fvRWYDhr1DTseOGwCeNgKY
Ad7t4k4l2OzxFMPJL4KElBw=
=HURv
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Apr_2008_10_45_49_+1000_DLVG.IBeQWeZ1dqJ--
