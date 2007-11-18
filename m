Return-Path: <linux-kernel-owner+w=401wt.eu-S1753489AbXKRJqN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753489AbXKRJqN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2007 04:46:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751022AbXKRJqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 Nov 2007 04:46:00 -0500
Received: from paperboy.netsplit.com ([82.108.80.242]:34225 "EHLO
	paperboy.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbXKRJp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2007 04:45:59 -0500
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Sun, 18 Nov 2007 04:45:59 EST
Subject: Re: [PATCH 2/3] wait_task_stopped: tidy up the noreap case
From: Scott James Remnant <scott@ubuntu.com>
To: Oleg Nesterov <oleg@tv-sign.ru>
Cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alexey Dobriyan <adobriyan@sw.ru>, Kees Cook <kees@ubuntu.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071117163835.GA193@tv-sign.ru>
References: <20071116172413.GA7296@tv-sign.ru>
	 <20071116202403.1CF0C26F8BA@magilla.localdomain>
	 <20071117163835.GA193@tv-sign.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SM2zvVL9KITq/qNkE7Q3"
Date: Sun, 18 Nov 2007 09:14:04 +0000
Message-Id: <1195377244.6070.5.camel@wing-commander>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SM2zvVL9KITq/qNkE7Q3
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-11-17 at 19:38 +0300, Oleg Nesterov wrote:

> > While you're at it, you could fix the status argument to
> wait_noreap_copyout.
> > It should be just exit_code, not the WIFSTOPPED bit format it does now.
>=20
> OK, unless Scott is going to do this.
>=20
Have sent this patch separately to the list -- since it's actually my
first ever, I hope I got the format/sign-off/etc. right.

Scott
--=20
Scott James Remnant
scott@ubuntu.com

--=-SM2zvVL9KITq/qNkE7Q3
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHQAJcSnQiFMl4yK4RAjqtAJ9GlhGeHo6iOwW7hCdey07skVTpvwCeIwwj
XdSQ9hZNeii3cW3rWZDsT3E=
=NsGN
-----END PGP SIGNATURE-----

--=-SM2zvVL9KITq/qNkE7Q3--

