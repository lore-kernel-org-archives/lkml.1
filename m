Return-Path: <linux-kernel-owner+w=401wt.eu-S1753439AbZKZDK6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbZKZDK6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Nov 2009 22:10:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751742AbZKZDK6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Nov 2009 22:10:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51401 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750892AbZKZDK5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Nov 2009 22:10:57 -0500
Date: Thu, 26 Nov 2009 14:10:55 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jean Tourrilhes <jt@hpl.hp.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20091126141055.d8c67798.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__26_Nov_2009_14_10_55_+1100_qvjmtpKFXuR/J8HT"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__26_Nov_2009_14_10_55_+1100_qvjmtpKFXuR/J8HT
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the net tree got a conflict in
net/wireless/wext.c between commit
9fed059667d35fca9288460106e92dbb8ba35ea1 ("WE: Fix set events not
propagated") from the  tree and commit
3d23e349d807177eaf519d444677cee86b1a04cf ("wext: refactor") from the net
tree.

The latter deleted the file that the former modified.  I just ignored the
wireless-current change and removed the file (which seems to have been
done in the latter change anyway).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__26_Nov_2009_14_10_55_+1100_qvjmtpKFXuR/J8HT
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksN8b8ACgkQjjKRsyhoI8wNBACeK6J7j5flVc/lq2ElnoaG7ESN
P2UAoL1bvM2trJ1w3zyjqZ+lB0Ibtz66
=sNVK
-----END PGP SIGNATURE-----

--Signature=_Thu__26_Nov_2009_14_10_55_+1100_qvjmtpKFXuR/J8HT--
