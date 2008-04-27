Return-Path: <linux-kernel-owner+w=401wt.eu-S1763776AbYD0UOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763776AbYD0UOL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2008 16:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761900AbYD0UN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Apr 2008 16:13:58 -0400
Received: from diva.malsain.org ([91.121.19.57]:51724 "EHLO diva.malsain.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752899AbYD0UN5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2008 16:13:57 -0400
X-Greylist: delayed 2838 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2008 16:13:56 EDT
Subject: [PATCH] Increase the default RLIMIT_MEMLOCK
From: Josselin Mouette <joss@debian.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@osdl.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-O/JgcEXLE9N8/0toC6kv"
Date: Sun, 27 Apr 2008 21:26:27 +0200
Message-Id: <1209324387.4203.22.camel@shizuru>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-O/JgcEXLE9N8/0toC6kv
Content-Type: multipart/mixed; boundary="=-twpa3x1hGb3Nwxmjua9A"


--=-twpa3x1hGb3Nwxmjua9A
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

Currently, the default value for RLIMIT_MEMLOCK (defined in
include/linux/resource.h) is 32 KiB, because this value is enough for
GnuPG.

However this value is not enough for gnome-keyring-daemon, which will
store both SSH and GnuPG keys, plus user passwords for various kinds of
resources. Upstream authors recommend to provide a limit of at least 256
KiB for RLIMIT_MEMLOCK for the keys to remain securely in memory.

Given the amount of memory in current machines, I think 256 KiB is still
a very reasonable value. What do you think of increasing this default
value in the kernel?

Cheers,
--=20
 .''`.
: :' :      We are debian.org. Lower your prices, surrender your code.
`. `'       We will add your hardware and software distinctiveness to
  `-        our own. Resistance is futile.

--=-twpa3x1hGb3Nwxmjua9A
Content-Description: 
Content-Disposition: inline; filename=linux_mlock_256k.patch
Content-Type: text/x-patch; charset=ISO-8859-15
Content-Transfer-Encoding: base64

LS0tIGluY2x1ZGUvbGludXgvcmVzb3VyY2UuaC5vcmlnCTIwMDgtMDQtMjcgMjE6MTU6NDcuMDAw
MDAwMDAwICswMjAwDQorKysgaW5jbHVkZS9saW51eC9yZXNvdXJjZS5oCTIwMDgtMDQtMjcgMjE6
MjM6MDYuMDAwMDAwMDAwICswMjAwDQpAQCAtNTgsMTAgKzU4LDExIEBADQogI2RlZmluZSBfU1RL
X0xJTQkoOCoxMDI0KjEwMjQpDQogDQogLyoNCi0gKiBHUEcgd2FudHMgMzJrQiBvZiBtbG9ja2Vk
IG1lbW9yeSwgdG8gbWFrZSBzdXJlIHBhc3MgcGhyYXNlcw0KLSAqIGFuZCBvdGhlciBzZW5zaXRp
dmUgaW5mb3JtYXRpb24gYXJlIG5ldmVyIHdyaXR0ZW4gdG8gZGlzay4NCisgKiBUaGUgYmlnZ2Vz
dCB3aWRlc3ByZWFkIG1sb2NrZWQgbWVtb3J5IGNvbnN1bWVyIGlzIA0KKyAqIGdub21lLWtleXJp
bmctbWFuYWdlci4gSXQgbmVlZHMgMjU2a0IgdG8gbWFrZSBzdXJlIFNTSC9HUEcgDQorICogcGFz
c3BocmFzZXMgYW5kIG5ldHdvcmsgcGFzc3dvcmRzIGFyZSBuZXZlciB3cml0dGVuIHRvIGRpc2su
DQogICovDQotI2RlZmluZSBNTE9DS19MSU1JVAkoOCAqIFBBR0VfU0laRSkNCisjZGVmaW5lIE1M
T0NLX0xJTUlUCSg2NCAqIFBBR0VfU0laRSkNCiANCiAvKg0KICAqIER1ZSB0byBiaW5hcnkgY29t
cGF0aWJpbGl0eSwgdGhlIGFjdHVhbCByZXNvdXJjZSBudW1iZXJzDQo=


--=-twpa3x1hGb3Nwxmjua9A--

--=-O/JgcEXLE9N8/0toC6kv
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIFNNjrSla4ddfhTMRAu7DAKDNjyZRd4fYoJEOx2rfj3yExlqfnACfR6To
LR68qvDcMN6U+xhKMVQXQoE=
=6OuK
-----END PGP SIGNATURE-----

--=-O/JgcEXLE9N8/0toC6kv--

