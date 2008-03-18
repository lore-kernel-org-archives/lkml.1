Return-Path: <linux-kernel-owner+w=401wt.eu-S943566AbYCTAAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S943566AbYCTAAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1162144AbYCSWqX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 18:46:23 -0400
Received: from os.eurotux.com ([216.75.63.6]:46846 "EHLO os.eurotux.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1764672AbYCSWqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 18:46:20 -0400
Date: Tue, 18 Mar 2008 15:24:37 +0000
From: Luciano Rocha <luciano@eurotux.com>
To: linux-kernel@vger.kernel.org
Subject: target headers_install: no linux/if_addrlabel.h (2.6.24.3)
Message-ID: <20080318152437.GA29674@bit.office.eurotux.com>
Mail-Followup-To: Luciano Rocha <luciano@eurotux.com>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C7zPtVaVf+AK4Oqc"
Content-Disposition: inline
User-Agent: Mutt/1.5.14 (2007-03-31)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C7zPtVaVf+AK4Oqc
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Hello,

I've compiled Linux 2.6.24.3 for arm, using gcc 4.3.0, and I get the
following error when trying to extract the kernel headers. Is this
known, or do I have a problem with my configuration?

$ nice make -C /home/luciano/work/gilix/v2/src/linux O=3D$PWD ARCH=3Darm \
  CROSS_COMPILE=3Darm-unknown-linux-gnueabi- V=3D1 \
  modules_install INSTALL_MOD_PATH=3D$PWD/dist \
  headers_install INSTALL_HDR_PATH=3D$PWD/dist/usr

=2E..
  scripts/unifdef -U__KERNEL__ /home/luciano/work/gilix/v2/src/linux/includ=
e/linux/icmpv6.h | sed 	-e "s/ inline / __inline__ /g" -e "s/[[:space:]]__u=
ser[[:space:]]\{1,\}/ /g" -e "s/(__user[[:space:]]\{1,\}/ (/g" -e "s/[[:spa=
ce:]]__force[[:space:]]\{1,\}/ /g" -e "s/(__force[[:space:]]\{1,\}/ (/g" -e=
 "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" -e "s/(__iomem[[:space:]]\{1,\=
}/ (/g" -e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" -e "s/[=
[:space:]]__attribute_const__$//" -e "/^#include <linux\/compiler.h>/d" > /=
home/luciano/work/gilix/v2/build/linux/dist/usr/include/linux/icmpv6.h || :
  scripts/unifdef -U__KERNEL__ /home/luciano/work/gilix/v2/src/linux/includ=
e/linux/if_addr.h | sed 	-e "s/ inline / __inline__ /g" -e "s/[[:space:]]__=
user[[:space:]]\{1,\}/ /g" -e "s/(__user[[:space:]]\{1,\}/ (/g" -e "s/[[:sp=
ace:]]__force[[:space:]]\{1,\}/ /g" -e "s/(__force[[:space:]]\{1,\}/ (/g" -=
e "s/[[:space:]]__iomem[[:space:]]\{1,\}/ /g" -e "s/(__iomem[[:space:]]\{1,=
\}/ (/g" -e "s/[[:space:]]__attribute_const__[[:space:]]\{1,\}/\ /g" -e "s/=
[[:space:]]__attribute_const__$//" -e "/^#include <linux\/compiler.h>/d" > =
/home/luciano/work/gilix/v2/build/linux/dist/usr/include/linux/if_addr.h ||=
 :
make[3]: *** No rule to make target `/home/luciano/work/gilix/v2/src/linux/=
include/linux/if_addrlabel.h', needed by `/home/luciano/work/gilix/v2/build=
/linux/dist/usr/include/linux/if_addrlabel.h'.  Stop.
make[2]: *** [linux] Error 2
make[1]: *** [headers_install] Error 2
make: *** [sub-make] Error 2

Regards,
Luciano Rocha

--=20
Luciano Rocha <luciano@eurotux.com>
Eurotux Inform=E1tica, S.A. <http://www.eurotux.com/>

--C7zPtVaVf+AK4Oqc
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFH3961inSul6a7oB8RAhCCAJ4palY3TRNp1PKeFCWqeS/VSylOGACgg9jA
2DoOO2BwJceqSyjJ9UbJ+wc=
=DvM1
-----END PGP SIGNATURE-----

--C7zPtVaVf+AK4Oqc--
