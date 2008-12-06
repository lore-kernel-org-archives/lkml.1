Return-Path: <linux-kernel-owner+w=401wt.eu-S1758145AbYLFMRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758145AbYLFMRW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:17:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757770AbYLFMRI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:17:08 -0500
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:9622 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757699AbYLFMRF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:17:05 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-nfs@vger.kernel.org, Max Kellermann <mk@cm4all.com>,
       linux-kernel@vger.kernel.org, gcosta@redhat.com,
       Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1228169383.20370.3.camel@localhost.localdomain>
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
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-g/WvySxpzsa0UFMPoYiZ"
Date: Sat, 06 Dec 2008 12:16:52 +0000
Message-Id: <1228565812.10856.30.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH 0/3] NFS regression in 2.6.26?, "task blocked for more
	than 120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=jSbuyrlv4UgA:10 a=ehd10kmKHQgA:10 a=A0nSxeOIyv4FNEfi7WcA:9 a=U1yseTTujbe9n9Mbub3fLUUnYNcA:4 a=LY0hPdMaydYA:10 a=J3SwD5zSHixMohUjSNgA:9 a=ItVx_DT-t3XnDXA0ENdFrhKt5FgA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-g/WvySxpzsa0UFMPoYiZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-12-01 at 22:09 +0000, Ian Campbell wrote:
> On Sun, 2008-11-30 at 19:17 -0500, Trond Myklebust wrote:=20
> > Can you see if the following 3 patches help? They're against 2.6.28-rc6=
,
> > but afaics the problems are pretty much the same on 2.6.26.
>=20
> Thanks.
>=20
> The server was actually running 2.6.25.7 but the matching sources have
> since been removed the backports.org so I've reproduce with 2.6.26 and
> now I'll add the patches.

Just a small progress report. Anecdotally I thought that unpatched
2.6.26.7 was worse than 2.6.25.7, mostly because it hung twice in the ~1
day I was running it where previously it was less frequent than once per
day.

With the patched server the client ran OK for 2.5 days then mysteriously
hung, the logs show none of the normal symptoms and my wife reset it
before I got home so I've no real clue what happened but I'm inclined to
think it was unrelated for now. I'll get back to you in a week or so if
the problem hasn't reoccurred.

Ian.
--=20
Ian Campbell

It's later than you think.

--=-g/WvySxpzsa0UFMPoYiZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkk6bTQACgkQM0+0qS9rzVn/uACeOPui26Cv/4sOESNeEO0VpwC9
W8EAoJHcgzLN5JbeqhzDeXpUweEEMGEi
=76BA
-----END PGP SIGNATURE-----

--=-g/WvySxpzsa0UFMPoYiZ--

