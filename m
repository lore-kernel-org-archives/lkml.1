Return-Path: <linux-kernel-owner+w=401wt.eu-S1751913AbZJMEdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751913AbZJMEdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 00:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751303AbZJMEdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 00:33:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44123 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750988AbZJMEdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 00:33:52 -0400
Date: Tue, 13 Oct 2009 15:33:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Michael Chan <mchan@broadcom.com>,
       "Shmulik Ravid - Rabinovitz" <shmulikr@broadcom.com>
Subject: linux-next: net tree build failure
Message-Id: <20091013153308.af56910a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__13_Oct_2009_15_33_08_+1100_u011ej/GoWJIxg=t"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Oct_2009_15_33_08_+1100_u011ej/GoWJIxg=t
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (powerpc allyesconfig) failed like this:

drivers/net/cnic.c: In function 'cnic_init_storm_conn_bufs':
drivers/net/cnic.c:1757: error: implicit declaration of functi
on 'csum_ipv6_magic'

Caused by commit 71034ba845c9ff219373066f904286c0b7506922 ("cnic: Add
main functions to support bnx2x devices") which I have reverted for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Oct_2009_15_33_08_+1100_u011ej/GoWJIxg=t
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrUAwQACgkQjjKRsyhoI8wAZQCgo+JJQAvbApKo4HW+pi0ytiI7
kwAAnR4qZ7tFCyw0jTRBkAiZIY8gt26v
=NEBl
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Oct_2009_15_33_08_+1100_u011ej/GoWJIxg=t--
