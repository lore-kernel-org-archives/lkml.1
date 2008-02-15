Return-Path: <linux-kernel-owner+w=401wt.eu-S1756202AbYBORLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756202AbYBORLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2008 12:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbYBORLK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Feb 2008 12:11:10 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:33243 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751691AbYBORLI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2008 12:11:08 -0500
Subject: Re: Disk schedulers
From: Zan Lynx <zlynx@acm.org>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Lukas Hejtmanek <xhejtman@ics.muni.cz>, linux-kernel@vger.kernel.org
In-Reply-To: <200802151557.59082.prakash@punnoor.de>
References: <20080214162104.GA5347@ics.muni.cz>
	 <Pine.LNX.4.64.0802151541370.30301@fbirervta.pbzchgretzou.qr>
	 <200802151557.59082.prakash@punnoor.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-aIeDty+2jUMx7GC6E0Lj"
Date: Fri, 15 Feb 2008 10:11:26 -0700
Message-Id: <1203095486.6663.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20080215/1JQ45J-0004p2-IQ-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-aIeDty+2jUMx7GC6E0Lj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Fri, 2008-02-15 at 15:57 +0100, Prakash Punnoor wrote:
> On the day of Friday 15 February 2008 Jan Engelhardt hast written:
> > On Feb 14 2008 17:21, Lukas Hejtmanek wrote:
> > >Hello,
> > >
> > >whom should I blame about disk schedulers?
> >
> > Also consider
> > - DMA (e.g. only UDMA2 selected)
> > - aging disk
>=20
> Nope, I also reported this problem _years_ ago, but till now much hasn't=20
> changed. Large writes lead to read starvation.

Yes, I see this often myself.  It's like the disk IO queue (I set mine
to 1024) fills up, and pdflush and friends can stuff write requests into
it much more quickly than any other programs can provide read requests.

CFQ and ionice work very well up until iostat shows average IO queuing
above 1024 (where I set the queue number).
--=20
Zan Lynx <zlynx@acm.org>

--=-aIeDty+2jUMx7GC6E0Lj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD4DBQBHtce+G8fHaOLTWwgRAjmfAJdDk9RuzmukPm00vgc8a2Dk8hy8AJ46GBp3
wQ4kH35/1cp8cIujlnURZA==
=GD0e
-----END PGP SIGNATURE-----

--=-aIeDty+2jUMx7GC6E0Lj--

