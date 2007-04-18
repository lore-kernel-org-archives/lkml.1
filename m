Return-Path: <linux-kernel-owner+w=401wt.eu-S2992562AbXDROOy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992562AbXDROOy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:14:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992565AbXDROOy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:14:54 -0400
Received: from iucha.net ([209.98.146.184]:55777 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992562AbXDROOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:14:53 -0400
Date: Wed, 18 Apr 2007 09:14:50 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418141450.GH24044@iucha.net>
References: <20070418033055.GA24044@iucha.net> <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqCDj3hiknadvR6t"
Content-Disposition: inline
In-Reply-To: <20070418134225.GG24044@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--AqCDj3hiknadvR6t
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2007 at 08:42:25AM -0500, Florin Iucha wrote:
> On Wed, Apr 18, 2007 at 09:15:31AM -0400, Trond Myklebust wrote:
> The netstat outputs are stable (not changed in 5 minutes):
>=20
>    http://iucha.net/nfs/21-rc7-nfs3/netstat-server :
>=20
> tcp        1      0 hermes.iucha.org:nfs    zeus.iucha.org:799      CLOSE=
_WAIT=20
> tcp        0      0 hermes.iucha.org:nfs    zeus.iucha.org:976      ESTAB=
LISHED
>=20
>    http://iucha.net/nfs/21-rc7-nfs3/netstat-client
>=20
> Active Internet connections (w/o servers)
> Proto Recv-Q Send-Q Local Address           Foreign Address         State=
     =20
> tcp        0      0 zeus.iucha.org:976      hermes.iucha.org:nfs    ESTAB=
LISHED
> tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:56880  ESTAB=
LISHED
> tcp        0      0 zeus.iucha.org:ssh      hermes.iucha.org:45176  ESTAB=
LISHED
>=20
> Could the port in CLOSE_WAIT state be the culprit?  (FWIW
> the server has been up for 38 days and subjected to
> this nfs test quite a bit without showing any stress).

The CLOSE_WAIT went away as soon as I rebooted the client.  Something
was holding it up...

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--AqCDj3hiknadvR6t
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJifaND0rFCN2b1sRAsF6AJ9sKnjGtlvYk+bW62fFErPNnesrmQCdFIoN
g7K1dLpriTVKmmy7rc2yU70=
=L+lc
-----END PGP SIGNATURE-----

--AqCDj3hiknadvR6t--
