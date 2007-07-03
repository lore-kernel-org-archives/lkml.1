Return-Path: <linux-kernel-owner+w=401wt.eu-S1753932AbXGCEyw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbXGCEyw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2007 00:54:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751302AbXGCEyo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jul 2007 00:54:44 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:34899 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264AbXGCEyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2007 00:54:43 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Tue, 3 Jul 2007 14:54:41 +1000
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org>
In-Reply-To: <20070703042916.GA17240@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart42282587.HUo68dgbAY";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707031454.42078.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart42282587.HUo68dgbAY
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Tuesday 03 July 2007 14:29:18 Matthew Garrett wrote:
> Suspend to RAM on a machine with / on a fuse filesystem turns out to be=20
> a screaming nightmare - either the suspend fails because syslog (for=20
> instance) can't be frozen, or the machine deadlocks for some other=20
> reason I haven't tracked down. We could "fix" fuse, or alternatively we=20
> could do what we do for suspend to RAM on other platforms (PPC and APM)=20
> and just not use the freezer.
>=20
> Signed-off-by: Matthew Garrett <mjg59@srcf.ucam.org>

Note, though, that this won't help at all when people use the "suspend-to-r=
am=20
instead of powering down after writing a hibernation image" feature in=20
(uswsusp | tuxonice). Fuse is just a broken idea in the first place, but=20
given that it exists, we still need to find the underlying cause.

Regards,

Nigel

--nextPart42282587.HUo68dgbAY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGidaSN0y+n1M3mo0RAkUJAKC/o1YA3g7emTgVnlIHw3ehNAhtZQCfRTcD
ADtLzGVAQzzxgGczvXVX+io=
=MUPf
-----END PGP SIGNATURE-----

--nextPart42282587.HUo68dgbAY--
