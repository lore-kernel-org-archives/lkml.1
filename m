Return-Path: <linux-kernel-owner+w=401wt.eu-S932447AbZHDGQ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447AbZHDGQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 02:16:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932428AbZHDGQ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 02:16:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47807 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932422AbZHDGQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 02:16:58 -0400
Date: Tue, 4 Aug 2009 16:16:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Steven Rostedt <srostedt@redhat.com>
Subject: linux-next: tip tree build warning
Message-Id: <20090804161640.70817ee6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__4_Aug_2009_16_16_40_+1000_nRUzz17sk77Zx5MW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Aug_2009_16_16_40_+1000_nRUzz17sk77Zx5MW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced these warnings:

kernel/trace/ring_buffer.c: In function 'rb_head_page_set':
kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from =
integer without a cast
kernel/trace/ring_buffer.c:704: warning: initialization makes pointer from =
integer without a cast
kernel/trace/ring_buffer.c: In function 'rb_head_page_replace':
kernel/trace/ring_buffer.c:797: warning: initialization makes integer from =
pointer without a cast

Introduced by commit 77ae365eca895061c8bf2b2e3ae1d9ea62869739
("ring-buffer: make lockless").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__4_Aug_2009_16_16_40_+1000_nRUzz17sk77Zx5MW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp30kgACgkQjjKRsyhoI8xEtACfbhHY2QITcpQ5syPmonYj79z5
DMUAn29cABgIiqCNtiHpwAanNtBjb+CJ
=1Ibt
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Aug_2009_16_16_40_+1000_nRUzz17sk77Zx5MW--
