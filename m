Return-Path: <linux-kernel-owner+w=401wt.eu-S1754423AbXGGEfY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbXGGEfY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2007 00:35:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750728AbXGGEfN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 7 Jul 2007 00:35:13 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:49160 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750699AbXGGEfM (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2007 00:35:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: linux-kernel@vger.kernel.org
Subject: cpufreq 'choice' Kconfig oddness in 2.6.22-rc6-mm1..
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1183782910_7487P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 07 Jul 2007 00:35:10 -0400
Message-ID: <6443.1183782910@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1183782910_7487P
Content-Type: text/plain; charset=us-ascii

So I was looking at drivers/cpufreq/Kconfig, and wondering...

Is there a specific reason why we have a 'choice' clause that allows selecting
'performance' or 'userspace' as the default governor, and no obvious way to
select powersave, ondemand, or conservative as a default? Or was this an
oversight I should cook up a patch for?  Looks like the Kconfig and a bit
of cut-n-paste in include/linux/cpufreq.h is all that's needed?




--==_Exmh_1183782910_7487P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGjxf+cC3lWbTT17ARAp7PAKC7DCT2Og8TKhJKRxrf8fJ4/C3daACgu6jk
zQeTZe8wB87w6wq5evJ4SSs=
=AuAo
-----END PGP SIGNATURE-----

--==_Exmh_1183782910_7487P--
