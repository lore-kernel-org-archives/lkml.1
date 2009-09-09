Return-Path: <linux-kernel-owner+w=401wt.eu-S1752934AbZIIDsB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752934AbZIIDsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Sep 2009 23:48:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752839AbZIIDsA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Sep 2009 23:48:00 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34080 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812AbZIIDr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Sep 2009 23:47:59 -0400
Date: Wed, 9 Sep 2009 13:47:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Siarhei Liakh <sliakh.lkml@gmail.com>, Xuxian Jiang <jiang@cs.ncsu.edu>,
       Arjan van de Ven <arjan@linux.intel.com>
Subject: linux-next: rr tree build failure
Message-Id: <20090909134752.f5b8c2e7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Sep_2009_13_47_52_+1000_fvckU9udN=5=v6t9"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Sep_2009_13_47_52_+1000_fvckU9udN=5=v6t9
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

kernel/module.c: In function 'set_section_ro_nx':
kernel/module.c:1549: error: implicit declaration of function 'set_memory_r=
o'
kernel/module.c:1560: error: implicit declaration of function 'set_memory_n=
x'
kernel/module.c: In function 'unset_section_ro_nx':
kernel/module.c:1575: error: implicit declaration of function 'set_memory_r=
w'

Caused by commit 25306e21864c2a220d6fa2e0632425028aa9626c
("module:ro-nx-protection") which uses these interfaces that are only
defined on x86 ...

I have used the version of the rr tree from next-20090908 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Sep_2009_13_47_52_+1000_fvckU9udN=5=v6t9
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqnJWgACgkQjjKRsyhoI8xXbACgq+Bc+RmETT3Uq4IoAtIOuRig
XqwAnjUO3zqhuK7pBh8LFfL3qnsuTiq/
=uYv4
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Sep_2009_13_47_52_+1000_fvckU9udN=5=v6t9--
