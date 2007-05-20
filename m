Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbXETG6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbXETG6t (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759677AbXETG6n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:58:43 -0400
Received: from mx33.mail.ru ([194.67.23.194]:19356 "EHLO mx33.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759538AbXETG6m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:58:42 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: bug in 2.6.22-rc2: loop mount limited to one single iso image
Date: Sun, 20 May 2007 10:58:36 +0400
User-Agent: KMail/1.9.6
Cc: Ray Lee <ray-lk@madrabbit.org>, Uwe Bugla <uwe.bugla@gmx.de>,
       Ken Chen <kenchen@google.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
References: <464F42F3.1080300@madrabbit.org> <2c0942db0705192316s2682807chd23df6f4de29edcb@mail.gmail.com> <20070520062816.GA4095@ftp.linux.org.uk>
In-Reply-To: <20070520062816.GA4095@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4838970.D3GLykZxeg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705201058.38117.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4838970.D3GLykZxeg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Sunday 20 May 2007, Al Viro wrote:
> On Sat, May 19, 2007 at 11:16:59PM -0700, Ray Lee wrote:
> > Ken? Ball's in your court. As the patch isn't providing a killer
> > feature for 2.6.22, I'd suggest just reverting it for now until the
> > issues are ironed out.
>
> Hold it.  The real question here is which logics do we want there.
> IOW, and how many device nodes do we want to appear and _when_ do
> we want them to appear?


of course we'd like to use exactly as many (or few) nodes as are in use rig=
ht=20
now and without fixed limit for their number; which implies that nodes shou=
ld=20
appear and go on as needed basis.

But right now there is no kernel mechanism that user level program could us=
e=20
to request allocation of new loop node. I won't discuss whether it is=20
legitimate to mandate new version of util-linux for kernel 2.6.22; but it i=
s=20
obvious that any kernel patch that adds such mechanism goes far beyond simp=
le=20
bug fix and is not acceptable at this stage.

So let's revert this change and discuss it for post-2.6.22 timeframe.

--nextPart4838970.D3GLykZxeg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGT/GeR6LMutpd94wRApLcAJ4o2yp+PSn5Uaady3upQc5ClYRhIQCggUcn
6RPAka5twWW2c5OiPN2N4zQ=
=TruD
-----END PGP SIGNATURE-----

--nextPart4838970.D3GLykZxeg--
