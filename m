Return-Path: <linux-kernel-owner+w=401wt.eu-S1754276AbXL0SaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbXL0SaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2007 13:30:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752105AbXL0SaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Dec 2007 13:30:13 -0500
Received: from wega.rz.tu-ilmenau.de ([141.24.4.159]:37766 "EHLO
	wega.rz.tu-ilmenau.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070AbXL0SaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2007 13:30:11 -0500
In-Reply-To: <20071226134811.GA9765@gondor.apana.org.au>
References: <60C7157B-A303-435A-92D3-A6DA1C0CC178@tu-ilmenau.de> <20071226134811.GA9765@gondor.apana.org.au>
Mime-Version: 1.0 (Apple Message framework v753)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-1--717841425"
Message-Id: <C1644401-A884-4D06-81D1-2DAC8454E778@tu-ilmenau.de>
Cc: linux-kernel@vger.kernel.org, michal@logix.cz,
       Linux Crypto Mailing List <linux-crypto@vger.kernel.org>
Content-Transfer-Encoding: 7bit
From: Alexander Eichhorn <alexander.eichhorn@tu-ilmenau.de>
Subject: Re: OOPS: 2.6.23.11 in PadLock-AES when used in LRW-Mode
Date: Thu, 27 Dec 2007 19:29:34 +0100
To: Herbert Xu <herbert@gondor.apana.org.au>
X-Pgp-Agent: GPGMail 1.1.2 (Tiger)
X-Mailer: Apple Mail (2.753)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-1--717841425
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed

Patch Works. Tested with 2.6.23.11 on Via C7 with aes-lrw-benbi and  
key-size 384 bit. Filesystem was an ext3 (default options) on top of  
plain partition, Raid-1, and Raid-5.

Thanks a lot,
Alexander

On 26. Dec 2007, at 14:48 Uhr, Herbert Xu wrote:
> Please let me know if the following patch fixes the problem for you.


Alexander Eichhorn                          Distr. Systems and  
Operating Systems Group
Faculty of Computer Science and Automation  Ilmenau Technical University
Campus Center, room 433                     phone: +49(0)3677-694557
http://www-ia.tu-ilmenau.de/~echa           fax:   +49(0)3677-694541

PGP Public Key: http://www-ia.tu-ilmenau.de/~echa/AlexanderEichhorn.asc
Fingerprint: 9724 37D9 77AD AF99 65B6  E220 F540 E333 C9EC DC4F




--Apple-Mail-1--717841425
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (Darwin)

iEYEARECAAYFAkdz7xIACgkQ9UDjM8ns3E/PIwCeMwPaa3niTE2q3taJw0gEyaOE
3b0AoIxMrbWmd55ygkzjlFeCUBjFrilV
=yUDS
-----END PGP SIGNATURE-----

--Apple-Mail-1--717841425--
