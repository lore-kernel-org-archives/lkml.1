Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYJEMSS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYJEMSS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Oct 2008 08:18:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753806AbYJEMSK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Oct 2008 08:18:10 -0400
Received: from msr30.hinet.net ([168.95.4.130]:45741 "EHLO msr30.hinet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753788AbYJEMSJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Oct 2008 08:18:09 -0400
Date: Sun, 5 Oct 2008 20:17:54 +0800
From: Kanru Chen <koster@debian.org.tw>
To: linux-kernel@vger.kernel.org
Subject: Re: TIOCGWINSZ retuns old pty size after receiving SIGWINCH
Message-ID: <20081005121753.GA18549@atom>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8t9RHnE3ZwKMSgU+"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8t9RHnE3ZwKMSgU+
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 5 Oct 2008 13:03:30 +0100
Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> The relevant fixes were pushed and are in the current -rc series kernels.
> The tty mutex now locks the TIOCG/SWINSZ calls using the tty mutex lock
> of the tty side of tty/pty pairs.

Thanks! I didn't notice that.

Regards,
--=20
   ~    Kanru Chen <koster@debian.org.tw>
  'v'   http://stu.csie.ncnu.edu.tw/~kanru.96/
 // \\  GnuPG-Key ID: 365CC7A2
/(   )\ Fingerprint: 3278 DFB4 BB28 6E8C 9E1F  1ECB B1B7 5B5F 365C C7A2
 ^`~'^

--8t9RHnE3ZwKMSgU+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkjosHEACgkQsbdbXzZcx6J4QACfXB4ZxQXZf+FfRyvvathtDg75
+B8AnAq+YC9XJGLugC5YFmIpw/BWRBsQ
=oEa+
-----END PGP SIGNATURE-----

--8t9RHnE3ZwKMSgU+--
