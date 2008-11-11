Return-Path: <linux-kernel-owner+w=401wt.eu-S1754875AbYKKCzw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754875AbYKKCzw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 21:55:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754065AbYKKCzn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 21:55:43 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:41020 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbYKKCzm (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 21:55:42 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.28-rc4-mmotm1110 - you gotta be kidding me...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1226372137_3458P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Mon, 10 Nov 2008 21:55:37 -0500
Message-ID: <30622.1226372137@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1226372137_3458P
Content-Type: text/plain; charset=us-ascii

Somebody's been hitting the phunky pharmaceuticals in the last 4 days,
because this ball-of-joy snuck into linux-next.patch sometime between
-mmotm1106 and --mmotm1110.

Seen in a 'make silentallconfig'

  Single-depth WCHAN output (SCHED_NO_NO_OMIT_FRAME_POINTER) [Y/n/?] (NEW) ?

  Calculate simpler /proc/<PID>/wchan values. If this option
  is disabled then wchan values will recurse back to the
  caller function. This provides more accurate wchan values,
  at the expense of slightly more scheduling overhead.

  If in doubt, say "Y".

So if I say 'y', is that a request to disable it, or enable it?  And
what exactly do I get if I vote *against* 'more accurate wchan values'?
Do I get everybody having the same wchan pointing somewhere in the
scheduler code, because that's where __builtin_return_address() points?

And please - a triple negative in the Kconfig variable name?  This has
gotta be a winner for poor taste in variable naming...



--==_Exmh_1226372137_3458P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJGPQpcC3lWbTT17ARAopSAJ0XS6rbGlYJEOT0l22zjG4sWPOXnwCfRdGe
9WiS0/T1LGKERGxE6mjZttM=
=5QW/
-----END PGP SIGNATURE-----

--==_Exmh_1226372137_3458P--
