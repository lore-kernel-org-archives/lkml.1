Return-Path: <linux-kernel-owner+w=401wt.eu-S1756531Ab0AGCMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756531Ab0AGCMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 21:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756228Ab0AGCMm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 21:12:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38141 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755903Ab0AGCMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 21:12:41 -0500
Date: Thu, 7 Jan 2010 13:12:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jouni Malinen <jouni.malinen@atheros.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20100107131234.4c340d1c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jan_2010_13_12_34_+1100_ktaER8VFFQYl8OIy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jan_2010_13_12_34_+1100_ktaER8VFFQYl8OIy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/mac80211/scan.c between commit
8a5b33f55452c226aa0e47d737e541985ff10e16 ("Revert "mac80211: replace
netif_tx_{start,stop,wake}_all_queues"") from the wireless-current tree
and commit b203ffc3a447eb8d9e6120b783ddee081b143061 ("mac80211:
Generalize off-channel operation helpers from scan code") from the net
tree.

I used the version from the net tree (though I suspect that it may not be
completely correct).  I assume that this will be fixed up shortly.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jan_2010_13_12_34_+1100_ktaER8VFFQYl8OIy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktFQxIACgkQjjKRsyhoI8wbWwCggaXr8DrVKzJwu6P5XPsBasJD
ZR0AnR1qPiE/lKdeYVQW+YdJB1v4AOS1
=2TfM
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jan_2010_13_12_34_+1100_ktaER8VFFQYl8OIy--
