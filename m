Return-Path: <linux-kernel-owner+w=401wt.eu-S1758806AbYB2Ek3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758806AbYB2Ek3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2008 23:40:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754547AbYB2EkS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Feb 2008 23:40:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:56615 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754498AbYB2EkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2008 23:40:17 -0500
Date: Fri, 29 Feb 2008 15:39:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Haavard Skinnemoen <hskinnemoen@atmel.com>, Greg KH <greg@kroah.com>,
       Mark Fasheh <mark.fasheh@oracle.com>
Subject: linux-next: semaphore update merge conflicts
Message-Id: <20080229153958.fc34e281.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Feb_2008_15_39_58_+1100_xYLvEupO09x=JdZs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Feb_2008_15_39_58_+1100_xYLvEupO09x=JdZs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Willy,

Not as bad as I thought it might be!  :-)

The merge had the following conflicts:

	Documentation/feature-removal-schedule.txt
		Conflicts with the ocfs2 tree - trivial to fix.
	arch/avr32/kernel/semaphore.c
		the avr32 tree appeared to just change spaces to tabs
		in this file so I removed it (as your changes did).
	include/linux/memory.h
		the driver-core changed the semaphore in here to a mutex,
		so the change from asm/semaphore.h to linux/semaphore.h
		is no longer needed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Feb_2008_15_39_58_+1100_xYLvEupO09x=JdZs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHx4yrTgG2atn1QN8RAg+oAJ92y0ksAUmZSMwIhL1d1tZoxYb36gCgjuGm
YsQJardJ6xvQCbGLJWMQcsQ=
=ClHQ
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Feb_2008_15_39_58_+1100_xYLvEupO09x=JdZs--
