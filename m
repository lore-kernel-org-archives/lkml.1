Return-Path: <linux-kernel-owner+w=401wt.eu-S1756671AbYFBCPY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756671AbYFBCPY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jun 2008 22:15:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753519AbYFBCPL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jun 2008 22:15:11 -0400
Received: from ozlabs.org ([203.10.76.45]:58399 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbYFBCPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jun 2008 22:15:09 -0400
Subject: Re: [PATCH] ftrace: powerpc clean ups
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@elte.hu>, proski@gnu.org, a.p.zijlstra@chello.nl,
       Pekka Paalanen <pq@iki.fi>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <srostedt@redhat.com>, linuxppc-dev@ozlabs.org,
       Soeren Sandmann Pedersen <sandmann@redhat.com>, paulus@samba.org
In-Reply-To: <Pine.LNX.4.58.0805221429020.18018@gandalf.stny.rr.com>
References: <20080515034942.109223655@goodmis.org>
	 <20080515035918.896765954@goodmis.org> <1211292277.7960.8.camel@localhost>
	 <Pine.LNX.4.58.0805221429020.18018@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vUkyxTTM+CreoaEPRw+2"
Date: Mon, 02 Jun 2008 12:15:07 +1000
Message-Id: <1212372907.14511.18.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vUkyxTTM+CreoaEPRw+2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-05-22 at 14:31 -0400, Steven Rostedt wrote:
> This patch cleans up the ftrace code in PowerPC based on the comments fro=
m
> Michael Ellerman.

Hi Steven,

Thanks for that.

I posted some patches last week, also in my git tree[1], that should
allow you to use create_branch() in your code (and also facilitate some
other things I wanted to do). I also added a #define for NOP also.

If/when my patches go into powerpc-next I'll do a patch against
linux-next for ftrace to use them.

cheers

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/mpe/linux-2.6.git;a=3Dsumm=
ary

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-vUkyxTTM+CreoaEPRw+2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIQ1erdSjSd0sB4dIRAp5HAJ0crqf+Y5Gk6KWHN2t/WDt3rFhEAwCdExPN
UkDm5XeSipwInpy82KDTHqU=
=p+P1
-----END PGP SIGNATURE-----

--=-vUkyxTTM+CreoaEPRw+2--

