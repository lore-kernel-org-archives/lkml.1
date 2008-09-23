Return-Path: <linux-kernel-owner+w=401wt.eu-S1752622AbYIWJ1P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622AbYIWJ1P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 05:27:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751121AbYIWJ04
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 05:26:56 -0400
Received: from postman.teamix.net ([194.150.191.120]:60086 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751113AbYIWJ0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 05:26:54 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: Documentation on CFQ iosched parameters
Date: Tue, 23 Sep 2008 11:26:51 +0200
User-Agent: KMail/1.9.9
Cc: linux-fsdevel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>,
       Aaron Carroll <aaronc@gelato.unsw.edu.au>
References: <200809221715.33143.ms@teamix.de> <48D85F49.4080001@gelato.unsw.edu.au>
In-Reply-To: <48D85F49.4080001@gelato.unsw.edu.au>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart33954141.Ny3XxkeaKM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809231126.51902.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart33954141.Ny3XxkeaKM
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 23. September 2008 schrieb Aaron Carroll:
> Martin Steigerwald wrote:
> > Hi!
> >
> > I am searching documentation about CFQ io scheduler. I can't find it in
> > linux 2.6.26 Documentation directory.
> >
> > I found about these in german[1]:
> >
> > back_seek_max:16384
> > back_seek_penalty:2
> > fifo_expire_async:250
> > fifo_expire_sync:123
> > quantum:4
> >
> > But I am completely missing about these:
> >
> > slice_async:40
>
> Base length of an asynchronous queue timeslice (that is, how long the
> queue has to dispatch requests each round).  The actual timeslice
> length is scaled by the I/O priority.

[...]

Thanks. As I do not find documentation about CFQ at all, I think I need to=
=20
create a new file from scratch... how about=20
Documentation/block/cfq-iosched.txt?

=46or that I need some more information about CFQ. I found the following=20
resources:

=2D CFQ V3 aka CFQ TS: http://lwn.net/Articles/143474/,=20
http://lwn.net/Articles/114770/ and posts by Jens,=20
http://lwn.net/Articles/113869/

=2D CFQ V2: Post by Jens, http://lwn.net/Articles/101029/

=2D CFQ: Post by Jens, http://lwn.net/Articles/22429/

=2D Documentation/block/as-iosched.txt / deadline-iosched.txt (as for how a=
n IO=20
scheduler can be documented)

Would that be what I should read in order to write such an documentation?=20

How about the relevance of CFQ and CFQ v2 stuff? What of it would be good t=
o=20
mention? I would like to limit documentation to what is still relevant for=
=20
the current implementation of the IO scheduler. Should I mention its=20
inheritance from SFQ - maybe in a small introduction and historic overview?

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart33954141.Ny3XxkeaKM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjYtlsACgkQHhDFkwOZrpCKyQCePRKHUjgi0sr8pe1wV9bfYVVI
MV8AmgO8kiLF8APUGMk5zVPN7FEX0nND
=CMex
-----END PGP SIGNATURE-----

--nextPart33954141.Ny3XxkeaKM--
