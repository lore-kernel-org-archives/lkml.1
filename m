Return-Path: <linux-kernel-owner+w=401wt.eu-S1030293AbXDCOvz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030293AbXDCOvz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 10:51:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030295AbXDCOvz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 10:51:55 -0400
Received: from cel.leonerd.org.uk ([62.49.94.186]:3041 "EHLO cel.leo"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1030293AbXDCOvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 10:51:54 -0400
Date: Tue, 3 Apr 2007 15:51:51 +0100
From: Paul LeoNerd Evans <leonerd@leonerd.org.uk>
To: Martin Mares <mj@ucw.cz>
Cc: "Antonino A. Daplas" <adaplas@gmail.com>, Andrew Morton <akpm@osdl.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       Paul LeoNerd Evans <leonerd@leonerd.org.uk>
Subject: Re: [PATCH] vt: Do not clear UTF when resetting console
Message-ID: <20070403145151.GN26707@cel.leo>
References: <46110F88.5040905@gmail.com> <mj+md-20070403.114037.27180.nikam@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/QKKmeG/X/bPShih"
Content-Disposition: inline
In-Reply-To: <mj+md-20070403.114037.27180.nikam@ucw.cz>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/QKKmeG/X/bPShih
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 03, 2007 at 01:41:27PM +0200, Martin Mares wrote:
> > Resetting the console, either by ANSI escape sequences or by the reset =
utility,
> > will drop the console back to legacy (non-UTF-8) mode.
>=20
> Yes, and as far as I understand the logic behind these escape sequences,
> it's the intended behavior, not a bug.
>=20
> The escape sequence for terminal reset should reset as much as possible,
> I see no reason for making an exception for the UTF-8 mode.

Does whatever defines what these escapes mean, have any comment to make
about UTF-8? If not, why can't we declare that UTF-8 mode is the "reset"
mode, the default that would be dropped to on a full reset, and if
anyone wanted to switch that out to non-default not-UTF-8 mode, they
could, but that a reset will always reenable it again..?

--=20
Paul "LeoNerd" Evans

leonerd@leonerd.org.uk
ICQ# 4135350       |  Registered Linux# 179460
http://www.leonerd.org.uk/

--/QKKmeG/X/bPShih
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGEmoH7eTlovtaLtYRAnEHAJ41KEPzbuvao+Y9qAZAyUeXbiDRegCgrd9Q
fMORYLo9FK5/bw0bJ6VUxm0=
=d2Rw
-----END PGP SIGNATURE-----

--/QKKmeG/X/bPShih--
