Return-Path: <linux-kernel-owner+w=401wt.eu-S1759711AbZFIJku@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbZFIJku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 05:40:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756917AbZFIJkm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 05:40:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36586 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755557AbZFIJkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 05:40:42 -0400
Date: Tue, 9 Jun 2009 19:40:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: voyager tree build failure
Message-Id: <20090609194038.826289f3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_19_40_38_+1000_+0xhiShooKVDlnZ."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_19_40_38_+1000_+0xhiShooKVDlnZ.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

Today's linux-next build (x86_64 allmodconfig) failed like this:

arch/x86/xen/smp.c:478: error: 'apic_safe_smp_processor_id' undeclared here=
 (not in a function)
arch/x86/kernel/smp.c:219: error: 'apic_safe_smp_processor_id' undeclared h=
ere (not in a function)

Caused by commit 6a6df48477c1959b1baa78ecabba72548d362f60 ("[VOYAGER]
x86: add {safe,hard}_smp_processor_id to smp_ops").

I have dropped the voyager tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_19_40_38_+1000_+0xhiShooKVDlnZ.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouLhYACgkQjjKRsyhoI8yiLgCeKi9Jl7C9la6DirYNS2Zua2qZ
6C4AnjMcug2LPnWtHi3eHuptn9rgd5dm
=SDZU
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_19_40_38_+1000_+0xhiShooKVDlnZ.--
