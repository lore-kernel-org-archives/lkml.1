Return-Path: <linux-kernel-owner+w=401wt.eu-S1754693AbZLMXY0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693AbZLMXY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Dec 2009 18:24:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbZLMXYZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Dec 2009 18:24:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36733 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbZLMXYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Dec 2009 18:24:24 -0500
Date: Mon, 14 Dec 2009 10:24:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Joe Perches <joe@perches.com>, Linus <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: origin tree build warning
Message-Id: <20091214102415.10bdcf24.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__14_Dec_2009_10_24_15_+1100_gCLpXm47BKmHVRUW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__14_Dec_2009_10_24_15_+1100_gCLpXm47BKmHVRUW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/mm/mmio-mod.c: In function 'print_pte':
arch/x86/mm/mmio-mod.c:100: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:106: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:110: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'die_kmmio_nesting_error':
arch/x86/mm/mmio-mod.c:123: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:134: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:136: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'mmiotrace_ioremap':
arch/x86/mm/mmio-mod.c:286: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'iounmap_trace_core':
arch/x86/mm/mmio-mod.c:305: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'clear_trace_list':
arch/x86/mm/mmio-mod.c:367: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'enter_uniprocessor':
arch/x86/mm/mmio-mod.c:404: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:406: warning: too many arguments for format
arch/x86/mm/mmio-mod.c: In function 'leave_uniprocessor':
arch/x86/mm/mmio-mod.c:426: warning: too many arguments for format
arch/x86/mm/mmio-mod.c:428: warning: too many arguments for format

Caused by commit 3a0340be06a9356eb61f6804107480acbe62c069 ("x86:
mmio-mod.c: Use pr_fmt").  Was this even build tested?  The patch doesn't
even match the commit message.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__14_Dec_2009_10_24_15_+1100_gCLpXm47BKmHVRUW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksld58ACgkQjjKRsyhoI8xhwgCbBcx0vQRNqVKN8/SaZQh65ClA
4TEAoL0dzrdRoaT5ths94h1QVH9xMrks
=E2XH
-----END PGP SIGNATURE-----

--Signature=_Mon__14_Dec_2009_10_24_15_+1100_gCLpXm47BKmHVRUW--
