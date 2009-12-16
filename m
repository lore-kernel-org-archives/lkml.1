Return-Path: <linux-kernel-owner+w=401wt.eu-S1758067AbZLPD7N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbZLPD7N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 22:59:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758266AbZLPD7H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 22:59:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57909 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758186AbZLPD7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 22:59:01 -0500
Date: Wed, 16 Dec 2009 14:58:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: rr tree build warning
Message-Id: <20091216145856.61ecb45e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__16_Dec_2009_14_58_56_+1100_wAy62y=sKXAntbbQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_Dec_2009_14_58_56_+1100_wAy62y=sKXAntbbQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

usr/include/linux/kernel.h:53: userspace cannot call function or variable d=
efined in the kernel

(it is the line "extern int __build_bug_on_failed;")

Introduced by commit 3cab06406acbf7f86f443bbde56e28f8047c75b6
("misc:enhance-BUILD_BUG_ON").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__16_Dec_2009_14_58_56_+1100_wAy62y=sKXAntbbQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksoWwAACgkQjjKRsyhoI8z8vwCfUDNm/mYmuQGqZhvBppSdUPvn
dQgAoLbSMV4eB+oWoTU7ZJ6yI5cv4wcI
=u2SO
-----END PGP SIGNATURE-----

--Signature=_Wed__16_Dec_2009_14_58_56_+1100_wAy62y=sKXAntbbQ--
