Return-Path: <linux-kernel-owner+w=401wt.eu-S966244AbXDDBga@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966244AbXDDBga (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 21:36:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966262AbXDDBg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 21:36:29 -0400
Received: from h80ad26a7.async.vt.edu ([128.173.38.167]:58126 "EHLO
	h80ad26a7.async.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966244AbXDDBgJ (ORCPT
	<RFC822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 21:36:09 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.2
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc5-mm4
In-Reply-To: Your message of "Mon, 02 Apr 2007 22:47:45 PDT."
             <20070402224745.71a25af7.akpm@linux-foundation.org>
From: Valdis.Kletnieks@vt.edu
References: <20070402224745.71a25af7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1175650554_3426P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Tue, 03 Apr 2007 21:35:54 -0400
Message-ID: <24083.1175650554@turing-police.cc.vt.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1175650554_3426P
Content-Type: text/plain; charset=us-ascii

On Mon, 02 Apr 2007 22:47:45 PDT, Andrew Morton said:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm4/

So I was looking at a patch for ACPI_SLEEP that went around a moment ago,
and ended up doing a 'make menuconfig'.

I do a '/ACPI_SLEEP' inside that, and I get this output:

x Symbol: ACPI_SLEEP [=n]                                                 x  
  x Prompt: Sleep States                                                    x  
  x   Defined at drivers/acpi/Kconfig:49                                    x  
  x   Depends on: !X86_NUMAQ && !X86_VISWS && !IA64_HP_SIM && (IA64 || X86) x  
  x   Location:                                                             x  
  x     -> Power management options                                         x  
  x       -> Power Management support (PM [=y])                             x  
  x         -> ACPI (Advanced Configuration and Power Interface) Support    x  
  x           -> ACPI Support (ACPI [=y])   

Only problem is that drivers/acpi/Kconfig:49 says:

config ACPI_SLEEP
        bool "Sleep States"
        depends on X86 && (!SMP || SUSPEND_SMP)
        depends on PM
        default y

Can somebody explain why I'm seeing the different Depends on in the two places?

--==_Exmh_1175650554_3426P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD8DBQFGEwD6cC3lWbTT17ARApFpAJ0Rqba1f2125cnJw65l2Nw6PR54TQCghexr
a/PS915lvmewfdSb5eF2C9s=
=Tr2t
-----END PGP SIGNATURE-----

--==_Exmh_1175650554_3426P--
