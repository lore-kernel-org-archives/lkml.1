Return-Path: <linux-kernel-owner+w=401wt.eu-S1758043AbXLGU1L@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043AbXLGU1L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2007 15:27:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757525AbXLGU0v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Dec 2007 15:26:51 -0500
Received: from threatwall.zlynx.org ([199.45.143.218]:34503 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757389AbXLGU0u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2007 15:26:50 -0500
Subject: 2.6.24-rc4-mm1 and /proc/<pid>/status Name: field
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-LdHgRLmLVBXRSgp6tWAm"
Date: Fri, 07 Dec 2007 20:26:43 +0000
Message-Id: <1197059203.15428.5.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
X-Envelope-From: zlynx@acm.org
X-Spam-Id: 20071207/1J0jmX-0000Oz-Q2-linux-kernel@vger.kernel.org:zlynx@acm.org:199.45.143.218
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-LdHgRLmLVBXRSgp6tWAm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Today I noticed pgrep doesn't work.  It seems the reason is a missing
Name: tag in the status file for a process in /proc.

# cat /proc/1/status
init
State:  S (sleeping)
Tgid:   1
Pid:    1
PPid:   0
TracerPid:      0
...etc, etc...

This is supposed to look like:
# cat /proc/1/status
Name:	init
State:	S (sleeping)
Tgid:	1
Pid:	1
PPid:	0
TracerPid:	0
...


--=20
Zan Lynx <zlynx@acm.org>

--=-LdHgRLmLVBXRSgp6tWAm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHWayDG8fHaOLTWwgRArY4AJ9UrOAif0j0a0UrNnD71P2U3i+/fACggQYn
qm9OEpYQhgP+DEnLQepkxYI=
=eq6W
-----END PGP SIGNATURE-----

--=-LdHgRLmLVBXRSgp6tWAm--

