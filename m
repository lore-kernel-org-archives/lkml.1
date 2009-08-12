Return-Path: <linux-kernel-owner+w=401wt.eu-S1754996AbZHLBN6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996AbZHLBN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 21:13:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753875AbZHLBN5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 21:13:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39436 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751762AbZHLBN4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 21:13:56 -0400
Date: Wed, 12 Aug 2009 11:13:49 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Takashi Iwai <tiwai@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Daniel Ribeiro <drwyrm@gmail.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: sound tree build warning
Message-Id: <20090812111349.14cb4d37.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Aug_2009_11_13_49_+1000_7g8nKtU_uMrUGpLp"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Aug_2009_11_13_49_+1000_7g8nKtU_uMrUGpLp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Takashi,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

sound/soc/codecs/ad1938.c:458: warning: initialization from incompatible po=
inter type

Introduced by commit a5479e389e989acfeca9c32eeb0083d086202280 ("ASoC:
change set_tdm_slot api to allow slot_width override").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Aug_2009_11_13_49_+1000_7g8nKtU_uMrUGpLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqCF00ACgkQjjKRsyhoI8xQxQCfYA6qnHbPW1m2eASbYE3SXSmT
2XcAmwdSGZEEdB9GNiq4+WBUvUBBKV12
=EBO2
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Aug_2009_11_13_49_+1000_7g8nKtU_uMrUGpLp--
