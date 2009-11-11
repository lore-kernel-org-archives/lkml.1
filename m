Return-Path: <linux-kernel-owner+w=401wt.eu-S1751061AbZKKJNB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751061AbZKKJNB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 04:13:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751299AbZKKJNA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 04:13:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:46110 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbZKKJM7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 04:12:59 -0500
Date: Wed, 11 Nov 2009 20:13:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: linux-next: tip tree build failure
Message-Id: <20091111201302.da1bab60.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Nov_2009_20_13_02_+1100_K1G64qEE317X8wHS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Nov_2009_20_13_02_+1100_K1G64qEE317X8wHS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allyesconfig) failed like this:

lib/swiotlb.c: In function 'setup_io_tlb_npages':
lib/swiotlb.c:114: error: 'swiotlb' undeclared (first use in this function)

Caused by commit 75f1cdf1dda92cae037ec848ae63690d91913eac ("x86: Handle
HW IOMMU initialization failure gracefully") from the tip tree.  It looks
like the "swiotlb" variable only exists in x86 and ia64.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Nov_2009_20_13_02_+1100_K1G64qEE317X8wHS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr6gB4ACgkQjjKRsyhoI8yhCwCglr6KvC+Hqff3xaMrf9shw7o+
pKMAn3zfHYalVDFzvkwZ9EYRP2R8iuF0
=N5oh
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Nov_2009_20_13_02_+1100_K1G64qEE317X8wHS--
