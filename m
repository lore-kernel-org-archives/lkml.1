Return-Path: <linux-kernel-owner+w=401wt.eu-S1754010AbZIJE7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010AbZIJE7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 00:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752694AbZIJE7w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 00:59:52 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54614 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917AbZIJE7v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 00:59:51 -0400
Date: Thu, 10 Sep 2009 14:59:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       sedji gaouaou <sedji.gaouaou@atmel.com>
Subject: linux-next: arm tree build failure
Message-Id: <20090910145944.690c873f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__10_Sep_2009_14_59_44_+1000_qjUK=yInyJEtXQnj"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_Sep_2009_14_59_44_+1000_qjUK=yInyJEtXQnj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

The next-20090907 and later builds (arm at91cap9adk_defconfig) failed
like this:

arch/arm/mach-at91/at91cap9_devices.c:821: warning: 'struct atmel_ac97_data=
' declared inside parameter list
arch/arm/mach-at91/at91cap9_devices.c:821: warning: its scope is only this =
definition or declaration, which is probably not what you want
arch/arm/mach-at91/at91cap9_devices.c:821: error: conflicting types for 'at=
91_add_device_ac97'
arch/arm/mach-at91/include/mach/board.h:178: note: previous declaration of =
'at91_add_device_ac97' was here
arch/arm/mach-at91/board-cap9adk.c:367: error: variable 'cap9adk_ac97_data'=
 has initializer but incomplete type
arch/arm/mach-at91/board-cap9adk.c: In function 'cap9adk_board_init':
arch/arm/mach-at91/board-cap9adk.c:397: warning: passing argument 1 of 'at9=
1_add_device_ac97' from incompatible pointer type
arch/arm/mach-at91/include/mach/board.h:178: note: expected 'struct ac97c_p=
latform_data *' but argument is of type 'struct atmel_ac97_data *'

Caused by commit d656f07a7405e788e1275d0238b67f593615f2bb ("ARM: 5640/1:
This patch modifies the support of AC97 on the at91sam9263 ek board").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__10_Sep_2009_14_59_44_+1000_qjUK=yInyJEtXQnj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkqoh8EACgkQjjKRsyhoI8wvPgCfW6uUcrQQsRkHDBktkRhusikn
yCwAn3/5hcmEpBfmk3/Qp+pNIUZ6FamI
=uD+o
-----END PGP SIGNATURE-----

--Signature=_Thu__10_Sep_2009_14_59_44_+1000_qjUK=yInyJEtXQnj--
