Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbZKTCC3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbZKTCC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 21:02:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758168AbZKTCC2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 21:02:28 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34278 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757731AbZKTCC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 21:02:27 -0500
Date: Fri, 20 Nov 2009 13:02:28 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tony Lindgren <tony@atomide.com>, <linux-omap@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: omap tree misaplied patch
Message-Id: <20091120130228.f3b82588.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__20_Nov_2009_13_02_28_+1100_t0Tjn1zKpq3iDGir"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Nov_2009_13_02_28_+1100_t0Tjn1zKpq3iDGir
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tony,

I think commit 8552f084d80cfc191ea5affacbeffe44e8629496 ("ARM OMAP3:
RX-51 board - add initialization of gpio keys") has been misapplied.  It
has this line:

	+#endif /* CONFIG_KEYBOARD_GPIO || CONFIG_KEYBOARD_GPIO_MODULE */

with the leading '+'.   I noticed this when merging with the input tree
as this made for a strange looking conflict.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__20_Nov_2009_13_02_28_+1100_t0Tjn1zKpq3iDGir
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksF+LQACgkQjjKRsyhoI8zWRwCcCInG01w/nVd1N/qtJjm2L792
fAEAn14LDzsJZz7WZR6HI4xSBULKfh15
=X82P
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Nov_2009_13_02_28_+1100_t0Tjn1zKpq3iDGir--
