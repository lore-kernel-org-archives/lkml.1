Return-Path: <linux-kernel-owner+w=401wt.eu-S1753166AbZG1CIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753166AbZG1CIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jul 2009 22:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZG1CIS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 27 Jul 2009 22:08:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53305 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752555AbZG1CIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jul 2009 22:08:17 -0400
Date: Tue, 28 Jul 2009 11:53:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       reinette chatre <reinette.chatre@intel.com>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20090728115351.192e8b5c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jul_2009_11_53_51_+1000_7pjav6Q0zweGbt7="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jul_2009_11_53_51_+1000_7pjav6Q0zweGbt7=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Today's linux-next merge of the net tree got a conflicts in
drivers/net/wireless/iwlwifi/iwl-3945.h and
drivers/net/wireless/iwlwifi/iwl3945-base.c between commit
45f5fa32b130b2a59f9b726be45ce7fa73fb834c ("iwlagn: fix minimum number of
queues setting") from the wireless-current tree and commit
5905a1aa71488b5f78822100c865ed7c4f9fcd8f ("iwl3945: cleanup number of
queues settings") from the net tree.

The latter just removes the code that the former modifies.  I used the
version from the net tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jul_2009_11_53_51_+1000_7pjav6Q0zweGbt7=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpuWi8ACgkQjjKRsyhoI8wwLgCgmmVAa9dUzq5oPHbBhuRwh5df
u3sAnA5XTWXK/HVkHyyi5rDSv52zOZYu
=feBC
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jul_2009_11_53_51_+1000_7pjav6Q0zweGbt7=--
