Return-Path: <linux-kernel-owner+w=401wt.eu-S1758039AbXKDM3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758039AbXKDM3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Nov 2007 07:29:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757316AbXKDM3F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Nov 2007 07:29:05 -0500
Received: from mta-2.ms.rz.RWTH-Aachen.DE ([134.130.7.73]:56785 "EHLO
	mta-2.ms.rz.rwth-aachen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755161AbXKDM3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Nov 2007 07:29:03 -0500
Date: Sun, 04 Nov 2007 13:27:44 +0100
From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: 2.6.24-rc1-82798a1 compile failure (x86_64)
In-reply-to: <20071104111640.GA17565@uranus.ravnborg.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: David Miller <davem@davemloft.net>, mingo@elte.hu, bunk@kernel.org,
       thomas@archlinux.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, akpm@linux-foundation.org
Message-id: <472DBAC0.7040802@archlinux.org>
MIME-version: 1.0
Content-type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary=------------enig8C66F15A3A7B7B9632790F1F
X-IronPort-AV: E=Sophos;i="4.21,368,1188770400";
 d="asc'?scan'208";a="32734773"
X-Enigmail-Version: 0.95.1
References: <20071103121149.GA22149@uranus.ravnborg.org>
 <20071104020217.GJ12045@stusta.de> <20071104100429.GA12311@elte.hu>
 <20071104.023133.241080055.davem@davemloft.net>
 <20071104111640.GA17565@uranus.ravnborg.org>
User-Agent: Thunderbird 2.0.0.6 (X11/20071015)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8C66F15A3A7B7B9632790F1F
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Sam Ravnborg schrieb:
> I'm afraid some people do not realize a whit about what they do.
> So at least we could let kbuild warn about it.
> Something like this:
>=20
> $ export CFLAGS=3D-O3
> $ make AFLAGS=3D-fisk
> Makefile:540: "Appending $AFLAGS (-fisk) from command line to kernel de=
fined $AFLAGS"
> Makefile:544: "Appending $CFLAGS (-O3) from environment to kernel defin=
ed $CFLAGS"
>   CHK     include/linux/version.h
>   CHK     include/linux/utsrelease.h
>   CC      arch/x86/kernel/asm-offsets.s
>   GEN     include/asm-x86/asm-offsets.h
>   CALL    scripts/checksyscalls.sh
>   CC      scripts/mod/empty.o

I agree, this is a sane way to do it. Would this patch have been
applied, I would have found the problem within minutes AND I would have
known that the kernel does use my CFLAGS, which I assumed it wouldn't.

Maybe you should prefix the message with a "WARNING: ".


--------------enig8C66F15A3A7B7B9632790F1F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHLbrAEda5KzHP/VARCEU4AJ4sWxWmtptQ+3rQujmgLKlr1jKFhwCfScVR
55JeSV8XlZNijKXH25flRqA=
=672t
-----END PGP SIGNATURE-----

--------------enig8C66F15A3A7B7B9632790F1F--
