Return-Path: <linux-kernel-owner+w=401wt.eu-S1755706AbZGMMUy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755706AbZGMMUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jul 2009 08:20:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755667AbZGMMUx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Jul 2009 08:20:53 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:34636 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755625AbZGMMUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jul 2009 08:20:53 -0400
Subject: Re: inotify regression, missing events
From: Scott James Remnant <scott@ubuntu.com>
To: Eric Paris <eparis@redhat.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1247313019.2791.1.camel@localhost>
References: <1247328127.4003.6.camel@wing-commander>
	 <1247313019.2791.1.camel@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-1Ceq/iMJJ8SiD8HNtIRC"
Date: Mon, 13 Jul 2009 13:21:09 +0100
Message-Id: <1247487669.14981.18.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1Ceq/iMJJ8SiD8HNtIRC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-07-11 at 07:50 -0400, Eric Paris wrote:

> On Sat, 2009-07-11 at 17:02 +0100, Scott James Remnant wrote:
> > Looks like there's a regression with inotify since the rewrite to use
> > fanotify.  Events are simply missing and not being delivered to
> > userspace.
> >=20
> > Here's a simple test case, just compile and run it:
>=20
> I bet I know exactly what it is (notification.c tail merge code isn't
> comparing filename only inode+mask) but I'm walking out of the house.
> I'll try my theory later tonight and post a patch.
>=20
> Stupid Eric, Stupid.
>=20
In other words, when the second deleted-file-in-a-directory event comes
through, it gets ignored because there's already a
"deleted-file-in-a-directory" event for that directory?

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-1Ceq/iMJJ8SiD8HNtIRC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpbJrUACgkQSnQiFMl4yK5hFQCffwSCIwTQSgoLdRIH7f7Zxt7P
W5oAn21Z1GZSXGuO84oOc9OBhPYaarXv
=cqGt
-----END PGP SIGNATURE-----

--=-1Ceq/iMJJ8SiD8HNtIRC--

