Return-Path: <linux-kernel-owner+w=401wt.eu-S1754054AbXDRV6F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbXDRV6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 17:58:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754057AbXDRV6E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 17:58:04 -0400
Received: from lugor.de ([212.112.242.222]:38746 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754054AbXDRV6C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 17:58:02 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS and suspend2: hang in atomic copy
Date: Wed, 18 Apr 2007 23:57:21 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
References: <20070413202100.GA9957@elte.hu> <200704182245.24156.mail@earthworm.de> <20070418211632.GA7610@elte.hu>
In-Reply-To: <20070418211632.GA7610@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1221021.De0KSsqXfv";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704182357.28107.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Wed, 18 Apr 2007 23:57:29 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1221021.De0KSsqXfv
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 18 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > > i took a quick look at suspend2 and it makes some use of yield().
> > > There's a bug in CFS's yield code, i've attached a patch that should
> > > fix it, does it make any difference to the hang?
> >
> > This patch should apply cleanly against what? The second hunk is
> > ignored as it has already been applied. Is this correct?
>
> hm, i think you might have had one of the earlier CFS patches.

You are right.

> > But no, it does not change anything. Let me know if you have any other
> > patches to test.
>
> could you try the -v3 patch i released a few hours ago:
>
>    http://redhat.com/~mingo/cfs-scheduler/
>
> although probably your suspend2 problem is still not fixed, it's worth a
> try nevertheless. Which suspend2 patch did you apply, and was it against
> -rc6 or -rc7?

You are right again. ;-)

Linux 2.6.21-rc7
Suspend2 2.2.9.11 (applies cleanly to -rc7)
CFS v3 (without any additional patches)

And it still hangs on suspend.
=2D-=20
Regards,
Chris

--nextPart1221021.De0KSsqXfv
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJpRHlZfG2c8gdSURAgG8AKDjAlVLZpVkeUgbwb71NqIsaR8s/gCgi2KO
aRio/METgUZgZLv7RaVLQeE=
=MDL2
-----END PGP SIGNATURE-----

--nextPart1221021.De0KSsqXfv--
