Return-Path: <linux-kernel-owner+w=401wt.eu-S1751175AbZHXBcc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751175AbZHXBcc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 21:32:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751149AbZHXBcc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 21:32:32 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33279 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751109AbZHXBcb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 21:32:31 -0400
Date: Mon, 24 Aug 2009 11:32:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Dick Streefland <dick@streefland.net>, Sam Ravnborg <sam@ravnborg.org>
Subject: linux-next: manual merge of the kconfig tree with the kbuild tree
Message-Id: <20090824113226.b61cccc6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Aug_2009_11_32_26_+1000__5OZ8JMYZ8_4y09S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Aug_2009_11_32_26_+1000__5OZ8JMYZ8_4y09S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steven,

Today's linux-next merge of the kconfig tree got conflicts in
scripts/extract-ikconfig between commit
692d21e03cfc740684639b019ce9ad708930eb47 ("kconfig: simplification of
scripts/extract-ikconfig") from the kbuild tree and commits
fd3132d5815bf72aeec7d5ad87161b4831f8e48c ("kconfig: add check if end
exists in extract-ikconfig") and 6be51ffc1791b72d11cef9bb0a578fe8c5d64c6a
("kconfig: have extract-ikconfig read ELF files") from the kconfig tree.

It looks like the kbuild patch obsoletes the first of the kconfig patches
and may obsolete the second.  I used the kbuild version for now, but
invite advice.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Aug_2009_11_32_26_+1000__5OZ8JMYZ8_4y09S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqR7aoACgkQjjKRsyhoI8ygfgCdHCjpqsI0FPjncCvmgP1q62tQ
r5EAn23Gls4s4iWp8qFAOT51US5b0E67
=XJYL
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Aug_2009_11_32_26_+1000__5OZ8JMYZ8_4y09S--
