Return-Path: <linux-kernel-owner+w=401wt.eu-S933231AbXDZHmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933231AbXDZHmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 03:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933297AbXDZHmf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 03:42:35 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:58196 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933231AbXDZHmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 03:42:33 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-/zRJ8btGWeTGwd22O8Ea"
Date: Thu, 26 Apr 2007 17:42:28 +1000
Message-Id: <1177573348.5025.224.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/zRJ8btGWeTGwd22O8Ea
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Thu, 2007-04-26 at 10:28 +0300, Pekka Enberg wrote:
> On 4/26/07, Nigel Cunningham <nigel@nigel.suspend2.net> wrote:
> > 3) Someone else steps up to the plate and tries to merge Suspend2 one
> > bit at a time.
>=20
> So which bits do we want to merge? For example, Suspend2
> kernel/power/ui.c, kernel/power/compression.c, and
> kernel/power/encryption.c seem pointless now that we have uswsusp.
> Furthermore, being the shameless Linus cheerleader that I am, I got
> the impression that we should fix the snapshot/shutdown logic in the
> kernel which Suspend2 doesn't really address?

I agree that the driver logic could be addressed too, but to answer your
question...

* Doing things in the right order? (Prepare the image, then do the
atomic copy, then save).
* Mulithreaded I/O (might as well use multiple cores to compress the
image, now that we're hotplugging later).
* Support for > 1 swap device.
* Support for ordinary files.
* Full image option.
* Modular design?

Regards,

Nigel

--=-/zRJ8btGWeTGwd22O8Ea
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMFfkN0y+n1M3mo0RAs1RAKCuBfOpmnHckPmN7LOxx88FA0ipswCg92Ap
dZTCsR36FXdYr63Zh/x/H2A=
=/x8G
-----END PGP SIGNATURE-----

--=-/zRJ8btGWeTGwd22O8Ea--

