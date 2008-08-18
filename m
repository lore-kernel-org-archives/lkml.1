Return-Path: <linux-kernel-owner+w=401wt.eu-S1754105AbYHROv4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105AbYHROv4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:51:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752780AbYHROvs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:51:48 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:26179 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbYHROvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:51:47 -0400
Date: Mon, 18 Aug 2008 17:51:31 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Pavel Emelyanov <xemul@openvz.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] binfmt_misc.c: avoid potential kernel stack overflow
Message-ID: <20080818145130.GB4818@localhost.localdomain>
References: <20080818112849.GA4951@localhost.localdomain> <48A98293.5080109@openvz.org> <20080818144418.GA4818@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XF85m9dhOBO43t/C"
Content-Disposition: inline
In-Reply-To: <20080818144418.GA4818@localhost.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-29)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XF85m9dhOBO43t/C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 18, 2008 at 05:44:19PM +0300, Kirill A. Shutemov wrote:
> I have noticed yet another problem: more than one bit of sh_bang can be
> used on alpha:
>=20
> fs/exec.c
> 1189                         return retval;
> 1190=20
> 1191                 /* Remember if the application is TASO.  */
> 1192                 bprm->sh_bang =3D eh->ah.entry < 0x100000000UL;
> 1193=20
> 1194                 bprm->file =3D file;

Sorry. Please ignore this part of the message. %)

--=20
Regards,  Kirill A. Shutemov
 + Belarus, Minsk
 + ALT Linux Team, http://www.altlinux.com/

--XF85m9dhOBO43t/C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkipjHIACgkQbWYnhzC5v6ofSACePn4RFzSGjr+aQocTpCOMwQYw
nGQAoIAftNkX0zEgZeWnAX4fE7tqmw97
=TtBR
-----END PGP SIGNATURE-----

--XF85m9dhOBO43t/C--
