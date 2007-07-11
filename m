Return-Path: <linux-kernel-owner+w=401wt.eu-S932544AbXGKMLb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544AbXGKMLb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 08:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761881AbXGKMLG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 08:11:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:45990 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761605AbXGKMLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 08:11:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Hibernation Redesign
Date: Wed, 11 Jul 2007 22:11:22 +1000
User-Agent: KMail/1.9.6
Cc: rjw@sisk.pl, a1426z@gawab.com, jeremy@goop.org, jbms@cmu.edu, pavel@ucw.cz,
       nickpiggin@yahoo.com.au, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
References: <200707081737.21932.a1426z@gawab.com> <200707111304.40504.rjw@sisk.pl> <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I8a6Y-0008Sm-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1311607.KNoiKArrxj";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707112211.23420.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1311607.KNoiKArrxj
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 11 July 2007 21:11:34 Miklos Szeredi wrote:
> > Anyway, to implement the kexec approach we must separate the
> > hibernation from the suspend at the drivers level, which I'm still
> > going to do, but I need to take part in endless discussions
>=20
> Discussions are good.  We understand the problem better.  Now I still
> think we don't understand every aspect completely, so continuing the
> discussion makes sense.
>=20
> > regarding the freezer, how it is bad and how we should drop it,
> > because it breaks things (which NB is not true, because it doesn't).
>=20
> This thread started out from a bug, that seemed to be caused by the
> freezer (we still don't exactly know what it was caused by), and the
> discussion uncovered various problems _with_ the freezer, that up to
> now no other _proper_ solutions have been propsed than to remove the
> freezer.

No other _proper_ solutions have been proposed. Everyone who suggests remov=
ing=20
the freezer also suggests implementing it all over again. It might be sendi=
ng=20
SIGSTOP to everything. It might be shifting the desk chairs around and=20
creating a completely new kernel context, but they always have the same=20
goal - stopping the existing activity, and they all come with their own=20
issues (even if they're not obvious yet because the alternatives are=20
currently vapourware to one extent or another).

IMHO, the real solution is to go back to the original issue and fix it=20
properly. Make fuse filesystems play nicely with the existing freezer. I've=
=20
just gone back and looked at the point where you started talking=20
about "malicious filesystems". You talk about fuse imposing certain orderin=
g=20
in the userspace tasks being frozen. Please, say more. What ordering issues=
?=20
Why? How can such ordering be determined programmatically?
=20
Regards,

Nigel

--nextPart1311607.KNoiKArrxj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGlMjrN0y+n1M3mo0RAhYrAKDdG1mkuibD1lDx/uZWgggjI62fdwCgk/gu
rXBK2yBy6rj+6deHM8RiDCo=
=UZsw
-----END PGP SIGNATURE-----

--nextPart1311607.KNoiKArrxj--
