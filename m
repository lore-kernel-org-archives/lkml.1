Return-Path: <linux-kernel-owner+w=401wt.eu-S1757214AbYJMLfm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214AbYJMLfm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 07:35:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756544AbYJMLf3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 07:35:29 -0400
Received: from postman.teamix.net ([194.150.191.120]:57132 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760081AbYJMLf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 07:35:28 -0400
To: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: Re: [TuxOnIce-devel] safe resuming: automatically invalidating an outdated hibernate snapshot
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
Date: Mon, 13 Oct 2008 13:35:25 +0200
Cc: Nigel Cunningham <ncunningham@crca.org.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1621858.rxY8xRftGr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810131335.25793.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1621858.rxY8xRftGr
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 13. Oktober 2008 schrieben Sie:
> Hi Martin.

Hi Nigel,

> On Mon, 2008-10-13 at 12:13 +0200, Martin Steigerwald wrote:
> > Cc to linux-kernel: This is mainly for tuxonice, but it might also be
> > relevant for other hibernate implementations. Maybe some general
> > mechanism for checking whether an on disk snapshot of the system is
> > current would be good - as also the resume parameter could be missing or
> > wrong or whatnot.
> >
> >
> > Hi!
> >
> > Is there a way to automatically invalidate the tuxonice snapshot when a
> > non tuxonice kernel is booted accidentally? I.e. could tuxonice recogni=
ze
> > when the swap partition has been accessed *after* the snapshot has been
> > written?

[...]

> The simplest way is to mkswap the appropriate partitions from a script
> run when booting (after we check whether to resume, of course). I
> believe the hibernate script already has support for this. Maybe
> pm-utils or such like needs it too?

Simple idea. But I dislike automatically formatting a partition on each boo=
t.=20
What if the user changes the partition layout and forgets to adapt swap=20
partition / resume parameter? AFAIR only mkfs.xfs really checks whether the=
=20
partition contains an existing filesystem and even that check does cannot=20
trigger in case an undetected filesystem is on the partition.

Thus I'd prefer a way to touch the swap partition without destroying its=20
contents and then checking whether it has been touched after the snapshot h=
as=20
been written. I would then like to have it touched on every bootup on the=20
Linux system. Would something along these lines be possible?

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart1621858.rxY8xRftGr
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjzMn0ACgkQHhDFkwOZrpBtBwCfYLqYWr70SsO4e/7KQOvOMFd2
G/AAn1XOhu70FxDSgTBob/x7eQUnaw5R
=3LN9
-----END PGP SIGNATURE-----

--nextPart1621858.rxY8xRftGr--
