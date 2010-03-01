Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751418Ab0CAHUK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 02:20:10 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56746 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733Ab0CAHUI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 02:20:08 -0500
Date: Mon, 1 Mar 2010 18:20:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Robert Richter <robert.richter@amd.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: linux-next: manual merge of the oprofile tree with Linus' tree
Message-Id: <20100301182001.f67b21ac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_18_20_01_+1100_5+/ri21fBnwZvdp7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_18_20_01_+1100_5+/ri21fBnwZvdp7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

Today's linux-next merge of the oprofile tree got a conflict in
arch/x86/kernel/cpu/perf_event.c between commit
8c48e444191de0ff84e85d41180d7bc3e74f14ef ("perf_events, x86: Implement
intel core solo/duo support") from Linus' tree and commit
27d4a358bf5ef730aacf50696b9b5dfc5e2a87a5 ("perf, x86: rename macro in
ARCH_PERFMON_EVENTSEL_ENABLE") from the oprofile tree.

I fixed it up (by using the version from Linus' tree and substituting
ARCH_PERFMON_EVENTSEL_ENABLE for ARCH_PERFMON_EVENTSEL0_ENABLE) and can
carry the fix for a while.  I also did the same substitution in
arch/x86/kernel/cpu/perf_event_p6.c .

It would be good if you did a merge with Linus' tree and fixed these up,
thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_18_20_01_+1100_5+/ri21fBnwZvdp7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLaqEACgkQjjKRsyhoI8z4QgCeKLAhqy5slK5gkKrrhvYEZxOK
q2sAni/JuJKQwBXqFhT33+ug03iiP1mN
=pbRU
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_18_20_01_+1100_5+/ri21fBnwZvdp7--
