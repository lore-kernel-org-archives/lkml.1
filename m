Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbYIZPhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbYIZPhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2008 11:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752211AbYIZPhZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Sep 2008 11:37:25 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:31434 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751611AbYIZPhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2008 11:37:24 -0400
From: Ian Campbell <ijc@hellion.org.uk>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Tom Tucker <tom@opengridcomputing.com>,
       Trond Myklebust <trond.myklebust@fys.uio.no>,
       Grant Coady <gcoady.lk@gmail.com>, linux-kernel@vger.kernel.org,
       neilb@suse.de, linux-nfs@vger.kernel.org
In-Reply-To: <20080923170344.GC2700@fieldses.org>
References: <20080912224323.GN22126@fieldses.org>
	 <48CAF80A.4010109@opengridcomputing.com>
	 <1221296243.2534.7.camel@localhost.localdomain>
	 <1221544139.2534.18.camel@localhost.localdomain>
	 <48CF9AC3.6060801@opengridcomputing.com>
	 <1221577412.28572.60.camel@zakaz.uk.xensource.com>
	 <48CFD7C3.5080207@opengridcomputing.com>
	 <1221582285.28572.67.camel@zakaz.uk.xensource.com>
	 <1222156770.6869.13.camel@localhost.localdomain>
	 <1222169589.6869.20.camel@localhost.localdomain>
	 <20080923170344.GC2700@fieldses.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-WKsm0TWQEwHV+eO4cfBL"
Date: Fri, 26 Sep 2008 16:37:06 +0100
Message-Id: <1222443426.3949.18.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-SA-Exim-Connect-IP: 192.168.1.5
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: NFS regression? Odd delays and lockups accessing an NFS export.
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
X-Cloudmark-Analysis: v=1.0 c=1 a=unbeb6qN2T0A:10 a=497XeZ5pv4kA:10 a=VBWmamPvmWA5gKh9pDAA:9 a=tCMsjMcSr9jI7iwp_lWLHf_fyVoA:4 a=LY0hPdMaydYA:10 a=2Gqrtl2hxvu63f_1LU4A:9 a=f1x-yzlD9YdmzDGO7VspwMneiPoA:4 a=rPt6xJ-oxjAA:10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-WKsm0TWQEwHV+eO4cfBL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-09-23 at 13:03 -0400, J. Bruce Fields wrote:
> On Tue, Sep 23, 2008 at 12:33:09PM +0100, Ian Campbell wrote:
> > On Tue, 2008-09-23 at 08:59 +0100, Ian Campbell wrote:
> > > I've found that the problem was backported into the stable stream sin=
ce
> > > I cannot reproduce the issue with 2.6.26 but I can with 2.6.26.5. Thi=
s
> > > is quite useful since there are only 3 relevant looking changesets in
> > > that range. I will bisect between these before confirming the culprit=
 on
> > > mainline.
>=20
> Could you double-check that this is reproduceable with this commit
> applied, and not reproduceable when it's not?

I've reproduced with exactly commit
f41f741838480aeaa3a189cff6e210503cf9c42d on trunk and am now running
2e96d2867245668dbdb973729288cf69b9fafa66 which is the changeset
immediately before.

> I suppose it's not impossible that this could be triggering the problem
> in some very roundabout way, but it seems a bit out of left field--so I
> wonder whether one of the bisection points could have gotten marked good
> when it should have been bad, or vice-versa.

It's possible, the good case is naturally quite hard to establish with
100% certainty. I declared v2.6.26 OK after an uptime of 4 days and 19
hours, compared with failure normally within 1-2 days. It's possible I
was premature in doing so. I'll run 2e96d2867 for at least a full week
before reporting back.

Ian.
--=20
Ian Campbell

Unix is mature OS, windows is still in diapers and they smell badly.
		-- Rafael Skodlar=20

--=-WKsm0TWQEwHV+eO4cfBL
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjdAaIACgkQM0+0qS9rzVlnhwCghXf5JG5La4zjqAI59GFAu8nX
1A4An0i4FpPd/3R4mGWQrDZNobtD/kBB
=VM2U
-----END PGP SIGNATURE-----

--=-WKsm0TWQEwHV+eO4cfBL--

