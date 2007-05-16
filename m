Return-Path: <linux-kernel-owner+w=401wt.eu-S1759738AbXEPSjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759738AbXEPSjR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 14:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756689AbXEPSjG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 14:39:06 -0400
Received: from mail-in-09.arcor-online.net ([151.189.21.49]:41297 "EHLO
	mail-in-09.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755753AbXEPSjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 14:39:05 -0400
From: Prakash Punnoor <prakash@punnoor.de>
To: Joshua Hoblitt <jhoblitt@ifa.hawaii.edu>
Subject: Re: [PATCH] Kconfig powernow-k8 driver should depend on ACPI P-States driver
Date: Wed, 16 May 2007 20:38:58 +0200
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, trivial@kernel.org
References: <20070516011711.GE15763@ifa.hawaii.edu>
In-Reply-To: <20070516011711.GE15763@ifa.hawaii.edu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3622395.dRHanFXsEW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705162039.02379.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3622395.dRHanFXsEW
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Mittwoch 16 Mai 2007 schrieb Joshua Hoblitt:
> Hello,
>
> Below is a one line patch to possibly fix this bug:
>
> http://bugs.gentoo.org/show_bug.cgi?id=3D178585
> http://bugzilla.kernel.org/show_bug.cgi?id=3D8075
>
> If the kernel is configured with:
>
> CONFIG_X86_POWERNOW_K8=3Dy
> CONFIG_X86_ACPI_CPUFREQ=3Dm
>
> Which is currently an allowed configuration, the powernow-k8 driver on
> an SMP system will fail with a warning like:

NAK. I have an Athlon X2 and it works for me w/o the P states driver compil=
ed=20
in.

YOu probably should ask the vendor to fix the bios or simply compile in the=
 p=20
states driver additionally w/o forcing the user to do it.

Maybe you want to give a hint in the p states driver help text?
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart3622395.dRHanFXsEW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.3 (GNU/Linux)

iD8DBQBGS0/GxU2n/+9+t5gRAsFdAJ40qlZZ2UuFiSJwgQeaJeLmWFbI6gCg1aq2
DSmoDj+u4RycWpE8+E3PrEY=
=bEmm
-----END PGP SIGNATURE-----

--nextPart3622395.dRHanFXsEW--
