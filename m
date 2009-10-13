Return-Path: <linux-kernel-owner+w=401wt.eu-S1751372AbZJMEIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372AbZJMEIh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751076AbZJMEIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:08:36 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39926 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751048AbZJMEIf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:08:35 -0400
Date: Tue, 13 Oct 2009 15:07:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: linux-next: staging tree build failure
Message-Id: <20091013150753.f738576e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_15_07_53_+1100_cxUZnMh0ZWE8WWsQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_15_07_53_+1100_cxUZnMh0ZWE8WWsQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) failed like this:

make[4]: *** No rule to make target `include/linux/hayesesp.h', needed by `=
usr/include/linux/.install'.  Stop.

Caused by commit a724aa0a5ad2b3c6b5ee48e79a09e9fbc5cf3ec9 ("tty: esp:
remove broken driver") which I have reverted for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_15_07_53_+1100_cxUZnMh0ZWE8WWsQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrT/RkACgkQjjKRsyhoI8wZsQCbBd4tPJo+jiH75Tq83LmSKijE
4p8An27Liz+hPJwfyQHCEKJ3U86Z6ctP
=L1A+
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_15_07_53_+1100_cxUZnMh0ZWE8WWsQ--
