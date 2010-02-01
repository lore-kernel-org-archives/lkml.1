Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab0BAHWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:22:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:52051 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754475Ab0BAHWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:22:09 -0500
Date: Mon, 1 Feb 2010 18:22:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build warning
Message-Id: <20100201182204.cc53b339.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Feb_2010_18_22_04_+1100_PqrIsUr+ZI9cf.tw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Feb_2010_18_22_04_+1100_PqrIsUr+ZI9cf.tw
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allyesconfig) produced this warning:

kernel/sched.c:1636: warning: 'update_shares_locked' defined but not used

Introduced by commit f492e12ef050e02bf0185b6b57874992591b9be1 ("sched:
Remove load_balance_newidle()").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Feb_2010_18_22_04_+1100_PqrIsUr+ZI9cf.tw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktmgRwACgkQjjKRsyhoI8zuBQCdEkuuo0wcoVPCxLFN8Gl/Lhp1
bIoAn3/b/2WyiTZ95PsF5fJlfHV5EX+V
=lcxs
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Feb_2010_18_22_04_+1100_PqrIsUr+ZI9cf.tw--
