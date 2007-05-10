Return-Path: <linux-kernel-owner+w=401wt.eu-S1757109AbXEJPQw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757109AbXEJPQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 11:16:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753215AbXEJPQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 11:16:45 -0400
Received: from iucha.net ([209.98.146.184]:55720 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753144AbXEJPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 11:16:44 -0400
Date: Thu, 10 May 2007 10:16:43 -0500
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Vivek Goyal <vgoyal@in.ibm.com>, Andi Kleen <ak@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Current git fails to compile on AMD64 for three days in a row
Message-ID: <20070510151642.GH26751@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QnBU6tTI9sljzm9u"
Content-Disposition: inline
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--QnBU6tTI9sljzm9u
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I just pulled the current git (de5603748af8bf7deac403e6ba92887f8d18e812)
and tried to compile it on my AMD64 box, to test Chuck's RPC fix.  It
fails:

   arch/x86_64/kernel/head64.c: In function =E2=80=98x86_64_start_kernel=E2=
=80=99:
   arch/x86_64/kernel/head64.c:70: error: size of array =E2=80=98type name=
=E2=80=99 is negative

It is failing in the same way since Monday.

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--QnBU6tTI9sljzm9u
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGQzdaND0rFCN2b1sRAq2dAJ4+TuzUhgMMFpO8Edy8CxCfKfVpGQCgmwc8
XD3zMrEd48Xzm0Js0hCdoYs=
=Hbj+
-----END PGP SIGNATURE-----

--QnBU6tTI9sljzm9u--
