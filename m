Return-Path: <linux-kernel-owner+w=401wt.eu-S1760181AbZKZJQS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760181AbZKZJQS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Nov 2009 04:16:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760164AbZKZJQI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Nov 2009 04:16:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47143 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760140AbZKZJQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Nov 2009 04:16:06 -0500
Date: Thu, 26 Nov 2009 20:16:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
Subject: linux-next: sparc tree build failure
Message-Id: <20091126201607.023e1269.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_20_16_07_+1100_qat5QJAOuINjMpIY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_20_16_07_+1100_qat5QJAOuINjMpIY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (sparc32 defconfig) failed like this:

arch/sparc/lib/atomic32.c: In function '__atomic_add_return':
arch/sparc/lib/atomic32.c:34: error: implicit declaration of function '__ra=
w_spin_lock_irqsave'
arch/sparc/lib/atomic32.c:38: error: implicit declaration of function '__ra=
w_spin_unlock_irqrestore'

Caused by commit 4df286e52917c95c415400367cfd523dfbb0f93a ("sparc: Make
atomic locks raw") which I have reverted for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_20_16_07_+1100_qat5QJAOuINjMpIY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksOR1cACgkQjjKRsyhoI8wX1gCfTmC0BR9HKkzjTrLFL2V9Qf94
zfAAn0JK1hHQiR7KRVMZyPq37XQ9Kidj
=wTGG
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_20_16_07_+1100_qat5QJAOuINjMpIY--
