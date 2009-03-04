Return-Path: <linux-kernel-owner+w=401wt.eu-S1757325AbZCDTVU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325AbZCDTVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 14:21:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756905AbZCDTVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 14:21:07 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:50597 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901AbZCDTVG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 14:21:06 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.29-rc breaks STD using Intel 945
Date: Wed, 4 Mar 2009 20:20:56 +0100
User-Agent: KMail/1.9.10
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.sourceforge.net
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10137046.hDL7lMaNFQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200903042020.57671.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10137046.hDL7lMaNFQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I tested several snapshots post 2.6.28 and all of them show one severe=20
problem: resume from disk is not always successful. Only about 50% of the=20
resume attempts work, in the other cases I just get a completely black=20
screen, can't switch to text console or anything. What I often get is a lin=
e=20
like this in the logs directly before suspend:

[drm:i915_get_vblank_counter] *ERROR* trying to get vblank count for disabl=
ed=20
pipe 0

Afterwards I find nothing in the logs. Switching back to 2.6.28 and everyth=
ing=20
works fine again. I have a Toshiba A110-178 running openSuSE 11.1 32 bit wi=
th=20
KDE 4.2.0. I upgraded my Xserver from 1.5 to 1.6 yesterday but that did not=
=20
change anything. The only external module I use is the omnibook module=20
(http://sf.net/projects/omnibook) which I've been using for years without a=
ny=20
problems.

VGA device is this:

00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,=20
943/940GML Express Integrated Graphics Controller (rev 03) (prog-if 00 [VGA=
=20
controller])
        Subsystem: Toshiba America Info Systems Device ff01
        Flags: bus master, fast devsel, latency 0, IRQ 16
        Memory at dc100000 (32-bit, non-prefetchable) [size=3D512K]
        I/O ports at 1800 [size=3D8]
        Memory at c0000000 (32-bit, prefetchable) [size=3D256M]
        Memory at dc200000 (32-bit, non-prefetchable) [size=3D256K]
        Capabilities: [90] Message Signalled Interrupts: Mask- 64bit-=20
Count=3D1/1 Enable-
        Capabilities: [d0] Power Management version 2
        Kernel modules: intelfb

00:02.1 Display controller: Intel Corporation Mobile 945GM/GMS/GME, 943/940=
GML=20
Express Integrated Graphics Controller (rev 03)
        Subsystem: Toshiba America Info Systems Device ff01
        Flags: bus master, fast devsel, latency 0
        Memory at dc180000 (32-bit, non-prefetchable) [size=3D512K]
        Capabilities: [d0] Power Management version 2

If you have any patches you want to try me or have any further questions ju=
st=20
mail me. If you're hanging around at CeBIT I can come over and we can discu=
ss=20
this in person as I'm there for the next days anyway.

Greetings,

Eike

--nextPart10137046.hDL7lMaNFQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkmu1JkACgkQXKSJPmm5/E6ldQCggJMahi7wEOFTjTuLTEetTp77
fP4AnAwXl4qROJIEZhW+Kw76WyO3NbZH
=+Dln
-----END PGP SIGNATURE-----

--nextPart10137046.hDL7lMaNFQ--
