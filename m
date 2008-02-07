Return-Path: <linux-kernel-owner+w=401wt.eu-S935519AbYBGVZA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935519AbYBGVZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 16:25:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935787AbYBGVV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 16:21:26 -0500
Received: from mail-in-12.arcor-online.net ([151.189.21.52]:48328 "EHLO
	mail-in-12.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934837AbYBGVVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 16:21:24 -0500
From: Prakash Punnoor <prakash@punnoor.de>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] Replace nvidia timer override quirk with pci id list
Date: Thu, 7 Feb 2008 22:21:18 +0100
User-Agent: KMail/1.9.7
Cc: mingo@elte.hu, tglx@linutronix.de, lenb@kernel.org,
       linux-kernel@vger.kernel.org
References: <20080207195519.GA21772@basil.nowhere.org>
In-Reply-To: <20080207195519.GA21772@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart9395819.Ub6Rb7MlLC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200802072221.19099.prakash@punnoor.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart9395819.Ub6Rb7MlLC
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On the day of Thursday 07 February 2008 Andi Kleen hast written:

> Replace the old "for all of nvidia" quirk with a quirk containing pci
> device ID. I goobled this list together from pci.ids and googling and it
> may be incomplete, but so far I haven't had complaints.

> +	QBRIDGE(PCI_VENDOR_ID_NVIDIA, 0x02f0, nvidia_timer), /* mcp 51/nf4 ? */

If you want to skip timer override on this board, this is a *NAK* from me. =
I=20
told you the last time, it only works reliably here on MCP51 with timer=20
override working. Even before Asus released a bios which had an option to=20
enable the hpet, I needed the override or I got irratic behaviour. Since I=
=20
got hpet enabled I gave up on arguing as the wrongly triggered quirk didn't=
=20
bug me anymore.

IIRC my nforce2 needed the override. I didn't see that in the list.

00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00: de 10 f0 02 06 00 b0 00 a2 00 00 05 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 43 10 c0 81
30: 00 00 00 00 44 00 00 00 00 00 00 00 ff 00 00 00

bye,
=2D-=20
(=B0=3D                 =3D=B0)
//\ Prakash Punnoor /\\
V_/                 \_V

--nextPart9395819.Ub6Rb7MlLC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHq3ZPxU2n/+9+t5gRAgZFAKC0rw3CI+MxOxVSExYlEQmCrPmdwgCgoUa9
8R948cPJ4KW4QB4PsS2MiLw=
=rgQi
-----END PGP SIGNATURE-----

--nextPart9395819.Ub6Rb7MlLC--
