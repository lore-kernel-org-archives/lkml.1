Return-Path: <linux-kernel-owner+w=401wt.eu-S933362AbZLRXBm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933362AbZLRXBm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 18:01:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933323AbZLRXBd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 18:01:33 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49274 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933355AbZLRXBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 18:01:31 -0500
Date: Sat, 19 Dec 2009 10:01:24 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Paris <eparis@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: fsnotify tree build warning
Message-Id: <20091219100124.d6c97ea1.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Dec_2009_10_01_24_+1100_.OCCMJG3R23+xR81"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Dec_2009_10_01_24_+1100_.OCCMJG3R23+xR81
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

fs/notify/fanotify/fanotify_user.c: In function 'remove_access_response':
fs/notify/fanotify/fanotify_user.c:234: warning: 'return' with a value, in =
function returning void

Introduced by commit 34cb304c7a759738bebcdb091b90e6e8f16b8fa6 ("fanotify:
userspace interface for permission responses").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__19_Dec_2009_10_01_24_+1100_.OCCMJG3R23+xR81
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkssCcQACgkQjjKRsyhoI8zYtwCbBSrtiuvWrue4HpgwLybsTa0l
g18AoK2i5jQE3f1uqOnQb8DWVLaj2Ggy
=J0gh
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Dec_2009_10_01_24_+1100_.OCCMJG3R23+xR81--
