Return-Path: <linux-kernel-owner+w=401wt.eu-S1754206AbZJBB0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206AbZJBB0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Oct 2009 21:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754082AbZJBB0p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Oct 2009 21:26:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58770 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754070AbZJBB0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Oct 2009 21:26:44 -0400
Date: Fri, 2 Oct 2009 11:26:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Theodore Tso <tytso@MIT.EDU>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Curt Wohlgemuth <curtw@google.com>
Subject: linux-next: ext4 tree build warning
Message-Id: <20091002112637.c962d8ae.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__2_Oct_2009_11_26_37_+1000_AOMZ8dEY3yZRuRQ/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Oct_2009_11_26_37_+1000_AOMZ8dEY3yZRuRQ/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ted,

Today's linux-next build (powerpc ppc64_defconfig) produced this warning:

fs/ext4/inode.c: In function 'ext4_dirty_inode':
fs/ext4/inode.c:5615: warning: unused variable 'current_handle'

Introduced by commit f3dc272fd5e2ae08244796bb39e7e1ce4b25d3b3 ("ext4:
Make sure ext4_dirty_inode() updates the inode in no journal mode"). This
variable is now only referenced by a jbd_debug().

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__2_Oct_2009_11_26_37_+1000_AOMZ8dEY3yZRuRQ/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrFVs0ACgkQjjKRsyhoI8x8YgCgtVl59ev+FLoLTJiNRPoGPLP4
rKMAoK+emyvia66Y7iQmfVzjdNi1hG+Z
=eyWh
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Oct_2009_11_26_37_+1000_AOMZ8dEY3yZRuRQ/--
