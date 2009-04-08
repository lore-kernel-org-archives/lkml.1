Return-Path: <linux-kernel-owner+w=401wt.eu-S935112AbZDHR4Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935112AbZDHR4Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 13:56:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934596AbZDHR4I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 13:56:08 -0400
Received: from mx0.hoeg.nl ([87.251.61.211]:61908 "EHLO palm.hoeg.nl"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758435AbZDHR4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 13:56:07 -0400
Date: Wed, 8 Apr 2009 19:56:03 +0200
From: Ed Schouten <ed@FreeBSD.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Inconsistency between PTY read() return values
Message-ID: <20090408175603.GI32098@hoeg.nl>
References: <20090408143631.GH32098@hoeg.nl> <20090408174716.6474af70@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sl5MdczEF/OU2Miu"
Content-Disposition: inline
In-Reply-To: <20090408174716.6474af70@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--sl5MdczEF/OU2Miu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> I would argue that TTYs do behave this way. We treat the disconnect as a
> hang up event. BSD sees it as EOF, Linux as hangup.

Would you mind explaining me the difference? I thought a modem
disconnect implies an end-of-file condition? If you take the code I
mentioned and modify it to close the master device and perform a read on
the TTY, it will return 0.

--=20
 Ed Schouten <ed@FreeBSD.org>

--sl5MdczEF/OU2Miu
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (FreeBSD)

iEYEARECAAYFAknc5TMACgkQ52SDGA2eCwVQ8ACbBjWjyabkXO5VEvW/Kzx7/U+n
QAYAnia+Z8tjo2/MMn0+UYvWazdl1MEN
=d2N+
-----END PGP SIGNATURE-----

--sl5MdczEF/OU2Miu--
