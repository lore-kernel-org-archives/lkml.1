Return-Path: <linux-kernel-owner+w=401wt.eu-S1753815AbZEZAxE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753815AbZEZAxE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 20:53:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZEZAwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 20:52:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:60233 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752775AbZEZAwy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 20:52:54 -0400
Date: Tue, 26 May 2009 10:52:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the x86 tree with Linus' tree
Message-Id: <20090526105249.986c4f3c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__26_May_2009_10_52_49_+1000_JRKoZ5_3_2=WKXc8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__26_May_2009_10_52_49_+1000_JRKoZ5_3_2=WKXc8
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the x86 tree got a conflict in
arch/x86/boot/memory.c between commit
bca23dba760d6705c013f89113c46570378fb626 ("x86, setup: revert ACPI 3 E820
extended attributes support") from Linus' tree and commit
df7699c56421c0476704f24a43409ac8c505f3d2 ("x86, setup: "glove box" BIOS
interrupts in the core boot code") from the x86 tree.

The former removed the code that the latter modified, so I used the
former (as is done in -tip).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__26_May_2009_10_52_49_+1000_JRKoZ5_3_2=WKXc8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkobPWEACgkQjjKRsyhoI8z7ygCcDmzt7jBeP4T7PfST5Vb+DB+i
Lk8AoKk1Exsnpf0MS3Ju6JuDkw0Dii6t
=mYgl
-----END PGP SIGNATURE-----

--Signature=_Tue__26_May_2009_10_52_49_+1000_JRKoZ5_3_2=WKXc8--
