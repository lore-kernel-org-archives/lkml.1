Return-Path: <linux-kernel-owner+w=401wt.eu-S1756275AbYGVDCP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756275AbYGVDCP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 23:02:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYGVDCA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 23:02:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52752 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886AbYGVDB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 23:01:59 -0400
Date: Tue, 22 Jul 2008 13:01:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] serial: fix struct uart_info change fallout
Message-Id: <20080722130152.f115224d.sfr@canb.auug.org.au>
In-Reply-To: <20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
References: <20080722102520.ca801ab5.sfr@canb.auug.org.au>
	<20080722025850.0d073a5e@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Jul_2008_13_01_52_+1000_BcLv.lp1U/rBNWE8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Jul_2008_13_01_52_+1000_BcLv.lp1U/rBNWE8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Tue, 22 Jul 2008 02:58:50 +0100 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> Yes I know.

Indeed, you knew before you pushed the breaking patches to Linus.

> I've been trying to get the other patches merged but each of the five
> pulls of Linus tree I have done has broken the tty patch merges *AGAIN*
> so I still don't have them tested and ready to merge despite it being 3AM.

Then why weren't the fixes rolled back into the original patch or at
least submitted at the same time?

> So much for the linux-next tree. Please give it until tomorrow or you are

What is your problem with the linux-next tree.  The problem was
discovered and reported when I first merged the ttydev tree into
linux-next on July 1.  The fixes were in linux-next on July 2.

> just going to break the tree again and mean I have to run another set of
> tests and regressions.

Please give what until tomorrow?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Jul_2008_13_01_52_+1000_BcLv.lp1U/rBNWE8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiFTaAACgkQjjKRsyhoI8y4LACeNxayZN3UxWUj/+qkvFm+F+25
xSsAoLbS8c4UHLMUYki17yu3bpqwOQO2
=h/3U
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Jul_2008_13_01_52_+1000_BcLv.lp1U/rBNWE8--
