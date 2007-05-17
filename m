Return-Path: <linux-kernel-owner+w=401wt.eu-S1760034AbXEQD7n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760034AbXEQD7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2007 23:59:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754870AbXEQD7g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 May 2007 23:59:36 -0400
Received: from erazor-zone.de ([81.169.131.33]:34688 "EHLO erazor-zone.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754511AbXEQD7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2007 23:59:35 -0400
X-Greylist: delayed 1870 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 May 2007 23:59:34 EDT
Message-ID: <464BCB66.2090205@da7a.de>
Date: Thu, 17 May 2007 05:26:30 +0200
From: Martin Christoph <mail@da7a.de>
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: 2.6.21 - "make modules" with GREP_OPTIONS="-C1" (and other)
X-Enigmail-Version: 0.95.0
OpenPGP: id=3AEB7D5D;
	url=http://da7a.de/files/mail_da7a.de.asc
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEU1JBhuVkF+VSqdfmXB
 m4bcuKH21sBNIIpcAAACYElEQVQ4y02UQZLjIAxFbWcOYIJnb8MF2ogDdBrR66kK+ATB9z/CfAln
 eqhyFnp+EhImg3NuHX7W6OZhQEx/7orWScGE2CTAe2esvDVtjmjb5K2pGwhsbrNkYy1MZtIgDHIU
 dp9rrQ0PJ3efB6nrfHCG+Ghnq0eFY7a5G24bPeUT61DwMVyGW0fieh6CkIz3QbYlBrLlevYFZddG
 uhHzcQEoj+ENBsv1Ag1Kmvt2A0Cs7QKtKZi6ccv1v1RvA4/n4w2O+s/Arn79bIpzLR/jZaw+XYQT
 UZRGrl1tnkhyvYhKIt5HBcGthsh/A5R4nK1w6oYHQOKsbWNXGcAknCOGaGXmCpAol8cQ+QuGXxci
 GeNZ+LHQdzKG0wM1grFElvkozCly3smwGC4YShyZjleVlKhhsOVuFJTIR21NWi/RZP7CYQRvaz1a
 PnVgON5EtWC0IWBXGDcjqFMsyVZG206321rGyI8OiNlt6MNFvFpRo+fiZPENOWmQAF71rOUCexUQ
 QlgQeOHRubQEIyCVCxQliPk1rY7ZA4jhF30bnWfp45kM4jA8oTimjfHp15vT7pwWJysfM1bhUgTc
 JzE8jk/iMQNgAcxvg7JEACQfDmV13Ug2F4xXvnQcS5Em1PBkYtM5pBRB635XA5kM5YojAmHZBnUj
 4K55rpKrSAVcqekyUnCUe10VjFMAwzi9sIoYgO5qRLLOxB7P/CRjl3QVp7uxYkjfKc248LP0QYnM
 7cZaAJ3sBuBzMDB2MyzIpQBfm2Uf/wwjDFyU33vEmdfy3M0YcRU+cUG9wc/ysNffAoTkM8BfjPb9
 0b+560sAAAAASUVORK5CYII=
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="------------enig75EAB88E0FBE1B069D85A098"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig75EAB88E0FBE1B069D85A098
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

[1] Summary:
If i have some GREP_OPTIONS set (like -C1 or other) i get several errors
while trying to do "make modules".

[2] Full description:
With some GREP_OPTIONS set "make modules" drops several errors like that:=


root@spot /usr/src/linux # GREP_OPTIONS=3D"-C1" make modules
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  Building modules, stage 2.
[...]
WARNING: "aes_enc_blk" [arch/i386/crypto/aes.ko] undefined!
WARNING: "aes_dec_blk" [arch/i386/crypto/aes.ko] undefined!
[...]
make[1]: *** [__modpost] Error 1
make: *** [modules] Error 2

[3] Keywords:
"make modules", "GREP_OPTIONS", "WARNING", "undefined"

[X.] Suggestion to fix:
Unset GREP_OPTIONS within make process.



--------------enig75EAB88E0FBE1B069D85A098
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iD8DBQFGS8ttpMtXzTrrfV0RCmWGAJ9p3GnYaRuypoxmj/nxN9zcdGSNYQCgovLd
nZLPvbR5rOHLFRR8dHoA1a0=
=PG6o
-----END PGP SIGNATURE-----

--------------enig75EAB88E0FBE1B069D85A098--
