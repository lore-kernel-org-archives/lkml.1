Return-Path: <linux-kernel-owner+w=401wt.eu-S1754870AbZLDIgP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870AbZLDIgP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 03:36:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754855AbZLDIgO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 03:36:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40150 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754774AbZLDIgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 03:36:13 -0500
Date: Fri, 4 Dec 2009 19:36:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Patrick McHardy <kaber@trash.net>, David Miller <davem@davemloft.net>,
       <netdev@vger.kernel.org>
Subject: linux-next: manual merge of the sysctl tree with the net tree
Message-Id: <20091204193613.8986a3c6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Dec_2009_19_36_13_+1100_zJQ4Qik+y3yrDuzS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Dec_2009_19_36_13_+1100_zJQ4Qik+y3yrDuzS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next merge of the sysctl tree got a conflict in
kernel/sysctl_check.c between commit
8153a10c08f1312af563bb92532002e46d3f504a ("ipv4: add sysctl to accept
packets with local source addresses") from the net tree and commit
83ac201b4f06eb8aeb7ac93cf162651ba30e0b28 ("sysctl: Remove dead code from
sysctl_check") from the sysctl tree.

The latter removes the need for the former to change this file.  I just
used the latter.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Dec_2009_19_36_13_+1100_zJQ4Qik+y3yrDuzS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksYyf0ACgkQjjKRsyhoI8yv6QCgu+22/azgw9SVjpdnlo7sJFqf
kb8AoKDfyPVRZ3415pHZ8T+Q9hZ/lx/I
=hkXo
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Dec_2009_19_36_13_+1100_zJQ4Qik+y3yrDuzS--
