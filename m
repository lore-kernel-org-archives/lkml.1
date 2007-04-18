Return-Path: <linux-kernel-owner+w=401wt.eu-S2992646AbXDRUqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992646AbXDRUqK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 16:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992654AbXDRUqK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 16:46:10 -0400
Received: from lugor.de ([212.112.242.222]:43289 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992646AbXDRUqJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 16:46:09 -0400
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: CFS and suspend2: hang in atomic copy
Date: Wed, 18 Apr 2007 22:45:18 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
References: <20070413202100.GA9957@elte.hu> <200704181759.03559.mail@earthworm.de> <20070418164621.GA30744@elte.hu>
In-Reply-To: <20070418164621.GA30744@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)k
	:nv*xqk4C@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)n#Q.o
	kE~&T]0cQX6]<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<3O7GY9y_i!qG&Vv\D8/
	%4@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1521128.O9VBnNadKO";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704182245.24156.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Wed, 18 Apr 2007 22:45:26 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1521128.O9VBnNadKO
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 18 April 2007, Ingo Molnar wrote:
> * Christian Hesse <mail@earthworm.de> wrote:
> > On Friday 13 April 2007, Ingo Molnar wrote:
> > > as usual, any sort of feedback, bugreports, fixes and suggestions are
> > > more than welcome,
> >
> > When trying to suspend a system patched
> > with suspend2 2.2.9.11 it hangs with "doing atomic copy". Pressing the
> > ESC key results in a message that it tries to abort suspend, but then
> > still hangs.
>
> i took a quick look at suspend2 and it makes some use of yield().
> There's a bug in CFS's yield code, i've attached a patch that should fix
> it, does it make any difference to the hang?

This patch should apply cleanly against what? The second hunk is ignored as=
 it=20
has already been applied. Is this correct?

But no, it does not change anything. Let me know if you have any other patc=
hes=20
to test.
=2D-=20
Regards,
Chris

--nextPart1521128.O9VBnNadKO
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJoNklZfG2c8gdSURAipIAJ4r5CsjhRZLZQum4P8++Oh7ifddNQCgnorN
6z7yjyzVNa15y/3O6OeFJGE=
=wPX3
-----END PGP SIGNATURE-----

--nextPart1521128.O9VBnNadKO--
