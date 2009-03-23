Return-Path: <linux-kernel-owner+w=401wt.eu-S1754881AbZCWCGu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbZCWCGu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Mar 2009 22:06:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752603AbZCWCGl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Mar 2009 22:06:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:44609 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752668AbZCWCGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Mar 2009 22:06:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,404,1233561600"; 
   d="asc'?scan'208";a="123005353"
Subject: Re: [PATCH] efifb: dmi set video type
From: Huang Ying <ying.huang@intel.com>
To: Brian Maly <bmaly@redhat.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49C56754.4080909@redhat.com>
References: <49C56754.4080909@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-R255YMi/bs8t6QJuKGTI"
Date: Mon, 23 Mar 2009 10:06:24 +0800
Message-Id: <1237773984.24215.312.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-R255YMi/bs8t6QJuKGTI
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Brian,

The patch is OK for me.

Please cc linux-fbdev-devel@lists.sourceforge.net and "Antonino A.
Daplas" <adaplas@pol.net> on framebuffer driver patches.

Best Regards,
Huang Ying

On Sun, 2009-03-22 at 06:16 +0800, Brian Maly wrote:
> The current logic for dmi matching in efifb does not allow efifb to load=20
> on all hardware that we can dmi match for.
>=20
> For a real world example, boot with elilo (3.7 or 3.8 vanilla) and on a=20
> Apple (MacBook) and EFI framebuffer driver will not load (you will have=20
> no video).
> This specific hardware is efi v1.10, so we have UGA and not GOP. Without=20
> special bootloader magic (i.e. extra elilo patches for UGA graphics=20
> detection) no screen info will be passed to the kernel and as a result=20
> efifb will not load.
>=20
> This patch allows the dmi match to happen by moving it to earlier in=20
> efifb_init, and sets the video type (in set_system) so that efifb can=20
> load when we have a valid dmi match and already know the specifics of=20
> the hardware.
>=20
> Without this patch the efifb driver will fail to load in the event=20
> screen info is not found and passed in by the bootloader, being that we=20
> will never get to look for a dmi match. A primary reason for matching=20
> with dmi is because not all bootloaders detect the video info properly.=20
> The solution is that in the event of a dmi match, we should set=20
> screen_info.orig_video_isVGA. Most bootloaders fail to set screen info=20
> on Apple hardware, and this is a big problem for people who use Apple=20
> hardware.
>=20
> Tested on a MacBook SantaRosa with elilo-3.8 (vanilla) and resolves the=20
> issue, the dmi match now works, EFI framebuffer now loads and video works=
.
>=20
>=20
> Signed-off-by: Brian Maly <bmaly@redhat>
>=20
>=20

--=-R255YMi/bs8t6QJuKGTI
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknG7pgACgkQKhFGF+eHlpj6OQCcCQH1LIdgvSPUqGy7OGR3QKUR
DIUAnidLok/Zdgn034p/mhGsWkRg2VDv
=q+ZK
-----END PGP SIGNATURE-----

--=-R255YMi/bs8t6QJuKGTI--

