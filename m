Return-Path: <linux-kernel-owner+w=401wt.eu-S1754172AbZIWGiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbZIWGiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Sep 2009 02:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754011AbZIWGiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Sep 2009 02:38:23 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48266 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009AbZIWGiX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Sep 2009 02:38:23 -0400
Date: Wed, 23 Sep 2009 16:38:17 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jan Beulich <JBeulich@novell.com>,
       Jason Wessel <jason.wessel@windriver.com>
Subject: linux-next: manual merge of the usb tree with Linus' tree
Message-Id: <20090923163817.44bcebb8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Sep_2009_16_38_17_+1000_WpdwWgg0dAT3me5q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Sep_2009_16_38_17_+1000_WpdwWgg0dAT3me5q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the usb tree got a conflict in
arch/x86/kernel/early_printk.c between commit
414128bd33fef3242747154dfa444970bc5caf4c ("x86: Increase timeout for EHCI
debug port reset completion in early printk") from Linus' tree and commit
bd965307ef6b7a56219f8883d5038f6573a94f6e ("USB: ehci,dbgp,early_printk:
split ehci debug driver from early_printk.c") from the usb tree.

The latter moved the code that the former modified.  A later USB patch
used an even longer loop delay.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Sep_2009_16_38_17_+1000_WpdwWgg0dAT3me5q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkq5wlkACgkQjjKRsyhoI8wdtQCfZ3bZXLFENqu27HOlwlb4cfZQ
vT0An32K63mky/leiybLDUeXs1/p7JIk
=k1BN
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Sep_2009_16_38_17_+1000_WpdwWgg0dAT3me5q--
