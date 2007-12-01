Return-Path: <linux-kernel-owner+w=401wt.eu-S1754915AbXLAVBi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915AbXLAVBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2007 16:01:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbXLAVBX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Dec 2007 16:01:23 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:38343 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbXLAVBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2007 16:01:23 -0500
Date: Sat, 1 Dec 2007 22:01:20 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Jiri Slaby <jirislaby@gmail.com>, Matthew Wilcox <matthew@wil.cx>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, linux-usb-devel@lists.sourceforge.net,
       linux-pm@lists.linux-foundation.org
Subject: Re: WARNING: at kernel/resource.c:189 __release_resource
Message-ID: <20071201220120.15f4fd49@poseidon.drzeus.cx>
In-Reply-To: <200711291640.38158.bjorn.helgaas@hp.com>
References: <4745F77C.7040402@gmail.com>
	<20071126220538.1aed9c33.akpm@linux-foundation.org>
	<200711291640.38158.bjorn.helgaas@hp.com>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.2; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=PGP-SHA1; boundary="=_hera.drzeus.cx-3439-1196542881-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-3439-1196542881-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 29 Nov 2007 16:40:37 -0700
Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:

>=20
> The corresponding PCI code in pci_device_suspend() does not do
> any generic device disable or resource release.  I don't know
> why PNP disables the device on suspend.  I glanced through the
> ACPI spec but didn't see a requirement for it.  Maybe Pierre [1]
> remembers.
>=20

Afraid not. There was a reason for it, but my mind draws a blank as to what=
 that was... I have a slight recollection of bad BIOS interaction during ST=
R, but I'm not sure it was related to this specific patch.

Rgds
Pierre

--=_hera.drzeus.cx-3439-1196542881-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFHUcug7b8eESbyJLgRAvw+AKDvTib2vHpkDdXwiz8ay9SmtVUW2QCfbE0c
bjqMg+x+TzV3lu/mygu89xI=
=uxzS
-----END PGP SIGNATURE-----

--=_hera.drzeus.cx-3439-1196542881-0001-2--
