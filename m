Return-Path: <linux-kernel-owner+w=401wt.eu-S1754115AbZLCBPg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115AbZLCBPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Dec 2009 20:15:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbZLCBPf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Dec 2009 20:15:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54701 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752871AbZLCBPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Dec 2009 20:15:35 -0500
Date: Thu, 3 Dec 2009 12:15:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Woodhouse <dwmw2@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ralf Baechle <ralf@linux-mips.org>,
       Uwe =?UTF-8?B?S2xlaW5lLUvDtm5pZw==?= 
	<u.kleine-koenig@pengutronix.de>,
       Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: linux-next: manual merge of the mtd tree with the  tree
Message-Id: <20091203121533.f9de2dac.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__3_Dec_2009_12_15_33_+1100_GRGYM43z9SmxFu51"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Dec_2009_12_15_33_+1100_GRGYM43z9SmxFu51
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the mtd tree got a conflict in
drivers/mtd/nand/excite_nandflash.c between commit
9e910a91b88d450951c849d12598645562acc4b2 ("MIPS: eXcite: Remove
platform") from the mips tree and commit
8fead79c96c68164372c47c7b3c79d2da0871c93 ("mtd: move excite_nand_remove
to .devexit.text") from the mtd tree.

The former just removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Dec_2009_12_15_33_+1100_GRGYM43z9SmxFu51
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksXETUACgkQjjKRsyhoI8xijgCcCy1W91xAbdXMnWRsZ+0ikWcE
gOwAoKpDurf4hCALMH0hAJKJ84SGcb2q
=C6tn
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Dec_2009_12_15_33_+1100_GRGYM43z9SmxFu51--
