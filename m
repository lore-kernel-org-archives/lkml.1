Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbZAJVUi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbZAJVUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2009 16:20:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755159AbZAJVUM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Jan 2009 16:20:12 -0500
Received: from zelda.netsplit.com ([87.194.19.211]:52296 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZAJVUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2009 16:20:09 -0500
Subject: Re: [RESEND][RFC PATCH v2] waitfd
From: Scott James Remnant <scott@canonical.com>
To: Casey Dahlin <cdahlin@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Randy Dunlap <randy.dunlap@oracle.com>,
       Roland McGrath <roland@redhat.com>,
       Davide Libenzi <davidel@xmailserver.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
In-Reply-To: <49690FC9.4010403@redhat.com>
References: <49639EB8.40204@redhat.com> <4963ABF0.6070400@redhat.com>
	 <20090107123457.GB16268@elte.hu>  <20090107171922.GA18000@redhat.com>
	 <1231598863.11642.55.camel@quest>  <49690FC9.4010403@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-W+9iAj8BbJ/TCxqUe7Y4"
Date: Sat, 10 Jan 2009 21:20:19 +0000
Message-Id: <1231622419.11642.197.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-W+9iAj8BbJ/TCxqUe7Y4
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-10 at 16:14 -0500, Casey Dahlin wrote:

> From the perspective of waitfd, the only difference between WNOHANG and
> O_NONBLOCK is which argument you put the flags in. The API should only
> support one or the other, but internally they would imply the same thing.
>=20
Well, you get O_NONBLOCK for free by having a file descriptor; and you
can't turn off people trying to turn it on/off with fcntl() - so you may
as well just use that, no? :-)

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-W+9iAj8BbJ/TCxqUe7Y4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklpERMACgkQSnQiFMl4yK5HcACfU+SnzXuB6j34xOUztiYDm3SX
e10AnjXtzuc+5lCcRwmVwKO/DEOANn7y
=vFUK
-----END PGP SIGNATURE-----

--=-W+9iAj8BbJ/TCxqUe7Y4--

