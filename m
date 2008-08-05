Return-Path: <linux-kernel-owner+w=401wt.eu-S1760720AbYHEJWy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760720AbYHEJWy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 05:22:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758697AbYHEJWq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 05:22:46 -0400
Received: from server.drzeus.cx ([85.8.24.28]:57818 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755010AbYHEJWp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 05:22:45 -0400
Date: Tue, 5 Aug 2008 11:22:34 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: David =?UTF-8?B?SMOkcmRlbWFu?= <david@hardeman.nu>
Cc: linux-kernel@vger.kernel.org
Subject: Re: sdhci: Ricoh Co Ltd R5C822 SD/SDIO/MMC/MS/MSPro Host Adapter -
 disabling IRQ
Message-ID: <20080805112234.759819fe@mjolnir.drzeus.cx>
In-Reply-To: <20080802224725.GA6574@hardeman.nu>
References: <20080624181656.GB14243@hardeman.nu>
	<20080710083457.7887d363@mjolnir.drzeus.cx>
	<20080711164706.GA8943@hardeman.nu>
	<20080719015531.6c8a1981@mjolnir.drzeus.cx>
	<20080802224725.GA6574@hardeman.nu>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-5447-1217928163-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-5447-1217928163-0001-2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 3 Aug 2008 00:47:25 +0200
David H=C3=A4rdeman <david@hardeman.nu> wrote:

> On Sat, Jul 19, 2008 at 01:55:31AM +0200, Pierre Ossman wrote:
> >
> >I see that you have an iwl4965. I got this precise problem when I
> >toggled the rfkill switch on my laptop. It is fixed in 2.6.26 though.
> >Could you try upgrading the kernel and see if it's the same bug?
>=20
> Unfortunately the problem is still present with 2.6.26 (Debian package=20
> linux-image-2.6.26-1-amd64):
>=20

Weird. What kind of efforts have you done in determining the source of
this interrupt? As I mentioned, I find it hard to believe that the card
reader is doing this as it is completely passive until you insert a
card.

Have you tried booting in a single user mode? Or with a minimal set of
modules loaded?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-5447-1217928163-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiYG+EACgkQ7b8eESbyJLh/5wCfcoOSoZGrUkVmKIQ8y53md45m
C3MAoLDkjLY++yDFSzOyUQTzw7B401Wd
=wl0d
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-5447-1217928163-0001-2--
