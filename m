Return-Path: <linux-kernel-owner+w=401wt.eu-S2992834AbXDRQlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992834AbXDRQlT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 12:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992842AbXDRQlT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 12:41:19 -0400
Received: from lugor.de ([212.112.242.222]:47147 "EHLO solar.vpn.lugor.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S2992834AbXDRQlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 12:41:18 -0400
X-Greylist: delayed 2389 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 Apr 2007 12:41:18 EDT
From: Christian Hesse <mail@earthworm.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: CFS and suspend2: hang in atomic copy (was: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS])
Date: Wed, 18 Apr 2007 17:58:55 +0200
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Nick Piggin <npiggin@suse.de>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, suspend2-devel@lists.suspend2.net
References: <20070413202100.GA9957@elte.hu>
In-Reply-To: <20070413202100.GA9957@elte.hu>
X-Face: 1\p'dhO'VZk,x0lx6U}!Y*9UjU4n2@4c<"a*K%3Eiu'VwM|-OYs;S-PH>4EdJMfGyycC)=?utf-8?q?k=0A=09=3Anv*xqk4C?=@1b8tdr||mALWpN[2|~h#Iv;)M"O$$#P9Kg+S8+O#%EJx0TBH7b&Q<m)=?utf-8?q?n=23Q=2Eo=0A=09kE=7E=26T=5D0cQX6=5D?=<q!HEE,F}O'Jd#lx/+){Gr@W~J`h7sTS(M+oe5<=?utf-8?q?3O7GY9y=5Fi!qG=26Vv=5CD8/=0A=09=254?=@&~$Z@UwV'NQ$Ph&3fZc(qbDO?{LN'nk>+kRh4`C3[KN`-1uT-TD_m
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1623040.6pUSZCQ8hM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200704181759.03559.mail@earthworm.de>
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-2.0 (solar.vpn.lugor.de [10.5.1.1]); Wed, 18 Apr 2007 17:59:05 +0200 (CEST)
X-Spam-Flag: NO
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1623040.6pUSZCQ8hM
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi Ingo and all,

On Friday 13 April 2007, Ingo Molnar wrote:
> as usual, any sort of feedback, bugreports, fixes and suggestions are
> more than welcome,

I just gave CFS a try on my system. From a user's point of view it looks go=
od=20
so far. Thanks for your work.

However I found a problem: When trying to suspend a system patched with=20
suspend2 2.2.9.11 it hangs with "doing atomic copy". Pressing the ESC key=20
results in a message that it tries to abort suspend, but then still hangs.

I cced suspend2 devel list, perhaps Nigel is interested as well.
=2D-=20
Regards,
Chris

--nextPart1623040.6pUSZCQ8hM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGJkBHlZfG2c8gdSURAhqXAJ90btjygXsWS4C2JXfzRBFV7DZPlACfWLz0
9a21GIAoizNnFQxreP5dAls=
=3BDI
-----END PGP SIGNATURE-----

--nextPart1623040.6pUSZCQ8hM--
