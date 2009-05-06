Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbZEFDKs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbZEFDKs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 May 2009 23:10:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbZEFDKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 May 2009 23:10:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44120 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751759AbZEFDKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 May 2009 23:10:38 -0400
Date: Wed, 6 May 2009 13:10:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, Nicolas Pitre <nico@cam.org>,
       Wolfram Sang <w.sang@pengutronix.de>,
       Russell King <rmk@arm.linux.org.uk>,
       LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: manual merge of the i2c tree with the arm-current tree
Message-Id: <20090506131031.83f1b04d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__6_May_2009_13_10_31_+1000_rQ+.KXA1JuZXkPTU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__6_May_2009_13_10_31_+1000_rQ+.KXA1JuZXkPTU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Today's linux-next merge of the i2c tree got a conflict in
arch/arm/configs/kirkwood_defconfig arch/arm/configs/mv78xx0_defconfig
arch/arm/configs/orion5x_defconfig between various commits from the
arm-current tree and commit c637675d24618d8e0afe344096a1ad96986c4f50
("i2c/chips: Move max6875 to drivers/misc/eeprom") from the i2c tree.

The latter patch changes many defconfig files. Please don't do that -
especially for those defconfigs that do not select the config options you
are changing (which is the vast majority).  This just creates conflicts
for no purpose at all.  It looks like the only defconfigs that may have
needed updating are:

arch/mips/configs/bigsur_defconfig
arch/mips/configs/mtx1_defconfig
arch/powerpc/configs/ppc6xx_defconfig

I have dropped the changes to all the others (165 of them).  Please
update the patch.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__6_May_2009_13_10_31_+1000_rQ+.KXA1JuZXkPTU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoA/6gACgkQjjKRsyhoI8zbWACfYxvTv66nJ+QfoDzK96SrWeH9
SaoAoKEFpQuCF1aqD9VPKEcRhqGOFK+W
=J6gp
-----END PGP SIGNATURE-----

--Signature=_Wed__6_May_2009_13_10_31_+1000_rQ+.KXA1JuZXkPTU--
