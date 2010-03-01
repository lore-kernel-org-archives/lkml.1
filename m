Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305Ab0CAIPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:15:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49823 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770Ab0CAIPC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:15:02 -0500
Date: Mon, 1 Mar 2010 19:14:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Alan Cox <alan@linux.intel.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20100301191457.315de136.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Mar_2010_19_14_57_+1100_y71Vo4o7sicn9bdM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Mar_2010_19_14_57_+1100_y71Vo4o7sicn9bdM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the final tree, today's linux-next build (powerpc allnoconfig)
produced these warnings:

drivers/char/tty_buffer.c: In function 'tty_insert_flip_string_fixed_flag':
drivers/char/tty_buffer.c:251: warning: comparison of distinct pointer type=
s lacks a cast
drivers/char/tty_buffer.c: In function 'tty_insert_flip_string_flags':
drivers/char/tty_buffer.c:288: warning: comparison of distinct pointer type=
s lacks a cast

Introduced by commit 96a421002f897237bcc44efd909dd58aa759319c ("tty: Keep
the default buffering to sub-page units") from the tty tree.  Its just
the min macro parameters.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Mar_2010_19_14_57_+1100_y71Vo4o7sicn9bdM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuLd4EACgkQjjKRsyhoI8xZvQCaA7TSLSO0p496xXUR3PX8A53C
Sl8An14+GvT22xEB6qKd/QMcwUsvawJ+
=ViqA
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Mar_2010_19_14_57_+1100_y71Vo4o7sicn9bdM--
