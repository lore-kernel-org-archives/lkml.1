Return-Path: <linux-kernel-owner+w=401wt.eu-S1754688AbYLNSYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688AbYLNSYp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751250AbYLNSYg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:24:36 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:32144 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751001AbYLNSYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:24:35 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228565812.10856.30.camel@localhost.localdomain>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
	 <1227596962.16868.22.camel@localhost.localdomain>
	 <1227619696.7057.19.camel@heimdal.trondhjem.org>
	 <1227620339.9425.99.camel@zakaz.uk.xensource.com>
	 <1227621434.7057.33.camel@heimdal.trondhjem.org>
	 <1227621877.9425.102.camel@zakaz.uk.xensource.com>
	 <1227737539.31008.2.camel@localhost.localdomain>
	 <1228090631.7112.11.camel@heimdal.trondhjem.org>
	 <1228169383.20370.3.camel@localhost.localdomain>
	 <1228565812.10856.30.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-84U0ymxV8LHT/KQ4Ne6R"
Date: Sun, 14 Dec 2008 18:24:05 +0000
Message-Id: <1229279045.3721.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=jSbuyrlv4UgA:10 a=ehd10kmKHQgA:10 a=gbGJtTxsRAEqlF_pel8A:9 a=bqdjPPUWKn-p7_yZsmon_S21sEYA:4 a=LY0hPdMaydYA:10 a=1GvFFWyYGZFHkjtuOZwA:9 a=9Znt2lsJJ6rGEo4rCkE3XDkwUysA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-84U0ymxV8LHT/KQ4Ne6R
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-12-06 at 12:16 +0000, Ian Campbell wrote:
> On Mon, 2008-12-01 at 22:09 +0000, Ian Campbell wrote:
> > On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:=20
> > > Can you see if the following 3 patches help? They're against 2.6.28-r=
c6,
> > > but afaics the problems are pretty much the same on 2.6.26.
> >=20
> > Thanks.
> >=20
> > The server was actually running 2.6.25.7 but the matching sources have
> > since been removed the backports.org so I've reproduce with 2.6.26 and
> > now I'll add the patches.
>=20
> Just a small progress report. Anecdotally I thought that unpatched
> 2.6.26.7 was worse than 2.6.25.7, mostly because it hung twice in the ~1
> day I was running it where previously it was less frequent than once per
> day.
>=20
> With the patched server the client ran OK for 2.5 days then mysteriously
> hung, the logs show none of the normal symptoms and my wife reset it
> before I got home so I've no real clue what happened but I'm inclined to
> think it was unrelated for now. I'll get back to you in a week or so if
> the problem hasn't reoccurred.

$ uptime=20
 18:15:29 up 9 days, 22 min,  1 user,  load average: 0.74, 0.64, 0.46

This is on the problematic client, so it looks like the server side fix
has sorted it. Thanks very much Trond.

Ian.
--=20
Ian Campbell

You have only to mumble a few words in church to get married and few words
in your sleep to get divorced.

--=-84U0ymxV8LHT/KQ4Ne6R
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklFTzYACgkQM0+0qS9rzVnkfACaA+HfZO4cma2BEN0gLS9ImG2i
RvgAmgPRXKARJCHdV94NRENB8eqHQnnO
=rzIg
-----END PGP SIGNATURE-----

--=-84U0ymxV8LHT/KQ4Ne6R--

