Return-Path: <linux-kernel-owner+w=401wt.eu-S1759388AbYGRXzo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759388AbYGRXzo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 19:55:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbYGRXzh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 19:55:37 -0400
Received: from server.drzeus.cx ([85.8.24.28]:51434 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753287AbYGRXzg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 19:55:36 -0400
Date: Sat, 19 Jul 2008 01:55:31 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
 disabling IRQ
Message-ID: <20080719015531.6c8a1981@mjolnir.drzeus.cx>
In-Reply-To: <20080711164706.GA8943@hardeman.nu>
References: <20080624181656.GB14243@hardeman.nu>
	<20080710083457.7887d363@mjolnir.drzeus.cx>
	<20080711164706.GA8943@hardeman.nu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-24238-1216425335-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-24238-1216425335-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jul 2008 18:47:06 +0200
David H=C3=A4rdeman <david@hardeman.nu> wrote:

> On Thu, Jul 10, 2008 at 08:34:57AM +0200, Pierre Ossman wrote:
> >And can you give me a complete
> >dmesg dump. The sdhci hardware might not be the culprit, but just a
> >trigger in that it enables that interrupt line.
>=20
> Attached below....and /proc/interrupts says:
>=20

I see that you have an iwl4965. I got this precise problem when I
toggled the rfkill switch on my laptop. It is fixed in 2.6.26 though.
Could you try upgrading the kernel and see if it's the same bug?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-24238-1216425335-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiBLXYACgkQ7b8eESbyJLgKHACcCZeWo88vQGO9Ynag9hgtR48q
YE0An1hVdGUpCghgbajr86ZkhS8DSd92
=3U9H
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-24238-1216425335-0001-2--
