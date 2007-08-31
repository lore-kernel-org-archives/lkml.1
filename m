Return-Path: <linux-kernel-owner+w=401wt.eu-S1759479AbXHaCQd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479AbXHaCQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2007 22:16:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755174AbXHaCQY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Aug 2007 22:16:24 -0400
Received: from orca.ele.uri.edu ([131.128.51.63]:54208 "EHLO orca.ele.uri.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753666AbXHaCQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2007 22:16:24 -0400
X-Greylist: delayed 1246 seconds by postgrey-1.27 at vger.kernel.org; Thu, 30 Aug 2007 22:16:24 EDT
Date: Thu, 30 Aug 2007 21:56:20 -0400
From: Will Simoneau <simoneau@ele.uri.edu>
To: linux-kernel@vger.kernel.org
Cc: hpa@zytor.com
Subject: new x86 setup code hangs on Dell Inspiron 5150
Message-ID: <20070831015620.GA6259@ele.uri.edu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="nFreZHaLTZJo0R7j"
Content-Disposition: inline
User-Agent: Mutt/1.5.16 [Linux 2.6.21.1-grsec-b0rg i686]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--nFreZHaLTZJo0R7j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

While trying to put together a new kernel for my laptop (Dell I5150, as
in subject) I found that recent kernels just don't boot. Right after
grub loads the kernel, before the "Uncompressing Linux" message is
shown, it hangs. The BIOS appears to still be alive (ctrl-alt-del works,
keyboard lock LEDs respond). It seems to be caused by the new x86 setup
code.

My kernel is Linus' git as of a1c582d0720f2eff61043e90711767decf37b917.
I bisected and confirmed that 4fd06960f120e02e9abc802a09f9511c400042a5
triggers a non-functioning boot.

This system has Dell BIOS rev A38 and a P4 3.2 w/HT.

What should I do next to debug this problem?

--nFreZHaLTZJo0R7j
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.6 (GNU/Linux)

iD8DBQFG13VELYBaX8VDLLURApv0AKDHOZRy7W88qYZ/KzhgDlWfo0j32wCeNwI9
6I04gNGt5YCuo7eHTGgDJz8=
=x6hz
-----END PGP SIGNATURE-----

--nFreZHaLTZJo0R7j--
