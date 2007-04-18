Return-Path: <linux-kernel-owner+w=401wt.eu-S2992554AbXDRORY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992554AbXDRORY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 10:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992570AbXDRORY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 10:17:24 -0400
Received: from iucha.net ([209.98.146.184]:35468 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992554AbXDRORX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 10:17:23 -0400
Date: Wed, 18 Apr 2007 09:17:23 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070418141722.GI24044@iucha.net>
References: <1176868485.6796.42.camel@heimdal.trondhjem.org> <20070418040730.GC24044@iucha.net> <20070417211350.ebba1493.akpm@linux-foundation.org> <20070418043040.GD24044@iucha.net> <alpine.LFD.0.98.0704172148490.31155@woody.linux-foundation.org> <20070417223738.8f49a39f.akpm@linux-foundation.org> <20070418123842.GF24044@iucha.net> <1176902131.6796.62.camel@heimdal.trondhjem.org> <20070418134225.GG24044@iucha.net> <1176905506.6796.84.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rCb8EA+9TsBVtA92"
Content-Disposition: inline
In-Reply-To: <1176905506.6796.84.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--rCb8EA+9TsBVtA92
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 18, 2007 at 10:11:46AM -0400, Trond Myklebust wrote:
> On Wed, 2007-04-18 at 08:42 -0500, Florin Iucha wrote:
> > Could the port in CLOSE_WAIT state be the culprit?  (FWIW
> > the server has been up for 38 days and subjected to
> > this nfs test quite a bit without showing any stress).
>=20
> The port in CLOSE_WAIT shows that a socket was closed down recently, but
> once the connection is re-established, the client should start sending
> data.
> Do you have a copy of wireshark or ethereal on hand? If so, could you
> take a look at whether or not any NFS traffic is going between the
> client and server once the hang happens?
> Note that the timeout value is 60 seconds, so if you see no immediate
> traffic, then let the ethereal/wireshark session keep running for a
> couple more minutes.

Should I run wireshark/ethereal on the client or on the server?

I'll get a trace tonight (10 PM CST) and get back to you.

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--rCb8EA+9TsBVtA92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGJihyND0rFCN2b1sRAoTvAJ0Q73im7blIfqfWfqF/96gQECdzZwCeMeb6
dQaZbxXzW3+yBHYlzG4LHWI=
=mh6w
-----END PGP SIGNATURE-----

--rCb8EA+9TsBVtA92--
