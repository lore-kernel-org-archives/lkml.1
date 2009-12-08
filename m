Return-Path: <linux-kernel-owner+w=401wt.eu-S1753466AbZLHIOU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466AbZLHIOU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 03:14:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752408AbZLHIOS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 03:14:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48015 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbZLHIOR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 03:14:17 -0500
Date: Tue, 8 Dec 2009 19:14:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: hwpoison tree build failure
Message-Id: <20091208191418.79270012.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Dec_2009_19_14_18_+1100_vLQBTig6._DhNGnh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Dec_2009_19_14_18_+1100_vLQBTig6._DhNGnh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andi,

Today's linux-next build (x86_64 allmodconfig) failed like this:

ERROR: "set_migratetype_isolate" [mm/hwpoison-inject.ko] undefined!
ERROR: "unset_migratetype_isolate" [mm/hwpoison-inject.ko] undefined!

I have used the version from next-20091207 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Dec_2009_19_14_18_+1100_vLQBTig6._DhNGnh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkseCtoACgkQjjKRsyhoI8yEzACeM7Myq3ewL1pf0bEzrkef0EQE
wM4AnREZC4TlDkd30hMwU5NizBntZfSl
=Luf0
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Dec_2009_19_14_18_+1100_vLQBTig6._DhNGnh--
