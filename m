Return-Path: <linux-kernel-owner+w=401wt.eu-S1751488AbZJKX5b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488AbZJKX5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Oct 2009 19:57:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751233AbZJKX5a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Oct 2009 19:57:30 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54223 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751216AbZJKX53 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Oct 2009 19:57:29 -0400
Date: Mon, 12 Oct 2009 10:56:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: origin tree build warning
Message-Id: <20091012105646.5faca84d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__12_Oct_2009_10_56_46_+1100_tbVGE._sLvTeN=JL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__12_Oct_2009_10_56_46_+1100_tbVGE._sLvTeN=JL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

Today's linux-next build (powerpc ppc64_defconfig) produced these warnings:

fs/nfs/super.c: In function 'nfs_compare_remount_data':
fs/nfs/super.c:1852: warning: passing argument 1 of 'rpc_cmp_addr' from inc=
ompatible pointer type
include/linux/sunrpc/clnt.h:254: note: expected 'const struct sockaddr *' b=
ut argument is of type 'struct __kernel_sockaddr_storage *'
fs/nfs/super.c:1852: warning: passing argument 2 of 'rpc_cmp_addr' from inc=
ompatible pointer type
include/linux/sunrpc/clnt.h:254: note: expected 'const struct sockaddr *' b=
ut argument is of type 'struct __kernel_sockaddr_storage *'

Introduced by commit bcd2ea17da6a329a7276cde7286d802f009af332 ("NFS: Fix
port initialisation in nfs_remount()").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__12_Oct_2009_10_56_46_+1100_tbVGE._sLvTeN=JL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrScL4ACgkQjjKRsyhoI8ykwACgsiD6EFv4abf8DgLPh7Ta73Ft
jm8An0oicAyajxge6hTtbJzpR/4pbpYr
=Sz+r
-----END PGP SIGNATURE-----

--Signature=_Mon__12_Oct_2009_10_56_46_+1100_tbVGE._sLvTeN=JL--
