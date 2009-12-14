Return-Path: <linux-kernel-owner+w=401wt.eu-S1758142AbZLNTwZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758142AbZLNTwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Dec 2009 14:52:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758121AbZLNTwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Dec 2009 14:52:23 -0500
Received: from mail.klingt.org ([86.59.21.178]:36775 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758101AbZLNTwU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Dec 2009 14:52:20 -0500
Message-ID: <4B269765.1070703@klingt.org>
Date: Mon, 14 Dec 2009 20:52:05 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7pre) Gecko/20091214 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: stern@rowland.harvard.edu
Subject: 2.6.32 regression: unable to handle kernel paging request
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD5B21E4F19898B3A816225CB"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [86.59.21.178]); Mon, 14 Dec 2009 20:52:10 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD5B21E4F19898B3A816225CB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi all,

i cannot boot any 2.6.32 kernel (i tested back until -rc5) on my nehalem
machine (x86_64, 12gb ram).

there are bug messages in various (mostly module loader) functions,
stating "unable to handle kernel paging request". 2.6.31 on the same
machine works like charm. i haven't been able to save a boot log, but it
didn't look too different from this:

http://lkml.org/lkml/2009/12/8/207

thnx, tim

--=20
tim@klingt.org
http://tim.klingt.org

I must say I find television very educational. The minute somebody
turns it on, I go to the library and read a good book.
  Groucho Marx


--------------enigD5B21E4F19898B3A816225CB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAksml2UACgkQdL+4qsZfVsuvJQCfWxKXwnPADyh56sc9at6MLyap
cbAAn0MeJcxqeNbXiocrdcu0RZD/STxP
=7qLf
-----END PGP SIGNATURE-----

--------------enigD5B21E4F19898B3A816225CB--
