Return-Path: <linux-kernel-owner+w=401wt.eu-S1758302AbZDHAK7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758302AbZDHAK7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 20:10:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757359AbZDHAKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 20:10:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34420 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757211AbZDHAKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 20:10:38 -0400
Date: Wed, 8 Apr 2009 10:10:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, Christian Pellegrin <chripell@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: origin tree build failure
Message-Id: <20090408101032.75afd7af.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.14.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__8_Apr_2009_10_10_32_+1000_kwpSavlbI9d0X+3o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__8_Apr_2009_10_10_32_+1000_kwpSavlbI9d0X+3o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

Today's linux-next build (x86_64 allmodconfig) failed like this:

make[3]: *** No rule to make target `drivers/serial/max3100.c', needed by `=
drivers/serial/max3100.o'.  Stop.

The commit 1dcb884ca8048efb4ce2999d367c26369ab2227c ("Add support for the
MAX3100 SPI UART.") added everything except the file above.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__8_Apr_2009_10_10_32_+1000_kwpSavlbI9d0X+3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknb63gACgkQjjKRsyhoI8yyagCcCzjURscJhT/PBR3T+fAi+uKB
tTQAnjcr+ewGrImFpIjzPamCLiUevA/G
=JVc0
-----END PGP SIGNATURE-----

--Signature=_Wed__8_Apr_2009_10_10_32_+1000_kwpSavlbI9d0X+3o--
