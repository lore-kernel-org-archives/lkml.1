Return-Path: <linux-kernel-owner+w=401wt.eu-S1752670AbZAKSjc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbZAKSjc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 13:39:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751574AbZAKSjY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 13:39:24 -0500
Received: from turing-police.cc.vt.edu ([128.173.14.107]:47043 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbZAKSjX (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 13:39:23 -0500
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>,
       Richard Purdie <rpurdie@linux.intel.com>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.29-mmotm0109 Odd prompt for Sharp Corgi backlight.
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1231699127_4078P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Jan 2009 13:38:47 -0500
Message-ID: <67095.1231699127@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1231699127_4078P
Content-Type: text/plain; charset=us-ascii

So I'm building mmotm-0109, doing a 'make oldconfig', and out pops:

    Generic (aka Sharp Corgi) Backlight Driver (BACKLIGHT_GENERIC) [Y/n/m/?] (NEW) ?

Say y to enable the generic platform backlight driver previously
known as the Corgi backlight driver. If you have a Sharp Zaurus
SL-C7xx, SL-Cxx00 or SL-6000x say y.


Two questions:

1) Is it a Corgi driver, or truly a generic one?  It can't be *too* generic
if it only applies to 3 Sharp Zaurus models?  Or do I want to specify it for
my Dell laptop that has a backlight too (in which case that help text needs
fixing)...

2) Why does this default to 'Y'? (Probably depends on the answer to (1) - if
it's for one vendor, it probably should be N, but Y may make sense if it's
proper for the vast majority of all laptops and similar that have a backlight.

--==_Exmh_1231699127_4078P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFJajy3cC3lWbTT17ARAkeRAJ9GzgU+R0P/woFRuxB8uRPxpA28sQCfQ4qr
AptIUo4WOltSKmPMa0TPZQs=
=Crel
-----END PGP SIGNATURE-----

--==_Exmh_1231699127_4078P--
