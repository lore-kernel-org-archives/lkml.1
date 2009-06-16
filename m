Return-Path: <linux-kernel-owner+w=401wt.eu-S937848AbZFPGMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937848AbZFPGMZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 02:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S937600AbZFPGJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 02:09:46 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:35737 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936202AbZFPGJp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 02:09:45 -0400
Date: Tue, 16 Jun 2009 15:58:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>,
       Roel Kluin <roel.kluin@gmail.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: linux-next: manual merge of the driver-core tree with the powerpc
 tree
Message-Id: <20090616155843.191a455b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Jun_2009_15_58_43_+1000_9lL/ZKkJEu2s6x8r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Jun_2009_15_58_43_+1000_9lL/ZKkJEu2s6x8r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the driver-core tree got a conflict in
drivers/block/ps3vram.c between commits
6dee2c87ebbe5d7ce8c4c163966a0bd9c02c75ef ("block/ps3: remove driver_data
direct access of struct device") and
03fa68c245cccbcb99035cbabaa13b408ba91ab5 ("ps3: shorten ps3_system_bus_
[gs]et_driver_data to ps3_system_bus_[gs]et_drvdata") from the powerpc
tree and commit db7afa200c4ef6823a2a40e4ea1dd747775be01a ("block/ps3:
remove driver_data direct access of struct device") from the driver-core
tree.

I fixed it up (used the powerpc tree version).  Again, Greg, I think the
driver-core tree version is no longer relevant.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__16_Jun_2009_15_58_43_+1000_9lL/ZKkJEu2s6x8r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko3NJMACgkQjjKRsyhoI8xzQgCdFMAYT5I72u80Rfn5w2au880o
ovkAn3mg+NV4OmunvQy+Hw3lUcZekMg7
=FguH
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Jun_2009_15_58_43_+1000_9lL/ZKkJEu2s6x8r--
