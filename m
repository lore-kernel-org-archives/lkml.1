Return-Path: <linux-kernel-owner+w=401wt.eu-S1756475AbZBWEQv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756475AbZBWEQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 23:16:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751662AbZBWEQn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 23:16:43 -0500
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:57360 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577AbZBWEQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 23:16:42 -0500
Subject: Re: i915: drm:i915_wait_irq EBUSY
From: Eric Anholt <eric@anholt.net>
To: Niel Lambrechts <niel.lambrechts@gmail.com>
Cc: "linux.kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <49A0053F.2050109@gmail.com>
References: <49A0053F.2050109@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-fKjm4JIqqk5rs5VUDI9z"
Date: Sun, 22 Feb 2009 20:16:40 -0800
Message-Id: <1235362600.5811.23.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fKjm4JIqqk5rs5VUDI9z
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-02-21 at 15:44 +0200, Niel Lambrechts wrote:
> Hi
>=20
> I recently changed AccelMethod to XAA in my xorg.conf, and after
> resuming (from hibernate), my X-server crashed with the following dmesg.
> It was non-fatal, as I could restart X (from a black console screen -
> not sure if that is related). Never had any problems suspending to
> either disk/memory without this option up to now...
> =20
> dmesg output:
> ata2.00: ACPI cmd e3/00:1f:00:00:00:a0
> succeeded                                                            =20
> ata2.00: ACPI cmd e3/00:02:00:00:00:a0
> succeeded                                                            =20
> ata2.00: ACPI cmd e3/00:1f:00:00:00:a0
> succeeded                                                            =20
> ata2.00: ACPI cmd e3/00:02:00:00:00:a0
> succeeded                                                            =20
> ata2.00: configured for
> UDMA/133                                                                 =
           =20
>=20
> Restarting tasks ...
> done.                                                                    =
              =20
>=20
> ata2: exception Emask 0x10 SAct 0x0 SErr 0x0 action 0x9
> t4                                                  =20
> ata2: irq_stat
> 0x40000001                                                               =
                    =20
>=20
> ata2.00: configured for
> UDMA/133                                                                 =
           =20
>=20
> ata2: EH
> complete                                                                 =
                          =20
>=20
> [drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
> 44209484                                        =20
> [drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
> 44209484                                        =20
> [drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
> 44209484                                        =20
> [drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted:
> 44209484                                        =20
> [drm:i915_wait_irq] *ERROR* EBUSY -- rec: 44209483 emitted: 44209484
>=20
> The problem occurred on my Thinkpad W500, running OpenSUSE 11.1 with
> vanilla 2.6.28.6-pae kernel, using the integrated Intel Mobile GM45
> Express chipset.
>=20
> Any ideas?

The chip is hung.  Don't use XAA -- it hasn't been the default or even
supported while your chipset has existed.

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-fKjm4JIqqk5rs5VUDI9z
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmiIygACgkQHUdvYGzw6vd1AQCffNaleRJSsxDqcDbo2AoT+KUP
Y3gAn0J2p8il5e4ABt8iLgvc0nDVQbrg
=uw7Y
-----END PGP SIGNATURE-----

--=-fKjm4JIqqk5rs5VUDI9z--

