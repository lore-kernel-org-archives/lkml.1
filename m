Return-Path: <linux-kernel-owner+w=401wt.eu-S1757576AbZFIBtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576AbZFIBtW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jun 2009 21:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757552AbZFIBsZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Jun 2009 21:48:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53008 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757556AbZFIBsY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jun 2009 21:48:24 -0400
Date: Tue, 9 Jun 2009 11:48:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: kbuild tree build failure
Message-Id: <20090609114820.69d23ab3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_11_48_20_+1000_oLZO9X9cTBxFpOBn"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_11_48_20_+1000_oLZO9X9cTBxFpOBn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sam,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

powerpc-linux-ld:arch/powerpc/kernel/vmlinux.lds:190: syntax error

Caused by commit 59d59d97e34c6593bec43666679b28da5d583958 ("Improve
vmlinux.lds.h support for arch specific linker scripts") which was
clearly not build tested - don't do that! There is a missing \ at the end
of a line in the definition of the HEAD_SECTION macro.

I have used the version of the kbuild tree from next-20090605.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_11_48_20_+1000_oLZO9X9cTBxFpOBn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkotv2QACgkQjjKRsyhoI8xo9gCgsThGjzeoFUK65j+KjzNRRW92
5NgAn2sMDmLoQIToLmE5GlcpsWIi12yg
=hJo0
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_11_48_20_+1000_oLZO9X9cTBxFpOBn--
