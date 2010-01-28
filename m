Return-Path: <linux-kernel-owner+w=401wt.eu-S1754940Ab0A1HXo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab0A1HXo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 02:23:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754086Ab0A1HXm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 02:23:42 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:53955 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752786Ab0A1HXm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 02:23:42 -0500
Date: Thu, 28 Jan 2010 18:23:34 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jonathan Cameron <jic23@cam.ac.uk>, Zhang Rui <rui.zhang@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Jean Delvare <khali@linux-fr.org>
Subject: linux-next:als tree build failure
Message-Id: <20100128182334.7226bdf6.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__28_Jan_2010_18_23_34_+1100_2Sml073+WS1ipErH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__28_Jan_2010_18_23_34_+1100_2Sml073+WS1ipErH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc allnoconfig) failed like this:

ld: drivers/i2c/chips/built-in.o: No such file: No such file or directory

Caused by commit b75349f118718a435f2bb7b6e675572ecd591627 ("tsl2550: Move
form i2c/chips to als and update interfaces").  This removes the last
driver from drivers/i2c/chips/ .  Maybe it needs to remove the directory
completely and the references to it from drivers/i2c as well.

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__28_Jan_2010_18_23_34_+1100_2Sml073+WS1ipErH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkthO3YACgkQjjKRsyhoI8w3TQCgtaMaBFPbDCb5+cr0D4NF3XwC
d3EAniZnbIuW74qkLoDNh9XXIwhizbNC
=PUOL
-----END PGP SIGNATURE-----

--Signature=_Thu__28_Jan_2010_18_23_34_+1100_2Sml073+WS1ipErH--
