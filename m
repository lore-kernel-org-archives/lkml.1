Return-Path: <linux-kernel-owner+w=401wt.eu-S1756077AbZJFDCl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077AbZJFDCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 23:02:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755871AbZJFDCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 23:02:40 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51217 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755834AbZJFDCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 23:02:39 -0400
Date: Tue, 6 Oct 2009 14:01:54 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Philipp Reisner <philipp.reisner@linbit.com>, <drbd-dev@linbit.com>
Subject: linux-next: block/drbd tree build warning
Message-Id: <20091006140154.8d94d95c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_14_01_54_+1100_Ai_VUbGcy5ILQKYg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_14_01_54_+1100_Ai_VUbGcy5ILQKYg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens, Philipp,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/block/drbd/drbd_nl.c: In function 'drbd_nl_init':
drivers/block/drbd/drbd_nl.c:2309: warning: passing argument 3 of 'cn_add_c=
allback' from incompatible pointer type
include/linux/connector.h:167: note: expected 'void (*)(struct cn_msg *, st=
ruct netlink_skb_parms *)' but argument is of type 'void (*)(struct cn_msg =
*)'

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_14_01_54_+1100_Ai_VUbGcy5ILQKYg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrKsyIACgkQjjKRsyhoI8y6UACfUuJLy6uEuHLILte0KEaJz3y/
pvMAn30N9UidNRzWm5uwOBJnI+4tOuK+
=0HZ9
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_14_01_54_+1100_Ai_VUbGcy5ILQKYg--
