Return-Path: <linux-kernel-owner+w=401wt.eu-S1752749AbZLABbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbZLABbq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 20:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751824AbZLABbp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 20:31:45 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43432 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017AbZLABbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 20:31:44 -0500
Date: Tue, 1 Dec 2009 12:31:42 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20091201123142.fe6bc824.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__1_Dec_2009_12_31_42_+1100_N1++7VOr=RMixzvR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Dec_2009_12_31_42_+1100_N1++7VOr=RMixzvR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in net/mac80211/ht.=
c between commit 827d42c9ac91ddd728e4f4a31fefb906ef2ceff7 ("mac80211: fix s=
purious delBA handling") from the wireless-current tree and commit c951ad35=
50ab40071bb0f222ba6125845769c08a ("mac80211: convert aggregation to operate=
 on vifs/stas") from the net tree.

I fixed it up (by using the version from the wireless-current tree) and
can carry the fix as necessary.  This may well not be correct.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Dec_2009_12_31_42_+1100_N1++7VOr=RMixzvR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksUcf4ACgkQjjKRsyhoI8yb4wCgugZsKIOHAw2ii8QNPk4SXx+J
r9IAoLyKEiz62T4iAxRd73VPSTVYdU1b
=XAFd
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Dec_2009_12_31_42_+1100_N1++7VOr=RMixzvR--
