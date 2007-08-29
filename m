Return-Path: <linux-kernel-owner+w=401wt.eu-S1757520AbXH2D1S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520AbXH2D1S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2007 23:27:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753663AbXH2D1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Aug 2007 23:27:07 -0400
Received: from iucha.net ([209.98.146.184]:33513 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753544AbXH2D1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2007 23:27:06 -0400
Date: Tue, 28 Aug 2007 22:27:05 -0500
From: Florin Iucha <florin@iucha.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Bret Towe <magnade@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: NFS woes again
Message-ID: <20070829032705.GD7067@iucha.net>
References: <20070821132704.GJ10422@iucha.net> <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz> <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net> <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com> <20070823173637.GS10422@iucha.net> <1188220651.6701.32.camel@heimdal.trondhjem.org> <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com> <20070828013541.GA10422@iucha.net> <1188307723.6701.138.camel@heimdal.trondhjem.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <1188307723.6701.138.camel@heimdal.trondhjem.org>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 28, 2007 at 09:28:43AM -0400, Trond Myklebust wrote:
> Doh! I see the problem: cancel_delayed_work_sync() shouldn't ever be
> called recursively.
>=20
> The following patch should be correct. Please just discard the previous
> one...

So far so good.  This patch got one hour uptime...  I'll stay with
this kernel for a few days, to keep an eye on it.

Thanks,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG1OeJND0rFCN2b1sRAsEJAJsG03kqkwZibujkR57HJfbhW2URJACeI9uT
KVXRCwmKnBxuK//q9d2SPp4=
=HiEj
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
