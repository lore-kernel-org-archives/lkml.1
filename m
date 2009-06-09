Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbZFIG0x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbZFIG0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 02:26:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753555AbZFIG0n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 02:26:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39104 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbZFIG0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 02:26:42 -0400
Date: Tue, 9 Jun 2009 16:26:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rr tree build warning
Message-Id: <20090609162636.d2351007.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Jun_2009_16_26_36_+1000_l0t=ZNwp_s48JEsK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Jun_2009_16_26_36_+1000_l0t=ZNwp_s48JEsK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/cpu/cpufreq/powernow-k8.c:1287: warning: passing argument 1=
 of 'check_supported_cpu' makes pointer from integer without a cast
arch/x86/kernel/cpu/cpufreq/powernow-k8.c:514: note: expected 'void *' but =
argument is of type 'unsigned int'

Introduced by commit b3594a9ce5fb32533084ec75f1954c93f461591d ("cpumask:
avoid playing with cpus_allowed in powernow-k8.c").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Jun_2009_16_26_36_+1000_l0t=ZNwp_s48JEsK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouAJwACgkQjjKRsyhoI8xtswCgisGQLzpm3dteyCH0HWqDI4ih
Sp8AnisInaPtPo/+1a1NOsKV2VDUjnLX
=t4yi
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Jun_2009_16_26_36_+1000_l0t=ZNwp_s48JEsK--
