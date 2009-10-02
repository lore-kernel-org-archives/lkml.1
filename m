Return-Path: <linux-kernel-owner+w=401wt.eu-S1754031AbZJBBP7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754031AbZJBBP7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:15:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753846AbZJBBP6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:15:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51845 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830AbZJBBP6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:15:58 -0400
Date: Fri, 2 Oct 2009 11:15:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Krzysztof Helt <krzysztof.h1@wp.pl>
Subject: linux-next: sound tree build failure
Message-Id: <20091002111552.7ca81454.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__2_Oct_2009_11_15_52_+1000_=CPyXMfl.YdgJz5s"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Oct_2009_11_15_52_+1000_=CPyXMfl.YdgJz5s
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

make[4]: *** No rule to make target `include/sound/sscape_ioctl.h', needed =
by `usr/include/sound/.install'.

Caused by commit acd47100914b2896d0699febefd077f85c4dd272 ("ALSA: sscape:
convert to firmware loader framework") which removed
include/sound/sscape_ioctl.h but neglected to update include/sound/Kbuild.

I have used the sound tree from next-20090930 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__2_Oct_2009_11_15_52_+1000_=CPyXMfl.YdgJz5s
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrFVEkACgkQjjKRsyhoI8y1wQCglelz/qO5PDoa6PPjA5kB1s+4
1poAoJ2zFoHGWknPXHFkjqnTpuOt0OQa
=Ro8c
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Oct_2009_11_15_52_+1000_=CPyXMfl.YdgJz5s--
