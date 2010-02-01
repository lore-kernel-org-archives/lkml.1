Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab0BAHMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 02:12:38 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56671 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab0BAHMh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 02:12:37 -0500
Date: Mon, 1 Feb 2010 18:12:30 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build warning
Message-Id: <20100201181230.9766bbab.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Feb_2010_18_12_30_+1100_SQDFYJMsH5Bk7+66"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Feb_2010_18_12_30_+1100_SQDFYJMsH5Bk7+66
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allnoconfig) produced this warning:

kernel/sched.c: In function 'wake_up_new_task':
kernel/sched.c:2631: warning: unused variable 'cpu'

Introduced by commit fabf318e5e4bda0aca2b0d617b191884fda62703 ("sched:
Fix fork vs hotplug vs cpuset namespaces").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Feb_2010_18_12_30_+1100_SQDFYJMsH5Bk7+66
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktmft4ACgkQjjKRsyhoI8zllACeLjPw7zXf/ecSi3ye5txwdQU3
9YMAn1KYzSeaM0VS/no2jYF2+CTG95Zy
=3eiK
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Feb_2010_18_12_30_+1100_SQDFYJMsH5Bk7+66--
