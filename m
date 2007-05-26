Return-Path: <linux-kernel-owner+w=401wt.eu-S1760779AbXEZOwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779AbXEZOwQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2007 10:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754915AbXEZOwG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 May 2007 10:52:06 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:51944 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754349AbXEZOwF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2007 10:52:05 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: linux-kernel@vger.kernel.org
Subject: [BUG] Warning in mm/slab.c:777
Date: Sat, 26 May 2007 08:48:55 +0200
User-Agent: KMail/1.9.7
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8087035.aFPaOeNA8f";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705260849.00356.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8087035.aFPaOeNA8f
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

After bootup (runlevel 5) I found this in dmesg:

WARNING: at mm/slab.c:777 __find_general_cachep()
 [<c0165fe1>] __kmalloc+0x40/0xc3
 [<f8f4d5ed>] drm_rmdraw+0x126/0x24e [drm]
 [<c023e68b>] skb_dequeue+0x39/0x3f
 [<f8f4d4c7>] drm_rmdraw+0x0/0x24e [drm]
 [<f8f4e10e>] drm_ioctl+0x14c/0x192 [drm]
 [<c0172cb0>] do_ioctl+0x4c/0x62
 [<c0172efd>] vfs_ioctl+0x237/0x249
 [<c017aff3>] mntput_no_expire+0x11/0x68
 [<c0172f5b>] sys_ioctl+0x4c/0x65
 [<c0103cde>] sysenter_past_esp+0x5f/0x85
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

Kernel is Linus' git of yesterday, the first occurence of this in my logs w=
as=20
on May 16th.

Greetings,

Eike

--nextPart8087035.aFPaOeNA8f
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGV9hcXKSJPmm5/E4RAiVhAKCWv2od0miQaSiAbbucFlKfvAM//gCgp8fr
oIlh4+bu3WhRM0xMkR1yZtg=
=R/HZ
-----END PGP SIGNATURE-----

--nextPart8087035.aFPaOeNA8f--
