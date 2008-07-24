Return-Path: <linux-kernel-owner+w=401wt.eu-S1754225AbYGXUjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754225AbYGXUjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2008 16:39:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751623AbYGXUj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Jul 2008 16:39:27 -0400
Received: from server.drzeus.cx ([85.8.24.28]:55329 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751027AbYGXUj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2008 16:39:26 -0400
Date: Thu, 24 Jul 2008 22:39:20 +0200
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org
Subject: Re: post 2.6.26 requires pciehp_slot_with_bus
Message-ID: <20080724223920.1f4dd753@mjolnir.drzeus.cx>
In-Reply-To: <488877C8.9020706@jp.fujitsu.com>
References: <20080724134737.4b91f30d@mjolnir.drzeus.cx>
	<488877C8.9020706@jp.fujitsu.com>
X-Mailer: Claws Mail 3.4.0 (GTK+ 2.13.5; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_freyr.drzeus.cx-10963-1216931965-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-10963-1216931965-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Jul 2008 21:38:32 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Hi Pierre,
> (Added linux-pci to CC)
>=20
> Pierre Ossman wrote:
> > Somewhere post 2.6.26, pciehp started whining about not being able to
> > claim the slot and error code -17. It suggested adding
> > "pciehp_slot_with_bus", which actually helped. Still, having a kernel
> > parameter should just be a temporary fix.
>=20
> The "pciehp_slot_with_bus" option is a workaround for the platforms
> that assign the same physical slot number to multiple slots. If your
> system has PCI chassis and it supports Chassis Number registers,
> maybe one of the solution is using chassis number + slot number as a
> slot name. But I don't have any idea other than "pciehp_slot_with_bus"
> if your system doesn't support chassis number.
>=20

The what now? :)

This is a laptop with a single expressport that worked fine up until
this merge window. What changed and why is it no longer possible to
support this hardware without a kernel parameter?

Rgds
--=20
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-10963-1216931965-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEARECAAYFAkiI6HwACgkQ7b8eESbyJLhHtgCgxO+Gouh56FMuuyfb2ZYGaFX8
nPsAoLH9m9S4k0lNVwOHfcqXU/fTZR1a
=ryDO
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-10963-1216931965-0001-2--
