Return-Path: <linux-kernel-owner+w=401wt.eu-S1766825AbXDSPut@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766825AbXDSPut (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2007 11:50:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766826AbXDSPus
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Apr 2007 11:50:48 -0400
Received: from iucha.net ([209.98.146.184]:46125 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766825AbXDSPur (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2007 11:50:47 -0400
Date: Thu, 19 Apr 2007 10:50:46 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070419155046.GR24044@iucha.net>
References: <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net> <1176905506.6796.84.camel@heimdal.trondhjem.org> <20070419015232.GO24044@iucha.net> <1176950713.6422.95.camel@heimdal.trondhjem.org> <462786C9.7090405@oracle.com> <1176995848.6663.1.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IUSVF+LtaR4kWxuH"
Content-Disposition: inline
In-Reply-To: <1176995848.6663.1.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--IUSVF+LtaR4kWxuH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2007 at 11:17:28AM -0400, Trond Myklebust wrote:
> On Thu, 2007-04-19 at 11:12 -0400, Chuck Lever wrote:
> > Perhaps instead of looking at the number of bytes sent, the logic in th=
e=20
> > last hunk of this patch should check which queue the request is sitting=
 on.
>=20
> ??? It would be a bug for the request to be sitting on _any_ queue when
> it enters xprt_transmit().
>=20
> Here is the patch that I'm currently testing.

Trond,

What is the set of patches that are you testing?  I'd like to give
that a spin tonight as well.

It is possible that what makes my configuration more susceptible
to the problem is the fact that the client significantly overpowers
the server: Athlon x2 4200+ with 2Gb of RAM for the client vs. PIII
1Ghz 512 MB RAM for the server.  They both have gigabit ethernet
and both NICs and the switch support jumbo frames.

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--IUSVF+LtaR4kWxuH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJ4/WND0rFCN2b1sRAg0nAKCbmQP/n9LxuScGpVwzMbrzJiIJKwCeJfFj
M3x4TP5Y99aYcEZdgU58D0w=
=StBV
-----END PGP SIGNATURE-----

--IUSVF+LtaR4kWxuH--
