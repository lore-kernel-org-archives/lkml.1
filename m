Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0CKCV5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Mar 2010 21:21:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56269 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752801Ab0CKCV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Mar 2010 21:21:56 -0500
Date: Thu, 11 Mar 2010 13:21:49 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the pcmcia tree
Message-Id: <20100311132149.c6ef7616.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__11_Mar_2010_13_21_49_+1100_VUE2c5ZGQANmBw3B"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__11_Mar_2010_13_21_49_+1100_VUE2c5ZGQANmBw3B
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dominik,

After merging the pcmcia tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/pcmcia/pcmcia_resource.c:704:1: error: unterminated #ifdef

Caused by commit 484f4b3fdd8f3de102b07a9b6d0d72342bcc1590 ("pcmcia:
revert "irq probe can be done without risking an IRQ storm"") which has
conflict resolution fragments still in it ...

Please, please, read and build test this stuff ...

I have used the version of the pcmcis tree from next-20100310 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__11_Mar_2010_13_21_49_+1100_VUE2c5ZGQANmBw3B
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuYU70ACgkQjjKRsyhoI8wUSgCghe50yJA6ySH1KSp4+Sz4sdPn
5bwAn0PXa8xq6/9/6HDeQcbDr/G9cCHd
=bxcP
-----END PGP SIGNATURE-----

--Signature=_Thu__11_Mar_2010_13_21_49_+1100_VUE2c5ZGQANmBw3B--
