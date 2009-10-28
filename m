Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbZJ1HOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbZJ1HOr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Oct 2009 03:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757463AbZJ1HOr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Oct 2009 03:14:47 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56316 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757450AbZJ1HOq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Oct 2009 03:14:46 -0400
Date: Wed, 28 Oct 2009 18:14:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: tip tree build warning
Message-Id: <20091028181443.50a09dbb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Oct_2009_18_14_43_+1100_J.=z8wB9j5=o1bhG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Oct_2009_18_14_43_+1100_J.=z8wB9j5=o1bhG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

In file included from arch/x86/include/asm/smp.h:13,
                 from arch/x86/include/asm/mmzone_64.h:12,
                 from arch/x86/include/asm/mmzone.h:4,
                 from include/linux/mmzone.h:783,
                 from include/linux/gfp.h:4,
                 from include/linux/kmod.h:22,
                 from include/linux/module.h:13,
                 from arch/x86/kernel/apic/apic_noop.c:14:
arch/x86/include/asm/apic.h: In function 'default_apicid_to_cpu_present':
arch/x86/include/asm/apic.h:591: warning: the frame size of 8192 bytes is l=
arger than 2048 bytes

It may not have been caused by the tip tree, but I can't find what
changed to cause this and a commit from the tip tree has exposed it
(9844ab11c763bfed9f054c82366b19dcda66aca9 "x86, apic: Introduce the NOOP
apic driver").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Oct_2009_18_14_43_+1100_J.=z8wB9j5=o1bhG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrn72QACgkQjjKRsyhoI8xKpACfclt8tyVD70IodF/OnNsRbv2/
c/AAoIwdTq2BUM4FVEncr8nvw6/IABqy
=3WQR
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Oct_2009_18_14_43_+1100_J.=z8wB9j5=o1bhG--
