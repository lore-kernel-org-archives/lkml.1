Return-Path: <linux-kernel-owner+w=401wt.eu-S1755910AbYKCV7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755910AbYKCV7q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 16:59:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752985AbYKCV7h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 16:59:37 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:33386 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752945AbYKCV7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 16:59:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :x-enigmail-version:content-type;
        b=RsvkRGza+YFiU4x15WXuIrW3JkcNoL8F2HKEZJp6BHBEqPxhctG5Ccdn/WHlbBZWlV
         iftGQEosUHmJMSeECxCZfHLxvaaJCX7HidgRjH9oPHWPVHZigHcTsVRQhNTEcAY5eXd7
         EvU6wi20faG23vWmj5/ZDpTuCpKn8MhRjSVSc=
Message-ID: <490F73CD.4010705@gmail.com>
Date: Mon, 03 Nov 2008 23:57:33 +0200
From: "Eugene V. Lyubimkin" <jackyf.devel@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: mmap: is default non-populating behavior stable?
X-Enigmail-Version: 0.95.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE277DC70624059272E51407A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE277DC70624059272E51407A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hello kernel hackers!

The current implementation of mmap() in kernel is very convenient.
It allows to mmap(fd) very big amount of memory having small file as back=
-end.
So one can mmap() 100 MiB on empty file, use first 10 KiB of memory, munm=
ap() and have
only 10 KiB of file at the end. And while working with memory, file will =
automatically be
grown by read/write memory requests.

Question is: can user-space application rely on this behavior (I failed t=
o find any
documentation about this)?

TIA and please CC me in replies.

--=20
Eugene V. Lyubimkin aka JackYF


--------------enigE277DC70624059272E51407A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkPc88ACgkQchorMMFUmYzb0gCcDhSzz+MbkLKj2imeQS3CZPYg
g7IAoK7K4DLf1AkY6WOGE2HnQDl4JSHL
=/WW7
-----END PGP SIGNATURE-----

--------------enigE277DC70624059272E51407A--
