Return-Path: <linux-kernel-owner+w=401wt.eu-S1759323AbXKCKEr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759323AbXKCKEr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2007 06:04:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755691AbXKCKEk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 Nov 2007 06:04:40 -0400
Received: from mta-1.ms.rz.RWTH-Aachen.DE ([134.130.7.72]:62089 "EHLO
	mta-1.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754919AbXKCKEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2007 06:04:39 -0400
Date: Sat, 03 Nov 2007 11:04:36 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
In-reply-to: <4726F510.9060207@archlinux.org>
To: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Message-id: <472C47B4.4030808@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig5A308263CD3F95C9923D5CFD
X-IronPort-AV: E=Sophos;i="4.21,366,1188770400";
 d="asc'?scan'208";a="32624071"
X-Enigmail-Version: 0.95.1
References: <fg5kar$d70$1@ger.gmane.org>
 <alpine.LFD.0.9999.0710292310040.3186@localhost.localdomain>
 <47266BF6.6070206@archlinux.org>
 <alpine.LFD.0.9999.0710300033470.3186@localhost.localdomain>
 <4726F510.9060207@archlinux.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5A308263CD3F95C9923D5CFD
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Thomas B=E4chler schrieb:
>=20
> I just remembered, a friend of mine got it to compile with the exact
> same toolchain, but with a different configuration (which I don't have)=
=2E
> He used a snapshot tarball from yesterday though, not the git tree.
>=20

I found the problem and eliminated it. While this is my own fault, it is
still a bug in either the kernel or the build system: I had CFLAGS set
to "-Wall -O3 -march=3Dnative -pipe". I always thought the kernel would
ignore those and set its own CFLAGS, but I was wrong. Either the -O3 or
the -march=3Dnative break the build process on gcc 4.2.2.



--------------enig5A308263CD3F95C9923D5CFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHLEe0Eda5KzHP/VARCAAVAJ9F8k3buBpTuE5vyyjXdafmqUNQVQCfbFVs
3+pM3kF3jesR/omm8CgJyz8=
=7+FK
-----END PGP SIGNATURE-----

--------------enig5A308263CD3F95C9923D5CFD--
