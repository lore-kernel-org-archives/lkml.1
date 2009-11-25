Return-Path: <linux-kernel-owner+w=401wt.eu-S1758657AbZKYKmW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758657AbZKYKmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 05:42:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758625AbZKYKmV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 05:42:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38972 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758556AbZKYKmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 05:42:20 -0500
Date: Wed, 25 Nov 2009 21:42:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: percpu tree build warning
Message-Id: <20091125214219.f37935e8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_21_42_19_+1100_l7GA/DqL0xFSjZIT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_21_42_19_+1100_l7GA/DqL0xFSjZIT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/hw_breakpoint.c: In function 'arch_install_hw_breakpoint':
arch/x86/kernel/hw_breakpoint.c:121: warning: assignment from incompatible =
pointer type
arch/x86/kernel/hw_breakpoint.c: In function 'arch_uninstall_hw_breakpoint':
arch/x86/kernel/hw_breakpoint.c:156: warning: assignment from incompatible =
pointer type

I am not sure where this one came from ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Nov_2009_21_42_19_+1100_l7GA/DqL0xFSjZIT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksNCgsACgkQjjKRsyhoI8yBRgCfSAJAd8UCzWc5TlUP412hENbt
01cAn2Qzh2V2vARLB1TNddaO2f+k/V6U
=WxLm
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_21_42_19_+1100_l7GA/DqL0xFSjZIT--
