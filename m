Return-Path: <linux-kernel-owner+w=401wt.eu-S1753626AbZJLD45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753626AbZJLD45 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 23:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753370AbZJLD45
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 23:56:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48632 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753338AbZJLD44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 23:56:56 -0400
Date: Mon, 12 Oct 2009 14:56:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: tip tree question
Message-Id: <20091012145609.c3cc78aa.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Oct_2009_14_56_09_+1100_wOeeOteqUezzpWH1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Oct_2009_14_56_09_+1100_wOeeOteqUezzpWH1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I noticed that the auto-latest branch of the tip tree (which is what is
included in linux-next) has had the tip out-of-tree branch merged into
it.  This seems to just introduce lots of commits into linux-next that
have nothing to do with the tip tree (some of which contain fixes that
are also in Linus' tree) and adds a localversion-tip file.

I was wondering if this was done out of necessity or by oversight.

I have reverted commit e67d8da85f7a4c2772fe3731de9396b6d01a045e ("Merge
branch 'out-of-tree' into auto-latest") from linux-next for today and the
x86_64 allmodconfig and powerpc ppc64_defconfig builds still seem OK.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Oct_2009_14_56_09_+1100_wOeeOteqUezzpWH1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrSqNkACgkQjjKRsyhoI8zYswCePQsZgVkcA2A920TiSBPrSrCH
3SAAn22lk4/Yj5DYIVh6j6Om0/CLavzL
=nWHp
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Oct_2009_14_56_09_+1100_wOeeOteqUezzpWH1--
