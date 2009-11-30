Return-Path: <linux-kernel-owner+w=401wt.eu-S1751208AbZK3FkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbZK3FkP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 00:40:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbZK3FkP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 00:40:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43558 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZK3FkO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 00:40:14 -0500
Date: Mon, 30 Nov 2009 16:40:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "David S. Miller" <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Andrei Pelinescu-Onciul <andrei@iptel.org>
Subject: linux-next: net tree build warning
Message-Id: <20091130164015.9bb8f6a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__30_Nov_2009_16_40_15_+1100_QCtDKLFe6TTpg+lE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__30_Nov_2009_16_40_15_+1100_QCtDKLFe6TTpg+lE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

net/sctp/socket.c: In function 'sctp_setsockopt_autoclose':
net/sctp/socket.c:2091: warning: large integer implicitly truncated to unsi=
gned type

Introduced by commit f6778aab6ccc4b510b4dcfa770d9949b696b4545 ("sctp:
limit maximum autoclose setsockopt value") from the net tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__30_Nov_2009_16_40_15_+1100_QCtDKLFe6TTpg+lE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksTWr8ACgkQjjKRsyhoI8z55QCfS8ZAEgpCf9dks2s8jlL8t1Em
AJsAn1zI6z6HCmvqYrngotjJOmCaSyA/
=LzlK
-----END PGP SIGNATURE-----

--Signature=_Mon__30_Nov_2009_16_40_15_+1100_QCtDKLFe6TTpg+lE--
