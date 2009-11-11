Return-Path: <linux-kernel-owner+w=401wt.eu-S1756967AbZKKH70@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756967AbZKKH70 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 02:59:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756940AbZKKH7Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 02:59:25 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:41860 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755700AbZKKH7Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 02:59:25 -0500
Date: Wed, 11 Nov 2009 18:59:19 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the percpu tree with the tip tree
Message-Id: <20091111185919.a442804d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__11_Nov_2009_18_59_19_+1100_d9+yh=mstGzlpuga"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__11_Nov_2009_18_59_19_+1100_d9+yh=mstGzlpuga
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the percpu tree got a conflict in
arch/powerpc/platforms/pseries/hvCall.S between commit
c8cd093a6e9f96ea6b871576fd4e46d7c818bb89 ("powerpc: tracing: Add
hypervisor call tracepoints") from the tip tree and commit
dd17c8f72993f9461e9c19250e3f155d6d99df22 ("percpu: remove per_cpu__
prefix") from the percpu tree.

The former removed the code changed by the latter, so I just used the tip
tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__11_Nov_2009_18_59_19_+1100_d9+yh=mstGzlpuga
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr6btcACgkQjjKRsyhoI8yC5gCgg5gEn80a4+SUExELdsG2utyF
fZAAoLfWbsb+1ih49RSHAMh2RgOUEZNJ
=wjge
-----END PGP SIGNATURE-----

--Signature=_Wed__11_Nov_2009_18_59_19_+1100_d9+yh=mstGzlpuga--
