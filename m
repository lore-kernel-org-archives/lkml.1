Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0CJEbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Mar 2010 23:31:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43737 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756203Ab0CJEbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Mar 2010 23:31:22 -0500
Date: Wed, 10 Mar 2010 15:31:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: linux-next: build warning after merge of the security-testing tree
Message-Id: <20100310153116.291d4e6f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Mar_2010_15_31_16_+1100_xSwzEdYFWW8k7rEH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Mar_2010_15_31_16_+1100_xSwzEdYFWW8k7rEH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

After merging the security-testing tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

scripts/selinux/genheaders/genheaders.c: In function 'main':
scripts/selinux/genheaders/genheaders.c:84: warning: initialization discard=
s qualifiers from pointer target type

Introduced by commit 634a539e16bd7a1ba31c3f832baa725565cc9f96 ("selinux:
const strings in tables").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Mar_2010_15_31_16_+1100_xSwzEdYFWW8k7rEH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuXIJUACgkQjjKRsyhoI8wBUQCfZkFjy201a4IKkwcoH+nKgQad
8NwAn20MbTjIn7fv96hobdm1pyL1u6UG
=9h+a
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Mar_2010_15_31_16_+1100_xSwzEdYFWW8k7rEH--
