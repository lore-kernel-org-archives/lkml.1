Return-Path: <linux-kernel-owner+w=401wt.eu-S1753096AbZFOG4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753096AbZFOG4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751590AbZFOG4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:56:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60118 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296AbZFOG4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:56:11 -0400
Date: Mon, 15 Jun 2009 16:55:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Paul Mackerras <paulus@samba.org>
Subject: linux-next: tip/perfcounters tree build warning
Message-Id: <20090615165559.66c76c58.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Jun_2009_16_55_59_+1000_CkY7RBlWTge4lS3o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Jun_2009_16_55_59_+1000_CkY7RBlWTge4lS3o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allyesconfig) produced this warning:

arch/powerpc/kernel/perf_counter.c: In function 'record_and_restart':
arch/powerpc/kernel/perf_counter.c:1016: warning: unused variable 'addr'

Introduced by commit df1a132bf3d3508f863336c80a27806a2ac947e0
("perf_counter: Introduce struct for sample data").

I checked the tip/master branch and this is not fixed there.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Jun_2009_16_55_59_+1000_CkY7RBlWTge4lS3o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko18H8ACgkQjjKRsyhoI8yPWwCcDExquSsvDgcdPuvVx8ZZ0L7M
kiMAnRHjGM+9pORUznv4hkBjvXhl4p7u
=/6yo
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Jun_2009_16_55_59_+1000_CkY7RBlWTge4lS3o--
