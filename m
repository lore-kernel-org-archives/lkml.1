Return-Path: <linux-kernel-owner+w=401wt.eu-S1753236AbZFVBBY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236AbZFVBBY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 21:01:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbZFVBBP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 21:01:15 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36832 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751174AbZFVBBP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 21:01:15 -0400
Date: Mon, 22 Jun 2009 11:01:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>, general@lists.openfabrics.org
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: linux-next: origin tree build warning
Message-Id: <20090622110113.7cd89382.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_11_01_13_+1000_m_cRvG2f5/ugGLE5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_11_01_13_+1000_m_cRvG2f5/ugGLE5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

drivers/infiniband/hw/mthca/mthca_mr.c: In function 'mthca_arbel_write_mtt_=
seg':
drivers/infiniband/hw/mthca/mthca_mr.c:358: warning: 'dma_sync_single' is d=
eprecated (declared at /scratch/sfr/next/include/linux/dma-mapping.h:113)
drivers/infiniband/hw/mthca/mthca_mr.c: In function 'mthca_arbel_map_phys_f=
mr':
drivers/infiniband/hw/mthca/mthca_mr.c:810: warning: 'dma_sync_single' is d=
eprecated (declared at /scratch/sfr/next/include/linux/dma-mapping.h:113)

Introduced by commit dbe6f1869188b6e04e38aa861dd198befb08bcd7
("dma-mapping: mark dma_sync_single and dma_sync_sg as deprecated").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_11_01_13_+1000_m_cRvG2f5/ugGLE5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko+19kACgkQjjKRsyhoI8wCjgCgqPi+OiUfCupcAR+molNU1oD9
I7cAmwb50Y98KUDhBW8IHC5fB+fOv/At
=Q10J
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_11_01_13_+1000_m_cRvG2f5/ugGLE5--
