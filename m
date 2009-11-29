Return-Path: <linux-kernel-owner+w=401wt.eu-S1753390AbZK2V5O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753390AbZK2V5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 16:57:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbZK2V5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 16:57:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39996 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753265AbZK2V5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 16:57:12 -0500
Date: Mon, 30 Nov 2009 08:57:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>,
       =?UTF-8?B?QW7DrWJhbA==?= Monsalve Salazar <anibal@debian.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: linux-kbuild.git
Message-Id: <20091130085713.75f56423.sfr@canb.auug.org.au>
In-Reply-To: <4B0F9F0D.6010601@suse.cz>
References: <4B0E73E1.50900@suse.cz>
	<20091126193750.GA15453@merkur.ravnborg.org>
	<20091127152211.55043dbb.sfr@canb.auug.org.au>
	<4B0F9F0D.6010601@suse.cz>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_08_57_13_+1100_0OpR/904v96TQU19"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Nov_2009_08_57_13_+1100_0OpR/904v96TQU19
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Michal,

On Fri, 27 Nov 2009 10:42:37 +0100 Michal Marek <mmarek@suse.cz> wrote:
>
> >  Do you intend to run the equivalent of
> > the kbuild-current tree (bug fixes for the current release while they a=
re
> > waiting to go to Linus)?  I have removed the kbuild-current tree for now
> > since the only commit in it is in the new kbuild tree.
>=20
> I plan to maintain such a branch, but I thought I would base the
> for-next branch on top of it, so that you get everything in one pack. Or
> would you still prefer to have two kbuild branches in linux-next, so
> that you can remove the for-next branch if necessary and keep the
> for-current branch? Just tell me what fits you best.

Running a for-current branch allows you to queue up urgent fixes without
disrupting your for-next branch.  I will merge such a branch early on
(actually before I do my first build) so that I don't have to worry about
problems that are already have fixes pending for to be merged by Linus in
his current tree.  Also, as you say, if I have problems with your
for-next branch, it does not affect the more urgent patches.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_08_57_13_+1100_0OpR/904v96TQU19
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksS7jkACgkQjjKRsyhoI8xw/wCfeloYLCe86Wuq4qwVasICM+b/
Q/YAoKThUIaRARno72+2bicDS/C2mbyO
=8C4M
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_08_57_13_+1100_0OpR/904v96TQU19--
