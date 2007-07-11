Return-Path: <linux-kernel-owner+w=401wt.eu-S1759594AbXGKCzG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594AbXGKCzG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2007 22:55:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753814AbXGKCyx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jul 2007 22:54:53 -0400
Received: from gilford.textdrive.com ([207.7.108.53]:63098 "EHLO
	gilford.textdrive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbXGKCyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2007 22:54:51 -0400
X-Greylist: delayed 1975 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jul 2007 22:54:51 EDT
Date: Tue, 10 Jul 2007 20:21:23 -0600
From: Ira Snyder <kernel@irasnyder.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Hawkins" <darthmdh@gmail.com>, linux-kernel@vger.kernel.org,
       Con Kolivas <kernel@kolivas.org>, ck list <ck@vds.kolivas.org>,
       linux-mm@kvack.org, Paul Jackson <pj@sgi.com>
Subject: Re: [ck] Re: -mm merge plans for 2.6.23
Message-Id: <20070710202123.d819835e.kernel@irasnyder.com>
In-Reply-To: <20070710181419.6d1b2f7e.akpm@linux-foundation.org>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<200707102015.44004.kernel@kolivas.org>
	<b21f8390707101802o2d546477n2a18c1c3547c3d7a@mail.gmail.com>
	<20070710181419.6d1b2f7e.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.13; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Jul_2007_20_21_23_-0600_A+QX21NFDGxiEG5O"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Jul_2007_20_21_23_-0600_A+QX21NFDGxiEG5O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 10 Jul 2007 18:14:19 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Wed, 11 Jul 2007 11:02:56 +1000 "Matthew Hawkins" <darthmdh@gmail.com>=
 wrote:
>=20
> > We all know swap prefetch has been tested out the wazoo since Moses was=
 a
> > little boy, is compile-time and runtime selectable, and gives an import=
ant
> > and quantifiable performance increase to desktop systems.
>=20
> Always interested.  Please provide us more details on your usage and
> testing of that code.  Amount of memory, workload, observed results,
> etc?
>=20

I often leave long compiles running overnight (I'm a gentoo user). I always=
 have the desktop running, with quite a few applications open, usually fire=
fox, amarok, sylpheed, and liferea at the minimum. I've recently tried usin=
g a "stock" gentoo kernel, without the swap prefetch patch, and in the morn=
ing when I get on the computer, it hits the disk pretty hard pulling my app=
lications (especially firefox) in from swap. With swap prefetch, the system=
 responds like I expect: quick. It doesn't hit the swap at all, at least th=
at I can tell.

Swap prefetch definitely makes a difference for me: it makes my experience =
MUCH better.

My system is a Core Duo 1.83GHz laptop, with 1GB ram and a 5400 rpm disk. W=
ith the disk being so slow, the less I hit swap, the better.

I'll cast my vote to merge swap prefetch.

--Signature=_Tue__10_Jul_2007_20_21_23_-0600_A+QX21NFDGxiEG5O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQFGlD6oqvO4Mr6SCJURApoWAKCrUb3d93byOsQ/VkIm/urz//x65QCfQfSa
GvRsvmXfiOTvV8YFhOR7ryM=
=Ztn3
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Jul_2007_20_21_23_-0600_A+QX21NFDGxiEG5O--
