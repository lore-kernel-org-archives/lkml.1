Return-Path: <linux-kernel-owner+w=401wt.eu-S1755378AbZJABTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755378AbZJABTm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Sep 2009 21:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbZJABTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Sep 2009 21:19:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45002 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbZJABTk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Sep 2009 21:19:40 -0400
Date: Thu, 1 Oct 2009 11:19:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: sound tree build failure
Message-Id: <20091001111935.8fb15d90.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__1_Oct_2009_11_19_35_+1000_IZwhblki.BjZ7qc8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__1_Oct_2009_11_19_35_+1000_IZwhblki.BjZ7qc8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64_allmodconfig) failed like this:

sound/soc/codecs/wm8711.c:523: warning: 'struct spi_device' declared inside=
 parameter list
sound/soc/codecs/wm8711.c:523: warning: its scope is only this definition o=
r declaration, which is probably not what you want
sound/soc/codecs/wm8711.c: In function 'wm8711_spi_probe':
sound/soc/codecs/wm8711.c:534: error: dereferencing pointer to incomplete t=
ype
sound/soc/codecs/wm8711.c:536: error: dereferencing pointer to incomplete t=
ype
sound/soc/codecs/wm8711.c: At top level:
sound/soc/codecs/wm8711.c:541: warning: 'struct spi_device' declared inside=
 parameter list
sound/soc/codecs/wm8711.c: In function 'wm8711_spi_remove':
sound/soc/codecs/wm8711.c:543: error: dereferencing pointer to incomplete t=
ype
sound/soc/codecs/wm8711.c: At top level:
sound/soc/codecs/wm8711.c:551: warning: 'struct spi_device' declared inside=
 parameter list
sound/soc/codecs/wm8711.c: In function 'wm8711_spi_suspend':
sound/soc/codecs/wm8711.c:553: error: dereferencing pointer to incomplete t=
ype
sound/soc/codecs/wm8711.c: At top level:
sound/soc/codecs/wm8711.c:556: warning: 'struct spi_device' declared inside=
 parameter list
sound/soc/codecs/wm8711.c: In function 'wm8711_spi_resume':
sound/soc/codecs/wm8711.c:558: error: dereferencing pointer to incomplete t=
ype
sound/soc/codecs/wm8711.c: At top level:
sound/soc/codecs/wm8711.c:565: error: variable 'wm8711_spi_driver' has init=
ializer but incomplete type
sound/soc/codecs/wm8711.c:566: error: unknown field 'driver' specified in i=
nitializer
sound/soc/codecs/wm8711.c:566: error: extra brace group at end of initializ=
er
sound/soc/codecs/wm8711.c:566: error: (near initialization for 'wm8711_spi_=
driver')
sound/soc/codecs/wm8711.c:568: error: 'spi_bus_type' undeclared here (not i=
n a function)
sound/soc/codecs/wm8711.c:570: warning: excess elements in struct initializ=
er
sound/soc/codecs/wm8711.c:570: warning: (near initialization for 'wm8711_sp=
i_driver')
sound/soc/codecs/wm8711.c:571: error: unknown field 'probe' specified in in=
itializer
sound/soc/codecs/wm8711.c:571: warning: excess elements in struct initializ=
er
sound/soc/codecs/wm8711.c:571: warning: (near initialization for 'wm8711_sp=
i_driver')
sound/soc/codecs/wm8711.c:572: error: unknown field 'suspend' specified in =
initializer
sound/soc/codecs/wm8711.c:572: warning: excess elements in struct initializ=
er
sound/soc/codecs/wm8711.c:572: warning: (near initialization for 'wm8711_sp=
i_driver')
sound/soc/codecs/wm8711.c:573: error: unknown field 'resume' specified in i=
nitializer
sound/soc/codecs/wm8711.c:573: warning: excess elements in struct initializ=
er
sound/soc/codecs/wm8711.c:573: warning: (near initialization for 'wm8711_sp=
i_driver')
sound/soc/codecs/wm8711.c:574: error: unknown field 'remove' specified in i=
nitializer
sound/soc/codecs/wm8711.c:574: warning: excess elements in struct initializ=
er
sound/soc/codecs/wm8711.c:574: warning: (near initialization for 'wm8711_sp=
i_driver')
sound/soc/codecs/wm8711.c: In function 'wm8711_modinit':
sound/soc/codecs/wm8711.c:635: error: implicit declaration of function 'spi=
_register_driver'
sound/soc/codecs/wm8711.c:635: error: 'wm8731_spi_driver' undeclared (first=
 use in this function)
sound/soc/codecs/wm8711.c:635: error: (Each undeclared identifier is report=
ed only once
sound/soc/codecs/wm8711.c:635: error: for each function it appears in.)
sound/soc/codecs/wm8711.c: In function 'wm8711_exit':
sound/soc/codecs/wm8711.c:651: error: implicit declaration of function 'spi=
_unregister_driver'
sound/soc/codecs/wm8711.c:651: error: 'wm8731_spi_driver' undeclared (first=
 use in this function)

Caused by commit 08aff8cd7a8568588d460c4bf8875a492d430314 ("ASoC: Add SPI
support to WM8711").

I have used the version of the sound tree from next-20090930 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__1_Oct_2009_11_19_35_+1000_IZwhblki.BjZ7qc8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrEA6cACgkQjjKRsyhoI8y8YACeOdv4YCtBM5szYg/1wh0/L5iC
35UAoLQRaK9P4VhUdmZEXumidswy7ZET
=luTy
-----END PGP SIGNATURE-----

--Signature=_Thu__1_Oct_2009_11_19_35_+1000_IZwhblki.BjZ7qc8--
