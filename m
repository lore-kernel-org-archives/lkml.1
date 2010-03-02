Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0CBAgl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 19:36:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37583 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694Ab0CBAgk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 19:36:40 -0500
Date: Tue, 2 Mar 2010 11:36:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: linux-next: build failure after merge of the ext3 tree
Message-Id: <20100302113634.2c7f5e03.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__2_Mar_2010_11_36_34_+1100_7e.1yNpQWT63jmxs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Mar_2010_11_36_34_+1100_7e.1yNpQWT63jmxs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

After merging the ext3 tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/jfs/jfs_xtree.c: In function 'xtSplitRoot':
fs/jfs/jfs_xtree.c:1256: error: 'rec' undeclared (first use in this functio=
n)

Caused by commit bff3333e868578990f6fe794a7cba0c74bd433ac ("dquot:
cleanup space allocation / freeing routines").

This is annoying ... this file system could be build tested on any
architecture, so why wasn't it?

I have used the version of the ext3 tree from next-20100301 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__2_Mar_2010_11_36_34_+1100_7e.1yNpQWT63jmxs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuMXZIACgkQjjKRsyhoI8zB6gCfQiUurYdliX+mQor1kI0inL4p
HTwAoI/zvGpzfkiUJKTBSoG1kZx8ZGmh
=nOQU
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Mar_2010_11_36_34_+1100_7e.1yNpQWT63jmxs--
