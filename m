Return-Path: <linux-kernel-owner+w=401wt.eu-S1755365AbXD0GIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365AbXD0GIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 02:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755363AbXD0GIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 02:08:32 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:41028 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755365AbXD0GIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 02:08:31 -0400
Subject: Re: Back to the future.
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
References: <1177567481.5025.211.camel@nigel.suspend2.net>
	 <84144f020704260028q190fc90fs8f9ea703e42e7910@mail.gmail.com>
	 <1177573348.5025.224.camel@nigel.suspend2.net>
	 <alpine.LFD.0.98.0704260941310.9964@woody.linux-foundation.org>
	 <1177617379.4737.29.camel@nigel.suspend2.net>
	 <Pine.LNX.4.64.0704270750320.13539@sbz-30.cs.Helsinki.FI>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-q2bdYnfD/WIxBrNHe7xq"
Date: Fri, 27 Apr 2007 16:08:30 +1000
Message-Id: <1177654110.4737.91.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-q2bdYnfD/WIxBrNHe7xq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi.

On Fri, 2007-04-27 at 07:52 +0300, Pekka J Enberg wrote:
> On Thu, 2007-04-26 at 09:56 -0700, Linus Torvalds wrote:
> > >    which will map in the snapshot, return the mapped address and the =
size=20
> > >    (and if you want to support snapshots > 4GB, be my guest, but I su=
spect=20
> > >    you're actually *better* off just admitting that if you cannot shr=
ink=20
> > >    the snapshot to less than 32 bits, it's not worth doing)
> =20
> On Fri, 27 Apr 2007, Nigel Cunningham wrote:
> > That inherently limits the image to half of available ram (you need
> > somewhere to store the snapshot), so you won't get the full image you
> > express interest in below.
>=20
> It doesn't. We can make the userspace mapped pages copy-on-write. As long=
=20
> as the userspace makes sure there's not much activity during=20
> snapshot/shutdown, we will be fine. What we probably do need to copy is=20
> kernel pages.

COW is a possibility, but I understood (perhaps wrongly) that Linus was
thinking of a single syscall or such like to prepare the snapshot. If
you're going to start doing things like this, won't that mean you'd then
have to update/redo the snapshot or somehow nullify the effect of
anything the programs does so that doing it again after the snapshot is
restored doesn't cause problems?

I was going to leave it at that and press send, but perhaps that
wouldn't be wise. I feel I should also ask what you're thinking of as a
means of making sure userspace doesn't do much activity.

Thanks for your labours!

Regards,

Nigel

--=-q2bdYnfD/WIxBrNHe7xq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGMZNeN0y+n1M3mo0RAopDAJ4nqnszwtQlbMllFX8JVksRge9qbgCgmilK
phxPNqXDVHepzuCrVm2DuNU=
=0GSP
-----END PGP SIGNATURE-----

--=-q2bdYnfD/WIxBrNHe7xq--

