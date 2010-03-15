Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964828Ab0COKMk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 06:12:40 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50770 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964815Ab0COKMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 06:12:36 -0400
Date: Mon, 15 Mar 2010 11:12:32 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: rtc-linux@googlegroups.com
Cc: linux-kernel@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
       kernel-janitors@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Ralf Baechle <ralf@linux-mips.org>,
       Paul Gortmaker <p_gortmaker@yahoo.com>,
       Alessandro Zummo <a.zummo@towertech.it>, linux-mips@linux-mips.org,
       Jiri Kosina <jkosina@suse.cz>
Subject: Re: [rtc-linux] Re: [PATCH] init dynamic bin_attribute structures
Message-ID: <20100315101232.GB20604@pengutronix.de>
References: <alpine.LFD.2.00.1003141054050.3719@i5.linux-foundation.org> <1268612981-9009-1-git-send-email-w.sang@pengutronix.de> <alpine.LRH.2.00.1003151055060.26353@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="neYutvxvOLaeuPCA"
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.00.1003151055060.26353@twin.jikos.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--neYutvxvOLaeuPCA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> I don't understand how cocinelle works, but the resulting patch seems to=
=20
> be incomplete.

Okay, will investigate, thanks for the pointer.

> The fix is needed at least in firmware loader (for which Greg has already=
=20
> queued patch), in ACPI thermal driver [1], etc).

Firmware loader should be handled differently, see other mails in the
originating thread, so I skipped it intentionally. at24 also needed a fix, =
but
that one was just applied via the i2c-tree, so I skipped it, too. Will check
the ACPI-case!

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--neYutvxvOLaeuPCA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkueCBAACgkQD27XaX1/VRswuQCdFiF8i3Vjj2s0QPm1v4UCjE2R
pJYAoI5n8xxHNNFVFuS3KCJDpN1uBst/
=9hnN
-----END PGP SIGNATURE-----

--neYutvxvOLaeuPCA--
