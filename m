Return-Path: <linux-kernel-owner+w=401wt.eu-S1751437AbZJEFBc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751437AbZJEFBc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 01:01:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751045AbZJEFBb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 01:01:31 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33717 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750761AbZJEFBb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 01:01:31 -0400
Date: Mon, 5 Oct 2009 16:00:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: suspend tree build failure
Message-Id: <20091005160044.d95daf41.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__5_Oct_2009_16_00_44_+1100__R+P14YCRttQ3jGZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__5_Oct_2009_16_00_44_+1100__R+P14YCRttQ3jGZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rafael,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

drivers/built-in.o: In function `.device_initialize':
(.text+0x95cf4): undefined reference to `.device_pm_init'
drivers/built-in.o: In function `.device_del':
(.text+0x95ec4): undefined reference to `.device_pm_remove'
drivers/built-in.o: In function `.device_add':
(.text+0x965cc): undefined reference to `.device_pm_add'

Caused by commit 1db698d9d2c5a2f4032e620dd18c75b61eaca2c8 ("PM: Introduce
PM links framework").  This build has CONFIG_PM not set.

I have used the suspend tree from next-20091002 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__5_Oct_2009_16_00_44_+1100__R+P14YCRttQ3jGZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkrJfXwACgkQjjKRsyhoI8x8jACdF38y3DevM1FFyDKXKXT4+maN
4lcAn2M6qrACLoEmfdYrSnR5xh6unNH7
=PHDB
-----END PGP SIGNATURE-----

--Signature=_Mon__5_Oct_2009_16_00_44_+1100__R+P14YCRttQ3jGZ--
