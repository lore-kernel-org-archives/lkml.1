Return-Path: <linux-kernel-owner+w=401wt.eu-S1751022AbZHJEP2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751022AbZHJEP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 00:15:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750869AbZHJEP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 00:15:27 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39410 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbZHJEP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 00:15:26 -0400
Date: Mon, 10 Aug 2009 14:15:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: sound tree build warning
Message-Id: <20090810141518.cf9a3a2f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__10_Aug_2009_14_15_18_+1000_KlchzHmR.lZJ=po2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Aug_2009_14_15_18_+1000_KlchzHmR.lZJ=po2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

sound/soc/codecs/wm8731.c:44: warning: 'wm8731_spi_write' declared 'static'=
 but never defined

Introduced by commit 27ded041f03026e8c6be9efc626e11ddfb4620c1 ("ASoC:
Factor out 7 bit register 9 bit data SPI write").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__10_Aug_2009_14_15_18_+1000_KlchzHmR.lZJ=po2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp/ntYACgkQjjKRsyhoI8xI5wCgjifNMh3wB/6y2ITcNbrl1Mm0
7ggAnAoOusn5Z1agDq2IttWDKe86iAmw
=G+iy
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Aug_2009_14_15_18_+1000_KlchzHmR.lZJ=po2--
