Return-Path: <linux-kernel-owner+w=401wt.eu-S1754469AbYH1BqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469AbYH1BqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 21:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753373AbYH1BqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 21:46:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44691 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042AbYH1BqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 21:46:11 -0400
Date: Thu, 28 Aug 2008 11:46:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "William L. Irwin" <wli@holomorphy.com>
Subject: sparc build failure
Message-Id: <20080828114602.6c6df4a2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Aug_2008_11_46_02_+1000_08DEFSLk7n2IRWKB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Aug_2008_11_46_02_+1000_08DEFSLk7n2IRWKB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Linus' tree fails to build for sparc32 allmodconfig:

kernel/relay.c:701: undefined reference to `smp_call_function_single'

This is because it has CONFIG_SMP but not CONFIG_USE_GENERIC_SMP_HELPERS.

I am not sure what to do about this.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Aug_2008_11_46_02_+1000_08DEFSLk7n2IRWKB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAki2A1oACgkQjjKRsyhoI8yBQQCdFvwQA1Rl6dfDQrO01c7zhH0e
7ysAoL9mlQ3tiqZiggMBiV+qXojFvKZ9
=dAEX
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Aug_2008_11_46_02_+1000_08DEFSLk7n2IRWKB--
