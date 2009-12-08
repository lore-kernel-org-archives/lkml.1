Return-Path: <linux-kernel-owner+w=401wt.eu-S966936AbZLHXmb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966936AbZLHXmb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 18:42:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966927AbZLHXmZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 18:42:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41328 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966918AbZLHXmQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 18:42:16 -0500
Date: Wed, 9 Dec 2009 10:42:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Masami Hiramatsu <mhiramat@redhat.com>
Subject: linux-next: origin (tip) tree build warning
Message-Id: <20091209104216.94249b11.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Dec_2009_10_42_16_+1100_mN3GF=7UGsFKp7jm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Dec_2009_10_42_16_+1100_mN3GF=7UGsFKp7jm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's (and probably several earlier) linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/tools/test_get_len.c: In function 'main':
arch/x86/tools/test_get_len.c:116: warning: unused variable 'c'

Introduced by commit d65ff75fbe6f8ac7c17f18e4108521898468822c ("x86: Add
verbose option to insn decoder test").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Dec_2009_10_42_16_+1100_mN3GF=7UGsFKp7jm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkse5FgACgkQjjKRsyhoI8wvjACbBZt7bhkMFlThYN1bHfOOVBls
Ju0AoKU+mMN4pFwIJuGy0/umg0ktYbqP
=L9qx
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Dec_2009_10_42_16_+1100_mN3GF=7UGsFKp7jm--
