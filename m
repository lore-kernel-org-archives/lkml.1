Return-Path: <linux-kernel-owner+w=401wt.eu-S1760764AbXHHJXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764AbXHHJXQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 05:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755359AbXHHJXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 05:23:04 -0400
Received: from mail.gmx.net ([213.165.64.20]:59300 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755410AbXHHJXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 05:23:02 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX19ACl1T4/BAAvb/Aw/2MFIYHF52vKeiVla2fNd8Ja
	pKmyUWfUpaUHtx
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [ibm-acpi-devel] suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Wed, 8 Aug 2007 11:22:52 +0200
User-Agent: KMail/1.9.5
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
References: <200708051902.18801.toralf.foerster@gmx.de> <200708071521.33679.toralf.foerster@gmx.de> <200708071738.24502.rjw@sisk.pl>
In-Reply-To: <200708071738.24502.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1380805.pGmvZEDqbS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708081122.55036.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1380805.pGmvZEDqbS
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Dienstag, 7. August 2007 17:38 schrieb Rafael J. Wysocki:

> Actually, you don't need the patch above, just do
> "echo shutdown > /sys/power/disk" before the hibernation (or use
> BTW, can you please try this patch before you do that:
> http://www.sisk.pl/kernel/hibernation_and_suspend/2.6.23-rc2/patches/19-A=
CPI-Enable-GPEs-before-_WAK-is-called.patch

This patch applied at commit cfee47f doesn't solve the regression.

>=20
> So place "echo shutdown > /sys/power/disk" before that into your script.
yep, that works for me.

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart1380805.pGmvZEDqbS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGuYtshyrlCH22naMRAhf2AKCjSdjK+hpd4RPmLRvJ+/AwipbqkwCfWdPC
echoUufqB8VnGas965/SKjI=
=WNrF
-----END PGP SIGNATURE-----

--nextPart1380805.pGmvZEDqbS--
