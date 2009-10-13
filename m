Return-Path: <linux-kernel-owner+w=401wt.eu-S1759675AbZJMNlf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759675AbZJMNlf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 09:41:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752196AbZJMNle
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 09:41:34 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:34290 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539AbZJMNld (ORCPT
	<rfc822;groupwise-GHaskins@novell.com;0:0>);
	Tue, 13 Oct 2009 09:41:33 -0400
Message-ID: <4AD48364.4000807@novell.com>
Date: Tue, 13 Oct 2009 09:40:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.23 (Macintosh/20090812)
MIME-Version: 1.0
To: Rakib Mullick <rakib.mullick@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm]: vbus: Fix section mismatch warnings in pci-bridge.c
References: <b9df5fa10910111808p424bba2bu999a7a49f32cc3d0@mail.gmail.com>
In-Reply-To: <b9df5fa10910111808p424bba2bu999a7a49f32cc3d0@mail.gmail.com>
X-Enigmail-Version: 0.96.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA27442C53551BD4B8C00119F"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA27442C53551BD4B8C00119F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Rakib Mullick wrote:
>  The functions vbus_pci_open, _ioq_init, eventq_init,
> vbus_pci_eventq_register are
> annoted with __init and referenced from a function __devinit
> vbus_pci_probe, which
> causes a section mismatch.So annote those functions with __devinit.
>=20
>  We were warned by the following warnings:
>=20
>   LD      drivers/vbus/vbus-pcibridge.o
> WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x19e): Section
> mismatch in reference from the function vbus_pci_probe() to the
> function .init.text:vbus_pci_open()
> The function __devinit vbus_pci_probe() references
> a function __init vbus_pci_open().
> If vbus_pci_open is only used by vbus_pci_probe then
> annotate vbus_pci_open with a matching annotation.
>=20
> WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x1f4): Section
> mismatch in reference from the function vbus_pci_probe() to the
> function .init.text:_ioq_init()
> The function __devinit vbus_pci_probe() references
> a function __init _ioq_init().
> If _ioq_init is only used by vbus_pci_probe then
> annotate _ioq_init with a matching annotation.
>=20
> WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x240): Section
> mismatch in reference from the function vbus_pci_probe() to the
> function .init.text:eventq_init()
> The function __devinit vbus_pci_probe() references
> a function __init eventq_init().
> If eventq_init is only used by vbus_pci_probe then
> annotate eventq_init with a matching annotation.
>=20
> WARNING: drivers/vbus/vbus-pcibridge.o(.devinit.text+0x45a): Section
> mismatch in reference from the function vbus_pci_probe() to the
> function .init.text:vbus_pci_eventq_register()
> The function __devinit vbus_pci_probe() references
> a function __init vbus_pci_eventq_register().
> If vbus_pci_eventq_register is only used by vbus_pci_probe then
> annotate vbus_pci_eventq_register with a matching annotation.
>=20
> ---
> Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>

Applied Rakib, thanks.

Kind Regards,
-Greg


--------------enigA27442C53551BD4B8C00119F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkrUg2QACgkQP5K2CMvXmqEK3ACfQZYjcPAWE4Wwc+XLm2v3oQ+B
8vwAmgP0lsWpeqHB6EgcHhUJS8CEF8xY
=4T5u
-----END PGP SIGNATURE-----

--------------enigA27442C53551BD4B8C00119F--
