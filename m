Return-Path: <linux-kernel-owner+w=401wt.eu-S1758872AbYEHBWJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872AbYEHBWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 21:22:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754982AbYEHBVy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 21:21:54 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41737 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778AbYEHBVv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 21:21:51 -0400
Date: Thu, 8 May 2008 11:21:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, Ingo Molnar <mingo@elte.hu>,
       Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: the purge :-)
Message-Id: <20080508112130.fd574b50.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_May_2008_11_21_30_+1000_b/R+ecpCoFgHNSVb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_May_2008_11_21_30_+1000_b/R+ecpCoFgHNSVb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Having published my expectations of what should be in linux-next, I am
no implementing what I think is what I said.  :-)

This is open to discussion (including suggestions about other trees).

The following trees are being excluded from today because I think that
they contain changes that:
	- have not been published/reviewed/tested sufficiently
	- are not currently intended for 2.6.26 or 2.6.27.
(not all reasons apply to all trees).  Please don't take offense, I am
just trying to obey my own guidelines.

ldp
x86_latest
sched_latest

Ingo, I assume that things will migrate from {x86,sched} latest to
for-akpm (for-next?) over time.  Greg, you might consider setting up a
subset (currently probably empty) of the ldp tree for drivers that are
readier for integration.

As an aside, the kbuild tree is still dropped for today since Sam is not
in a position to fix stuff until the weekend and the wireless tree is
dropped today because it can not be fetched.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_May_2008_11_21_30_+1000_b/R+ecpCoFgHNSVb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIlWgTgG2atn1QN8RAlkXAJ47D54z1nLpNwxUHqtFF1qKYXb1lwCbBMiw
lgivfPx9Stc7j1We83H59Gw=
=q1CE
-----END PGP SIGNATURE-----

--Signature=_Thu__8_May_2008_11_21_30_+1000_b/R+ecpCoFgHNSVb--
