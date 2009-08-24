Return-Path: <linux-kernel-owner+w=401wt.eu-S1751652AbZHXGzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751652AbZHXGzA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 02:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751547AbZHXGy7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 02:54:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49423 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751452AbZHXGy7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 02:54:59 -0400
Date: Mon, 24 Aug 2009 16:54:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build failure
Message-Id: <20090824165449.559d1597.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_16_54_49_+1000_3hH2F0hzYrAyAUtb"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_16_54_49_+1000_3hH2F0hzYrAyAUtb
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

arch/powerpc/kernel/perf_callchain.c: In function 'perf_callchain_kernel':
arch/powerpc/kernel/perf_callchain.c:73: error: implicit declaration of fun=
ction 'perf_paranoid_anon_ip'

Caused by commit 512cec5d6f2a71e04464bf4fd76a50571bd0dea1 ("perf_counter:
powerpc: Support the anonimized kernel callchain bits") which I have
reverted for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_16_54_49_+1000_3hH2F0hzYrAyAUtb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqSOTkACgkQjjKRsyhoI8zltQCfSN9Hesl0MUsjm7Ivrc3f1k6C
fsgAoIFOY3UwO1+pT+0G6jAmpILZrTE5
=alVR
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_16_54_49_+1000_3hH2F0hzYrAyAUtb--
