Return-Path: <linux-kernel-owner+w=401wt.eu-S1759907AbXH1Bfx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759907AbXH1Bfx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2007 21:35:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752302AbXH1Bfn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Aug 2007 21:35:43 -0400
Received: from iucha.net ([209.98.146.184]:46421 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752172AbXH1Bfm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2007 21:35:42 -0400
Date: Mon, 27 Aug 2007 20:35:41 -0500
From: Florin Iucha <florin@iucha.net>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Bret Towe <magnade@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Subject: Re: NFS woes again
Message-ID: <20070828013541.GA10422@iucha.net>
References: <Pine.LNX.4.64.0708211502330.2460@twin.jikos.cz> <20070821131759.GI10422@iucha.net> <20070821132704.GJ10422@iucha.net> <Pine.LNX.4.64.0708211536560.2460@twin.jikos.cz> <20070822132200.GO10422@iucha.net> <20070823125210.GQ10422@iucha.net> <dda83e780708231014x66093dafj83263a2a1c8203bb@mail.gmail.com> <20070823173637.GS10422@iucha.net> <1188220651.6701.32.camel@heimdal.trondhjem.org> <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="utG8zEvBNE7w4yrA"
Content-Disposition: inline
In-Reply-To: <dda83e780708271819x247ac49dx981c49a80ed6a999@mail.gmail.com>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--utG8zEvBNE7w4yrA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 27, 2007 at 06:19:29PM -0700, Bret Towe wrote:
> On 8/27/07, Trond Myklebust <trond.myklebust@fys.uio.no> wrote:
> > > > this sounds alot like the post i did yesterday titled 'nfs4 hang re=
gression'
> > > > i tracked it down to commit 3d39c691ff486142dd9aaeac12f553f4476b7a6
> > >
> > > Yes, it certainly does -- all the symptoms match!
> >
> > Could you and Bret please check if the attached patch fixes the hang?
>
> no good for me still hangs after ~30minutes

I just booted into the new kernel
(3d39c691ff486142dd9aaeac12f553f4476b7a6 + Trond's patch) and it hangs
in 10-15 minutes.

Process traces available at http://iucha.net/nfs/23-rc2-nfs-fix-1/kernel.lo=
g.gz

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--utG8zEvBNE7w4yrA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG03vtND0rFCN2b1sRAqTBAJ9xWvbFjlzgrUXWo07iGk+rbfopRACePINo
mF1So6wfxXsc4y5PfGaceKs=
=troU
-----END PGP SIGNATURE-----

--utG8zEvBNE7w4yrA--
