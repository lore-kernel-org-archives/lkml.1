Return-Path: <linux-kernel-owner+w=401wt.eu-S2992639AbXDYK6l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992639AbXDYK6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2007 06:58:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161875AbXDYK6k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Apr 2007 06:58:40 -0400
Received: from lugor.de ([212.112.242.222]:58967 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1161865AbXDYK6i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2007 06:58:38 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [patch] CFS scheduler, -v5
Date: Wed, 25 Apr 2007 12:51:44 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Thomas Gleixner <tglx@linutronix.de>, caglar@pardus.org.tr,
       Willy Tarreau <w@1wt.eu>, Gene Heskett <gene.heskett@gmail.com>,
       Mark Lord <lkml@rtr.ca>, Ulrich Drepper <drepper@redhat.com>
References: <20070420140457.GA14017@elte.hu> <200704241854.47269.mail@earthworm.de> <20070425092544.GA498@elte.hu>
In-Reply-To: <20070425092544.GA498@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2757491.DN77DcP9B4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704251251.49298.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Wed, 25 Apr 2007 12:51:51 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2757491.DN77DcP9B4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 25 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > On Monday 23 April 2007, Ingo Molnar wrote:
> > > i'm pleased to announce release -v5 of the CFS scheduler patchset.
> >
> > Hi Ingo,
> >
> > I just noticed that with cfs all processes (except some kernel
> > threads) run on cpu 0. I don't think this is expected cpu affinity for
> > an smp system? I remember about half of the processes running on each
> > core with mainline.
>
> i've got several SMP systems with CFS and all distribute the load
> properly to all CPUs, so it would be nice if you could tell me more
> about how the problem manifests itself on your system.
>
> for example, if you start two infinite loops:
>
>     for (( N=3D0; N < 2; N++ )); do ( while :; do :; done ) & done
>
> do they end up on the same CPU?
>
> Or do you mean that the default placement of single tasks starts at
> CPU#0, while with mainline they were alternating?

That was not your fault. I updated suspend2 to 2.2.9.13 and everything work=
s=20
as expected again. Sorry for the noise.
=2D-=20
Regards,
Chris

--nextPart2757491.DN77DcP9B4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGLzLFlZfG2c8gdSURAksOAJ9tJgFTmY3IAAHnob6tfHCfo+IO8ACgrxi9
NnwmJ3t2MHjQLtr9eqAd6BA=
=C++a
-----END PGP SIGNATURE-----

--nextPart2757491.DN77DcP9B4--
