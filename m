Return-Path: <linux-kernel-owner+w=401wt.eu-S1750939AbZHXAXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750939AbZHXAXG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 20:23:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750806AbZHXAXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 20:23:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59624 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbZHXAXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 20:23:05 -0400
Date: Mon, 24 Aug 2009 10:22:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, <linuxppc-dev@ozlabs.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@lst.de>
Subject: linux-next: powerpc tree build warning
Message-Id: <20090824102256.3e8d69b6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_10_22_56_+1000_TsIzUDLM0EdywED="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_10_22_56_+1000_TsIzUDLM0EdywED=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

kernel/time/tick-sched.c: In function 'tick_nohz_stop_sched_tick':
kernel/time/tick-sched.c:261: warning: format '%02x' expects type 'unsigned=
 int', but argument 2 has type 'long unsigned int'

Introduced by commit 6826a57d1abc8ac9f59b24f1a008554c6560a995 ("powerpc:
Switch to asm-generic/hardirq.h") which changed
irq_cpustat_t::__softirq_pending from "unsigned int" to "unsigned long"
on powerpc.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_10_22_56_+1000_TsIzUDLM0EdywED=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqR3WAACgkQjjKRsyhoI8yuxACdENh3S1MUrabBRkUusT73XveS
BxcAn3kXMNnBe0PxH3H8DiujgkMYbWKA
=SnUD
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_10_22_56_+1000_TsIzUDLM0EdywED=--
