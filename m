Return-Path: <linux-kernel-owner+w=401wt.eu-S1752532AbZL1LQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532AbZL1LQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Dec 2009 06:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbZL1LQg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Dec 2009 06:16:36 -0500
Received: from mail.klingt.org ([86.59.21.178]:59439 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751168AbZL1LQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Dec 2009 06:16:36 -0500
Message-ID: <4B389391.8050303@klingt.org>
Date: Mon, 28 Dec 2009 12:16:33 +0100
From: Tim Blechmann <tim@klingt.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8pre) Gecko/20091226 Shredder/3.0.1pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: perf: counter and event question
X-Enigmail-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC7D5D5540891D87A680941EB"
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (klingt.org [127.0.0.1]); Mon, 28 Dec 2009 12:16:34 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC7D5D5540891D87A680941EB
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

hi all,

trying to use the perf subsystem, i am a bit confused by the terms
`performance counter' and `performance event'.

i am trying to compare `counting' counters with `sampling' counters. as
a test case, i am counting PERF_COUNT_HW_INSTRUCTIONS of the same code
piece with both approaches. the sampling counters are sampled with a
period of 1. the code is really trivial [1].

the `counting' counters report numbers of about 9000 instructions, but
the mmap buffer only seems to contain about 100 to 200 event samples.
from my (limited) understanding, these number should at least be
similar, so i am a bit confused to see such a big difference. am i
missing something, like it is impossible to sample instructions with a
period of 1? or could there be an issue with my code?

thanks, tim

[1] http://tim.klingt.org/git?p=3Dperf-cpp.git

--=20
tim@klingt.org
http://tim.klingt.org

I don't write music for sissy ears.
  Charles Ives


--------------enigC7D5D5540891D87A680941EB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAks4k5MACgkQdL+4qsZfVsurQgCfYHs/RVCJLNMXEZ/Fj4wFBYXT
IeoAn2FzZoFF4SB4XgXkVsxGO/2fxFUF
=8scw
-----END PGP SIGNATURE-----

--------------enigC7D5D5540891D87A680941EB--
