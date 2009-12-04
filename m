Return-Path: <linux-kernel-owner+w=401wt.eu-S1755482AbZLDAgx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482AbZLDAgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 19:36:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755127AbZLDAgw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 19:36:52 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39753 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754889AbZLDAgv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 19:36:51 -0500
Date: Fri, 4 Dec 2009 11:36:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       NeilBrown <neilb@suse.de>
Subject: linux-next: nfs tree build failure
Message-Id: <20091204113650.0776ce8f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Dec_2009_11_36_50_+1100_mDbY7=S0ofAfb4FI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Dec_2009_11_36_50_+1100_mDbY7=S0ofAfb4FI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

fs/nfs/nfs4proc.c: In function 'nfs4_handle_exception':
fs/nfs/nfs4proc.c:282: error: 'err' undeclared (first use in this function)

Caused by commit b3508de20f0fc48f5e597b189eed930343ed1441
("NFS4ERR_FILE_OPEN handling in Linux/NFS").

Please, please build test, at least, *before* you publish a tree that is
included in linux-next.  I have used the nfs tree from next-20091203 for
today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Dec_2009_11_36_50_+1100_mDbY7=S0ofAfb4FI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksYWaIACgkQjjKRsyhoI8wLfACfbMR4Cerl3HHvs2jpbLflsHhv
NSYAnR7IMMwpQCSgu3Q3BkZYA6mKweAS
=fezt
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Dec_2009_11_36_50_+1100_mDbY7=S0ofAfb4FI--
