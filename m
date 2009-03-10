Return-Path: <linux-kernel-owner+w=401wt.eu-S1753625AbZCJC2W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbZCJC2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 22:28:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752564AbZCJC2O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 22:28:14 -0400
Received: from 69-30-77-85.dq1sn.easystreet.com ([69.30.77.85]:50147 "EHLO
	kingsolver.anholt.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZCJC2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 22:28:13 -0400
Subject: Re: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
From: Eric Anholt <eric@anholt.net>
To: Nico Schottelius <nico-linux-20090213@schottelius.org>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20090213094048.GC10175@denkbrett.schottelius.org>
References: <20090213093354.GA10175@denkbrett.schottelius.org>
	 <20090213094048.GC10175@denkbrett.schottelius.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SHCuZ9TYT9Ispt9qanaC"
Date: Mon, 09 Mar 2009 19:28:11 -0700
Message-Id: <1236652091.10190.23.camel@gaiman>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SHCuZ9TYT9Ispt9qanaC
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-02-13 at 10:40 +0100, Nico Schottelius wrote:
> Nico Schottelius [Fri, Feb 13, 2009 at 10:33:54AM +0100]:
> > [...]
>=20
> dmesg:

> [  129.846561] [drm] Initialized drm 1.1.0 20060810
> [  129.877658] pci 0000:00:02.0: power state changed by ACPI to D0
> [  129.877678] pci 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ =
16
> [  129.877687] pci 0000:00:02.0: setting latency timer to 64
> [  129.934945] pci 0000:00:02.0: irq 30 for MSI/MSI-X
> [  129.935021] [drm] Initialized i915 1.6.0 20080730 on minor 0
> [  129.988541] [drm:i915_initialize] *ERROR* can not ioremap virtual addr=
ess for ring buffer

This is bad -- without the ringbuffer, initialization fails, so the DRM
support for opregion shouldn't work.

There have been fixes in later kernels for ioremap issues, which may or
may not affect what you're seeing.  Also, are you using KMS or not?

--=20
Eric Anholt
eric@anholt.net                         eric.anholt@intel.com



--=-SHCuZ9TYT9Ispt9qanaC
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkm10DsACgkQHUdvYGzw6vccIgCfXQdig9Dq+IkcrN2ORHKW2N3o
OaIAn2XOtYTdCX1zjI0Mxvh5Q2NN/nKf
=aYJ3
-----END PGP SIGNATURE-----

--=-SHCuZ9TYT9Ispt9qanaC--

