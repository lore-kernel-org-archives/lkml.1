Return-Path: <linux-kernel-owner+w=401wt.eu-S1756087AbZJFCzy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbZJFCzy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 22:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754776AbZJFCzx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 22:55:53 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47930 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766AbZJFCzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 22:55:52 -0400
Date: Tue, 6 Oct 2009 13:55:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>
Subject: linux-next: suspend tree build failure
Message-Id: <20091006135505.f07ee40d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Oct_2009_13_55_05_+1100_oi2wW5BLLATsgDku"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Oct_2009_13_55_05_+1100_oi2wW5BLLATsgDku
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (x86_64 allmodconfig) failed like this:

kernel/freezer.c:27: error: expected ',' or ';' before '{' token

Caused by commit 9a4801cb8df76263abbb3049c0208625b7f34286 ("PM / freezer:
Make refrigerator cold") which neglected to include linux/compiler.h for
the definition of __cold.

I have used the version of the suspend tree from next-20091002 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Oct_2009_13_55_05_+1100_oi2wW5BLLATsgDku
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrKsYkACgkQjjKRsyhoI8zO8QCgghkfYUSSdTzbDDLRGZJJRVTf
xHAAn0Jo4wvLLj+kZ8HWp5QqmCc0GcTF
=mmVj
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Oct_2009_13_55_05_+1100_oi2wW5BLLATsgDku--
