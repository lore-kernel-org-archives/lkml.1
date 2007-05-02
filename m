Return-Path: <linux-kernel-owner+w=401wt.eu-S1766703AbXEBWll@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766703AbXEBWll (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 18:41:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767132AbXEBWll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 18:41:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:56575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1766703AbXEBWlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 18:41:40 -0400
Message-ID: <46391392.4070706@redhat.com>
Date: Wed, 02 May 2007 15:41:22 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linux Kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Andi Kleen <ak@suse.de>
Subject: Why ssse3?
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFFA09106E8D9E85FED75E34B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFFA09106E8D9E85FED75E34B
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Note the extra 's'.  We use "sse" and "sse2", but "ssse3".  I assume
it's a typo.


Signed-off-by: Ulrich Drepper <drepper@redhat.com>

--- arch/i386/kernel/cpu/proc.c	2007-02-15 11:21:18.000000000 -0800
+++ arch/i386/kernel/cpu/proc.c-new	2007-05-02 15:31:17.000000000 -0700
@@ -46,7 +46,7 @@

 		/* Intel-defined (#2) */
 		"pni", NULL, NULL, "monitor", "ds_cpl", "vmx", "smx", "est",
-		"tm2", "ssse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
+		"tm2", "sse3", "cid", NULL, NULL, "cx16", "xtpr", NULL,
 		NULL, NULL, "dca", NULL, NULL, NULL, NULL, "popcnt",
 		NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,


--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigFFA09106E8D9E85FED75E34B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGOROS2ijCOnn/RHQRAnA0AJ9qSjBgx7mYKepqWp1/vARDSXrsYwCgsUJZ
eRAnDVrLm8+xdh8J8XUvo74=
=Z8Ag
-----END PGP SIGNATURE-----

--------------enigFFA09106E8D9E85FED75E34B--
