Return-Path: <linux-kernel-owner+w=401wt.eu-S1756962AbZGFBiJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756962AbZGFBiJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jul 2009 21:38:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753119AbZGFBh4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Jul 2009 21:37:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41759 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751487AbZGFBhz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jul 2009 21:37:55 -0400
Date: Mon, 6 Jul 2009 11:37:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Avi Kivity <avi@qumranet.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Gleb Natapov <gleb@redhat.com>
Subject: linux-next: kvm tree build warning
Message-Id: <20090706113752.8dec663a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jul_2009_11_37_52_+1000_M6aF7iBb1J_Ttld3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jul_2009_11_37_52_+1000_M6aF7iBb1J_Ttld3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Avi,

Today's linux-next build (x86_64_allmodconfig) produced this warning:

arch/x86/kvm/lapic.c: In function 'apic_mmio_write':
arch/x86/kvm/lapic.c:834: warning: 'return' with no value, in function retu=
rning non-void

Introduced by commit 55b23c7377c9f9f0b4a4b90950f0e18b26ac45e8 ("KVM:
x2apic interface to lapic").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jul_2009_11_37_52_+1000_M6aF7iBb1J_Ttld3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRVXAACgkQjjKRsyhoI8z8jACbB5HcAse27/bvsy5NVEDgKTxx
TegAnRKlrD5UeXxF+5p8ieXr4/0QDY0v
=hgBe
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jul_2009_11_37_52_+1000_M6aF7iBb1J_Ttld3--
