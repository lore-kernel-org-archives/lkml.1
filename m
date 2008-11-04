Return-Path: <linux-kernel-owner+w=401wt.eu-S1756454AbYKDTKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756454AbYKDTKn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 14:10:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753940AbYKDTKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 14:10:34 -0500
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:28202 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753715AbYKDTKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 14:10:33 -0500
From: Ian Campbell <ijc@hellion.org.uk>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Max Kellermann <mk@cm4all.com>, linux-kernel@vger.kernel.org,
       gcosta@redhat.com, Grant Coady <grant_lkml@dodo.com.au>,
       "J. Bruce Fields" <bfields@fieldses.org>,
       Tom Tucker <tom@opengridcomputing.com>
In-Reply-To: <1225546878.4390.3.camel@heimdal.trondhjem.org>
References: <20081017123207.GA14979@rabbit.intern.cm-ag>
	 <1224484046.23068.14.camel@localhost.localdomain>
	 <1225539927.2221.3.camel@localhost.localdomain>
	 <1225546878.4390.3.camel@heimdal.trondhjem.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/00s/Y+hRA1Z8xM79DHv"
Date: Tue, 04 Nov 2008 19:10:21 +0000
Message-Id: <1225825821.633.14.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] NFS regression in 2.6.26?, "task blocked for more than
	120 seconds"
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=6OAc2UI1ETEA:10 a=Gm1qT94b7fUA:10 a=2YeoAcyWQkzzKz1GXHEA:9 a=RyS3b1PkRLM5ESz_w9llA5GXSaAA:4 a=LY0hPdMaydYA:10 a=8v7eF3GjAdVOH0voAogA:9 a=FPRSLMxVN_TiWW0KGkAPG3DSs90A:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/00s/Y+hRA1Z8xM79DHv
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2008-11-01 at 09:41 -0400, Trond Myklebust wrote:
> On Sat, 2008-11-01 at 11:45 +0000, Ian Campbell wrote:
> > On Mon, 2008-10-20 at 07:27 +0100, Ian Campbell wrote:
> > > So far I have bisected down to this range and am currently testing
> > > acee478 which has been up for >4days.
> >=20
> > Another update. It has now bisected down to a small range=20
> >=20
> > 7272dcd31d56580dee7693c21e369fd167e137fe SUNRPC: xprt_autoclose() shoul=
d not call xprt_disconnect()
> > e06799f958bf7f9f8fae15f0c6f519953fb0257c SUNRPC: Use shutdown() instead=
 of close() when disconnecting a TCP socket
> > ef80367071dce7d2533e79ae8f3c84ec42708dc8 SUNRPC: TCP clear XPRT_CLOSE_W=
AIT when the socket is closed for writes
> > 3b948ae5be5e22532584113e2e02029519bbad8f SUNRPC: Allow the client to de=
tect if the TCP connection is closed
> > 67a391d72ca7efb387c30ec761a487e50a3ff085 SUNRPC: Fix TCP rebinding logi=
c
> > 66af1e558538137080615e7ad6d1f2f80862de01 SUNRPC: Fix a race in xs_tcp_s=
tate_change()
> >=20
> > I'm currently testing 3b948ae5be5e22532584113e2e02029519bbad8f.
> >=20
> > 7272dcd31d56580dee7693c21e369fd167e137fe repro'd in half a day while
> > ef818a28fac9bd214e676986d8301db0582b92a9 (parent of
> > 66af1e558538137080615e7ad6d1f2f80862de01) survived for 7 days.
> >=20
> > Ian.
>=20
> Have you tested with the TCP RST fix yet? It has been merged into
> mainline, so it should be in the latest 2.6.28-git, but I've attached it
> so you can apply it to your test kernel...

I cherry picked 2a9e1cfa23fb62da37739af81127dab5af095d99 onto v2.6.25
and unfortunately it has not fixed the issue. I'll go back to bisecting
with 3b948ae5be5e22532584113e2e02029519bbad8f.

Ian.

>=20
> Cheers
>   Trond
>=20
--=20
Ian Campbell

Superior ability breeds superior ambition.
		-- Spock, "Space Seed", stardate 3141.9

--=-/00s/Y+hRA1Z8xM79DHv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkQnh0ACgkQM0+0qS9rzVnwdQCfbYoWD+Tr4epevtl9UDxBFr8Z
014An2FhLqFJ+ZOeiPBzK8qbxTe3GM4q
=Txwk
-----END PGP SIGNATURE-----

--=-/00s/Y+hRA1Z8xM79DHv--

