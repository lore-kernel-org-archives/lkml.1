Return-Path: <linux-kernel-owner+w=401wt.eu-S1754645AbYKQV5g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645AbYKQV5g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 16:57:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751791AbYKQV51
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 16:57:27 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:43206 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751689AbYKQV51 (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 16:57:27 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc4-mmotm1110 shift-lock oddness
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226959015_3596P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 17 Nov 2008 16:56:55 -0500
Message-ID: <5397.1226959015@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226959015_3596P
Content-Type: text/plain; charset=us-ascii

Twice today, I've managed to get my laptop into an odd state where the keyboard
got quite confused:

1) For the characters [a-z] the shift bit was *inverted* - if the shift-lock
LED was off, you'd get UPPER-case, and if it was on, you'd get lower-case.

2) To add to the fun, the 0-9 keys were stuck shifted - I'd get the special
characters no matter what setting the shift or shift-lock key had.  I suspect
that the special-char keys like [{ and ;: were also stuck in shifted state,
but can't totally confirm it.

The previous two issues combined meant that I wasn't able to su or login
as root to do much of anything about it (guess who has special chars in their
root password? ;)

3) ctl-alt-Fn to switch virtual consoles was spotty/erratic - one time
I was unable to use it at all, another time I was able to use c-a-F1 to get
to a green-screen console, but then F2 to get another one or F7 to get
back to the X server screen wouldn't work.

4) Fortunately for my sanity, alt-sysrq was still working as advertised,
so I was able to reboot and thus clear the problem.

I was thinking this might be a simple "missed a key press/released" event
for a shift key, except that doesn't explain the numerics getting stuck shifted.

Any suggestions/hints for instrumentation/etc, in case I can replicate it
again?

--==_Exmh_1226959015_3596P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJIeincC3lWbTT17ARAsMXAKDxMFHGzUEbdVit6Z7OfHhwdhP51gCeK2qk
il5f7FwsnBLFpw3oL6N+bbM=
=L3UN
-----END PGP SIGNATURE-----

--==_Exmh_1226959015_3596P--
