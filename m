Return-Path: <linux-kernel-owner+w=401wt.eu-S1755085AbYBXVUa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085AbYBXVUa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 16:20:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752895AbYBXVUT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 16:20:19 -0500
Received: from orchitis.omgwallhack.org ([66.179.21.205]:57086 "EHLO
	smtp.omgwallhack.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872AbYBXVUS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 16:20:18 -0500
From: Julian Blake Kongslie <jblake@omgwallhack.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <200802241223.46930.rjw@sisk.pl>
References: <1203553943.4422.25.camel@dukephillips.omgwallhack.org>
	 <200802232143.31903.rjw@sisk.pl>
	 <1203827444.4202.18.camel@dukephillips.omgwallhack.org>
	 <200802241223.46930.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9afue8FvMP3jMvRFp6vp"
Message-Id: <1203887415.4154.4.camel@dukephillips.omgwallhack.org>
Mime-Version: 1.0
Subject: Re: Hang on suspend
Organization: Fists of Righteous Harmony
Date: Sun, 24 Feb 2008 13:20:06 -0800
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9afue8FvMP3jMvRFp6vp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2008-02-24 at 12:23 +0100, Rafael J. Wysocki wrote:
> Can you please check what's at the address platform_suspend_late+0x19?

0xc0253ca9 is in platform_suspend_late (drivers/base/platform.c:579).
574	{
575		struct platform_driver *drv =3D to_platform_driver(dev->driver);
576		struct platform_device *pdev;
577		int ret =3D 0;
578=09
579		pdev =3D container_of(dev, struct platform_device, dev);
580		if (dev->driver && drv->suspend_late)
581			ret =3D drv->suspend_late(pdev, mesg);
582=09
583		return ret;

> Thanks,
> Rafael

Thanks,

--=20
-Julian Blake Kongslie
<jblake@omgwallhack.org>

If this is a mailing list, please CC me on replies.
vim: set ft=3Dtext :

--=-9afue8FvMP3jMvRFp6vp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Don't have my public key? Email <jblake@omgwallhack.org> and I'll gladly mail it to you.

iD8DBQBHwd02uU009xtCYDURAvIBAJ4i/W36cNIJzbEdBEyVWlhI+RHxMACgk855
ipNPEbS6MNLg08WShg4SerY=
=YxeN
-----END PGP SIGNATURE-----

--=-9afue8FvMP3jMvRFp6vp--

