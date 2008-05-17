Return-Path: <linux-kernel-owner+w=401wt.eu-S1755492AbYEQN26@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492AbYEQN26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2008 09:28:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753251AbYEQN2t
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 May 2008 09:28:49 -0400
Received: from turing-police.cc.vt.edu ([128.173.14.107]:48906 "EHLO
	turing-police.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751796AbYEQN2s (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2008 09:28:48 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.26-rc* - CONFIG_FRAME_WARN help text clarification...
From: Valdis.Kletnieks@vt.edu
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1211030892_14984P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sat, 17 May 2008 09:28:12 -0400
Message-ID: <74983.1211030892@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1211030892_14984P
Content-Type: text/plain; charset=us-ascii

I hit this during a 'make oldconfig', and had to ponder and dig through the
Makefiles to see if pre-4.4 should set it to 0, or not.

Make it clear to people who hit this in a 'make oldconfig' that it's safe to
set it so that whenever their box finally *does* get gcc 4.4, it will be used.

Signed-Off-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>

*** linux-2.6.26-rc2-mm1/lib/Kconfig.debug.gccvers	2008-05-17 09:14:05.000000000 -0400
--- linux-2.6.26-rc2-mm1/lib/Kconfig.debug	2008-05-17 09:15:45.000000000 -0400
***************
*** 34,40 ****
  	  Tell gcc to warn at build time for stack frames larger than this.
  	  Setting this too low will cause a lot of warnings.
  	  Setting it to 0 disables the warning.
! 	  Requires gcc 4.4
  
  config MAGIC_SYSRQ
  	bool "Magic SysRq key"
--- 34,40 ----
  	  Tell gcc to warn at build time for stack frames larger than this.
  	  Setting this too low will cause a lot of warnings.
  	  Setting it to 0 disables the warning.
! 	  Requires gcc 4.4, but is safe to set for earlier releases.
  
  config MAGIC_SYSRQ
  	bool "Magic SysRq key"


--==_Exmh_1211030892_14984P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFILt1scC3lWbTT17ARAlnGAKDyRESrLErmkUc/3kLygGar/Be3wACfWMoT
p/e98FyDdtnA1xArUZceqdA=
=/Tef
-----END PGP SIGNATURE-----

--==_Exmh_1211030892_14984P--
