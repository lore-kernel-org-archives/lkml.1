Return-Path: <linux-kernel-owner+w=401wt.eu-S1753246AbYI2Ftv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbYI2Ftv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2008 01:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbYI2Ftn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Sep 2008 01:49:43 -0400
Received: from mx71.mail.ru ([194.67.23.4]:51039 "EHLO mx71.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751558AbYI2Ftm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2008 01:49:42 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-kbuild@vger.kernel.org
Subject: Building two (external) modules from the same sources
Date: Mon, 29 Sep 2008 09:49:34 +0400
User-Agent: KMail/1.9.10
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2083589.Lk0uras9UW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809290949.35749.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2083589.Lk0uras9UW
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have here driver that can be built for two different types of
hardware from basically the same sources (this is port of old Agere
drivers for Hermes-I/Hermes-II chipsets). Build differs only in one
define -DHERMES2 and single file with different firmware. Unfortunately
"if HII" are spread over sources which makes splitting of sources rather
questionable.

What is the best way (from kbuild POV) to build two modules - for H-I
and H-II - from the same set of source files?

TIA

-andrey

--nextPart2083589.Lk0uras9UW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjgbG8ACgkQR6LMutpd94x9WQCZAQkQUQGFw+NqS4XTReiw57b6
pUsAn23EvcFOUIF9Y38hQzBDipClhYgy
=71CF
-----END PGP SIGNATURE-----

--nextPart2083589.Lk0uras9UW--
